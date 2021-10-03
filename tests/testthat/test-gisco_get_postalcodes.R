test_that("Error on postal codes", {
  expect_error(gisco_get_postalcodes("1991"))
})

test_that("Postal codes online", {
  skip_if_gisco_offline()
  skip_on_cran()

  expect_message(gisco_get_postalcodes(country = "LU", verbose = TRUE))
})
