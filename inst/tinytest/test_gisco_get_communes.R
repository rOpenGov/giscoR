library(tinytest)

expect_error(gisco_get_communes(year = "2007"))
expect_error(gisco_get_communes(epsg = "9999"))
expect_error(gisco_get_communes(year = "2004", spatialtype = "COASTL"))
expect_error(gisco_get_communes(year = "2004", spatialtype = "INLAND"))
expect_error(gisco_get_communes(spatialtype = "ERR"))


# See if there is access
if (gisco_check_access()) {
  expect_silent(gisco_get_communes(spatialtype = "COASTL"))
  expect_silent(gisco_get_communes(spatialtype = "LB", country = "LU"))
  expect_silent(gisco_get_communes(spatialtype = "COASTL"))
}


