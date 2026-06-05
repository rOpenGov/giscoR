test_that("Error on postal codes", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_error(gisco_get_postal_codes("1991", "Years available for"))
})

test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_get_postal_codes(
      year = 2024,
      country = "ES",
      update_cache = TRUE
    ),
    "Error"
  )
  expect_null(n)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Postal codes use resolved GISCO files", {
  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/PCODE_PT_2024_4326.gpkg",
        name = "PCODE_PT_2024_4326.gpkg"
      )
    },
    read_gisco_dataset = function(url,
                                  name,
                                  cache = TRUE,
                                  cache_dir = NULL,
                                  subdir,
                                  update_cache = FALSE,
                                  verbose = FALSE,
                                  filters = NULL,
                                  ...) {
      expect_match(url, "PCODE_PT_2024_4326[.]gpkg$")
      expect_identical(name, "PCODE_PT_2024_4326.gpkg")
      expect_true(cache)
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "postal_codes")
      expect_true(update_cache)
      expect_true(verbose)
      expect_true(is.function(filters))
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
})
test_that("Extensions", {
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
