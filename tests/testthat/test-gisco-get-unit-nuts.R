test_that("NUTS unit returns NULL when offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_test_cached_db("unit-nuts-db-")

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })
  expect_snapshot(
    n <- gisco_get_unit_nuts(year = 2024, update_cache = TRUE, verbose = TRUE)
  )
  expect_null(n)
})

test_that("NUTS unit returns NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_test_cached_db("unit-nuts-db-")

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(
    n <- gisco_get_unit_nuts(year = 2024, update_cache = TRUE, verbose = TRUE)
  )
  expect_null(n)
})

test_that("NUTS unit reads ES416 for several spatial types", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("test-unit-nuts-")
  years <- db_values("nuts", "year", formatted = FALSE)

  for (y in years) {
    expect_silent(
      gr <- gisco_get_unit_nuts(
        unit = "ES416",
        spatialtype = "LB",
        cache_dir = cdir,
        year = y
      )
    )
    expect_identical(rev(names(gr))[1:2], c("geometry", "geo"))
    expect_s3_class(gr, "sf")
    expect_s3_class(gr, "tbl_df")
  }
})

test_that("NUTS unit returns matching data with and without cache", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("test-unit-nuts-")
  expect_identical(list.files(cdir, recursive = TRUE), character(0))

  # Not caching
  expect_message(
    g <- gisco_get_unit_nuts(
      "ES416",
      spatialtype = "LB",
      cache = FALSE,
      cache_dir = cdir,
      year = "2024",
      verbose = TRUE
    ),
    "Reading from"
  )
  expect_identical(rev(names(g))[1:2], c("geometry", "geo"))

  expect_identical(list.files(cdir, recursive = TRUE), character(0))

  # And now caching
  expect_message(
    g <- gisco_get_unit_nuts(
      "ES416",
      spatialtype = "LB",
      cache = TRUE,
      cache_dir = cdir,
      year = "2024",
      verbose = TRUE
    )
  )
  expect_identical(rev(names(g))[1:2], c("geometry", "geo"))

  expect_length(list.files(cdir, recursive = TRUE), 1)

  expect_message(
    g <- gisco_get_unit_nuts(
      "ES416",
      spatialtype = "LB",
      cache = TRUE,
      cache_dir = cdir,
      year = "2024",
      verbose = TRUE
    ),
    "File already cached"
  )
  expect_identical(rev(names(g))[1:2], c("geometry", "geo"))
})

test_that("NUTS unit supports multiple calls and units", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("test-unit-nuts-")

  # Message even when verbose FALSE
  expect_message(
    g <- gisco_get_unit_nuts(
      "XXXYY",
      spatialtype = "LB",
      cache = FALSE,
      cache_dir = cdir,
      year = "2016",
      verbose = FALSE
    ),
    "Skipping"
  )
  expect_null(g)

  # Several
  expect_message(
    g <- gisco_get_unit_nuts(
      c("XXX", "ES", "DE111", "CZ01"),
      spatialtype = "LB",
      cache = FALSE,
      cache_dir = cdir,
      year = "2016",
      verbose = FALSE
    ),
    "Skipping"
  )
  expect_equal(nrow(g), 3)
  expect_identical(g$CNTR_CODE, c("ES", "DE", "CZ"))
  expect_identical(as.character(sf::st_geometry_type(g)), rep("POINT", 3))

  # Polygon

  pol <- gisco_get_unit_nuts(
    c("LU", "ITC", "SK010"),
    year = 2024,
    spatialtype = "RG",
    resolution = 60,
    cache_dir = cdir
  )
  expect_equal(nrow(pol), 3)
  expect_identical(as.character(sf::st_geometry_type(pol)), rep("POLYGON", 3))
})

test_that("NUTS unit validates year, EPSG, resolution and spatial type", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(gisco_get_unit_nuts(year = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_nuts(epsg = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_nuts(resolution = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_nuts(spatialtype = "foo"), error = TRUE)
})
