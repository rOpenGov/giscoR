test_that("Healthcare online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_healthcare())
  # expect_silent(gisco_get_healthcare(cache = FALSE))
  expect_silent(gisco_get_healthcare(country = "Spain"))
  expect_message(gisco_get_healthcare(verbose = TRUE))
})
