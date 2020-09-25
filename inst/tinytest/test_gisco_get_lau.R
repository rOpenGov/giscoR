library(tinytest)

expect_error(gisco_get_lau(year = "2001"))
expect_error(gisco_get_lau(crs = "9999"))

home <- length(unclass(packageVersion("giscoR"))[[1]]) == 4
getOption("gisco_cache_dir")

if(home){


}

