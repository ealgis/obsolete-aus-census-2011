import os.path
import hashlib
import zipfile
import sqlalchemy
import subprocess
import glob
from .util import piperun, table_name_valid, make_logger

from .seqclassifier import SequenceClassifier
import csv


logger = make_logger(__name__)


class LoaderException(Exception):
    pass


class DirectoryAccess(object):
    def __init__(self, directory):
        self._directory = directory

    def __enter__(self):
        return self

    def __exit__(self, type, value, traceback):
        pass

    def getdir(self):
        return self._directory

    def get(self, filename):
        return os.path.join(self._directory, filename)

    def glob(self, pattern):
        return glob.glob(os.path.join(self.getdir(), pattern))


class ZipAccess(DirectoryAccess):
    def __init__(self, parent, tmpdir, zf_path):
        self._parent, self._tmpdir, self._zf_path = parent, tmpdir, zf_path
        self._unpacked = False
        dpath = os.path.join(self._tmpdir, hashlib.sha1(zf_path.encode('utf8')).hexdigest())
        super(ZipAccess, self).__init__(dpath)

    def _unpack(self):
        if self._parent is not None:
            zf_path = self._parent.get(self._zf_path)
        else:
            zf_path = self._zf_path
        with open(zf_path, 'rb') as fd:
            with zipfile.ZipFile(fd) as zf:
                zf.extractall(self.getdir())
        self._unpacked = True

    def get(self, filename):
        if not self._unpacked:
            self._unpack()
        return super(ZipAccess, self).get(filename)

    def glob(self, filename):
        if not self._unpacked:
            self._unpack()
        return super(ZipAccess, self).glob(filename)

    def __exit__(self, type, value, traceback):
        return super(ZipAccess, self).__exit__(type, value, traceback)


class RewrittenCSV(object):
    def __init__(self, tmpdir, csvpath, mutate_row_cb=None):
        def default_mutate(line, row):
            return row
        if mutate_row_cb is None:
            mutate_row_cb = default_mutate
        self._tmpdir = tmpdir
        self._path = os.path.join(self._tmpdir, hashlib.sha1(csvpath.encode('utf8')).hexdigest() + '.csv')
        with open(csvpath, 'r') as csv_in:
            with open(self._path, 'w') as csv_out:
                r = csv.reader(csv_in)
                w = csv.writer(csv_out)
                w.writerows((mutate_row_cb(line, row) for (line, row) in enumerate(r)))

    def get(self):
        return self._path

    def __enter__(self):
        return self

    def __exit__(self, *args):
        os.unlink(self._path)


class GeoDataLoader(object):
    @classmethod
    def get_file_base(cls, fname):
        return os.path.splitext(fname)[0]

    @classmethod
    def generate_table_name(cls, base):
        table_name = os.path.splitext(os.path.basename(base))[0].replace(" ", "_").replace("-", '_')
        return table_name.lower()


class ShapeLoader(GeoDataLoader):
    @classmethod
    def prj_text(cls, shppath):
        # figure out srid code
        shpbase = ShapeLoader.get_file_base(shppath)
        try:
            with open(shpbase + '.prj') as prj:
                return prj.read()
        except IOError:
            return None

    def __init__(self, schema_name, shppath, srid, table_name=None):
        self.schema_name = schema_name
        self.shppath = shppath
        self.shpbase = ShapeLoader.get_file_base(shppath)
        self.shpname = os.path.basename(shppath)
        self.table_name = table_name or GeoDataLoader.generate_table_name(shppath)
        if not table_name_valid(self.table_name):
            raise LoaderException("table name is `%s' is invalid." % self.table_name)
        self.srid = srid

    def load(self, eal):
        shp_cmd = ['shp2pgsql', '-s', str(self.srid), '-t', '2D', '-I', self.shppath, self.schema_name + '.' + self.table_name]
        os.environ['PGPASSWORD'] = eal.dbpassword()
        _, _, code = piperun(shp_cmd, [
            'psql',
            '-h', eal.dbhost(),
            '-U', eal.dbuser(),
            '-p', str(eal.dbport()),
            '-q', eal.dbname()])
        if code != 0:
            raise LoaderException("load of %s failed." % self.shpname)
        # make the meta info
        logger.info("registering, table name is: %s" % (self.table_name))
        eal.register_table(self.table_name, geom=True, srid=self.srid, gid='gid')


