test_that("Error on postal codes", {
  expect_error(gisco_get_postalcodes("1991"))
})
