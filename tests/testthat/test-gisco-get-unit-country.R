test_that("Country unit returns NULL when offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_test_cached_db("unit-country-db-")

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })
  expect_snapshot(
    n <- gisco_get_unit_country(
      year = 2024,
      unit = "ES",
      update_cache = TRUE,
      verbose = TRUE
    )
  )
  expect_null(n)
})

test_that("Country unit returns NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_test_cached_db("unit-country-db-")

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(
    n <- gisco_get_unit_country(
      year = 2024,
      unit = "ES",
      update_cache = TRUE,
      verbose = TRUE
    )
  )
  expect_null(n)
})

test_that("Country unit reads Greece for several spatial types", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("test-unit-")
  years <- db_values("countries", "year", formatted = FALSE)

  for (y in years) {
    expect_silent(
      gr <- gisco_get_unit_country(
        unit = "Greece",
        spatialtype = "LB",
        cache_dir = cdir,
        year = y
      )
    )
    expect_s3_class(gr, "sf")
    expect_s3_class(gr, "tbl_df")
  }
})

test_that("Country unit returns matching data with and without cache", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("test-unit-")
  expect_identical(list.files(cdir, recursive = TRUE), character(0))

  # Not caching
  expect_message(
    g_online <- gisco_get_unit_country(
      "ES",
      spatialtype = "LB",
      cache = FALSE,
      cache_dir = cdir,
      year = "2024",
      verbose = TRUE
    ),
    "Reading from"
  )

  expect_identical(list.files(cdir, recursive = TRUE), character(0))

  # And now caching
  expect_message(
    g_cached <- gisco_get_unit_country(
      "ES",
      spatialtype = "LB",
      cache = TRUE,
      cache_dir = cdir,
      year = "2024",
      verbose = TRUE
    )
  )
  expect_length(list.files(cdir, recursive = TRUE), 1)
  expect_equal(g_cached, g_online)

  expect_message(
    g_reused <- gisco_get_unit_country(
      "ES",
      spatialtype = "LB",
      cache = TRUE,
      cache_dir = cdir,
      year = "2024",
      verbose = TRUE
    ),
    "File already cached"
  )
  expect_equal(g_reused, g_cached)
})

test_that("Country unit supports multiple calls and countries", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("test-unit-")

  # Message even when verbose FALSE
  expect_message(
    g <- gisco_get_unit_country(
      "Kosovo",
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
    g <- gisco_get_unit_country(
      c("Kosovo", "Spain", "Germany"),
      spatialtype = "LB",
      cache = FALSE,
      cache_dir = cdir,
      year = "2016",
      verbose = FALSE
    ),
    "Skipping"
  )
  expect_equal(nrow(g), 2)
  expect_identical(g$ISO3_CODE, c("ESP", "DEU"))
  expect_identical(as.character(sf::st_geometry_type(g)), rep("POINT", 2))

  # Polygon

  pol <- gisco_get_unit_country(
    c("Vatican City", "Andorra", "Monaco"),
    year = 2024,
    spatialtype = "RG",
    resolution = 60,
    cache_dir = cdir
  )
  expect_equal(nrow(pol), 3)
  expect_identical(as.character(sf::st_geometry_type(pol)), rep("POLYGON", 3))
})

test_that("Country unit validates year, EPSG, resolution and spatial type", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(gisco_get_unit_country(year = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_country(epsg = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_country(resolution = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_country(spatialtype = "foo"), error = TRUE)
})
