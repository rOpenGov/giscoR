test_that("Communes offline", {
  expect_error(gisco_get_communes(year = "2007"))
  expect_error(gisco_get_communes(epsg = "9999"))
  expect_error(gisco_get_communes(year = "2004", spatialtype = "COASTL"))
  expect_error(gisco_get_communes(year = "2004", spatialtype = "INLAND"))
  expect_error(gisco_get_communes(spatialtype = "ERR"))
})

test_that("Communes online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_communes(spatialtype = "COASTL"))

  # Trying to query a dataset without a country field. Should show a message
  # even with verbose TRUE
  expect_message(gisco_get_communes(
    spatialtype = "COASTL",
    country = "LU",
    verbose = FALSE
  ))

  expect_message(s2 <- gisco_get_communes(spatialtype = "LB", verbose = TRUE))
  expect_s3_class(s2, "tbl_df")
  expect_s3_class(s2, "sf")
  expect_silent(lu <- gisco_get_communes(spatialtype = "LB", country = "LU"))
  expect_s3_class(lu, "tbl_df")
  expect_s3_class(lu, "sf")
  expect_equal(as.character(unique(lu$CNTR_CODE)), "LU")
})
