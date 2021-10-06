test_that("Grid offline", {
  expect_error(gisco_get_grid(resolution = 24))
  expect_error(gisco_get_grid(spatialtype = "9999"))
})

test_that("Grids online", {
  skip_if_gisco_offline()
  # skip_on_cran()

  expect_silent(gisco_get_grid())
  expect_silent(gisco_get_grid(100))
  expect_message(gisco_get_grid(100, verbose = TRUE))
  expect_message(gisco_get_grid(100, spatialtype = "POINT", verbose = TRUE))
})
