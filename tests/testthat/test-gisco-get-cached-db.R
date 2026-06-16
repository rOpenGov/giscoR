test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  gb <- gisco_get_cached_db()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(fend <- gisco_get_cached_db(update_cache = TRUE))
  expect_null(fend)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
})

test_that("Test 404", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_get_cached_db(update_cache = TRUE),
    "Could not access"
  )
  expect_null(n)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Offline detection", {
  skip_on_cran()
  skip_if_gisco_offline()
  cdir <- detect_cache_dir_muted()
  cdir_db <- create_cache_dir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")
  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))
  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(n <- get_db(), "Could not access")
  old_db <- gisco_db
  expect_identical(n, old_db)

  # Next time silent and cached
  expect_silent(n2 <- get_db())
  expect_identical(n2, gisco_db)

  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})
test_that("On CRAN", {
  skip_on_cran()
  skip_if_gisco_offline()

  # Imagine we are in CRAN
  env_orig <- Sys.getenv("NOT_CRAN")
  Sys.setenv("NOT_CRAN" = "false")
  expect_true(on_cran())

  cdir <- detect_cache_dir_muted()
  cdir_db <- create_cache_dir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")
  if (file.exists(cached_db)) {
    unlink(cached_db)
  }
  expect_false(file.exists(cached_db))
  expect_silent(n <- gisco_get_cached_db())
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

test_that("Cached DB helpers build cache paths and scrape entries", {
  cdir <- file.path(tempdir(), "testthat", "cache-db-helper")
  unlink(cdir, force = TRUE, recursive = TRUE)

  expect_identical(
    cached_db_file(cdir),
    file.path(cdir, "cache_db", "gisco_cached_db.rds")
  )
  expect_true(dir.exists(file.path(cdir, "cache_db")))

  local_mocked_bindings(
    scrap_api_data = function(entry_point) {
      data.frame(id_giscor = entry_point, year = "2024")
    }
  )
  db <- scrape_distribution_db(c("nuts", "lau"))
  expect_identical(db$id_giscor, c("nuts", "lau"))
})

test_that("Cached DB normalization adds derived columns", {
  db <- data.frame(
    id_giscor = c("coas", "nuts", "urau", "pcode"),
    year = c("2016", "2024", "2021", "2024"),
    api_file = c(
      "COAS_RG_20M_2016_4326.gpkg",
      "NUTS_RG_20M_2024_4326_LEVL_2.gpkg",
      "URAU_RG_100K_2021_4326_CITIES.gpkg",
      "PCODE_PT_2024_4326.gpkg"
    ),
    api_entry = "https://example.com"
  )

  out <- normalize_distribution_db(db)
  expect_s3_class(out, "tbl_df")
  expect_true(all(
    c(
      "epsg",
      "resolution",
      "spatialtype",
      "nuts_level",
      "level",
      "ext",
      "last_updated"
    ) %in%
      names(out)
  ))
  expect_true("coastal_lines" %in% out$id_giscor)
  expect_true("urban_audit" %in% out$id_giscor)
  expect_true("postal_codes" %in% out$id_giscor)
  expect_true("2" %in% out$nuts_level)
  expect_true("CITIES" %in% out$level)
})

test_that("Get database", {
  skip_on_cran()
  skip_if_gisco_offline()

  # Get db
  new_db <- gisco_get_cached_db(update_cache = TRUE)
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
  cdir <- detect_cache_dir_muted()
  cdir_db <- create_cache_dir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")
  unlink(cached_db)
  expect_false(file.exists(cached_db))

  # Get db
  new_db <- gisco_get_cached_db()
  expect_true(file.exists(cached_db))
  new_db_cached <- gisco_get_cached_db()
  expect_identical(new_db, new_db_cached)
})
