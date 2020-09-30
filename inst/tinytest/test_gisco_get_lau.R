library(tinytest)

expect_error(gisco_get_lau(year = "2001"))
expect_error(gisco_get_lau(epsg = "9999"))
