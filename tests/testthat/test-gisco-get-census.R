test_that("Census returns NULL for 404 responses", {
  local_mocked_bindings(
    is_404 = function(...) {
      TRUE
    },
    read_gisco_dataset = function(...) {
      message("Error")
      NULL
    }
  )
  expect_snapshot(
    n <- gisco_get_census(update_cache = TRUE, spatialtype = "PT")
  )
  expect_null(n)
})

test_that("Census uses the legacy geodata reader", {
  local_mocked_bindings(read_gisco_dataset = function(
    url,
    cache_dir = NULL,
    subdir,
    update_cache = FALSE,
    verbose = FALSE,
    post_process = NULL,
    ...
  ) {
    expect_match(url, "CENSUS_UNITS_2011_RG_SH[.]zip$")
    expect_identical(cache_dir, "cache")
    expect_identical(subdir, "census")
    expect_true(update_cache)
    expect_true(verbose)
    expect_identical(post_process, transform_to_wgs84)
    data.frame(id = "RG")
  })

  census <- gisco_get_census(
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(census$id, "RG")
})

test_that("Census selects the point file", {
  local_mocked_bindings(read_gisco_dataset = function(url, ...) {
    expect_match(url, "CENSUS_UNITS_PT_2011_SH[.]zip$")
    data.frame(id = "PT")
  })

  census <- gisco_get_census(spatialtype = "PT")
  expect_identical(census$id, "PT")
})

test_that("Census reads point geometries", {
  expect_snapshot(gisco_get_census(year = 2020), error = TRUE)

  local_mocked_bindings(read_gisco_dataset = function(
    url,
    post_process = NULL,
    ...
  ) {
    expect_match(url, "CENSUS_UNITS_PT_2011_SH[.]zip$")
    data <- sf::st_as_sf(tibble::tibble(
      id = "PT",
      geometry = sf::st_sfc(sf::st_point(c(1, 1)), crs = 4326)
    ))
    post_process(data)
  })

  all <- expect_silent(gisco_get_census(spatialtype = "PT"))
  expect_s3_class(all, "tbl_df")
  expect_s3_class(all, "sf")
  expect_true(unique(sf::st_geometry_type(all)) == "POINT")
  expect_identical(sf::st_crs(all), sf::st_crs(4326))
})
test_that("Census reads polygon geometries", {
  local_mocked_bindings(read_gisco_dataset = function(
    url,
    post_process = NULL,
    verbose = FALSE,
    ...
  ) {
    expect_match(url, "CENSUS_UNITS_2011_RG_SH[.]zip$")
    expect_false(verbose)
    data <- sf::st_as_sf(tibble::tibble(
      id = "RG",
      geometry = sf::st_sfc(
        sf::st_multipolygon(list(list(rbind(
          c(0, 0),
          c(1, 0),
          c(1, 1),
          c(0, 0)
        )))),
        crs = 4326
      )
    ))
    message("Mocked census polygon read.")
    post_process(data)
  })

  # On read should warn
  expect_snapshot(all <- gisco_get_census(spatialtype = "RG"))
  expect_s3_class(all, "tbl_df")
  expect_s3_class(all, "sf")
  expect_true(unique(sf::st_geometry_type(all)) == "MULTIPOLYGON")
  expect_identical(sf::st_crs(all), sf::st_crs(4326))
})
