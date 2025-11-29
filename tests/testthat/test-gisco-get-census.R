test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_err = TRUE)
  expect_message(
    n <- gisco_get_census(update_cache = TRUE, spatialtype = "PT"),
    "Error"
  )
  expect_null(n)
  options(gisco_test_err = FALSE)
})

test_that("Get Census POINT", {
  expect_error(gisco_get_census(year = 2020))

  skip_on_cran()
  skip_if_gisco_offline()

  all <- expect_silent(gisco_get_census(spatialtype = "PT"))
  expect_s3_class(all, "tbl_df")
  expect_s3_class(all, "sf")
  expect_true(unique(sf::st_geometry_type(all)) == "POINT")
  expect_identical(
    sf::st_crs(all),
    sf::st_crs(4326)
  )
})
test_that("Get Census POLYGON", {
  skip_on_cran()
  skip_if_gisco_offline()

  # On read should warn
  expect_message(all <- gisco_get_census(spatialtype = "RG"))
  expect_s3_class(all, "tbl_df")
  expect_s3_class(all, "sf")
  expect_true(unique(sf::st_geometry_type(all)) == "MULTIPOLYGON")
  expect_identical(
    sf::st_crs(all),
    sf::st_crs(4326)
  )
})
