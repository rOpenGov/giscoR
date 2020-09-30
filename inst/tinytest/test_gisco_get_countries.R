library(tinytest)

expect_silent(gisco_get_countries())
expect_error(gisco_get_countries(year = 2001, resolution = 60))
expect_error(gisco_get_countries(year = 2011))
expect_error(gisco_get_countries(epsg = 2819))
expect_error(gisco_get_countries(spatialtype = "aa"))
expect_error(gisco_get_countries(res = 15))
cachetest <- paste0(tempdir(),"_tinytest_get_countries")
expect_silent(gisco_get_countries(spatialtype = "LB", cache_dir = cachetest))
expect_silent(gisco_get_countries(spatialtype = "LB"))
expect_silent(gisco_get_countries(spatialtype = "COASTL"))
expect_silent(gisco_get_countries(spatialtype = "COASTL", year = 2020))
expect_silent(gisco_get_countries(spatialtype = "COASTL",
                                  country_iso3 = c("ITA", "POL")))
expect_silent(gisco_get_countries(country_iso3 = c("ITA", "POL")))
expect_silent(gisco_get_countries(region = c("Africa", "Americas")))
expect_silent(gisco_get_countries(
  update_cache = TRUE,
  region = c("Africa", "Americas")
))


#Test internal data
library(sf)
cntr <- gisco_get_countries()
expect_true(sf::st_crs(cntr)$epsg == 4326)

coast <- gisco_get_countries(spatialtype = "COASTL")
expect_true(sf::st_crs(coast)$epsg == 4326)

