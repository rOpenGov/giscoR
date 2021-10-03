test_that("Healthcare online", {
  skip_if_gisco_offline()
  skip_on_cran()

  expect_silent(gisco_get_healthcare())
  expect_silent(gisco_get_healthcare(country = "Spain"))
  expect_message(gisco_get_healthcare(verbose = TRUE))
})
