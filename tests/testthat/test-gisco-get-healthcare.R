test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  options(gisco_test_404 = TRUE)
  expect_message(
    n <- gisco_get_healthcare(update_cache = TRUE, year = 2020),
    "Error"
  )
  expect_null(n)
  options(gisco_test_404 = FALSE)
})

test_that("Healthcare online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(n <- gisco_get_healthcare(year = 2020))

  expect_silent(n <- gisco_get_healthcare())
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_silent(esp <- gisco_get_healthcare(country = "Spain"))
  expect_lt(nrow(esp), nrow(n))

  expect_message(gisco_get_healthcare(verbose = TRUE))

  # No cache
  expect_silent(n <- gisco_get_healthcare())
  expect_silent(n2 <- gisco_get_healthcare(cache = FALSE))
  expect_identical(n, n2)
})
