
try:
    import simplejson as json
except ImportError:
    import json
from sqlalchemy import inspect
from geoalchemy2.types import Geometry
from sqlalchemy import create_engine
from sqlalchemy_utils import database_exists, create_database, drop_database
from sqlalchemy.schema import CreateSchema
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from ealgis_data_schema.schema_v1 import store
from collections import Counter
from .util import cmdrun
import os
import sqlalchemy
from .util import make_logger

Base = declarative_base()


logger = make_logger(__name__)


class DataLoaderFactory:
    def __init__(self, db_name):
        def make_connection_string():
            dbuser = os.environ.get('DB_USERNAME')
            dbpassword = os.environ.get('DB_PASSWORD')
            dbhost = os.environ.get('DB_HOST')
            return 'postgres://%s:%s@%s:5432/%s' % (dbuser, dbpassword, dbhost, db_name)

        # create database and connect
        connection_string = make_connection_string()
        self._engine = create_engine(connection_string)
        self._create_database(connection_string)
        self._create_extensions(connection_string)

    def make_loader(self, schema_name, **loader_kwargs):
        self._create_schema(schema_name)
        return DataLoader(self._engine, schema_name, **loader_kwargs)

    def _create_database(self, connection_string):
        # Initialise the database
        if database_exists(connection_string):
            logger.info("database already exists: deleting.")
            drop_database(connection_string)
        create_database(connection_string)
        logger.debug("dataloader database created")

    def _create_schema(self, schema_name):
        logger.info("create schema: %s" % schema_name)
        self._engine.execute(CreateSchema(schema_name))

    def _create_extensions(self, connection_string):
        extensions = ('postgis', 'postgis_topology')
        for extension in extensions:
            try:
                logger.info("creating extension: %s" % extension)
                self._engine.execute('CREATE EXTENSION %s;' % extension)
            except sqlalchemy.exc.ProgrammingError as e:
                if 'already exists' not in str(e):
                    print("couldn't load: %s (%s)" % (extension, e))


