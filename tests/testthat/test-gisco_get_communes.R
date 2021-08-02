test_that("Communes offline", {
  expect_error(gisco_get_communes(year = "2007"))
  expect_error(gisco_get_communes(epsg = "9999"))
  expect_error(gisco_get_communes(year = "2004", spatialtype = "COASTL"))
  expect_error(gisco_get_communes(year = "2004", spatialtype = "INLAND"))
  expect_error(gisco_get_communes(spatialtype = "ERR"))
})

test_that("Communes online", {
  skip_if_not(
    gisco_check_access(),
    "Skipping... GISCO not reachable."
  )

  expect_silent(gisco_get_communes(spatialtype = "COASTL"))
  expect_warning(gisco_get_communes(spatialtype = "LB", cache = FALSE))
  expect_silent(gisco_get_communes(spatialtype = "LB", country = "LU"))
  expect_silent(gisco_get_communes(spatialtype = "COASTL"))
})
