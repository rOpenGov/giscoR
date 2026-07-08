test_that("Airports return NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(n <- gisco_get_airports(update_cache = TRUE), "Error")
  expect_null(n)
})

test_that("Airports use the legacy geodata reader", {
  local_mocked_bindings(read_gisco_dataset = function(
    url,
    cache_dir = NULL,
    subdir,
    update_cache = FALSE,
    verbose = FALSE,
    post_process = NULL,
    ...
  ) {
    expect_match(url, "Airports-2013-SHP[.]zip$")
    expect_identical(cache_dir, "cache")
    expect_identical(subdir, "airports")
    expect_true(update_cache)
    expect_true(verbose)
    expect_identical(post_process, transform_to_wgs84)
    data.frame(CNTR_CODE = c("ES", "FR"), name = c("a", "b"))
  })

  airports <- gisco_get_airports(
    country = "ES",
    year = 2013,
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(airports$CNTR_CODE, "ES")
})

test_that("Airports select the 2006 file", {
  local_mocked_bindings(read_gisco_dataset = function(url, ...) {
    expect_match(url, "AIRP_SH[.]zip$")
    data.frame(CNTR_CODE = "ES", name = "a")
  })

  airports <- gisco_get_airports(year = 2006)
  expect_identical(airports$CNTR_CODE, "ES")
})

test_that("Airports download current and legacy point data", {
  expect_error(gisco_get_airports(year = 2020), "`year` must be")

  skip_on_cran()
  skip_if_gisco_offline()

  all <- expect_silent(gisco_get_airports())
  es <- expect_silent(gisco_get_airports(country = "ES"))
  expect_true(all(sf::st_geometry_type(all) == "POINT"))
  expect_s3_class(es, "tbl_df")
  expect_s3_class(es, "sf")
  expect_lt(nrow(es), nrow(all))
  expect_identical(sf::st_crs(all), sf::st_crs(4326))

  expect_identical(sf::st_crs(es), sf::st_crs(4326))

  expect_identical(as.character(unique(es$CNTR_CODE)), "ES")
  expect_true(nrow(all) > nrow(es))

  # 2006

  all <- expect_silent(gisco_get_airports(2006))
  expect_true(all(sf::st_geometry_type(all) == "POINT"))

  es <- expect_silent(gisco_get_airports(2006, country = "ES"))
  expect_s3_class(es, "tbl_df")
  expect_s3_class(es, "sf")
  expect_lt(nrow(es), nrow(all))
  expect_identical(sf::st_crs(all), sf::st_crs(4326))

  expect_identical(sf::st_crs(es), sf::st_crs(4326))

  expect_identical(as.character(unique(es$CNTR_CODE)), "ES")
  expect_true(nrow(all) > nrow(es))
})
