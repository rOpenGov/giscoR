test_that("Grid offline", {
  expect_error(gisco_get_grid(resolution = 24))
  expect_error(gisco_get_grid(spatialtype = "9999"))
  expect_silent(gisco_get_grid())
})

test_that("Grids online", {
  expect_silent(gisco_get_grid(100))
  expect_message(gisco_get_grid(100, verbose = TRUE))
  expect_message(gisco_get_grid(100, spatialtype = "POINT", verbose = TRUE))
})
