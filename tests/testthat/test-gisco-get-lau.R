test_that("offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(n <- gisco_get_lau(update_cache = TRUE, year = 2020), "Error")
  expect_null(n)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("LAU use resolved GISCO files", {
  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/LAU_RG_2024_4326.gpkg",
        name = "LAU_RG_2024_4326.gpkg"
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
                                  operator = "AND",
                                  ...) {
      expect_match(url, "LAU_RG_2024_4326[.]gpkg$")
      expect_identical(name, "LAU_RG_2024_4326.gpkg")
      expect_true(cache)
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "lau")
      expect_true(update_cache)
      expect_true(verbose)
      expect_true(is.function(filters))
      expect_identical(operator, "OR")
      data.frame(GISCO_ID = "ES_12016", name = "a")
    }
  )

  lau <- gisco_get_lau(
    gisco_id = "ES_12016",
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(lau$GISCO_ID, "ES_12016")
})

test_that("LAU Errors", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_error(gisco_get_lau(year = "2001"))
  expect_error(gisco_get_lau(epsg = "9999"))
})


test_that("LAU combines country and GISCO ID filters", {
  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/LAU_RG_2024_4326.gpkg",
        name = "LAU_RG_2024_4326.gpkg"
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
                                  operator = "AND",
                                  ...) {
      expect_identical(subdir, "lau")
      expect_identical(operator, "OR")
      expect_true(is.function(filters))
      data.frame(
        CNTR_CODE = c("LI", "ES"),
        GISCO_ID = c("LI_0101", "ES_12016")
      )
    }
  )

  lau <- gisco_get_lau(year = 2024, country = "LI", gisco_id = "ES_12016")
  expect_identical(lau$CNTR_CODE, c("LI", "ES"))
  expect_identical(lau$GISCO_ID, c("LI_0101", "ES_12016"))
})

test_that("Deprecations", {
  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/LAU_RG_2024_4326.gpkg",
        name = "LAU_RG_2024_4326.gpkg"
      )
    },
    read_gisco_dataset = function(...) {
      data.frame(GISCO_ID = "ES_12016", name = "a")
    }
  )

  expect_snapshot(
    s <- gisco_get_lau(year = 2024, cache = TRUE, gisco_id = "ES_12016")
  )
  expect_equal(nrow(s), 1)
  expect_equal(s$GISCO_ID, "ES_12016")
})

test_that("Extensions", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(gisco_get_lau(ext = "docx"), error = TRUE)

  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/LAU_RG_2020_4326.geojson",
        name = "LAU_RG_2020_4326.geojson"
      )
    },
    read_gisco_dataset = function(url, name, ...) {
      expect_match(url, "[.]geojson$")
      expect_identical(name, "LAU_RG_2020_4326.geojson")
      data.frame(CNTR_CODE = "LU", name = "a")
    }
  )
  lau <- gisco_get_lau(year = 2020, ext = "geojson", country = "LU")
  expect_identical(lau$CNTR_CODE, "LU")
})
