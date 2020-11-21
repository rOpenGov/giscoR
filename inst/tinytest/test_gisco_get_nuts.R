library(tinytest)

expect_error(gisco_get_nuts(year = 2003, resolution = 60))
expect_error(gisco_get_nuts(year = 2011))
expect_error(gisco_get_nuts(epsg = 2819))
expect_error(gisco_get_nuts(spatialtype = "aa"))
expect_error(gisco_get_nuts(res = 15))
expect_error(gisco_get_nuts(spatialtype = "COASTL"))
expect_error(gisco_get_nuts(spatialtype = "INLAND"))
expect_error(gisco_get_nuts(nuts_level = 4))
expect_error(gisco_get_nuts(nuts_level = 4, resolution = 1))
expect_error(gisco_get_nuts(nuts_level = NULL))

expect_silent(gisco_get_nuts())
expect_true(sf::st_is_longlat(gisco_get_nuts()))
expect_silent(gisco_get_nuts(nuts_level = "0"))


expect_message(gisco_get_nuts(verbose = TRUE))


