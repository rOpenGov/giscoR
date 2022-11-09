test_that("Test cache online", {
  # Get current cache dir
  current <- gsc_helper_detect_cache_dir()

  cat("User cache dir is ", current, "\n")

  # Set a temp cache dir
  expect_message(gisco_set_cache_dir(verbose = TRUE))
  testdir <- expect_silent(gisco_set_cache_dir(verbose = FALSE))
  # Clean
  expect_silent(gisco_clear_cache(config = FALSE, verbose = FALSE))
  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))


  # Reset just for testing all cases
  testdir <- file.path(tempdir(), "giscoR", "testthat")
  expect_message(gisco_set_cache_dir(testdir))

  cat("Testing cache dir is ", Sys.getenv("GISCO_CACHE_DIR"), "\n")


  skip_on_cran()
  skip_if_gisco_offline()

  expect_message(gisco_get_countries(resolution = "60", verbose = TRUE))

  expect_true(dir.exists(testdir))

  expect_message(gisco_clear_cache(config = FALSE, verbose = TRUE))

  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Restore cache
  expect_message(gisco_set_cache_dir(current, verbose = TRUE))
  expect_silent(gisco_set_cache_dir(current, verbose = FALSE))
  expect_equal(current, Sys.getenv("GISCO_CACHE_DIR"))
  expect_true(dir.exists(current))
})
