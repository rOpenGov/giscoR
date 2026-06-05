test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_get_census(update_cache = TRUE, spatialtype = "PT"),
    "Error"
  )
  expect_null(n)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Census uses the legacy geodata reader", {
  local_mocked_bindings(
    read_gisco_dataset = function(url,
                                  cache_dir = NULL,
                                  subdir,
                                  update_cache = FALSE,
                                  verbose = FALSE,
                                  post_process = NULL,
                                  ...) {
      expect_match(url, "CENSUS_UNITS_2011_RG_SH[.]zip$")
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "census")
      expect_true(update_cache)
      expect_true(verbose)
      expect_identical(post_process, transform_to_wgs84)
      data.frame(id = "RG")
    }
  )

  census <- gisco_get_census(
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(census$id, "RG")
})

test_that("Census selects the point file", {
  local_mocked_bindings(
    read_gisco_dataset = function(url, ...) {
      expect_match(url, "CENSUS_UNITS_PT_2011_SH[.]zip$")
      data.frame(id = "PT")
    }
  )

  census <- gisco_get_census(spatialtype = "PT")
  expect_identical(census$id, "PT")
})

test_that("Get Census POINT", {
  expect_error(gisco_get_census(year = 2020))

  skip_on_cran()
  skip_if_gisco_offline()

  all <- expect_silent(gisco_get_census(spatialtype = "PT"))
  expect_s3_class(all, "tbl_df")
  expect_s3_class(all, "sf")
  expect_true(unique(sf::st_geometry_type(all)) == "POINT")
  expect_identical(sf::st_crs(all), sf::st_crs(4326))
})
test_that("Get Census POLYGON", {
  skip_on_cran()
  skip_if_gisco_offline()

  # On read should warn
  expect_message(all <- gisco_get_census(spatialtype = "RG"))
  expect_s3_class(all, "tbl_df")
  expect_s3_class(all, "sf")
  expect_true(unique(sf::st_geometry_type(all)) == "MULTIPOLYGON")
  expect_identical(sf::st_crs(all), sf::st_crs(4326))
})
