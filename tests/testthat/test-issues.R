test_that("#18 Cyprus in EU / Europe", {
  # https://github.com/rOpenGov/giscoR/issues/18
  cy_code <- convert_country_code("Cyprus")
  expect_false(cy_code %in% get_countrycodes_region(region = "Europe"))
  expect_true(cy_code %in% get_countrycodes_region(region = c("Europe", "EU")))
})


test_that("#62 geo column to NUTS", {
  # https://github.com/rOpenGov/giscoR/issues/62

  # Shipped dataset
  expect_true("geo" %in% names(giscoR::gisco_nuts_2024))

  skip_on_cran()
  skip_if_gisco_offline()

  # In default nuts call
  nuts2_data <- gisco_get_nuts()
  expect_true("geo" %in% names(nuts2_data))

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

  expect_true("geo" %in% names(nuts0_nocache))

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

  expect_true("geo" %in% names(nuts0_nocache_lb))

  # Cache
  nuts0_cache <- gisco_get_nuts(
    nuts_level = 0,
    resolution = 60,
    year = 2021,
    epsg = 3035,
    nuts_id = "LU"
  )

  expect_true("geo" %in% names(nuts0_cache))

  nuts0_cache_lb <- gisco_get_nuts(
    nuts_level = 0,
    resolution = 60,
    year = 2021,
    epsg = 3035,
    spatialtype = "LB",
    nuts_id = "LU"
  )

  expect_true("geo" %in% names(nuts0_cache_lb))

  # Units

  # No cached
  u_nuts0_nocached <- gisco_get_unit_nuts(
    year = 2021,
    unit = "LU",
    cache = FALSE,
    resolution = 60
  )

  expect_true("geo" %in% names(u_nuts0_nocached))

  u_nuts0_nocached_lb <- gisco_get_unit_nuts(
    year = 2021,
    unit = "LU",
    cache = FALSE,
    spatialtype = "LB",
    resolution = 60
  )

  expect_true("geo" %in% names(u_nuts0_nocached_lb))

  # Cached
  u_nuts0_cached <- gisco_get_unit_nuts(
    year = 2021,
    unit = "LU",
    cache = TRUE,
    resolution = 60
  )

  expect_true("geo" %in% names(u_nuts0_cached))

  u_nuts0_cached_lb <- gisco_get_unit_nuts(
    year = 2021,
    unit = "LU",
    cache = TRUE,
    spatialtype = "LB",
    resolution = 60
  )

  expect_true("geo" %in% names(u_nuts0_cached_lb))
})
