library(tinytest)

expect_error(gisco_get_nuts(year = 2003, resolution = 60))
expect_error(gisco_get_nuts(year = 2011))
expect_error(gisco_get_nuts(epsg = 2819))
expect_error(gisco_get_nuts(spatialtype = "aa"))
expect_error(gisco_get_nuts(res = 15))
expect_error(gisco_get_nuts(spatialtype = "COASTL"))
expect_error(gisco_get_nuts(spatialtype = "INLAND"))
expect_error(gisco_get_nuts(nuts_level = 4))
expect_error(gisco_get_nuts(nuts_level = 4, resolution = 1))
expect_error(gisco_get_nuts(nuts_level = NULL))

expect_silent(gisco_get_nuts())
expect_true(sf::st_is_longlat(gisco_get_nuts()))
expect_silent(gisco_get_nuts(nuts_level = "0"))


expect_message(gisco_get_nuts(verbose = TRUE))

# See if there is access
if (gisco_check_access()) {
    expect_silent(gisco_get_nuts(spatialtype = "LB"))
    expect_silent(gisco_get_nuts(resolution = "60", nuts_level = "0" ))
    expect_silent(gisco_get_nuts(resolution = "60", nuts_level = "0", update_cache = TRUE, verbose = TRUE))
    expect_silent(gisco_get_nuts(resolution = "60", nuts_level = "0" , nuts_id = "ES5"))
    
    expect_silent(gisco_get_nuts(resolution = "60", nuts_id = "ES5", spatialtype = "LB"))
    
expect_silent(gisco_get_nuts(resolution = "60", nuts_id = "ES5", spatialtype = "COASTL"))
    expect_silent(gisco_get_nuts(resolution = "60",country = c("ITA", "POL")))

      a <- gisco_get_nuts(resolution = "60", epsg = '3035')
      b <- gisco_get_nuts(resolution = "60", epsg = '3857')
      c <- gisco_get_nuts(resolution = "60", epsg = "4326")

      epsg3035 <- sf::st_crs(3035)
      epsg3857 <- sf::st_crs(3857)
      epsg4326 <- sf::st_crs(4326)

      expect_equal(epsg3035,sf::st_crs(a))
      expect_equal(epsg3857,sf::st_crs(b))
      expect_equal(epsg4326,sf::st_crs(c))

}

