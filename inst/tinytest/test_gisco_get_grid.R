library(tinytest)

expect_error(gisco_get_grid(resolution = 24))
expect_error(gisco_get_grid(spatialtype = "9999"))
expect_silent(gisco_get_grid())
