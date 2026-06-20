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
  config_root <- withr::local_tempdir("gisco-config-")
  withr::local_envvar(
    c(
      GISCO_CACHE_DIR = NA_character_,
      R_USER_CONFIG_DIR = config_root,
      XDG_CONFIG_HOME = config_root
    )
  )

  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), "")
  expect_false(file.exists(file.path(
    tools::R_user_dir("giscoR", "config"),
    "gisco_cache_dir"
  )))

  muted <- detect_cache_dir_muted()
  created <- create_cache_dir()
  muted2 <- detect_cache_dir_muted()

  expect_identical(file.path(tempdir(), "giscoR"), muted)
  expect_identical(muted, created)
  expect_identical(muted, muted2)
  expect_true(nzchar(Sys.getenv("GISCO_CACHE_DIR")))
})

test_that("Mock migration", {
  skip_on_cran()
  config_root <- withr::local_tempdir("gisco-config-")
  cache_dir <- withr::local_tempdir("gisco-cache-")
  old <- withr::local_tempdir("gisco-old-config-")
  withr::local_envvar(
    c(
      GISCO_CACHE_DIR = NA_character_,
      R_USER_CONFIG_DIR = config_root,
      XDG_CONFIG_HOME = config_root
    )
  )

  new <- tools::R_user_dir("giscoR", "config")
  fname <- "gisco_cache_dir"
  old_fname <- file.path(old, fname)
  new_fname <- file.path(new, fname)

  writeLines(cache_dir, old_fname)
  expect_true(file.exists(old_fname))
  expect_false(file.exists(new_fname))
  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), "")

  expect_snapshot(migrate_cache(old = old, new = new))

  expect_false(dir.exists(old))
  expect_true(file.exists(new_fname))
  expect_identical(readLines(new_fname), cache_dir)
  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), cache_dir)
})
