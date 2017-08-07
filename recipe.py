from census2011 import load_shapes
from census2011.ealgis.db import DataLoaderFactory
from census2011.ealgis.util import make_logger


logger = make_logger(__name__)


def main():
    tmpdir = "/app/tmp"
    census_dir = '/app/data/2011 Datapacks BCP_IP_TSP_PEP_ECP_WPP_ERP_Release 3'
    factory = DataLoaderFactory("scratch_census_2011", clean=True)
    shape_result = load_shapes(factory, census_dir, tmpdir)
    logger.debug(shape_result)


if __name__ == '__main__':
    main()
