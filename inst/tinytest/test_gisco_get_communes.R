library(tinytest)

expect_error(gisco_get_communes(year = "2007"))
expect_error(gisco_get_communes(epsg = "9999"))
expect_error(gisco_get_communes(year = "2004", spatialtype = "COASTL"))
expect_error(gisco_get_communes(year = "2004", spatialtype = "INLAND"))
expect_error(gisco_get_communes(spatialtype = "ERR"))
expect_silent(gisco_get_communes(country = "BEL"))
