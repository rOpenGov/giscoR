test_that("Error on postal codes", {
  expect_error(gisco_get_postalcodes("1991"))
})

test_that("Postal codes online", {
  skip_on_cran()
  skip_if_not(
    gisco_check_access(),
    "Skipping... GISCO not reachable."
  )
  expect_silent(gisco_get_postalcodes())
})
