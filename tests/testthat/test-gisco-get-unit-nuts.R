test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_offline = TRUE)
  expect_message(
    n <- gisco_get_unit_nuts(
      year = 2024,
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
    n <- gisco_get_unit_nuts(
      year = 2024,
      update_cache = TRUE,
      verbose = TRUE
    ),
    "Error"
  )
  expect_null(n)
  options(gisco_test_404 = FALSE)
})

test_that("unit_nuts: ES416", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit_nuts")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
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
    expect_s3_class(gr, "sf")
    expect_s3_class(gr, "tbl_df")
  }

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("unit_nuts: Caching", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit_nuts")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

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

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

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
  expect_length(
    list.files(cdir, recursive = TRUE),
    1
  )

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

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("unit_nuts: Multi calls", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit_nuts")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }

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
  expect_true(all(g$CNTR_CODE == c("ES", "DE", "CZ")))
  expect_true(all(sf::st_geometry_type(g) == "POINT"))

  # Polygon

  pol <- gisco_get_unit_nuts(
    c("LU", "ITC", "SK010"),
    year = 2024,
    spatialtype = "RG",
    resolution = 60,
    cache_dir = cdir
  )
  expect_equal(nrow(pol), 3)
  expect_true(all(sf::st_geometry_type(pol) == "POLYGON"))

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("unit_nuts: Validate inputs", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(gisco_get_unit_nuts(year = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_nuts(epsg = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_nuts(resolution = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_nuts(spatialtype = "foo"), error = TRUE)
})

test_that("unit_nuts: Old tests", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_unit_nuts(unit = "ES"))

  dups <- expect_silent(gisco_get_unit_nuts(
    unit = c("ES", "IT", "ES"), resolution = 60, spatialtype = "LB"
  ))

  expect_equal(nrow(dups), 2)

  expect_silent(gisco_get_unit_nuts(
    year = 2016,
    unit = "PT",
    spatialtype = "LB", resolution = 60,
    update_cache = TRUE
  ))
  r <- gisco_get_unit_nuts(
    unit = c("FR", "ES", "xt", "PT"), resolution = 60,
    spatialtype = "LB"
  )

  expect_true(nrow(r) == 3)
  expect_message(gisco_get_unit_nuts(
    unit = c("FR", "ES", "xt", "PT"), spatialtype = "LB"
  ))

  expect_message(gisco_get_unit_nuts(verbose = TRUE))
  expect_message(gisco_get_unit_nuts(unit = c("ES1", "ES345", "FFRE3")))
  expect_silent(gisco_get_unit_nuts(
    year = "2016",
    update_cache = TRUE,
    unit = "ES"
  ))
})
