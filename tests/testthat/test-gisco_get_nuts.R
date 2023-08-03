test_that("NUTS offline", {
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

  expect_silent(aa <- gisco_get_nuts())
  expect_true("geo" %in% names(aa))
  expect_identical(aa$geo, aa$NUTS_ID)

  expect_true(sf::st_is_longlat(gisco_get_nuts()))
  expect_silent(gisco_get_nuts(nuts_level = "0"))


  expect_message(gisco_get_nuts(verbose = TRUE))
})

test_that("NUTS online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(aa <- gisco_get_nuts(spatialtype = "LB"))
  expect_true("geo" %in% names(aa))
  expect_identical(aa$geo, aa$NUTS_ID)
  expect_silent(gisco_get_nuts(spatialtype = "LB", cache = FALSE))

  expect_silent(aa <- gisco_get_nuts(resolution = "60", nuts_level = "0"))
  expect_true("geo" %in% names(aa))
  expect_identical(aa$geo, aa$NUTS_ID)
  expect_message(
    gisco_get_nuts(
      resolution = "60",
      nuts_level = "0",
      update_cache = TRUE,
      verbose = TRUE
    )
  )
  expect_silent(aa <- gisco_get_nuts(
    resolution = "60",
    nuts_level = "0",
    nuts_id = "ES5"
  ))
  expect_equal(nrow(aa), 1)
  expect_true("geo" %in% names(aa))
  expect_identical(aa$geo, aa$NUTS_ID)

  expect_silent(aa <- gisco_get_nuts(
    resolution = "60",
    nuts_id = "ES5",
    spatialtype = "LB"
  ))
  expect_equal(nrow(aa), 1)
  expect_true("geo" %in% names(aa))
  expect_identical(aa$geo, aa$NUTS_ID)

  expect_silent(aa <- gisco_get_nuts(
    resolution = "60",
    nuts_id = "ES5",
    spatialtype = "BN"
  ))

  # On BN no NUTS_ID
  expect_false("geo" %in% names(aa))


  expect_silent(
  aa <- gisco_get_nuts(resolution = "60", 
  country = c("ITA", "POL"))
  )

  expect_true("geo" %in% names(aa))
  expect_identical(aa$geo, aa$NUTS_ID)

  a <- gisco_get_nuts(resolution = "60", epsg = "3035")
  b <- gisco_get_nuts(resolution = "60", epsg = "3857")
  c <- gisco_get_nuts(resolution = "60", epsg = "4326")

  epsg3035 <- sf::st_crs(3035)
  epsg3857 <- sf::st_crs(3857)
  epsg4326 <- sf::st_crs(4326)

  expect_equal(epsg3035, sf::st_crs(a))
  expect_equal(epsg3857, sf::st_crs(b))
  expect_equal(epsg4326, sf::st_crs(c))
})


test_that("offline", {
  options(giscoR_test_offline = TRUE)
  expect_message(
    n <- gisco_get_nuts(update_cache = TRUE, resolution = 60),
    "not reachable"
  )
  expect_null(n)
  options(giscoR_test_offline = FALSE)
})
