test_that("Test cache", {
  # Get current cache dir
  expect_message(current <- gisco_detect_cache_dir())

  # Set a temp cache dir
  expect_message(gisco_set_cache_dir(verbose = TRUE))
  testdir <- expect_silent(gisco_set_cache_dir(
    file.path(current, "testthat"),
    verbose = FALSE
  ))

  expect_identical(gisco_detect_cache_dir(), testdir)

  # Clean
  expect_silent(gisco_clear_cache(config = FALSE, verbose = FALSE))
  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Reset just for testing all cases
  testdir <- file.path(tempdir(), "giscor", "testthat")
  expect_message(gisco_set_cache_dir(testdir))

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

test_that("Mock restart", {
  # Store current value
  getvar <- Sys.getenv("GISCO_CACHE_DIR")

  # New empty value
  Sys.unsetenv("GISCO_CACHE_DIR")
  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), "")

  # Careful!
  cache_config <- file.path(
    rappdirs::user_config_dir("giscoR", "R"),
    "gisco_cache_dir"
  )

  if (file.exists(cache_config)) {
    stored_val <- readLines(cache_config)
    gisco_clear_cache(cached_data = FALSE, config = TRUE)
    expect_false(file.exists(cache_config))
    expect_true(Sys.getenv("GISCO_CACHE_DIR") == "")

    # We are clear now, we should detect default cache location
    default_loc <- detect_cache_dir_muted()

    # Should be the tempdir
    expect_identical(file.path(tempdir(), "giscoR"), default_loc)

    # Now we should restore the cache
    expect_message(
      gisco_set_cache_dir(stored_val, overwrite = TRUE, install = TRUE),
      "cache dir is"
    )

    # But for the next test we delete the envar
    Sys.unsetenv("GISCO_CACHE_DIR")
    expect_identical(Sys.getenv("GISCO_CACHE_DIR"), "")
  }

  muted <- detect_cache_dir_muted()
  created <- create_cache_dir()
  muted2 <- detect_cache_dir_muted()

  expect_identical(muted, created)
  expect_identical(muted, muted2)
  expect_false(Sys.getenv("GISCO_CACHE_DIR") == "")
  expect_identical(muted, getvar)

  # Restore cache
  Sys.setenv("GISCO_CACHE_DIR" = getvar)
})
