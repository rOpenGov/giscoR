test_that("Grid offline", {
  expect_error(gisco_get_grid(resolution = 24))
  expect_error(gisco_get_grid(spatialtype = "9999"))
})

test_that("Grids online", {
  skip_on_cran()
  skip_if_gisco_offline()

  # Warnings due to issues with the GPKG driver
  gdef <- gisco_get_grid()
  expect_s3_class(gdef, "sf")
  expect_s3_class(gdef, "tbl_df")
  expect_silent(g100 <- gisco_get_grid(100))
  expect_s3_class(g100, "sf")
  expect_s3_class(gdef, "tbl_df")

  expect_message(g100 <- gisco_get_grid(100, verbose = TRUE))
  expect_s3_class(g100, "sf")
  expect_s3_class(gdef, "tbl_df")

  expect_message(
    p <- gisco_get_grid(100, spatialtype = "POINT", verbose = TRUE)
  )
})

test_that("Offline", {
  options(giscoR_test_offline = TRUE)
  expect_message(
    n <- gisco_get_grid(update_cache = TRUE),
    "Error"
  )
  expect_null(n)
  options(giscoR_test_offline = FALSE)
})