class DataLoader:
    def __init__(self, engine, schema_name, mandatory_srids=None):
        self.engine = engine
        Session = sessionmaker()
        Session.configure(bind=self.engine)
        self.session = Session()

        # make extensions, create target schema
        self._schema_name = schema_name

        self._table_names_used = Counter()
        self._mandatory_srids = mandatory_srids

        metadata, tables = store.load_schema(schema_name)
        metadata.create_all(self.engine)
        self.tables = dict((t.name, t) for t in tables)
        self.classes = dict((t.name, self.get_table_class(t.name)) for t in tables)

    def engineurl(self):
        return self.engine.engine.url

    def dbname(self):
        return self.engine.engine.url.database

    def dbhost(self):
        return self.engine.engine.url.host

    def dbuser(self):
        return self.engine.engine.url.username

    def dbport(self):
        return self.engine.engine.url.port

    def dbschema(self):
        return self._schema_name

    def dbpassword(self):
        return self.engine.engine.url.password

    def have_table(self, table_name):
        try:
            self.get_table(table_name)
            return True
        except sqlalchemy.exc.NoSuchTableError:
            return False

    def get_table(self, table_name):
        return sqlalchemy.Table(table_name, sqlalchemy.MetaData(), schema=self._schema_name, autoload=True, autoload_with=self.engine.engine)

    def get_table_names(self):
        "this is a more lightweight approach to getting table names from the db that avoids all of that messy reflection"
        "c.f. http://docs.sqlalchemy.org/en/rel_0_9/core/reflection.html?highlight=inspector#fine-grained-reflection-with-inspector"
        inspector = inspect(self.engine.engine)
        return inspector.get_table_names(schema=self._schema_name)

    def get_table_class(self, table_name):
        # nothing bad happens if there is a clash, but it produces warnings
        self._table_names_used[table_name] += 1
        nm = "Table_%s_%d" % (table_name, self._table_names_used[table_name])
        return type(nm, (Base,), {'__table__': self.get_table(table_name)})

    def geom_column(self, table_name):
        info = self.get_table(table_name)
        geom_columns = []

        for column in info.columns:
            # GeoAlchemy2 lets us find geometry columns
            if isinstance(column.type, Geometry):
                geom_columns.append(column)

        if len(geom_columns) > 1:
            raise Exception("more than one geometry column?")
        return geom_columns[0]

    def set_table_metadata(self, table_name, meta_dict):
        ti = self.get_table_info(table_name)
        ti.metadata_json = json.dumps(meta_dict)
        self.session.commit()

    def register_columns(self, table_name, columns):
        ti = self.get_table_info(table_name)
        for column_name, meta_dict in columns:
            self.session.execute(
                self.tables['column_info'].insert().values(
                    name=column_name,
                    table_info_id=ti.id,
                    metadata_json=meta_dict))
        self.session.commit()

    def register_column(self, table_name, column_name, meta_dict):
        self.register_columns(table_name, [column_name, meta_dict])

    def repair_geometry(self, geometry_source):
        # FIXME: clean this up, make generic: or delete, and move into loaders?
        logger.debug("running geometry QC and repair: %s" % (geometry_source.table_info.name))
        cls = self.get_table_class(geometry_source.table_info.name)
        geom_attr = getattr(cls, geometry_source.column)
        self.session.execute(sqlalchemy.update(
            cls.__table__, values={
                geom_attr: sqlalchemy.func.st_multi(sqlalchemy.func.st_buffer(geom_attr, 0))
            }).where(sqlalchemy.func.st_isvalid(geom_attr) == False))  # noqa

    def reproject(self, geometry_source_id, from_column, to_srid):
        # add the geometry column
        GeometrySource = self.classes['geometry_source']
        TableInfo = self.classes['table_info']
        geometry_source = self.session.query(GeometrySource).filter(GeometrySource.id == geometry_source_id).one()
        table_info = self.session.query(TableInfo).filter(TableInfo.id == geometry_source.table_info_id).one()
        new_column = "%s_%d" % (from_column, to_srid)
        self.session.execute(sqlalchemy.func.addgeometrycolumn(
            self._schema_name,
            table_info.name,
            new_column,
            to_srid,
            geometry_source.geometry_type,
            2))  # fixme ndim=2 shouldn't be hard-coded
        self.session.commit()
        # committed, so we can introspect it, and then transform original
        # geometry data to this SRID
        cls = self.get_table_class(table_info.name)
        tbl = cls.__table__
        self.session.execute(
            sqlalchemy.update(
                tbl, values={
                    getattr(tbl.c, new_column):
                    sqlalchemy.func.st_transform(
                        sqlalchemy.func.ST_Force2D(
                            getattr(tbl.c, from_column)),
                        to_srid)
                }))
        self.session.execute(
            self.tables['geometry_source_column'].insert().values(
                geometry_source_id=geometry_source_id,
                column=new_column,
                srid=to_srid))
        # make a geometry index on this
        self.session.commit()
        self.session.execute("CREATE INDEX %s ON %s.%s USING gist ( %s )" % (
            "%s_%s_gist" % (
                table_info.name,
                new_column),
            self._schema_name,
            table_info.name,
            new_column))
        self.session.commit()

    def register_table(self, table_name, geom=False, srid=None, gid=None):
        table_info_id, = self.session.execute(
            self.tables['table_info'].insert().values(
                name=table_name)).inserted_primary_key
        if geom:
            column = self.geom_column(table_name)
            if column is None:
                raise Exception("Cannot automatically determine geometry column for `%s'" % table_name)
            # figure out what type of geometry this is
            qstr = 'SELECT geometrytype(%s) as geomtype FROM %s.%s WHERE %s IS NOT null GROUP BY geomtype' % \
                (column.name, self._schema_name, table_name, column.name)
            conn = self.session.connection()
            res = conn.execute(qstr)
            rows = res.fetchall()
            if len(rows) != 1:
                geomtype = 'GEOMETRY'
            else:
                geomtype = rows[0][0]
            source_id, = self.session.execute(
                self.tables['geometry_source'].insert().values(
                    table_info_id=table_info_id,
                    geometry_type=geomtype,
                    gid=gid)).inserted_primary_key
            self.session.execute(
                self.tables['geometry_source_column'].insert().values(
                    geometry_source_id=source_id,
                    column=column.name,
                    srid=srid))
            to_generate = set(self._mandatory_srids)
            if srid in to_generate:
                to_generate.remove(srid)
            for gen_srid in to_generate:
                self.reproject(source_id, column.name, gen_srid)
        self.session.commit()

    def get_table_info(self, table_name):
        TableInfo = self.classes['table_info']
        return self.session.query(TableInfo).filter(TableInfo.name == table_name).one()

    def get_geometry_source(self, table_name):
        TableInfo = self.classes['table_info']
        GeometrySource = self.classes['geometry_source']
        return self.session.query(GeometrySource).join(GeometrySource.table_info).filter(TableInfo.name == table_name).one()

    def get_geometry_source_by_id(self, id):
        GeometrySource = self.classes['geometry_source']
        return self.session.query(GeometrySource).filter(GeometrySource.id == id).one()

    def add_geolinkage(self, geo_table_name, geo_column, attr_table_name, attr_column):
        GeometryLinkage = self.classes['geometry_linkage']
        geo_source = self.get_geometry_source(geo_table_name)
        attr_table = self.get_table_info(attr_table_name)
        linkage = GeometryLinkage(
            geometry_source=geo_source,
            geo_column=geo_column,
            attribute_table=attr_table,
            attr_column=attr_column)
        self.session.add(linkage)
        self.session.commit()

    def get_geometry_relation(self, from_source, to_source):
        GeometryRelation = self.classes['geometry_relation']
        try:
            return self.session.query(GeometryRelation).filter(
                GeometryRelation.geo_source_id == from_source.id,
                GeometryRelation.overlaps_with_id == to_source.id).one()
        except sqlalchemy.orm.exc.NoResultFound:
            return None
    
    def add_dependency(self, dep_name):
        dep_metadata, dep_tables = store.load_schema(dep_name)
        meta = dep_tables['ealgis_metadata']
        row = self.session.query(meta).one()
        logger.debug(row)

    def dump(self, target_file):
        logger.info("dumping database")
        os.environ['PGPASSWORD'] = self.dbpassword()
        shp_cmd = [
            "pg_dump", 
            str(self.engineurl()),
            "--schema=%s" % self._schema_name,
            "--format=c",
            "--file=%s" % target_file]

        stdout, stderr, code = cmdrun(shp_cmd)
        if code != 0:
            raise Exception("database dump with pg_dump failed: %s." % stderr)
        else:
            logger.info("successfully dumped database to %s" % target_file)
            logger.info("load with: pg_restore --username=user --dbname=db /path/to/%s" % self._schema_name)
            logger.info("then run VACUUM ANALYZE;")
    
    def set_version(self, **kwargs):
        version = self.classes['ealgis_metadata'](**kwargs)
        self.session.add(version)
        self.session.commit()


