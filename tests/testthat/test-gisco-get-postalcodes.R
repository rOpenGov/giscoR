test_that("Error on postal codes", {
  expect_error(gisco_get_postalcodes("1991", "Years available for"))
})

test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  db <- gisco_get_latest_db()

  options(giscoR_test_offline = TRUE)
  expect_message(
    n <- gisco_get_postalcodes(
      year = 2024,
      country = "ES",
      update_cache = TRUE
    ),
    "Error"
  )
  expect_null(n)
  options(giscoR_test_offline = FALSE)
})

test_that("Postal codes online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_message(gisco_get_postalcodes(
    country = "Malta",
    verbose = TRUE
  ))

  li <- expect_silent(gisco_get_postalcodes(country = "Malta"))
  expect_s3_class(li, "sf")
  expect_s3_class(li, "tbl_df")
  expect_length(unique(li$CNTR_ID), 1)
  expect_identical(as.character(unique(li$CNTR_ID)), "MT")

  # Several
  li2 <- expect_silent(gisco_get_postalcodes(country = c("MT", "LU")))
  expect_length(unique(li2$CNTR_ID), 2)
  expect_s3_class(li2, "sf")
  expect_s3_class(li2, "tbl_df")

  expect_identical(sort(unique(li2$CNTR_ID)), c("LU", "MT"))

  # All
  all <- gisco_get_postalcodes()
  expect_s3_class(all, "sf")
  expect_s3_class(all, "tbl_df")
})
