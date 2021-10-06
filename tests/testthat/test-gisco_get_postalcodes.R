test_that("Error on postal codes", {
  expect_error(gisco_get_postalcodes("1991"))
})

test_that("Postal codes online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_message(gisco_get_postalcodes(
    country = "Malta",
    verbose = TRUE
  ))


  li <- expect_silent(gisco_get_postalcodes(country = "Malta"))
  expect_length(unique(li$CNTR_ID), 1)
  expect_identical(as.character(unique(li$CNTR_ID)), "MT")
})
