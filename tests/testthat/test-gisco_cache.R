test_that("Test cache online", {

  # Get current cache dir
  current <- gsc_helper_detect_cache_dir()

  cat("User cache dir is ", current, "\n")

  # Set a temp cache dir

  testdir <- expect_message(gisco_set_cache_dir())

  expect_false(current == Sys.getenv("GISCO_CACHE_DIR"))
  expect_equal(testdir, Sys.getenv("GISCO_CACHE_DIR"))

  cat("Testing cache dir is ", Sys.getenv("GISCO_CACHE_DIR"), "\n")

  skip_on_cran()
  skip_if_gisco_offline()

  expect_message(gisco_get_countries(resolution = "60", verbose = TRUE))

  expect_true(dir.exists(testdir))

  expect_message(gisco_clear_cache(config = FALSE, verbose = TRUE))

  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Restore cache
  expect_silent(gisco_set_cache_dir(current, verbose = FALSE))

  expect_false(testdir == Sys.getenv("GISCO_CACHE_DIR"))
  expect_equal(current, Sys.getenv("GISCO_CACHE_DIR"))
})
