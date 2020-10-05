library(tinytest)

expect_silent(gisco_get_nuts())
expect_error(gisco_get_nuts(year = 2003, resolution = 60))
expect_error(gisco_get_nuts(year = 2011))
expect_error(gisco_get_nuts(epsg = 2819))
expect_error(gisco_get_nuts(spatialtype = "aa"))
expect_error(gisco_get_nuts(res = 15))
expect_error(gisco_get_nuts(spatialtype = "COASTL"))
expect_error(gisco_get_nuts(spatialtype = "INLAND"))
expect_error(gisco_get_nuts(nuts_level = 4))

cachetest <- paste0(tempdir(), "_tinytest_get_nuts")


v <- length(as.character(unlist(packageVersion("giscoR"))))

if (v > 3) {
  expect_silent(gisco_get_nuts(spatialtype = "LB", cache_dir = cachetest))
  expect_silent(gisco_get_nuts(spatialtype = "LB"))
  expect_silent(gisco_get_nuts(year = 2021))
  expect_silent(gisco_get_nuts(country = c("ITA", "POL")))
  expect_silent(gisco_get_nuts(nuts_level = 3))
  expect_silent(gisco_get_nuts(nuts_id = "ES05"))
  expect_silent(gisco_get_nuts(update_cache = TRUE))
  expect_silent(gisco_get_nuts(
    update_cache = TRUE,
    year = 2021,
    nuts_level = "all"
  ))


  a <- gisco_get_nuts(epsg = '3035')
  b <- gisco_get_nuts(epsg = '3857')

  expect_false(sf::st_is_longlat(a))
  expect_false(sf::st_is_longlat(b))

  expect_silent(gisco_get_nuts(spatialtype = "LB"))
  expect_silent(gisco_get_nuts(
    year = 2010,
    resolution = "60",
    nuts_level = 0,
    update_cache = TRUE
  ))
}

#Test internal data
library(sf)
nuts <- gisco_get_nuts()
expect_true(sf::st_crs(nuts)$epsg == 4326)
