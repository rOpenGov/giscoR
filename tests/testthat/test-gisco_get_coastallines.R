test_that("Coastallines", {
  expect_error(gisco_get_coastallines(year = 2001, res = 60))
  expect_error(gisco_get_coastallines(year = 2011))
  expect_error(gisco_get_coastallines(epsg = 2819))
  expect_error(gisco_get_coastallines(res = 15))
  expect_silent(gisco_get_coastallines())
  expect_message(gisco_get_coastallines(verbose = TRUE))
  expect_true(sf::st_is_longlat(gisco_get_countries()))
})

test_that("Coastal download online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_coastallines(resolution = "60"))
  expect_silent(gisco_get_coastallines(resolution = "60", cache = FALSE))
  expect_silent(gisco_get_coastallines(resolution = 3))
  expect_message(gisco_get_coastallines(resolution = "60", verbose = TRUE))
  expect_message(gisco_get_coastallines(
    resolution = "60",
    verbose = TRUE,
    update_cache = TRUE
  ))
  cachetest <- paste0(tempdir(), "/coast")
  expect_silent(gisco_get_coastallines(
    resolution = "60",
    cache_dir = cachetest
  ))

  expect_message(
    a <- gisco_get_coastallines(
      resolution = "60",
      epsg = "3035",
      verbose = TRUE
    )
  )
  expect_s3_class(a, "tbl_df")
  expect_s3_class(a, "sf")
  b <- gisco_get_coastallines(resolution = "60", epsg = "3857")
  c <- gisco_get_coastallines(resolution = "60", epsg = "4326")

  epsg3035 <- sf::st_crs(3035)
  epsg3857 <- sf::st_crs(3857)
  epsg4326 <- sf::st_crs(4326)

  expect_identical(epsg3035, sf::st_crs(a))
  expect_identical(epsg3857, sf::st_crs(b))
  expect_identical(epsg4326, sf::st_crs(c))
})

test_that("Offline", {
  options(giscoR_test_offline = TRUE)
  expect_message(
    n <- gisco_get_coastallines(
      resolution = 60,
      cache_dir = tempdir(),
      update_cache = TRUE
    ),
    "not reachable"
  )
  expect_null(n)
  options(giscoR_test_offline = FALSE)
})
