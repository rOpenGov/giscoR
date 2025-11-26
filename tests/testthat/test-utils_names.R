test_that("Test message", {
  var <- "example"

  expect_silent(gsc_message(FALSE, "A", var, "here"))
  expect_message(gsc_message(TRUE, "A", var, "here"), "A example here")
})


test_that("Internal utils", {
  test <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "urau/geojson/URAU_LB_2020_3035_GREATER_CITIES.geojson"
  )

  expect_error(gsc_api_load(file = test, ext = "error"))

  skip_on_cran()
  skip_if_gisco_offline()

  s <- suppressWarnings(gsc_api_load(
    file = test,
    epsg = 4326,
    verbose = FALSE
  ))
  expect_s3_class(s, "sf")
  expect_true(all(sf::st_is_valid(s)))
  expect_true(sf::st_is_longlat(s))
})


test_that("Errors on database", {
  expect_error(gsc_api_url(ext = "error"))
  expect_error(gsc_api_url(nuts_level = "5"))

  expect_error(gsc_api_url(
    "urban_audit",
    year = 2020,
    spatialtype = "LB",
    level = "aaa"
  ))

  skip_on_cran()
  skip_if_gisco_offline()

  expect_message(
    n <- gsc_load_url(
      "https://github.com/dieghernan/a_fake_thing_here",
      verbose = FALSE
    ),
    "404"
  )

  expect_null(n)
  expect_message(gsc_api_url(
    "urban_audit",
    year = 2020,
    spatialtype = "LB",
    ext = "topojson"
  ))

  dwn <- gsc_api_url(
    "urban_audit",
    year = 2020,
    spatialtype = "LB",
    ext = "topojson"
  )
  expect_silent(gsc_load_url(dwn, update_cache = FALSE, verbose = FALSE))

  expect_message(gsc_api_url("urban_audit", year = 2020, spatialtype = "LB"))

  dwn <- expect_silent(gsc_api_url(ext = "svg"))

  expect_silent(gsc_load_url(dwn, update_cache = FALSE, verbose = FALSE))

  dwn <- expect_silent(gsc_api_url(ext = "shp"))

  load <- expect_silent(gsc_load_shp(
    dwn,
    update_cache = FALSE,
    verbose = FALSE
  ))
  expect_s3_class(load, "sf")
})
