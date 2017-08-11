from census2011 import load_shapes
from census2011 import load_attrs
from ealgis_common.db import DataLoaderFactory
from ealgis_common.util import make_logger


logger = make_logger(__name__)


def main():
    tmpdir = "/app/tmp"
    census_dir = '/app/data/2011 Datapacks BCP_IP_TSP_PEP_ECP_WPP_ERP_Release 3'
    factory = DataLoaderFactory("scratch_census_2011", clean=False)
    shape_result = load_shapes(factory, census_dir, tmpdir)
    attrs_results = load_attrs(factory, census_dir, tmpdir)
    for result in [shape_result] + attrs_results:
        result.dump(tmpdir)


if __name__ == '__main__':
    main()
