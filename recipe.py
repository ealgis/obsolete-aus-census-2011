from census2011 import load_shapes
from census2011.ealgis.db import DataLoaderFactory


def main():
    factory = DataLoaderFactory("scratch_census_2011")
    load_shapes(factory)


if __name__ == '__main__':
    main()
