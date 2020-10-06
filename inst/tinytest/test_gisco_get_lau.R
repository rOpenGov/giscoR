library(tinytest)

expect_error(gisco_get_lau(year = "2001"))
expect_error(gisco_get_lau(epsg = "9999"))
expect_silent(gisco_get_lau(country = "BE"))
expect_silent(gisco_get_lau(country = "BEL"))
expect_silent(gisco_get_lau(country = "Belgium"))
