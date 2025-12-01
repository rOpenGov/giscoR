test_that("No conexion", {
  skip_on_cran()
  skip_if_gisco_offline()

  gb <- gisco_get_latest_db(update_cache = TRUE)

  options(gisco_test_off = TRUE)

  expect_snapshot(
    fend <- gisco_get_latest_db(update_cache = TRUE),
  )
  expect_null(fend)

  expect_snapshot(
    fend <- gisco_get_latest_db_units(update_cache = TRUE),
  )
  expect_null(fend)

  options(gisco_test_off = FALSE)
})


test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_err = TRUE)
  expect_message(
    n <- gisco_get_latest_db(update_cache = TRUE),
    "Can't access"
  )
  expect_null(n)

  expect_message(
    n <- gisco_get_latest_db_units(update_cache = TRUE),
    "Can't access"
  )
  expect_null(n)

  options(gisco_test_err = FALSE)
})

test_that("Offline detection", {
  skip_on_cran()
  skip_if_gisco_offline()
  cdir <- gsc_helper_detect_cache_dir()
  cdir_db <- gsc_helper_cachedir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")
  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))
  options(gisco_test_err = TRUE)
  expect_message(
    n <- get_db(),
    "Can't access"
  )
  old_db <- gisco_db
  expect_identical(n, old_db)

  # Next time silent and cached
  expect_silent(n2 <- get_db())
  expect_identical(n2, gisco_db)

  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))
  options(gisco_test_err = FALSE)
})
test_that("On CRAN", {
  # Imagine we are in CRAN
  env_orig <- Sys.getenv("NOT_CRAN")
  Sys.setenv("NOT_CRAN" = "false")
  expect_true(on_cran())

  cdir <- gsc_helper_detect_cache_dir()
  cdir_db <- gsc_helper_cachedir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")
  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))
  expect_silent(n <- gisco_get_latest_db())
  old_db <- gisco_db
  expect_identical(n, old_db)

  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))

  # Restore
  Sys.setenv("NOT_CRAN" = env_orig)
  expect_identical(Sys.getenv("NOT_CRAN"), env_orig)
})

test_that("Get database", {
  skip_on_cran()
  skip_if_gisco_offline()

  # Get db
  new_db <- gisco_get_latest_db(update_cache = TRUE)
  expect_s3_class(new_db, "tbl_df")
  expect_snapshot(unique(new_db$id_giscor))
  expect_snapshot(unique(new_db$ext))
  expect_snapshot(unique(new_db$epsg))
  expect_snapshot(unique(new_db$nuts_level))
  expect_snapshot(unique(new_db$resolution))
  expect_snapshot(unique(new_db$spatialtype))
  expect_snapshot(unique(new_db$level))
  expect_snapshot(sort(unique(new_db$year)))
})

test_that("Test cached database", {
  skip_on_cran()
  skip_if_gisco_offline()
  cdir <- gsc_helper_detect_cache_dir()
  cdir_db <- gsc_helper_cachedir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")
  unlink(cached_db)
  expect_false(file.exists(cached_db))

  # Get db
  new_db <- gisco_get_latest_db()
  expect_true(file.exists(cached_db))
  new_db_cached <- gisco_get_latest_db()
  expect_identical(new_db, new_db_cached)
})

test_that("Offline detection units", {
  skip_on_cran()
  skip_if_gisco_offline()
  cdir <- gsc_helper_detect_cache_dir()
  cdir_db <- gsc_helper_cachedir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db_units.rds")
  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))
  options(gisco_test_err = TRUE)
  expect_message(
    n <- get_db_units(),
    "Can't access"
  )
  old_db <- gisco_db_units
  expect_identical(n, old_db)

  # Next time silent and cached
  expect_silent(n2 <- get_db_units())
  expect_identical(n2, gisco_db_units)

  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))
  options(gisco_test_err = FALSE)
})

test_that("On CRAN units", {
  # Imagine we are in CRAN
  env_orig <- Sys.getenv("NOT_CRAN")
  Sys.setenv("NOT_CRAN" = "false")
  expect_true(on_cran())

  cdir <- gsc_helper_detect_cache_dir()
  cdir_db <- gsc_helper_cachedir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db_units.rds")
  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))
  expect_silent(n <- gisco_get_latest_db_units())
  old_db <- gisco_db_units
  expect_identical(n, old_db)

  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))

  # Restore
  Sys.setenv("NOT_CRAN" = env_orig)
  expect_identical(Sys.getenv("NOT_CRAN"), env_orig)
})
test_that("Get database units", {
  skip_on_cran()
  skip_if_gisco_offline()

  # Get db
  new_db <- gisco_get_latest_db_units(update_cache = TRUE)
  expect_s3_class(new_db, "tbl_df")
  expect_snapshot(unique(new_db$id_giscor))
  expect_snapshot(unique(new_db$ext))
  expect_snapshot(unique(new_db$epsg))
  expect_snapshot(unique(new_db$resolution))
  expect_snapshot(unique(new_db$spatialtype))
  expect_snapshot(sort(unique(new_db$year)))
})

test_that("Test cached database units", {
  skip_on_cran()
  skip_if_gisco_offline()
  cdir <- gsc_helper_detect_cache_dir()
  cdir_db <- gsc_helper_cachedir(file.path(cdir, "cache_db"))
  cached_db <- file.path(cdir_db, "gisco_cached_db_units.rds")
  unlink(cached_db)
  expect_false(file.exists(cached_db))

  # Get db
  new_db <- gisco_get_latest_db_units()
  expect_true(file.exists(cached_db))
  new_db_cached <- gisco_get_latest_db_units()
  expect_identical(new_db, new_db_cached)
})
