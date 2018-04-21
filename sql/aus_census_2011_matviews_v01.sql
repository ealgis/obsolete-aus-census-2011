DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.ced_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.ced_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.ced AS geomtable;
CREATE INDEX "ced_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."ced_view" USING GIST ("geom_4326_z5");
CREATE INDEX "ced_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."ced_view" USING GIST ("geom_4326_z7");
CREATE INDEX "ced_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."ced_view" USING GIST ("geom_4326_z9");
CREATE INDEX "ced_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."ced_view" USING GIST ("geom_4326_z11");
CREATE INDEX "ced_view_geom_4326_gist" ON "aus_census_2011_shapes"."ced_view" USING GIST ("geom_4326");
CREATE UNIQUE INDEX "ced_view_ced_view_code_idx" ON "aus_census_2011_shapes"."ced_view" ("ced_code");
CREATE INDEX "ced_view_geom_3112_gist" ON "aus_census_2011_shapes"."ced_view" USING gist ("geom_3112");
CREATE INDEX "ced_view_geom_3857_gist" ON "aus_census_2011_shapes"."ced_view" USING gist ("geom_3857");
CREATE INDEX "ced_view_geom_idx" ON "aus_census_2011_shapes"."ced_view" USING gist ("geom");
CREATE UNIQUE INDEX "ced_view_gid_idx" ON "aus_census_2011_shapes"."ced_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.gccsa_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.gccsa_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.gccsa AS geomtable;
CREATE INDEX "gccsa_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."gccsa_view" USING GIST ("geom_4326_z5");
CREATE INDEX "gccsa_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."gccsa_view" USING GIST ("geom_4326_z7");
CREATE INDEX "gccsa_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."gccsa_view" USING GIST ("geom_4326_z9");
CREATE INDEX "gccsa_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."gccsa_view" USING GIST ("geom_4326_z11");
CREATE INDEX "gccsa_view_geom_4326_gist" ON "aus_census_2011_shapes"."gccsa_view" USING GIST ("geom_4326");
CREATE UNIQUE INDEX "gccsa_view_gccsa_view_code_idx" ON "aus_census_2011_shapes"."gccsa_view" ("gccsa_code");
CREATE INDEX "gccsa_view_geom_3112_gist" ON "aus_census_2011_shapes"."gccsa_view" USING gist ("geom_3112");
CREATE INDEX "gccsa_view_geom_3857_gist" ON "aus_census_2011_shapes"."gccsa_view" USING gist ("geom_3857");
CREATE INDEX "gccsa_view_geom_idx" ON "aus_census_2011_shapes"."gccsa_view" USING gist ("geom");
CREATE UNIQUE INDEX "gccsa_view_gid_idx" ON "aus_census_2011_shapes"."gccsa_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.iare_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.iare_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.iare AS geomtable;
CREATE INDEX "iare_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."iare_view" USING GIST ("geom_4326_z5");
CREATE INDEX "iare_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."iare_view" USING GIST ("geom_4326_z7");
CREATE INDEX "iare_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."iare_view" USING GIST ("geom_4326_z9");
CREATE INDEX "iare_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."iare_view" USING GIST ("geom_4326_z11");
CREATE INDEX "iare_view_geom_4326_gist" ON "aus_census_2011_shapes"."iare_view" USING GIST ("geom_4326");
CREATE INDEX "iare_view_geom_3112_gist" ON "aus_census_2011_shapes"."iare_view" USING gist ("geom_3112");
CREATE INDEX "iare_view_geom_3857_gist" ON "aus_census_2011_shapes"."iare_view" USING gist ("geom_3857");
CREATE INDEX "iare_view_geom_idx" ON "aus_census_2011_shapes"."iare_view" USING gist ("geom");
CREATE UNIQUE INDEX "iare_view_iare_view_code_idx" ON "aus_census_2011_shapes"."iare_view" ("iare_code");
CREATE UNIQUE INDEX "iare_view_gid_idx" ON "aus_census_2011_shapes"."iare_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.iloc_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.iloc_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.iloc AS geomtable;
CREATE INDEX "iloc_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."iloc_view" USING GIST ("geom_4326_z5");
CREATE INDEX "iloc_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."iloc_view" USING GIST ("geom_4326_z7");
CREATE INDEX "iloc_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."iloc_view" USING GIST ("geom_4326_z9");
CREATE INDEX "iloc_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."iloc_view" USING GIST ("geom_4326_z11");
CREATE INDEX "iloc_view_geom_4326_gist" ON "aus_census_2011_shapes"."iloc_view" USING GIST ("geom_4326");
CREATE INDEX "iloc_view_geom_3112_gist" ON "aus_census_2011_shapes"."iloc_view" USING gist ("geom_3112");
CREATE INDEX "iloc_view_geom_3857_gist" ON "aus_census_2011_shapes"."iloc_view" USING gist ("geom_3857");
CREATE INDEX "iloc_view_geom_idx" ON "aus_census_2011_shapes"."iloc_view" USING gist ("geom");
CREATE UNIQUE INDEX "iloc_view_iloc_view_code_idx" ON "aus_census_2011_shapes"."iloc_view" ("iloc_code");
CREATE UNIQUE INDEX "iloc_view_gid_idx" ON "aus_census_2011_shapes"."iloc_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.ireg_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.ireg_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.ireg AS geomtable;
CREATE INDEX "ireg_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."ireg_view" USING GIST ("geom_4326_z5");
CREATE INDEX "ireg_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."ireg_view" USING GIST ("geom_4326_z7");
CREATE INDEX "ireg_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."ireg_view" USING GIST ("geom_4326_z9");
CREATE INDEX "ireg_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."ireg_view" USING GIST ("geom_4326_z11");
CREATE INDEX "ireg_view_geom_4326_gist" ON "aus_census_2011_shapes"."ireg_view" USING GIST ("geom_4326");
CREATE INDEX "ireg_view_geom_3112_gist" ON "aus_census_2011_shapes"."ireg_view" USING gist ("geom_3112");
CREATE INDEX "ireg_view_geom_3857_gist" ON "aus_census_2011_shapes"."ireg_view" USING gist ("geom_3857");
CREATE INDEX "ireg_view_geom_idx" ON "aus_census_2011_shapes"."ireg_view" USING gist ("geom");
CREATE UNIQUE INDEX "ireg_view_ireg_view_code_idx" ON "aus_census_2011_shapes"."ireg_view" ("ireg_code");
CREATE UNIQUE INDEX "ireg_view_gid_idx" ON "aus_census_2011_shapes"."ireg_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.lga_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.lga_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.lga AS geomtable;
CREATE INDEX "lga_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."lga_view" USING GIST ("geom_4326_z5");
CREATE INDEX "lga_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."lga_view" USING GIST ("geom_4326_z7");
CREATE INDEX "lga_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."lga_view" USING GIST ("geom_4326_z9");
CREATE INDEX "lga_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."lga_view" USING GIST ("geom_4326_z11");
CREATE INDEX "lga_view_geom_4326_gist" ON "aus_census_2011_shapes"."lga_view" USING GIST ("geom_4326");
CREATE INDEX "lga_view_geom_3112_gist" ON "aus_census_2011_shapes"."lga_view" USING gist ("geom_3112");
CREATE INDEX "lga_view_geom_3857_gist" ON "aus_census_2011_shapes"."lga_view" USING gist ("geom_3857");
CREATE INDEX "lga_view_geom_idx" ON "aus_census_2011_shapes"."lga_view" USING gist ("geom");
CREATE UNIQUE INDEX "lga_view_lga_view_code_idx" ON "aus_census_2011_shapes"."lga_view" ("lga_code");
CREATE UNIQUE INDEX "lga_view_gid_idx" ON "aus_census_2011_shapes"."lga_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.poa_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.poa_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.poa AS geomtable;
CREATE INDEX "poa_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."poa_view" USING GIST ("geom_4326_z5");
CREATE INDEX "poa_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."poa_view" USING GIST ("geom_4326_z7");
CREATE INDEX "poa_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."poa_view" USING GIST ("geom_4326_z9");
CREATE INDEX "poa_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."poa_view" USING GIST ("geom_4326_z11");
CREATE INDEX "poa_view_geom_4326_gist" ON "aus_census_2011_shapes"."poa_view" USING GIST ("geom_4326");
CREATE INDEX "poa_view_geom_3112_gist" ON "aus_census_2011_shapes"."poa_view" USING gist ("geom_3112");
CREATE INDEX "poa_view_geom_3857_gist" ON "aus_census_2011_shapes"."poa_view" USING gist ("geom_3857");
CREATE INDEX "poa_view_geom_idx" ON "aus_census_2011_shapes"."poa_view" USING gist ("geom");
CREATE UNIQUE INDEX "poa_view_poa_view_code_idx" ON "aus_census_2011_shapes"."poa_view" ("poa_code");
CREATE UNIQUE INDEX "poa_view_gid_idx" ON "aus_census_2011_shapes"."poa_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.ra_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.ra_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.ra AS geomtable;
CREATE INDEX "ra_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."ra_view" USING GIST ("geom_4326_z5");
CREATE INDEX "ra_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."ra_view" USING GIST ("geom_4326_z7");
CREATE INDEX "ra_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."ra_view" USING GIST ("geom_4326_z9");
CREATE INDEX "ra_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."ra_view" USING GIST ("geom_4326_z11");
CREATE INDEX "ra_view_geom_4326_gist" ON "aus_census_2011_shapes"."ra_view" USING GIST ("geom_4326");
CREATE INDEX "ra_view_geom_3112_gist" ON "aus_census_2011_shapes"."ra_view" USING gist ("geom_3112");
CREATE INDEX "ra_view_geom_3857_gist" ON "aus_census_2011_shapes"."ra_view" USING gist ("geom_3857");
CREATE INDEX "ra_view_geom_idx" ON "aus_census_2011_shapes"."ra_view" USING gist ("geom");
CREATE UNIQUE INDEX "ra_view_ra_view_code_idx" ON "aus_census_2011_shapes"."ra_view" ("ra_code");
CREATE UNIQUE INDEX "ra_view_gid_idx" ON "aus_census_2011_shapes"."ra_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.sa1_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.sa1_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.sa1 AS geomtable;
CREATE INDEX "sa1_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."sa1_view" USING GIST ("geom_4326_z5");
CREATE INDEX "sa1_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."sa1_view" USING GIST ("geom_4326_z7");
CREATE INDEX "sa1_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."sa1_view" USING GIST ("geom_4326_z9");
CREATE INDEX "sa1_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."sa1_view" USING GIST ("geom_4326_z11");
CREATE INDEX "sa1_view_geom_4326_gist" ON "aus_census_2011_shapes"."sa1_view" USING GIST ("geom_4326");
CREATE INDEX "sa1_view_geom_3112_gist" ON "aus_census_2011_shapes"."sa1_view" USING gist ("geom_3112");
CREATE INDEX "sa1_view_geom_3857_gist" ON "aus_census_2011_shapes"."sa1_view" USING gist ("geom_3857");
CREATE INDEX "sa1_view_geom_idx" ON "aus_census_2011_shapes"."sa1_view" USING gist ("geom");
CREATE UNIQUE INDEX "sa1_view_sa1_view_7digit_idx" ON "aus_census_2011_shapes"."sa1_view" ("sa1_7digit");
CREATE UNIQUE INDEX "sa1_view_gid_idx" ON "aus_census_2011_shapes"."sa1_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.sa2_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.sa2_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.sa2 AS geomtable;
CREATE INDEX "sa2_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."sa2_view" USING GIST ("geom_4326_z5");
CREATE INDEX "sa2_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."sa2_view" USING GIST ("geom_4326_z7");
CREATE INDEX "sa2_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."sa2_view" USING GIST ("geom_4326_z9");
CREATE INDEX "sa2_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."sa2_view" USING GIST ("geom_4326_z11");
CREATE INDEX "sa2_view_geom_4326_gist" ON "aus_census_2011_shapes"."sa2_view" USING GIST ("geom_4326");
CREATE INDEX "sa2_view_geom_3112_gist" ON "aus_census_2011_shapes"."sa2_view" USING gist ("geom_3112");
CREATE INDEX "sa2_view_geom_3857_gist" ON "aus_census_2011_shapes"."sa2_view" USING gist ("geom_3857");
CREATE INDEX "sa2_view_geom_idx" ON "aus_census_2011_shapes"."sa2_view" USING gist ("geom");
CREATE UNIQUE INDEX "sa2_view_sa2_view_main_idx" ON "aus_census_2011_shapes"."sa2_view" ("sa2_main");
CREATE UNIQUE INDEX "sa2_view_gid_idx" ON "aus_census_2011_shapes"."sa2_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.sa3_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.sa3_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.sa3 AS geomtable;
CREATE INDEX "sa3_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."sa3_view" USING GIST ("geom_4326_z5");
CREATE INDEX "sa3_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."sa3_view" USING GIST ("geom_4326_z7");
CREATE INDEX "sa3_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."sa3_view" USING GIST ("geom_4326_z9");
CREATE INDEX "sa3_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."sa3_view" USING GIST ("geom_4326_z11");
CREATE INDEX "sa3_view_geom_4326_gist" ON "aus_census_2011_shapes"."sa3_view" USING GIST ("geom_4326");
CREATE INDEX "sa3_view_geom_3112_gist" ON "aus_census_2011_shapes"."sa3_view" USING gist ("geom_3112");
CREATE INDEX "sa3_view_geom_3857_gist" ON "aus_census_2011_shapes"."sa3_view" USING gist ("geom_3857");
CREATE INDEX "sa3_view_geom_idx" ON "aus_census_2011_shapes"."sa3_view" USING gist ("geom");
CREATE UNIQUE INDEX "sa3_view_sa3_view_code_idx" ON "aus_census_2011_shapes"."sa3_view" ("sa3_code");
CREATE UNIQUE INDEX "sa3_view_gid_idx" ON "aus_census_2011_shapes"."sa3_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.sa4_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.sa4_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.sa4 AS geomtable;
CREATE INDEX "sa4_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."sa4_view" USING GIST ("geom_4326_z5");
CREATE INDEX "sa4_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."sa4_view" USING GIST ("geom_4326_z7");
CREATE INDEX "sa4_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."sa4_view" USING GIST ("geom_4326_z9");
CREATE INDEX "sa4_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."sa4_view" USING GIST ("geom_4326_z11");
CREATE INDEX "sa4_view_geom_4326_gist" ON "aus_census_2011_shapes"."sa4_view" USING GIST ("geom_4326");
CREATE INDEX "sa4_view_geom_3112_gist" ON "aus_census_2011_shapes"."sa4_view" USING gist ("geom_3112");
CREATE INDEX "sa4_view_geom_3857_gist" ON "aus_census_2011_shapes"."sa4_view" USING gist ("geom_3857");
CREATE INDEX "sa4_view_geom_idx" ON "aus_census_2011_shapes"."sa4_view" USING gist ("geom");
CREATE UNIQUE INDEX "sa4_view_sa4_view_code_idx" ON "aus_census_2011_shapes"."sa4_view" ("sa4_code");
CREATE UNIQUE INDEX "sa4_view_gid_idx" ON "aus_census_2011_shapes"."sa4_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.sed_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.sed_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.sed AS geomtable;
CREATE INDEX "sed_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."sed_view" USING GIST ("geom_4326_z5");
CREATE INDEX "sed_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."sed_view" USING GIST ("geom_4326_z7");
CREATE INDEX "sed_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."sed_view" USING GIST ("geom_4326_z9");
CREATE INDEX "sed_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."sed_view" USING GIST ("geom_4326_z11");
CREATE INDEX "sed_view_geom_4326_gist" ON "aus_census_2011_shapes"."sed_view" USING GIST ("geom_4326");
CREATE INDEX "sed_view_geom_3112_gist" ON "aus_census_2011_shapes"."sed_view" USING gist ("geom_3112");
CREATE INDEX "sed_view_geom_3857_gist" ON "aus_census_2011_shapes"."sed_view" USING gist ("geom_3857");
CREATE INDEX "sed_view_geom_idx" ON "aus_census_2011_shapes"."sed_view" USING gist ("geom");
CREATE UNIQUE INDEX "sed_view_sed_view_code_idx" ON "aus_census_2011_shapes"."sed_view" ("sed_code");
CREATE UNIQUE INDEX "sed_view_gid_idx" ON "aus_census_2011_shapes"."sed_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.sla_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.sla_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.sla AS geomtable;
CREATE INDEX "sla_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."sla_view" USING GIST ("geom_4326_z5");
CREATE INDEX "sla_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."sla_view" USING GIST ("geom_4326_z7");
CREATE INDEX "sla_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."sla_view" USING GIST ("geom_4326_z9");
CREATE INDEX "sla_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."sla_view" USING GIST ("geom_4326_z11");
CREATE INDEX "sla_view_geom_4326_gist" ON "aus_census_2011_shapes"."sla_view" USING GIST ("geom_4326");
CREATE INDEX "sla_view_geom_3112_gist" ON "aus_census_2011_shapes"."sla_view" USING gist ("geom_3112");
CREATE INDEX "sla_view_geom_3857_gist" ON "aus_census_2011_shapes"."sla_view" USING gist ("geom_3857");
CREATE INDEX "sla_view_geom_idx" ON "aus_census_2011_shapes"."sla_view" USING gist ("geom");
CREATE UNIQUE INDEX "sla_view_sla_view_main_idx" ON "aus_census_2011_shapes"."sla_view" ("sla_main");
CREATE UNIQUE INDEX "sla_view_gid_idx" ON "aus_census_2011_shapes"."sla_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.sosr_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.sosr_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.sosr AS geomtable;
CREATE INDEX "sosr_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."sosr_view" USING GIST ("geom_4326_z5");
CREATE INDEX "sosr_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."sosr_view" USING GIST ("geom_4326_z7");
CREATE INDEX "sosr_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."sosr_view" USING GIST ("geom_4326_z9");
CREATE INDEX "sosr_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."sosr_view" USING GIST ("geom_4326_z11");
CREATE INDEX "sosr_view_geom_4326_gist" ON "aus_census_2011_shapes"."sosr_view" USING GIST ("geom_4326");
CREATE INDEX "sosr_view_geom_3112_gist" ON "aus_census_2011_shapes"."sosr_view" USING gist ("geom_3112");
CREATE INDEX "sosr_view_geom_3857_gist" ON "aus_census_2011_shapes"."sosr_view" USING gist ("geom_3857");
CREATE INDEX "sosr_view_geom_idx" ON "aus_census_2011_shapes"."sosr_view" USING gist ("geom");
CREATE UNIQUE INDEX "sosr_view_sosr_view_code_idx" ON "aus_census_2011_shapes"."sosr_view" ("sosr_code");
CREATE UNIQUE INDEX "sosr_view_gid_idx" ON "aus_census_2011_shapes"."sosr_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.sos_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.sos_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.sos AS geomtable;
CREATE INDEX "sos_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."sos_view" USING GIST ("geom_4326_z5");
CREATE INDEX "sos_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."sos_view" USING GIST ("geom_4326_z7");
CREATE INDEX "sos_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."sos_view" USING GIST ("geom_4326_z9");
CREATE INDEX "sos_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."sos_view" USING GIST ("geom_4326_z11");
CREATE INDEX "sos_view_geom_4326_gist" ON "aus_census_2011_shapes"."sos_view" USING GIST ("geom_4326");
CREATE INDEX "sos_view_geom_3112_gist" ON "aus_census_2011_shapes"."sos_view" USING gist ("geom_3112");
CREATE INDEX "sos_view_geom_3857_gist" ON "aus_census_2011_shapes"."sos_view" USING gist ("geom_3857");
CREATE INDEX "sos_view_geom_idx" ON "aus_census_2011_shapes"."sos_view" USING gist ("geom");
CREATE UNIQUE INDEX "sos_view_sos_view_code_idx" ON "aus_census_2011_shapes"."sos_view" ("sos_code");
CREATE UNIQUE INDEX "sos_view_gid_idx" ON "aus_census_2011_shapes"."sos_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.ssc_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.ssc_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.ssc AS geomtable;
CREATE INDEX "ssc_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."ssc_view" USING GIST ("geom_4326_z5");
CREATE INDEX "ssc_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."ssc_view" USING GIST ("geom_4326_z7");
CREATE INDEX "ssc_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."ssc_view" USING GIST ("geom_4326_z9");
CREATE INDEX "ssc_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."ssc_view" USING GIST ("geom_4326_z11");
CREATE INDEX "ssc_view_geom_4326_gist" ON "aus_census_2011_shapes"."ssc_view" USING GIST ("geom_4326");
CREATE INDEX "ssc_view_geom_3112_gist" ON "aus_census_2011_shapes"."ssc_view" USING gist ("geom_3112");
CREATE INDEX "ssc_view_geom_3857_gist" ON "aus_census_2011_shapes"."ssc_view" USING gist ("geom_3857");
CREATE INDEX "ssc_view_geom_idx" ON "aus_census_2011_shapes"."ssc_view" USING gist ("geom");
CREATE UNIQUE INDEX "ssc_view_ssc_view_code_idx" ON "aus_census_2011_shapes"."ssc_view" ("ssc_code");
CREATE UNIQUE INDEX "ssc_view_gid_idx" ON "aus_census_2011_shapes"."ssc_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.ste_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.ste_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.ste AS geomtable;
CREATE INDEX "ste_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."ste_view" USING GIST ("geom_4326_z5");
CREATE INDEX "ste_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."ste_view" USING GIST ("geom_4326_z7");
CREATE INDEX "ste_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."ste_view" USING GIST ("geom_4326_z9");
CREATE INDEX "ste_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."ste_view" USING GIST ("geom_4326_z11");
CREATE INDEX "ste_view_geom_4326_gist" ON "aus_census_2011_shapes"."ste_view" USING GIST ("geom_4326");
CREATE INDEX "ste_view_geom_3112_gist" ON "aus_census_2011_shapes"."ste_view" USING gist ("geom_3112");
CREATE INDEX "ste_view_geom_3857_gist" ON "aus_census_2011_shapes"."ste_view" USING gist ("geom_3857");
CREATE INDEX "ste_view_geom_idx" ON "aus_census_2011_shapes"."ste_view" USING gist ("geom");
CREATE UNIQUE INDEX "ste_view_state_code_idx" ON "aus_census_2011_shapes"."ste_view" ("state_code");
CREATE UNIQUE INDEX "ste_view_gid_idx" ON "aus_census_2011_shapes"."ste_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.sua_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.sua_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.sua AS geomtable;
CREATE INDEX "sua_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."sua_view" USING GIST ("geom_4326_z5");
CREATE INDEX "sua_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."sua_view" USING GIST ("geom_4326_z7");
CREATE INDEX "sua_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."sua_view" USING GIST ("geom_4326_z9");
CREATE INDEX "sua_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."sua_view" USING GIST ("geom_4326_z11");
CREATE INDEX "sua_view_geom_4326_gist" ON "aus_census_2011_shapes"."sua_view" USING GIST ("geom_4326");
CREATE INDEX "sua_view_geom_3112_gist" ON "aus_census_2011_shapes"."sua_view" USING gist ("geom_3112");
CREATE INDEX "sua_view_geom_3857_gist" ON "aus_census_2011_shapes"."sua_view" USING gist ("geom_3857");
CREATE INDEX "sua_view_geom_idx" ON "aus_census_2011_shapes"."sua_view" USING gist ("geom");
CREATE UNIQUE INDEX "sua_view_sua_view_code_idx" ON "aus_census_2011_shapes"."sua_view" ("sua_code");
CREATE UNIQUE INDEX "sua_view_gid_idx" ON "aus_census_2011_shapes"."sua_view" ("gid");


