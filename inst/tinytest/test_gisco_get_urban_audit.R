library(tinytest)

expect_error(gisco_get_urban_audit(year = "1999"))
expect_error(gisco_get_urban_audit(epsg = "9999"))
expect_error(gisco_get_urban_audit(level = "9999"))
expect_error(gisco_get_urban_audit(spatialtype = "BN"))
expect_error(gisco_get_urban_audit(year = 2001))

# See if there is access

