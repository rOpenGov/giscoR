test_that("Ports return NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(n <- gisco_get_ports(update_cache = TRUE))
  expect_null(n)
})

test_that("Ports use the legacy geodata reader", {
  local_mocked_bindings(read_gisco_dataset = function(
    url,
    cache_dir = NULL,
    subdir,
    update_cache = FALSE,
    verbose = FALSE,
    post_process = NULL,
    ...
  ) {
    expect_match(url, "PORT_2013_SH[.]zip$")
    expect_identical(cache_dir, "cache")
    expect_identical(subdir, "ports")
    expect_true(update_cache)
    expect_true(verbose)
    expect_identical(post_process, transform_to_wgs84)
    data.frame(PORT_ID = c("ESBCN", "FRABC"))
  })

  ports <- gisco_get_ports(
    country = "ES",
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(ports$PORT_ID, "ESBCN")
  expect_identical(ports$CNTR_ISO2, "ES")
})

test_that("Ports select the 2009 file", {
  local_mocked_bindings(read_gisco_dataset = function(url, ...) {
    expect_match(url, "PORT_2009_SH[.]zip$")
    data.frame(PORT_ID = "ESBCN")
  })

  ports <- gisco_get_ports(year = 2009)
  expect_identical(ports$CNTR_ISO2, "ES")
})

test_that("Ports download current and legacy point data", {
  expect_snapshot(gisco_get_ports(year = 2020), error = TRUE)
  expect_snapshot(gisco_get_ports(year = 2020, country = "ES"), error = TRUE)

  skip_on_cran()
  skip_if_gisco_offline()

  all <- expect_silent(gisco_get_ports())
  expect_true(all(sf::st_geometry_type(all) == "POINT"))

  expect_silent(gisco_get_ports())
  es <- expect_silent(gisco_get_ports(country = "ES"))
  expect_s3_class(es, "tbl_df")
  expect_s3_class(es, "sf")
  expect_true("CNTR_ISO2" %in% names(es))
  expect_lt(nrow(es), nrow(all))

  expect_identical(sf::st_crs(all), sf::st_crs(4326))

  expect_identical(sf::st_crs(es), sf::st_crs(4326))

  expect_identical(as.character(unique(es$CNTR_ISO2)), "ES")

  # 2009
  all <- expect_silent(gisco_get_ports(2009))
  expect_true(all(sf::st_geometry_type(all) == "POINT"))

  expect_silent(gisco_get_ports(2009))
  es <- expect_silent(gisco_get_ports(country = "ES"))
  expect_s3_class(es, "tbl_df")
  expect_s3_class(es, "sf")
  expect_true("CNTR_ISO2" %in% names(es))
  expect_lt(nrow(es), nrow(all))

  expect_identical(sf::st_crs(all), sf::st_crs(4326))

  expect_identical(sf::st_crs(es), sf::st_crs(4326))

  expect_identical(as.character(unique(es$CNTR_ISO2)), "ES")
})
