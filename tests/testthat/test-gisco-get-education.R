test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_get_education(country = "LU", update_cache = TRUE),
    "Error"
  )
  expect_null(n)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})
test_that("Education online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_education(country = "LU", cache = FALSE))
  expect_silent(gisco_get_education(country = "Denmark"))
  expect_message(gisco_get_education(verbose = TRUE, country = "BE"))

  # Several countries
  nn <- gisco_get_education(country = c("LU", "DK", "BE"))

  expect_length(unique(nn$cntr_id), 3)
  expect_s3_class(nn, "sf")
  expect_s3_class(nn, "tbl_df")

  # Full
  eufull <- gisco_get_education()
  expect_s3_class(eufull, "sf")
  expect_s3_class(eufull, "tbl_df")

  expect_gt(length(unique(eufull$cntr_id)), 10)
})

test_that("Education online 2020", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_education(country = "LU", cache = FALSE, year = 2020))
  expect_silent(gisco_get_education(country = "Denmark", year = 2020))
  expect_message(gisco_get_education(
    verbose = TRUE,
    country = "BE",
    year = 2020
  ))

  # Several countries
  nn <- gisco_get_education(country = c("LU", "DK", "BE"), year = 2020)

  expect_length(unique(nn$cntr_id), 3)
  expect_s3_class(nn, "sf")
  expect_s3_class(nn, "tbl_df")
})
