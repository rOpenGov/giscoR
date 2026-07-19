test_that("#18 Cyprus in EU / Europe", {
  # https://github.com/rOpenGov/giscoR/issues/18
  cy_code <- convert_country_code("Cyprus")
  expect_false(cy_code %in% get_countrycodes_region(region = "Europe"))
  expect_true(cy_code %in% get_countrycodes_region(region = c("Europe", "EU")))
})

test_that("#62 geo column to NUTS", {
  # https://github.com/rOpenGov/giscoR/issues/62

  # Shipped dataset
  expect_equal(setdiff("geo", names(giscoR::gisco_nuts_2024)), character(0))

  skip_on_cran()
  skip_if_gisco_offline()

  # In default nuts call
  nuts2_data <- gisco_get_nuts()
  expect_equal(setdiff("geo", names(nuts2_data)), character(0))

  # In no cached data
  nuts0_nocache <- gisco_get_nuts(
    cache = FALSE,
    nuts_level = 0,
    resolution = 60,
    year = 2021,
    epsg = 3035,
    nuts_id = "LU",
    ext = "geojson"
  )

  expect_equal(setdiff("geo", names(nuts0_nocache)), character(0))

  # No cached LB
  nuts0_nocache_lb <- gisco_get_nuts(
    cache = FALSE,
    nuts_level = 0,
    resolution = 60,
    year = 2021,
    epsg = 3035,
    spatialtype = "LB",
    nuts_id = "LU"
  )

  expect_equal(setdiff("geo", names(nuts0_nocache_lb)), character(0))

  # Cache
  nuts0_cache <- gisco_get_nuts(
    nuts_level = 0,
    resolution = 60,
    year = 2021,
    epsg = 3035,
    nuts_id = "LU"
  )

  expect_equal(setdiff("geo", names(nuts0_cache)), character(0))

  nuts0_cache_lb <- gisco_get_nuts(
    nuts_level = 0,
    resolution = 60,
    year = 2021,
    epsg = 3035,
    spatialtype = "LB",
    nuts_id = "LU"
  )

  expect_equal(setdiff("geo", names(nuts0_cache_lb)), character(0))

  # Units

  # No cached
  u_nuts0_nocached <- gisco_get_unit_nuts(
    year = 2021,
    unit = "LU",
    cache = FALSE,
    resolution = 60
  )

  expect_equal(setdiff("geo", names(u_nuts0_nocached)), character(0))

  u_nuts0_nocached_lb <- gisco_get_unit_nuts(
    year = 2021,
    unit = "LU",
    cache = FALSE,
    spatialtype = "LB",
    resolution = 60
  )

  expect_equal(setdiff("geo", names(u_nuts0_nocached_lb)), character(0))

  # Cached
  u_nuts0_cached <- gisco_get_unit_nuts(
    year = 2021,
    unit = "LU",
    cache = TRUE,
    resolution = 60
  )

  expect_equal(setdiff("geo", names(u_nuts0_cached)), character(0))

  u_nuts0_cached_lb <- gisco_get_unit_nuts(
    year = 2021,
    unit = "LU",
    cache = TRUE,
    spatialtype = "LB",
    resolution = 60
  )

  expect_equal(setdiff("geo", names(u_nuts0_cached_lb)), character(0))
})
