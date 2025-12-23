test_that("Test cache", {
  skip_on_cran()
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
  skip_on_cran()
  # Store current value
  getvar <- Sys.getenv("GISCO_CACHE_DIR")

  # New empty value
  Sys.unsetenv("GISCO_CACHE_DIR")
  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), "")

  # Careful!
  cache_config <- file.path(
    tools::R_user_dir("giscoR", "config"),
    "gisco_cache_dir"
  )
  tester_has_config_installed <- file.exists(cache_config)

  if (tester_has_config_installed) {
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

  # Restore cache
  if (tester_has_config_installed) {
    gisco_set_cache_dir(
      stored_val,
      install = TRUE,
      overwrite = TRUE,
      verbose = FALSE
    )
  }

  # Session value (may differ from current)
  gisco_set_cache_dir(getvar, install = FALSE)

  Sys.setenv("GISCO_CACHE_DIR" = getvar)
})


test_that("Mock migration", {
  skip_on_cran()

  # Store current value
  getvar <- Sys.getenv("GISCO_CACHE_DIR")
  # New empty value
  Sys.unsetenv("GISCO_CACHE_DIR")
  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), "")

  # Delete now cache files
  old <- rappdirs::user_config_dir("giscoR", "R")
  new <- tools::R_user_dir("giscoR", "config")
  fname <- "gisco_cache_dir"

  old_fname <- file.path(old, fname)
  new_fname <- file.path(new, fname)
  tester_has_config_installed <- file.exists(new_fname)

  unlink(old_fname)
  unlink(new_fname)

  expect_false(file.exists(old_fname))
  expect_false(file.exists(new_fname))

  # Create an old cache config
  nnn <- create_cache_dir(old)
  writeLines(tempdir(), old_fname)
  expect_true(file.exists(old_fname))

  # On detect we should see a message
  expect_snapshot(detected <- detect_cache_dir_muted())
  # And never again
  expect_silent(detected2 <- detect_cache_dir_muted())
  expect_identical(detected, detected2)
  expect_identical(detected, tempdir())
  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), detected)

  expect_false(file.exists(old_fname))
  expect_true(file.exists(new_fname))

  # OK, now re-configure the cache
  if (tester_has_config_installed) {
    gisco_set_cache_dir(
      getvar,
      install = TRUE,
      overwrite = TRUE,
      verbose = FALSE
    )
  } else {
    gisco_set_cache_dir(getvar, install = FALSE, verbose = FALSE)
  }

  after_test <- detect_cache_dir_muted()

  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), getvar)
  expect_identical(after_test, getvar)
})
