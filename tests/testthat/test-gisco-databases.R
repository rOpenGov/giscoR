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
