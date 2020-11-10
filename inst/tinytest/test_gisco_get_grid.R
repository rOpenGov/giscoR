library(tinytest)

expect_error(gisco_get_grid(resolution = 24))
expect_error(gisco_get_grid(spatialtype = "9999"))
expect_silent(gisco_get_grid())

if (gisco_check_access()) {
 expect_silent(gisco_get_grid(100))
 expect_silent(gisco_get_grid(100, verbose = TRUE))
 expect_message(gisco_get_grid(100, spatialtype = "POINT", verbose = TRUE))
}


