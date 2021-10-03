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
