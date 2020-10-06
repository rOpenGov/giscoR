library(tinytest)

expect_error(gisco_get_urban_audit(year = "2001"))
expect_error(gisco_get_urban_audit(epsg = "9999"))
expect_error(gisco_get_urban_audit(level = "9999"))

v <- length(as.character(unlist(packageVersion("giscoR"))))

if (v > 3) {
  cachetest <- paste0(tempdir(), "/get_urau")
  expect_silent(gisco_get_urban_audit(spatialtype = "LB", cache_dir = cachetest))
  expect_silent(gisco_get_urban_audit(spatialtype = "LB", level = "GREATER_CITIES"))
  expect_silent(gisco_get_urban_audit(
    level = "GREATER_CITIES",
    epsg = 3857,
    country = c("ITA", "POL")
  ))

  expect_silent(gisco_get_urban_audit(
    year = 2014,
    level = "GREATER_CITIES",
    epsg = 3857,
    country = c("ITA", "POL")
  ))

  expect_silent(gisco_get_urban_audit(
    year = 2020,
    level = "GREATER_CITIES",
    epsg = 3857,
    country = c("ITA", "POL")
  ))


  a <-
    gisco_get_urban_audit(epsg = '3035', level = "GREATER_CITIES")
  b <-
    gisco_get_urban_audit(epsg = '3857', level = "GREATER_CITIES")

  expect_false(sf::st_is_longlat(a))
  expect_false(sf::st_is_longlat(b))
}

