test_that("Error on postal codes", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_error(gisco_get_postal_codes("1991", "Years available for"))
})

test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_err = TRUE)
  expect_message(
    n <- gisco_get_postal_codes(
      year = 2024,
      country = "ES",
      update_cache = TRUE
    ),
    "Error"
  )
  expect_null(n)
  options(gisco_test_err = FALSE)
})

test_that("Postal codes online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_message(gisco_get_postal_codes(
    country = "Malta",
    verbose = TRUE
  ))

  expect_silent(li <- gisco_get_postal_codes(country = "Malta"))
  expect_s3_class(li, "sf")
  expect_s3_class(li, "tbl_df")
  expect_length(unique(li$CNTR_ID), 1)
  expect_identical(as.character(unique(li$CNTR_ID)), "MT")

  # Several
  expect_silent(li2 <- gisco_get_postal_codes(country = c("MT", "LU")))
  expect_length(unique(li2$CNTR_ID), 2)
  expect_s3_class(li2, "sf")
  expect_s3_class(li2, "tbl_df")

  expect_identical(sort(unique(li2$CNTR_ID)), c("LU", "MT"))

  # All
  all <- gisco_get_postal_codes()
  expect_s3_class(all, "sf")
  expect_s3_class(all, "tbl_df")
})
test_that("Extensions", {
  skip_on_cran()
  skip_if_gisco_offline()

  # Error
  expect_snapshot(
    gisco_get_postal_codes(ext = "docx"),
    error = TRUE
  )

  cdir <- file.path(tempdir(), "testpcode")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  # Filter
  db_shp <- gisco_get_postal_codes(
    cache_dir = cdir,
    ext = "shp",
    verbose = TRUE,
    country = "LU"
  )
  expect_length(
    list.files(cdir, recursive = TRUE, pattern = "shp.zip"),
    1
  )

  # Cleanup
  unlink(cdir, recursive = TRUE, force = TRUE)
})
