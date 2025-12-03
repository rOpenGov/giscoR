test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_offline = TRUE)
  expect_message(
    n <- gisco_get_unit_country(
      year = 2024,
      unit = "ES",
      update_cache = TRUE,
      verbose = TRUE
    ),
    "Offline"
  )
  expect_null(n)
  options(gisco_test_offline = FALSE)
})

test_that("Test 404", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_404 = TRUE)
  expect_message(
    n <- gisco_get_unit_country(
      year = 2024,
      unit = "ES",
      update_cache = TRUE,
      verbose = TRUE
    ),
    "Error"
  )
  expect_null(n)
  options(gisco_test_404 = FALSE)
})

test_that("unit_country: Greece", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
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

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("unit_country: Caching", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  # Not caching
  expect_message(
    g <- gisco_get_unit_country(
      "ES",
      spatialtype = "LB",
      cache = FALSE,
      cache_dir = cdir,
      year = "2024",
      verbose = TRUE
    ),
    "Reading from"
  )

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  # And now caching
  expect_message(
    g <- gisco_get_unit_country(
      "ES",
      spatialtype = "LB",
      cache = TRUE,
      cache_dir = cdir,
      year = "2024",
      verbose = TRUE
    )
  )
  expect_length(
    list.files(cdir, recursive = TRUE),
    1
  )

  expect_message(
    g <- gisco_get_unit_country(
      "ES",
      spatialtype = "LB",
      cache = TRUE,
      cache_dir = cdir,
      year = "2024",
      verbose = TRUE
    ),
    "File already cached"
  )

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("unit_country: Multi calls", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }

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
  expect_true(all(g$ISO3_CODE == c("ESP", "DEU")))
  expect_true(all(sf::st_geometry_type(g) == "POINT"))

  # Polygon

  pol <- gisco_get_unit_country(
    c("Vatican City", "Andorra", "Monaco"),
    year = 2024,
    spatialtype = "RG",
    resolution = 60,
    cache_dir = cdir
  )
  expect_equal(nrow(pol), 3)
  expect_true(all(sf::st_geometry_type(pol) == "POLYGON"))

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("unit_country: Validate inputs", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(gisco_get_unit_country(year = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_country(epsg = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_country(resolution = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_country(spatialtype = "foo"), error = TRUE)
})