DROP MATERIALIZED VIEW IF EXISTS aus_census_2011_shapes.ucl_view CASCADE;

            CREATE MATERIALIZED VIEW aus_census_2011_shapes.ucl_view AS
                SELECT
                    
                CASE WHEN ST_Area(geomtable.geom_3857) >= 978393.9620502561 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 4891.96981025128/20, 4891.96981025128/20),
                        244.598490512564
                    )), 4326)
                ELSE NULL END AS geom_4326_z5,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 244598.49051256402 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 1222.99245256282/20, 1222.99245256282/20),
                        61.149622628141
                    )), 4326)
                ELSE NULL END AS geom_4326_z7,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 122299.24525628201 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 305.748113140705/20, 305.748113140705/20),
                        15.28740565703525
                    )), 4326)
                ELSE NULL END AS geom_4326_z9,
                CASE WHEN ST_Area(geomtable.geom_3857) >= 38218.51414258813 THEN
                    ST_Transform(ST_MakeValid(ST_Simplify(
                        ST_SnapToGrid(geomtable.geom_3857, 76.43702828517625/20, 76.43702828517625/20),
                        3.8218514142588127
                    )), 4326)
                ELSE NULL END AS geom_4326_z11,
                    ST_Transform(geom_3857, 4326) AS geom_4326,
                    geomtable.*
                FROM aus_census_2011_shapes.ucl AS geomtable;
