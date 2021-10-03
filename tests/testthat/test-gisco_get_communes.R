test_that("Communes offline", {
  expect_error(gisco_get_communes(year = "2007"))
  expect_error(gisco_get_communes(epsg = "9999"))
  expect_error(gisco_get_communes(year = "2004", spatialtype = "COASTL"))
  expect_error(gisco_get_communes(year = "2004", spatialtype = "INLAND"))
  expect_error(gisco_get_communes(spatialtype = "ERR"))
})

test_that("Communes online", {
  skip_if_gisco_offline()
  skip_on_cran()

  expect_silent(gisco_get_communes(spatialtype = "COASTL"))
  expect_silent(gisco_get_communes(spatialtype = "LB", country = "LU"))
  expect_silent(gisco_get_communes(spatialtype = "COASTL"))
})
