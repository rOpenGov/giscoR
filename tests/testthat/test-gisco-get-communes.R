test_that("offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_get_communes(update_cache = TRUE, spatialtype = "LB"),
    "Error"
  )
  expect_null(n)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Communes use resolved GISCO files", {
  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/COMM_RG_2016_4326.shp.zip",
        name = "COMM_RG_2016_4326.shp.zip"
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
      expect_match(url, "COMM_RG_2016_4326[.]shp[.]zip$")
      expect_identical(name, "COMM_RG_2016_4326.shp.zip")
      expect_true(cache)
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "communes")
      expect_true(update_cache)
      expect_true(verbose)
      expect_true(is.function(filters))
      data.frame(CNTR_CODE = c("ES", "FR"), name = c("a", "b"))
    }
  )

  communes <- gisco_get_communes(
    country = "ES",
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(communes$CNTR_CODE, c("ES", "FR"))
})


test_that("Communes errors", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_error(gisco_get_communes(year = "2007"))
  expect_error(gisco_get_communes(epsg = "9999"))
  expect_error(gisco_get_communes(year = "2004", spatialtype = "COASTL"))
  expect_error(gisco_get_communes(year = "2004", spatialtype = "INLAND"))
  expect_error(gisco_get_communes(spatialtype = "ERR"))
})

test_that("Communes pass country filters to the reader", {
  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/COMM_LB_2016_4326.gpkg",
        name = "COMM_LB_2016_4326.gpkg"
      )
    },
    read_gisco_dataset = function(url,
                                  name,
                                  filters = NULL,
                                  verbose = FALSE,
                                  ...) {
      expect_match(url, "COMM_LB_2016_4326[.]gpkg$")
      expect_true(is.function(filters))
      expect_true(verbose)
      data.frame(CNTR_CODE = "LU", name = "a")
    }
  )

  communes <- gisco_get_communes(
    spatialtype = "LB",
    country = "LU",
    verbose = TRUE
  )
  expect_identical(communes$CNTR_CODE, "LU")
})

test_that("Deprecations", {
  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/COMM_LB_2016_4326.gpkg",
        name = "COMM_LB_2016_4326.gpkg"
      )
    },
    read_gisco_dataset = function(...) {
      data.frame(CNTR_CODE = "LU", name = "a")
    }
  )

  expect_snapshot(s <- gisco_get_communes(cache = FALSE, spatialtype = "LB"))
})

test_that("Extensions", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(gisco_get_communes(ext = "docx"), error = TRUE)

  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/COMM_LB_2016_4326.geojson",
        name = "COMM_LB_2016_4326.geojson"
      )
    },
    read_gisco_dataset = function(url, name, ...) {
      expect_match(url, "[.]geojson$")
      expect_identical(name, "COMM_LB_2016_4326.geojson")
      data.frame(CNTR_CODE = "ES", name = "a")
    }
  )
  communes <- gisco_get_communes(ext = "geojson", country = "ES")
  expect_identical(communes$CNTR_CODE, "ES")
})
