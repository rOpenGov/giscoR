test_that("Cache directory can be set and cleared", {
  skip_on_cran()
  skip_if_gisco_offline()
  # Get current cache dir
  current <- gisco_detect_cache_dir()
  expect_true(nzchar(current))

  # Set a temp cache dir
  expect_message(gisco_set_cache_dir(verbose = TRUE), "temporary cache")
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
  testdir <- local_test_cache_dir("gisco-cache-test-")
  expect_message(gisco_set_cache_dir(testdir), "cache directory")

  expect_true(dir.exists(testdir))

  expect_message(gisco_clear_cache(config = FALSE, verbose = TRUE), "Deleted")

  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Restore cache
  expect_message(
    gisco_set_cache_dir(current, verbose = TRUE),
    "cache directory"
  )
  expect_silent(gisco_set_cache_dir(current, verbose = FALSE))
  expect_equal(current, Sys.getenv("GISCO_CACHE_DIR"))
  expect_true(dir.exists(current))

  # Try cleaning
  new_dir <- local_test_cache_dir("new-cache-config-")
  old_dir <- local_test_cache_dir("old-cache-config-")

  writeLines("a", file.path(new_dir, "gisco_cache_dir"))
  writeLines("b", file.path(old_dir, "gisco_cache_dir"))
  expect_true(file.exists(file.path(new_dir, "gisco_cache_dir")))
  expect_true(file.exists(file.path(old_dir, "gisco_cache_dir")))
  expect_silent(migrate_cache(old_dir, new_dir))
  expect_true(file.exists(file.path(new_dir, "gisco_cache_dir")))
  expect_false(file.exists(file.path(old_dir, "gisco_cache_dir")))
})

test_that("Cache configuration is restored after a restart", {
  skip_on_cran()
  skip_if_gisco_offline()
  config_dir <- withr::local_tempdir("gisco-config-")
  withr::local_envvar(GISCO_CACHE_DIR = NA_character_)
  local_mocked_bindings(gisco_user_dir = function(which = "config") config_dir)

  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), "")
  expect_false(file.exists(file.path(
    gisco_user_dir("config"),
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

test_that("Cache configuration restores a persisted cache path", {
  config_dir <- withr::local_tempdir("gisco-config-")
  cache_dir <- withr::local_tempdir("gisco-cache-")
  writeLines(cache_dir, file.path(config_dir, "gisco_cache_dir"))
  withr::local_envvar(GISCO_CACHE_DIR = NA_character_)
  local_mocked_bindings(
    gisco_user_dir = function(which = "config") config_dir,
    migrate_cache = function(...) invisible()
  )

  muted <- detect_cache_dir_muted()

  expect_identical(muted, cache_dir)
  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), cache_dir)
})

test_that("Persistent cache config can be installed and overwritten", {
  skip_on_cran()
  skip_if_gisco_offline()
  root <- withr::local_tempdir("gisco-cache-install-")
  config_dir <- file.path(root, "config")
  cache_dir <- file.path(root, "cache")
  cache_dir2 <- file.path(root, "cache2")
  withr::local_envvar(GISCO_CACHE_DIR = NA_character_)
  local_mocked_bindings(gisco_user_dir = function(which = "config") config_dir)

  expect_silent(gisco_set_cache_dir(cache_dir, install = TRUE, verbose = FALSE))
  giscor_file <- file.path(config_dir, "gisco_cache_dir")
  expect_true(dir.exists(config_dir))
  expect_identical(readLines(giscor_file), cache_dir)

  expect_snapshot(
    error = TRUE,
    gisco_set_cache_dir(cache_dir2, install = TRUE, verbose = FALSE)
  )

  expect_silent(gisco_set_cache_dir(
    cache_dir2,
    install = TRUE,
    overwrite = TRUE,
    verbose = FALSE
  ))
  expect_identical(readLines(giscor_file), cache_dir2)
})

test_that("Clear cache can remove config without cached data", {
  skip_on_cran()
  skip_if_gisco_offline()
  config_dir <- withr::local_tempdir("gisco-config-")
  cache_dir <- withr::local_tempdir("gisco-cache-")
  writeLines("cache", file.path(config_dir, "gisco_cache_dir"))
  writeLines("data", file.path(cache_dir, "data.txt"))
  withr::local_envvar(GISCO_CACHE_DIR = cache_dir)
  local_mocked_bindings(
    gisco_user_dir = function(which = "config") config_dir,
    migrate_cache = function(...) invisible()
  )

  expect_message(
    gisco_clear_cache(config = TRUE, cached_data = FALSE, verbose = TRUE),
    "Deleted"
  )
  expect_false(dir.exists(config_dir))
  expect_true(dir.exists(cache_dir))
  expect_false(nzchar(Sys.getenv("GISCO_CACHE_DIR")))
})

test_that("Empty cache config falls back to temporary cache", {
  skip_on_cran()
  skip_if_gisco_offline()
  config_dir <- withr::local_tempdir("gisco-config-")
  writeLines("", file.path(config_dir, "gisco_cache_dir"))
  withr::local_envvar(GISCO_CACHE_DIR = NA_character_)
  local_mocked_bindings(
    gisco_user_dir = function(which = "config") config_dir,
    migrate_cache = function(...) invisible()
  )

  muted <- detect_cache_dir_muted()

  expect_identical(file.path(tempdir(), "giscoR"), muted)
  expect_identical(Sys.getenv("GISCO_CACHE_DIR"), muted)
})

test_that("Legacy cache configuration migrates to the current location", {
  skip_on_cran()
  skip_if_gisco_offline()
  config_dir <- withr::local_tempdir("gisco-config-")
  cache_dir <- withr::local_tempdir("gisco-cache-")
  old <- withr::local_tempdir("gisco-old-config-")
  withr::local_envvar(GISCO_CACHE_DIR = NA_character_)
  local_mocked_bindings(gisco_user_dir = function(which = "config") config_dir)

  new <- gisco_user_dir("config")
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
