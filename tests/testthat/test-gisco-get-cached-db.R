test_that("Cached database returns NULL when offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  gb <- gisco_get_cached_db()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(fend <- gisco_get_cached_db(update_cache = TRUE))
  expect_null(fend)
})

test_that("Cached database returns NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(n <- gisco_get_cached_db(update_cache = TRUE))
  expect_null(n)
})

test_that("Cached database stores fallback data when remote access fails", {
  skip_on_cran()
  skip_if_gisco_offline()
  cdir <- local_test_cache_dir("cache-db-offline-")
  withr::local_envvar(GISCO_CACHE_DIR = cdir)

  cdir <- detect_cache_dir_muted()
  cdir_db <- create_cache_dir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")
  expect_false(file.exists(cached_db))
  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(n <- get_db())
  old_db <- gisco_db
  expect_identical(n, old_db)

  # Next time silent and cached
  expect_silent(n2 <- get_db())
  expect_identical(n2, gisco_db)
})
test_that("Cached database is still created under CRAN settings", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("cache-db-cran-")
  withr::local_envvar(GISCO_CACHE_DIR = cdir, NOT_CRAN = "false")

  expect_true(on_cran())

  cdir <- detect_cache_dir_muted()
  cdir_db <- create_cache_dir(file.path(cdir, "cache_db"))
  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")

  expect_false(file.exists(cached_db))

  expect_silent(n <- gisco_get_cached_db())
  expect_identical(n, gisco_db)
  expect_true(file.exists(cached_db))
})
test_that("Cached DB helpers build cache paths and scrape entries", {
  cdir <- local_test_cache_dir("cache-db-helper-")

  expect_identical(
    cached_db_file(cdir),
    file.path(cdir, "cache_db", "gisco_cached_db.rds")
  )
  expect_true(dir.exists(file.path(cdir, "cache_db")))

  local_mocked_bindings(scrap_api_data = function(entry_point) {
    data.frame(id_giscor = entry_point, year = "2024")
  })
  db <- scrape_distribution_db(c("nuts", "lau"))
  expect_identical(db$id_giscor, c("nuts", "lau"))
})

test_that("API scraping skips child datasets that cannot be fetched", {
  calls <- 0L
  master <- paste0(
    '{"2024": {"files": "missing-child.json"}}'
  )

  local_mocked_bindings(
    gisco_perform_request = function(...) {
      calls <<- calls + 1L
      if (calls == 1L) {
        return(httr2::response(
          200,
          headers = list("content-type" = "application/json"),
          body = charToRaw(master)
        ))
      }
      NULL
    }
  )

  expect_null(scrap_api_data("nuts"))
  expect_identical(calls, 2L)
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
  expect_equal(
    setdiff(
      c(
        "epsg",
        "resolution",
        "spatialtype",
        "nuts_level",
        "level",
        "ext",
        "last_updated"
      ),
      names(out)
    ),
    character(0)
  )
  expect_equal(
    setdiff(c("coastal_lines", "urban_audit", "postal_codes"), out$id_giscor),
    character(0)
  )
  expect_equal(setdiff("2", out$nuts_level), character(0))
  expect_equal(setdiff("CITIES", out$level), character(0))
})

test_that("Cached database refreshes from the remote metadata", {
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

test_that("Cached database reuses the local RDS file", {
  skip_on_cran()
  skip_if_gisco_offline()
  cdir <- local_test_cache_dir("cache-db-")
  withr::local_envvar(GISCO_CACHE_DIR = cdir)

  cdir <- detect_cache_dir_muted()
  cdir_db <- create_cache_dir(file.path(cdir, "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")
  expect_false(file.exists(cached_db))

  # Get db
  new_db <- gisco_get_cached_db()
  expect_true(file.exists(cached_db))
  new_db_cached <- gisco_get_cached_db()
  expect_identical(new_db, new_db_cached)
})