CREATE INDEX "ucl_view_geom_4326_z5_gist" ON "aus_census_2011_shapes"."ucl_view" USING GIST ("geom_4326_z5");
CREATE INDEX "ucl_view_geom_4326_z7_gist" ON "aus_census_2011_shapes"."ucl_view" USING GIST ("geom_4326_z7");
CREATE INDEX "ucl_view_geom_4326_z9_gist" ON "aus_census_2011_shapes"."ucl_view" USING GIST ("geom_4326_z9");
CREATE INDEX "ucl_view_geom_4326_z11_gist" ON "aus_census_2011_shapes"."ucl_view" USING GIST ("geom_4326_z11");
CREATE INDEX "ucl_view_geom_4326_gist" ON "aus_census_2011_shapes"."ucl_view" USING GIST ("geom_4326");
CREATE INDEX "ucl_view_geom_3112_gist" ON "aus_census_2011_shapes"."ucl_view" USING gist ("geom_3112");
CREATE INDEX "ucl_view_geom_3857_gist" ON "aus_census_2011_shapes"."ucl_view" USING gist ("geom_3857");
CREATE INDEX "ucl_view_geom_idx" ON "aus_census_2011_shapes"."ucl_view" USING gist ("geom");
CREATE UNIQUE INDEX "ucl_view_ucl_view_code_idx" ON "aus_census_2011_shapes"."ucl_view" ("ucl_code");
CREATE UNIQUE INDEX "ucl_view_gid_idx" ON "aus_census_2011_shapes"."ucl_view" ("gid");