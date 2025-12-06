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

  cdir <- file.path(tempdir(), "test_health")
  unlink(cdir, force = TRUE, recursive = TRUE)
  expect_false(dir.exists(cdir))
  create_cache_dir(cdir)
  expect_true(dir.exists(cdir))

  # No Cache
  expect_silent(
    n <- gisco_get_healthcare(country = "LU", cache_dir = cdir, cache = FALSE)
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_true(all(n$cntr_id == "LU"))
  expect_length(list.files(cdir, recursive = TRUE), 0)

  # Cache
  expect_silent(
    n <- gisco_get_healthcare(country = "LU", cache = TRUE, cache_dir = cdir)
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_true(all(n$cntr_id == "LU"))
  expect_length(list.files(cdir, recursive = TRUE), 1)

  expect_silent(n <- gisco_get_healthcare(cache_dir = cdir))
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_silent(
    esp <- gisco_get_healthcare(country = "Spain", cache_dir = cdir)
  )
  expect_lt(nrow(esp), nrow(n))

  expect_message(gisco_get_healthcare(verbose = TRUE))
  unlink(cdir, force = TRUE, recursive = TRUE)
  expect_false(dir.exists(cdir))
})
