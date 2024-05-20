test_that("Education online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_education(country = "LU", cache = FALSE))
  expect_silent(gisco_get_education(country = "Denmark"))
  expect_message(gisco_get_education(verbose = TRUE, country = "BE"))

  # Several countries
  nn <- gisco_get_education(country = c("LU", "DK", "BE"))

  expect_length(unique(nn$cc), 3)

  # Full
  eufull <- gisco_get_education()

  expect_gt(length(unique(eufull$cc)), 10)
})

test_that("Offline", {
  options(giscoR_test_offline = TRUE)
  expect_message(
    n <- gisco_get_education(update_cache = TRUE),
    "not reachable"
  )
  expect_null(n)
  options(giscoR_test_offline = FALSE)
})
