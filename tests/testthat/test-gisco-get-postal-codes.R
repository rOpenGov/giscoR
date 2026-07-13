test_that("Postal codes validate available years", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(
    gisco_get_postal_codes("1991", "Years available for"),
    error = TRUE
  )
})

test_that("Postal codes return NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_test_cached_db("postal-db-")

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(
    n <- gisco_get_postal_codes(
      year = 2024,
      country = "ES",
      update_cache = TRUE
    )
  )
  expect_null(n)
})

test_that("Postal codes use resolved GISCO files", {
  filter_calls <- list()

  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/PCODE_PT_2024_4326.gpkg",
        name = "PCODE_PT_2024_4326.gpkg"
      )
    },
    convert_country_code_or_null = function(country) {
      c("MT", "LU")
    },
    make_sf_filter = function(
      file_local,
      values,
      candidates = c("CNTR_ID", "CNTR_CODE")
    ) {
      filter_calls[[length(filter_calls) + 1L]] <<- list(
        file_local = file_local,
        values = values,
        candidates = candidates
      )
      stats::setNames(list(values), paste(candidates, collapse = "|"))
    },
    read_gisco_dataset = function(
      url,
      name,
      cache = TRUE,
      cache_dir = NULL,
      subdir,
      update_cache = FALSE,
      verbose = FALSE,
      filters = NULL,
      ...
    ) {
      expect_match(url, "PCODE_PT_2024_4326[.]gpkg$")
      expect_identical(name, "PCODE_PT_2024_4326.gpkg")
      expect_true(cache)
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "postal_codes")
      expect_true(update_cache)
      expect_true(verbose)
      expect_true(is.function(filters))
      expect_identical(
        filters("postal_codes.gpkg"),
        list("CNTR_ID|CNTR_CODE" = c("MT", "LU"))
      )
      data.frame(CNTR_ID = c("MT", "LU"), name = c("a", "b"))
    }
  )

  postal_codes <- gisco_get_postal_codes(
    country = c("Malta", "LU"),
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(postal_codes$CNTR_ID, c("MT", "LU"))
  expect_identical(
    filter_calls,
    list(list(
      file_local = "postal_codes.gpkg",
      values = c("MT", "LU"),
      candidates = c("CNTR_ID", "CNTR_CODE")
    ))
  )
})

test_that("Postal codes select the requested EPSG", {
  local_mocked_bindings(
    resolve_gisco_file = function(id, year, epsg, ext, fn) {
      expect_identical(id, "postal_codes")
      expect_identical(year, 2025)
      expect_identical(epsg, 3035)
      expect_identical(ext, "gpkg")
      expect_identical(fn, "gisco_get_postal_codes")
      list(
        url = "https://example.com/PCODE_PT_2025_3035.gpkg",
        name = "PCODE_PT_2025_3035.gpkg"
      )
    },
    read_gisco_dataset = function(...) {
      data.frame(CNTR_ID = "LU", name = "a")
    }
  )

  postal_codes <- gisco_get_postal_codes(epsg = 3035)
  expect_identical(postal_codes$CNTR_ID, "LU")
})

test_that("Postal codes reject unsupported extensions and read shapefiles", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(gisco_get_postal_codes(ext = "docx"), error = TRUE)

  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/PCODE_PT_2024_4326.shp.zip",
        name = "PCODE_PT_2024_4326.shp.zip"
      )
    },
    read_gisco_dataset = function(url, name, ...) {
      expect_match(url, "[.]shp[.]zip$")
      expect_identical(name, "PCODE_PT_2024_4326.shp.zip")
      data.frame(CNTR_ID = "LU", name = "a")
    }
  )
  postal_codes <- gisco_get_postal_codes(ext = "shp", country = "LU")
  expect_identical(postal_codes$CNTR_ID, "LU")
})
