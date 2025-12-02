test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_offline = TRUE)
  expect_message(
    n <- gisco_get_unit_urban_audit(
      year = 2021,
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
    n <- gisco_get_unit_urban_audit(
      year = 2021,
      update_cache = TRUE,
      verbose = TRUE
    ),
    "Error"
  )
  expect_null(n)
  options(gisco_test_404 = FALSE)
})

test_that("unit_urau: Several years", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit_urau")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
  years <- db_values("urban_audit", "year", formatted = FALSE)

  for (y in years) {
    db <- gisco_get_metadata("urban_audit", y)[1, 1]
    expect_silent(
      gr <- gisco_get_unit_urban_audit(
        unit = db[[1]],
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
test_that("unit_urau: Several years polygon", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit_urau")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
  years <- db_values("urban_audit", "year", formatted = FALSE)

  for (y in years) {
    db <- gisco_get_metadata("urban_audit", y)[1, 1]
    expect_silent(
      gr <- gisco_get_unit_urban_audit(
        unit = db[[1]],
        spatialtype = "RG",
        cache_dir = cdir,
        year = y
      )
    )
    expect_s3_class(gr, "sf")
    expect_s3_class(gr, "tbl_df")
  }

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("unit_urau: Caching", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit_urau")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  # Not caching
  expect_message(
    g <- gisco_get_unit_urban_audit(
      spatialtype = "LB",
      cache = FALSE,
      cache_dir = cdir,
      year = "2021",
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
    g <- gisco_get_unit_urban_audit(
      spatialtype = "LB",
      cache = TRUE,
      cache_dir = cdir,
      year = "2021",
      verbose = TRUE
    )
  )
  expect_length(
    list.files(cdir, recursive = TRUE),
    1
  )

  expect_message(
    g <- gisco_get_unit_urban_audit(
      spatialtype = "LB",
      cache = TRUE,
      cache_dir = cdir,
      year = "2021",
      verbose = TRUE
    ),
    "File already cached"
  )

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("unit_urau: Multi calls", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "test_unit_urau")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }

  # Message even when verbose FALSE
  expect_message(
    g <- gisco_get_unit_urban_audit(
      "XXXYY",
      spatialtype = "LB",
      cache = FALSE,
      cache_dir = cdir,
      year = "2001",
      verbose = FALSE
    ),
    "Skipping"
  )
  expect_null(g)

  # Several
  expect_message(
    g <- gisco_get_unit_urban_audit(
      c("XXX", "BE001C1", "RO001C1", "DE111", "FI001K2"),
      spatialtype = "LB",
      cache = FALSE,
      cache_dir = cdir,
      year = "2018",
      verbose = FALSE
    ),
    "Skipping"
  )
  expect_equal(nrow(g), 3)
  expect_true(all(g$CNTR_CODE == c("BE", "RO", "FI")))
  expect_true(all(sf::st_geometry_type(g) == "POINT"))

  # Polygon

  pol <- gisco_get_unit_urban_audit(
    c("XXX", "BE001C1", "RO001C1", "DE111", "FI001K2"),
    year = 2018,
    spatialtype = "RG",
    cache_dir = cdir
  )
  expect_equal(nrow(pol), 3)
  expect_true(all(sf::st_geometry_type(pol) == "MULTIPOLYGON"))

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("unit_urban_audit: Validate inputs", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(gisco_get_unit_urban_audit(year = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_urban_audit(epsg = -1989), error = TRUE)
  expect_snapshot(gisco_get_unit_urban_audit(spatialtype = "foo"), error = TRUE)
})
