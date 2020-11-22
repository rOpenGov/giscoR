library(tinytest)

expect_error(gisco_get_units(year = "2001"))
expect_error(gisco_get_units(unit = NULL))
expect_error(gisco_get_units(epsg = 3456))
expect_error(gisco_get_units(resolution = "35"))
expect_error(gisco_get_units(id_giscoR = "lau"))
expect_error(gisco_get_units(spatialtype = "aa"))
expect_error(gisco_get_units(mode = "aa"))
