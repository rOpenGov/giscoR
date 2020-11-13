library(tinytest)

expect_error(gisco_get_coastallines(year = 2001, res = 60))
expect_error(gisco_get_coastallines(year = 2011))
expect_error(gisco_get_coastallines(epsg = 2819))
expect_error(gisco_get_coastallines(spatialtype = "aa"))
expect_error(gisco_get_coastallines(res = 15))
expect_silent(gisco_get_coastallines())
expect_message(gisco_get_coastallines(verbose = TRUE))
expect_true(sf::st_is_longlat(gisco_get_countries()))


# See if there is access

if (gisco_check_access()) {
  expect_silent(gisco_get_coastallines(resolution = "60"))
  expect_silent(gisco_get_coastallines(resolution = 3))
  expect_message(gisco_get_coastallines(resolution = "60", verbose = TRUE))
  expect_silent(gisco_get_coastallines(
    resolution = "60",
    verbose = TRUE,
    update_cache = TRUE
  ))
  cachetest <- paste0(tempdir(), "/coast")
  expect_silent(gisco_get_coastallines(resolution = "60",
                                       cache_dir = cachetest))

  a <- gisco_get_coastallines(resolution = "60", epsg = '3035')
  b <- gisco_get_coastallines(resolution = "60", epsg = '3857')
  c <- gisco_get_coastallines(resolution = "60", epsg = "4326")

  epsg3035 <- sf::st_crs(3035)
  epsg3857 <- sf::st_crs(3857)
  epsg4326 <- sf::st_crs(4326)

  expect_equal(epsg3035, sf::st_crs(a))
  expect_equal(epsg3857, sf::st_crs(b))
  expect_equal(epsg4326, sf::st_crs(c))
}
