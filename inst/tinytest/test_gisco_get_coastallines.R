library(tinytest)

expect_silent(gisco_get_coastallines())
expect_error(gisco_get_coastallines(year = 2001, res = 60))
expect_error(gisco_get_coastallines(year = 2011))
expect_error(gisco_get_coastallines(epsg = 2819))
expect_error(gisco_get_coastallines(spatialtype = "aa"))
expect_error(gisco_get_coastallines(res = 15))
cachetest <- paste0(tempdir(), "_tinytest")
expect_silent(gisco_get_coastallines(resolution = 60, cache_dir = cachetest))
expect_silent(gisco_get_coastallines(
  resolution = 60,
  cache_dir = cachetest,
  update_cache = TRUE
))

a <- gisco_get_coastallines(epsg = '3035')
b <- gisco_get_coastallines(epsg = '3857')      

expect_false(sf::st_is_longlat(a))
expect_false(sf::st_is_longlat(b))
