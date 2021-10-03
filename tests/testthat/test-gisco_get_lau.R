test_that("LAU offline", {
  expect_error(gisco_get_lau(year = "2001"))
  expect_error(gisco_get_lau(epsg = "9999"))
})


test_that("LAU online", {
  skip_if_gisco_offline()
  skip_on_cran()

  expect_silent(gisco_get_lau(country = "LU"))
})
