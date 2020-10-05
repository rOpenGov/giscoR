library(tinytest)

expect_silent(gisco_get_countries())
expect_error(gisco_get_countries(year = 2001, resolution = 60))
expect_error(gisco_get_countries(year = 2011))
expect_error(gisco_get_countries(epsg = 2819))
expect_error(gisco_get_countries(spatialtype = "aa"))
expect_error(gisco_get_countries(res = 15))
cachetest <- paste0(tempdir(), "_tinytest_get_countries")
expect_silent(gisco_get_countries(spatialtype = "LB", cache_dir = cachetest))

expect_silent(gisco_get_countries(spatialtype = "LB"))
expect_silent(gisco_get_countries(spatialtype = "COASTL"))
expect_silent(gisco_get_countries(spatialtype = "COASTL", year = 2020))
expect_silent(gisco_get_countries(spatialtype = "COASTL",
                                  country = c("ITA", "POL")))

v <- length(as.character(unlist(packageVersion("giscoR"))))

if (v > 3) {
  expect_silent(gisco_get_countries(country = c("ITA", "POL")))
  expect_silent(gisco_get_countries(region = c("Africa", "Americas")))
  expect_silent(gisco_get_countries(
    update_cache = TRUE,
    region = c("Africa", "Americas")
  ))

  expect_silent(gisco_get_countries(spatialtype = "COASTL",
                                    resolution = "20"))

  expect_silent(gisco_get_countries(resolution = "20"))

  a <- gisco_get_countries(epsg = '3035')
  b <- gisco_get_countries(epsg = '3857')

  expect_false(sf::st_is_longlat(a))
  expect_false(sf::st_is_longlat(b))
}

#Test internal data
library(sf)
cntr <- gisco_get_countries(resolution = "20")
expect_true(sf::st_crs(cntr)$epsg == 4326)

coast <-
  gisco_get_countries(spatialtype = "COASTL", resolution = "20")
expect_true(sf::st_crs(coast)$epsg == 4326)

if (at_home()) {
  expect_error(gisco_get_countries(country = "Z"))
  expect_warning(gisco_get_countries(country = "ZZ"))

  expect_silent(gisco_get_countries(country = "ES"))
  expect_true(nrow(gisco_get_countries(country = "Spain")) == 1)
  expect_true(nrow(gisco_get_countries(country = "ES")) == 1)
}
