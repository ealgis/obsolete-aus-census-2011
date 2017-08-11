#!/usr/bin/env python

#
# EAlGIS loader: Australian Census 2011; Data Pack 1
#

from .ealgis.loaders import ZipAccess, ShapeLoader
from .ealgis.util import make_logger
import os
import glob
import os.path
import sqlalchemy


logger = make_logger(__name__)
SHAPE_SCHEMA = 'aus_census_2011_shapes'
SHP_LINKAGE = {
    'ced': ('ced_code', None, 'Commonwealth Electoral Division'),
    'gccsa': ('gccsa_code', None, 'Greater Capital City Statistical Areas'),
    'iare': ('iare_code', None, 'Indigenous Area'),
    'iloc': ('iloc_code', None, 'Indigenous Location'),
    'ireg': ('ireg_code', None, 'Indigenous Region'),
    'lga': ('lga_code', None, 'Local Government Area'),
    'poa': ('poa_code', None, 'Postal Areas'),
    'ra': ('ra_code', None, 'Remoteness Area'),
    'sa1': ('sa1_7digit', sqlalchemy.types.Integer, 'Statistical Area Level 1'),
    'sa2': ('sa2_main', None, 'Statistical Area Level 2'),
    'sa3': ('sa3_code', None, 'Statistical Area Level 3'),
    'sa4': ('sa4_code', None, 'Statistical Area Level 4'),
    'sed': ('sed_code', None, 'State Electoral Division'),
    'sla': ('sla_main', None, 'Statistical Local Areas'),
    'sos': ('sos_code', None, 'Section of State'),
    'sosr': ('sosr_code', None, 'Section of State Range'),
    'ssc': ('ssc_code', None, 'State Suburb'),
    'ste': ('state_code', None, 'State/Territory'),
    'sua': ('sua_code', None, 'Significant Urban Areas'),
    'ucl': ('ucl_code', None, 'Urban Centre/Locality')
}


def load_shapes(factory, census_dir, tmpdir):
    loader = factory.make_loader(SHAPE_SCHEMA, mandatory_srids=[3112, 3857])

    def shapefiles():
        def shape_and_proj(g):
            for f in g:
                shape_name = os.path.basename(f)
                proj = shape_name.split('_')[1]
                yield f, proj
        # favour the POW shapes over the others; release 3 eccentricity
        projs_provided = set()
        for fname, proj in shape_and_proj(glob.glob(os.path.join(census_dir, "Digital Boundaries/*_POW_shape.zip"))):
            projs_provided.add(proj)
            yield fname
        for fname, proj in shape_and_proj(glob.glob(os.path.join(census_dir, "Digital Boundaries/*_shape.zip"))):
            if proj not in projs_provided:
                yield fname

    def load_shapes():
        logger.info("load census shapefiles")
        new_tables = []
        for fname in shapefiles():
            with ZipAccess(None, tmpdir, fname) as z:
                for shpfile in z.glob("*.shp"):
                    before = set(loader.get_table_names())
                    instance = ShapeLoader(loader.dbschema(), shpfile, 4283)
                    instance.load(loader)
                    new = list(set(loader.get_table_names()) - before)
                    assert(len(new) == 1)
                    new_tables.append(new[0])
        logger.info("loaded shapefiles OK")
        logger.info("creating shape indexes")
        # create column indexes on shape linkage
        loader.session.commit()
        for census_division in SHP_LINKAGE:
            pfx = "%s_2011" % (census_division)
            matches = [t for t in new_tables if t.startswith(pfx)]
            table = matches[0]
            logger.info('creating index for %s' % (table))
            info = loader.get_table(table)
            col, _, descr = SHP_LINKAGE[census_division]
            loader.set_table_metadata(table, {'description': descr})
            idx = sqlalchemy.Index("%s_%s_idx" % (table, col), info.columns[col], unique=True)
            idx.create(loader.engine)

    loader.set_metadata(
        name='ABS Census 2011',
        description="2011 Australian Census: Spatial Data")
    loader.session.commit()
    load_shapes()
    return loader.result()
    loader.dump('/app/tmp/%s.dump' % (SHAPE_SCHEMA))
