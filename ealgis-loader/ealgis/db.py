
try:
    import simplejson as json
except ImportError:
    import json
from sqlalchemy import inspect
from sqlalchemy.ext.declarative import declarative_base
import sys
import os
import sqlalchemy
import hashlib
import time
import random

Base = declarative_base()


class EAlGIS(object):
    "singleton with key application (eg. database connection) state"
    # pattern credit: http://stackoverflow.com/questions/42558/python-and-the-singleton-pattern
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(EAlGIS, cls).__new__(cls, *args, **kwargs)
            cls._instance._made = False
        return cls._instance

    def __init__(self):
        # don't want to construct multiple times
        if self._made:
            return
        self._made = True
        self.app = self._generate_app()
        self.datainfo = None

    def _connection_string(self):
        # try and autoconfigure for running under docker
        dbuser = os.environ.get('DB_USERNAME')
        dbpassword = os.environ.get('DB_PASSWORD')
        dbhost = os.environ.get('DB_HOST')
        if dbuser and dbpassword and dbhost:
            return 'postgres://%s:%s@%s:5432/ealgis' % (dbuser, dbpassword, dbhost)
        return 'postgres:///ealgis'

    def _generate_app(self):
        app = Flask(__name__)
        app.wsgi_app = ReverseProxied(app.wsgi_app)
        app.config['PROPAGATE_EXCEPTIONS'] = True
        app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
        app.config['SQLALCHEMY_DATABASE_URI'] = self._connection_string()

        return app

    def create_extensions(self):
        extensions = ('postgis', 'postgis_topology', 'citext', 'hstore')
        for extension in extensions:
            try:
                self.db.engine.execute('CREATE EXTENSION %s;' % extension)
                db.session.commit()
            except sqlalchemy.exc.ProgrammingError as e:
                if 'already exists' not in str(e):
                    print("couldn't load: %s (%s)" % (extension, e))

    def get_datainfo(self):
        """grab a representation of the data available in the database
        result is cached, so after first call this is fast"""

        def dump_linkage(linkage):
            name = linkage.attribute_table.name
            if linkage.attribute_table.metadata_json is not None:
                obj = json.loads(linkage.attribute_table.metadata_json)
            else:
                obj = {}
            obj['_id'] = linkage.id
            return name, obj

        def dump_source(source):
            if source.table_info.metadata_json is not None:
                source_info = json.loads(source.table_info.metadata_json)
            else:
                source_info = {'description': source.table_info.name}
            source_info['_id'] = source.id

            # source_info['tables'] = dict(dump_linkage(t) for t in source.linkages)
            source_info['type'] = source.geometry_type
            return source_info

        def make_datainfo():
            # our geography sources
            info = {}
            for source in GeometrySource.query.all():
                name = source.table_info.name
                info[name] = dump_source(source)
            return info

        if self.datainfo is None:
            self.datainfo = make_datainfo()
        return self.datainfo

    def serve(self):
        self.cache = {}
        print("%d >> spinning up" % (os.getpid()))
        # prime datainfo
        self.get_datainfo()
        print("%d >> ready" % (os.getpid()))
        return self.app

    def set_setting(self, k, v):
        try:
            setting = self.db.session.query(Setting).filter(Setting.key == k).one()
            setting.value = v
            self.db.session.commit()
        except sqlalchemy.orm.exc.NoResultFound:
            setting = Setting(key=k, value=v)
            self.db.session.add(setting)
            self.db.session.commit()

    def clear_setting(self, k):
        try:
            setting = self.db.session.query(Setting).filter(Setting.key == k).one()
            self.db.session.delete(setting)
            self.db.session.commit()
        except sqlalchemy.orm.exc.NoResultFound:
            pass

    def get_setting(self, k, d=None):
        try:
            setting = self.db.session.query(Setting).filter(Setting.key == k).one()
            return setting.value
        except sqlalchemy.orm.exc.NoResultFound:
            if d is None:
                raise KeyError()
            return d

    def _get_metadata(self):
        metadata = db.MetaData(bind=db.engine)
        metadata.reflect()
        return metadata

    def metadata_dirty(self):
        self._metadata = None
    
    def engineurl(self):
        return self.db.engine.url

    def dbname(self):
        return self.db.engine.url.database

    def dbhost(self):
        return self.db.engine.url.host

    def dbuser(self):
        return self.db.engine.url.username

    def dbport(self):
        return self.db.engine.url.port

    def dbpassword(self):
        return self.db.engine.url.password

    def have_table(self, table_name):
        try:
            self.get_table(table_name)
            return True
        except sqlalchemy.exc.NoSuchTableError:
            return False

    def get_table(self, table_name):
        return sqlalchemy.Table(table_name, sqlalchemy.MetaData(), autoload=True, autoload_with=db.engine)

    def get_table_names(self):
        "this is a more lightweight approach to getting table names from the db that avoids all of that messy reflection"
        "c.f. http://docs.sqlalchemy.org/en/rel_0_9/core/reflection.html?highlight=inspector#fine-grained-reflection-with-inspector"
        inspector = inspect(db.engine)
        return inspector.get_table_names()

    def unload(self, table_name):
        "drop a table and all associated EAlGIS information"
        try:
            ti = self.get_table_info(table_name)
        except sqlalchemy.orm.exc.NoResultFound:
            print("table `%s' is not registered with EAlGIS, unload request ignored." % table_name, file=sys.stderr)
            return False
        try:
            tbl = self.get_table(table_name)
            tbl.drop(self.db.engine)
            self.db.session.delete(ti)
            self.db.session.commit()
            return True
        except sqlalchemy.exc.NoSuchTableError:
            print("mystery unregister bug", file=sys.stderr)
            return False

    def get_table_class(self, table_name):
        # nothing bad happens if there is a clash, but it produces
        # warnings
        nm = str('tbl_%s_%s' % (table_name, hashlib.sha1("%s%g%g" % (table_name, random.random(), time.time())).hexdigest()[:8]))
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
        self.db.session.commit()

    def register_columns(self, table_name, columns):
        ti = self.get_table_info(table_name)
        for column_name, meta_dict in columns:
            ci = ColumnInfo(name=column_name, table_info=ti, metadata_json=json.dumps(meta_dict))
            self.db.session.add(ci)
        self.db.session.commit()

    def register_column(self, table_name, column_name, meta_dict):
        self.register_columns(table_name, [column_name, meta_dict])

    def required_srids(self):
        srids = set()

        def add_srid(s):
            if s is not None:
                srids.add(int(s))

        add_srid(self.get_setting('projected_srid', None))
        add_srid(self.get_setting('map_srid', None))
        return srids

    def repair_geometry(self, geometry_source):
        print("running geometry QC and repair:", geometry_source.table_info.name)
        cls = self.get_table_class(geometry_source.table_info.name)
        geom_attr = getattr(cls, geometry_source.column)
        self.db.session.execute(sqlalchemy.update(
            cls.__table__, values={
                geom_attr: sqlalchemy.func.st_multi(sqlalchemy.func.st_buffer(geom_attr, 0))
            }).where(sqlalchemy.func.st_isvalid(geom_attr) == False))  # noqa

    def reproject(self, geometry_source, to_srid):
        # add the geometry column
        new_column = "%s_%d" % (geometry_source.column, to_srid)
        self.db.session.execute(sqlalchemy.func.addgeometrycolumn(
            geometry_source.table_info.name,
            new_column,
            to_srid,
            geometry_source.geometry_type,
            2))  # fixme ndim=2 shouldn't be hard-coded
        self.db.session.commit()
        # committed, so we can introspect it, and then transform original
        # geometry data to this SRID
        cls = self.get_table_class(geometry_source.table_info.name)
        tbl = cls.__table__
        self.db.session.execute(
            sqlalchemy.update(
                tbl, values={
                    getattr(tbl.c, new_column):
                    sqlalchemy.func.st_transform(
                        sqlalchemy.func.ST_Force2D(
                            getattr(tbl.c, geometry_source.column)),
                        to_srid)
                }))
        # record projection information in the DB
        proj_info = GeometrySourceProjected(
            geometry_source_id=geometry_source.id,
            srid=to_srid,
            column=new_column)
        self.db.session.add(proj_info)
        # make a geometry index on this
        self.db.session.commit()
        self.db.session.execute("CREATE INDEX %s ON %s USING gist ( %s )" % (
            "%s_%s_gist" % (
                geometry_source.table_info.name,
                new_column),
            geometry_source.table_info.name,
            new_column))
        self.db.session.commit()

    def register_table(self, table_name, geom=False, srid=None, gid=None):
        self.metadata_dirty()
        ti = TableInfo(name=table_name)
        self.db.session.add(ti)
        if geom:
            column = self.geom_column(table_name)
            if column is None:
                raise Exception("Cannot automatically determine geometry column for `%s'" % table_name)
            # figure out what type of geometry this is
            qstr = 'SELECT geometrytype(%s) as geomtype FROM %s WHERE %s IS NOT null GROUP BY geomtype' % \
                (column.name, table_name, column.name)
            conn = self.db.session.connection()
            res = conn.execute(qstr)
            rows = res.fetchall()
            if len(rows) != 1:
                geomtype = 'GEOMETRY'
            else:
                geomtype = rows[0][0]
            ti.geometry_source = GeometrySource(column=column.name, geometry_type=geomtype, srid=srid, gid=gid)
            to_generate = self.required_srids()
            if srid in to_generate:
                to_generate.remove(srid)
            self.repair_geometry(ti.geometry_source)
            for gen_srid in to_generate:
                self.reproject(ti.geometry_source, gen_srid)
        self.db.session.commit()
        return ti

    def get_table_info(self, table_name):
        return TableInfo.query.filter(TableInfo.name == table_name).one()

    def get_geometry_source(self, table_name):
        return GeometrySource.query.join(GeometrySource.table_info).filter(TableInfo.name == table_name).one()

    def get_geometry_source_by_id(self, id):
        return GeometrySource.query.filter(GeometrySource.id == id).one()

    def resolve_attribute(self, geometry_source, attribute):
        attribute = attribute.lower()  # upper case tables or columns seem unlikely, but a possible FIXME
        # supports table_name.column_name OR just column_name
        s = attribute.split('.', 1)
        q = self.db.session.query(ColumnInfo, GeometryLinkage.id).join(TableInfo).join(GeometryLinkage)
        if len(s) == 2:
            q = q.filter(TableInfo.name == s[0])
            attr_name = s[1]
        else:
            attr_name = s[0]
        q = q.filter(GeometryLinkage.geometry_source == geometry_source).filter(ColumnInfo.name == attr_name)
        matches = q.all()
        if len(matches) > 1:
            raise TooManyMatches(attribute)
        elif len(matches) == 0:
            raise NoMatches(attribute)
        else:
            ci, linkage_id = matches[0]
            return GeometryLinkage.query.get(linkage_id), ci

    def add_geolinkage(self, geo_table_name, geo_column, attr_table_name, attr_column):
        geo_source = self.get_geometry_source(geo_table_name)
        attr_table = self.get_table_info(attr_table_name)
        linkage = GeometryLinkage(
            geometry_source=geo_source,
            geo_column=geo_column,
            attribute_table=attr_table,
            attr_column=attr_column)
        self.db.session.add(linkage)
        self.db.session.commit()

    def get_geometry_relation(self, from_source, to_source):
        try:
            return self.db.session.query(GeometryRelation).filter(
                GeometryRelation.geo_source_id == from_source.id,
                GeometryRelation.overlaps_with_id == to_source.id).one()
        except sqlalchemy.orm.exc.NoResultFound:
            return None

    def recompile_all(self):
        for defn in MapDefinition.query.all():
            config = defn.get()
            defn.set(config, force=True)