class MapInfoLoader(GeoDataLoader):
    def __init__(self, filename, srid, table_name=None):
        self.filename = filename
        self.srid = srid
        self.table_name = table_name or GeoDataLoader.generate_table_name(MapInfoLoader.get_file_base(filename))
        if not table_name_valid(self.table_name):
            raise LoaderException("table name is `%s' is invalid." % self.table_name)

    def load(self, eal):
        ogr_cmd = [
            'ogr2ogr',
            '-f', 'postgresql',
            'PG:dbname=\'%s\' host=\'%s\' port=\'%d\' user=\'%s\' password=\'%s\'' % (eal.dbname(), eal.dbhost(), eal.dbport(), eal.dbuser(), eal.dbpassword()),
            self.filename,
            '-nln', self.table_name,
            '-lco', 'fid=gid']
        logger.debug(ogr_cmd)
        try:
            subprocess.check_call(ogr_cmd)
        except subprocess.CalledProcessError:
            raise LoaderException("load of %s failed." % os.path.basename(self.filename))
        # make the meta info
        logger.info("registering, table name is: %s" % (self.table_name))
        eal.register_table(self.table_name, geom=True, srid=self.srid, gid='gid')


class KMLLoader(GeoDataLoader):
    def __init__(self, filename, srid, table_name=None):
        self.filename = filename
        self.srid = srid
        self.table_name = table_name or GeoDataLoader.generate_table_name(MapInfoLoader.get_file_base(filename))
        if not table_name_valid(self.table_name):
            raise LoaderException("table name is `%s' is invalid." % self.table_name)

    def load(self, eal):
        ogr_cmd = [
            'ogr2ogr',
            '-f', 'postgresql',
            'PG:dbname=\'%s\' host=\'%s\' port=\'%d\' user=\'%s\' password=\'%s\'' % (eal.dbname(), eal.dbhost(), eal.dbport(), eal.dbuser(), eal.dbpassword()),
            self.filename,
            '-nln', self.table_name,
            '-append',
            '-lco', 'fid=gid']
        logger.debug(ogr_cmd)
        try:
            subprocess.check_call(ogr_cmd)
        except subprocess.CalledProcessError:
            raise LoaderException("load of %s failed." % os.path.basename(self.filename))
        # delete any pins or whatever
        cls = eal.get_table_class(self.table_name)
        for obj in eal.db.session.query(cls).filter(sqlalchemy.func.geometrytype(cls.wkb_geometry) != 'MULTIPOLYGON'):
            eal.db.session.delete(obj)
        eal.db.session.commit()
        # make the meta info
        logger.debug("registering, table name is: %s" % (self.table_name))
        eal.register_table(self.table_name, geom=True, srid=self.srid, gid='gid')


class CSVLoader(GeoDataLoader):
    def __init__(self, schema_name, table_name, csvpath, pkey_column=None):
        self.schema_name = schema_name
        self.table_name = table_name
        self.csvpath = csvpath
        self.pkey_column = pkey_column

    def load(self, loader, column_types=None):
        def get_column_types(header, max_rows=None):
            sql_columns = {
                int: sqlalchemy.types.Integer,
                float: sqlalchemy.types.Float,
                str: sqlalchemy.types.Text
            }
            if column_types is not None:
                return [sql_columns[t] for t in column_types]
            classifiers = [SequenceClassifier() for column in header]
            for i, row in enumerate(r):
                for classifier, value in zip(classifiers, row):
                    classifier.update(value)
                if max_rows is not None and i == max_rows:
                    break
            return [sql_columns[t.get()] for t in classifiers]

        def columns(header):
            coldefs = []
            for idx, (column_name, ty) in enumerate(zip(header, get_column_types(header))):
                make_index = idx == self.pkey_column
                coldefs.append(sqlalchemy.Column(
                    column_name.lower(),
                    ty,
                    index=make_index,
                    unique=make_index,
                    primary_key=make_index))
            return coldefs

        # smell the file, generate a SQLAlchemy table definition
        # and then make it
        with open(self.csvpath) as fd:
            r = csv.reader(fd)
            header = next(r)
            cols = columns(header)
        metadata = sqlalchemy.MetaData()
        new_tbl = sqlalchemy.Table(self.table_name, metadata, *cols, schema=self.schema_name)
        metadata.create_all(loader.engine)
        loader.session.commit()
        del new_tbl

        # invoke the Postgres CSV loader
        conn = loader.session.connection()
        conn.execute('COPY %s.%s FROM %%s CSV HEADER' % (self.schema_name, self.table_name), (self.csvpath, ))
        ti = loader.register_table(self.table_name)
        loader.session.commit()
        return ti
