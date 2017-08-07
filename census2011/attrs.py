#!/usr/bin/env python

#
# EAlGIS loader: Australian Census 2011; Data Pack 1
#

import re
import os
import glob
import os.path
import openpyxl

from .ealgis.loaders import RewrittenCSV, CSVLoader
from .ealgis.util import alistdir, make_logger

logger = make_logger(__name__)


def load_package(loader, census_dir, tmpdir, dirname, xlsx_name):
    census_division_table = {}
    geo_gid_mapping = {}

    data_tables = []

    def load_datapacks(packname):
        def get_csv_files():
            files = []
            for geography in alistdir(d):
                g = os.path.join(geography, "*.csv")
                csv_files = glob.glob(g)
                if len(csv_files) == 0:
                    g = os.path.join(geography, "AUST", "*.csv")
                    csv_files = glob.glob(g)
                if len(csv_files) == 0:
                    raise Exception("can't find CSV files for `%s'" % geography)
                files += csv_files
            return files

        d = os.path.join(census_dir, packname, "Sequential Number Descriptor")
        csv_files = get_csv_files()
        table_re = re.compile(r'^2011Census_(.*)_sequential.csv$')
        linkage_pending = []

        for i, csv_path in enumerate(csv_files):
            if i > 3:
                break
            logger.info("[%d/%d] %s: %s" % (i + 1, len(csv_files), packname, os.path.basename(csv_path)))
            table_name = table_re.match(os.path.split(csv_path)[-1]).groups()[0].lower()
            data_tables.append(table_name)
            decoded = table_name.split('_')
            census_table, census_country = table_name[0], table_name[1]
            if len(decoded) == 3:
                census_division = decoded[2]
            else:
                census_division = None

            gid_match = None

            if census_division is not None:
                def make_match_fn():
                    lookup = geo_gid_mapping[census_division]

                    def _matcher(line, row):
                        if line == 0:
                            # rewrite the header
                            return ['gid'] + row
                        else:
                            return [str(lookup[row[0]])] + row
                    return _matcher
                gid_match = make_match_fn()

            # normalise the CSV file by reading it in and writing it out again,
            # Postgres is quite pedantic. we also want to add an additional column to it
            with RewrittenCSV(tmpdir, csv_path, gid_match) as norm:
                instance = CSVLoader(table_name, norm.get(), pkey_column=0)
                table_info = instance.load(loader)
                if table_info is not None and census_division is not None:
                    linkage_pending.append((table_name, table_info, census_division))

        # done as another pass to avoid having to re-run the reflection of the entire
        # database for every CSV file loaded (can be thousands)
        for attr_table, table_info, census_division in linkage_pending:
            geo_table = census_division_table[census_division]
            geo_column, _, _ = shp_linkage[census_division]
            loader.add_geolinkage(
                geo_table, "gid",
                attr_table, "gid")

    def load_metadata(*fnames):
        def load_workbook(fname):
            logger.info("parsing metadata: %s" % (fname))
            wb = openpyxl.load_workbook(fname, use_iterators=True)

            def sheet_data(sheet):
                return ([t.internal_value for t in r] for r in sheet.iter_rows())

            def skip(it, n):
                for i in range(n):
                    next(it)

            sheet_iter = sheet_data(wb.worksheets[0])
            skip(sheet_iter, 3)
            for row in sheet_iter:
                name = row[0]
                if not name:
                    continue
                name = name.lower()
                table_meta[name] = {'type': row[1], 'kind': row[2]}

            sheet_iter = sheet_data(wb.worksheets[1])
            skip(sheet_iter, 4)
            for row in sheet_iter:
                name = row[0]
                if not name:
                    continue
                name = name.lower()
                short_name, long_name, datapack_file, profile_table, column_heading = row[1:6]
                datapack_file = datapack_file.lower()
                if datapack_file not in col_meta:
                    col_meta[datapack_file] = []
                col_meta[datapack_file].append((name, {'type': row[2], 'kind': row[5]}))
            del wb

        table_meta = {}
        col_meta = {}
        for fname in fnames:
            load_workbook(os.path.join(census_dir, os.path.join('Metadata/', fname)))

        for table_name in data_tables:
            datapack_file = table_name.split('_', 1)[0].lower()
            m = re.match('^([A-Za-z]+[0-9]+)([a-z]+)?$', datapack_file)
            table_number = m.groups()[0]
            meta = table_meta[table_number]
            columns = col_meta[datapack_file]
            loader.set_table_metadata(table_name, meta)
            loader.register_columns(table_name, columns)

    loader.set_metadata(
        name="ABS Census 2011",
        description="Shapes")


def load_attrs(factory, census_dir, tmpdir):
    release = '3'
    packages = [
        ("2011 Basic Community Profile", "BCP"),
        ("2011 Aboriginal and Torres Strait Islander Peoples Profile", "IP"),
        ("2011 Place of Enumeration Profile", "PEP"),
        ("2011 Expanded Community Profile", "XCP"),
        ("2011 Time Series Profile", "TSP"),
        ("2011 Working Population Profile", "WPP"),
    ]
    for basename, abbrev in packages:
        dirname = basename + ' Release %s' % release
        schema_name = 'aus_census_2011_' + abbrev.lower()
        xlsx_name = "Metadata_2011_%s_DataPack.xlsx" % abbrev
        logger.debug([schema_name, dirname, xlsx_name])
        loader = factory.make_loader(schema_name)
        load_package(loader, census_dir, tmpdir, dirname, xlsx_name)
