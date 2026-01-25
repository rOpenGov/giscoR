test_that("Urban Audit offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_error(gisco_get_urban_audit(year = "1999"))
  expect_error(gisco_get_urban_audit(epsg = "9999"))
  expect_error(gisco_get_urban_audit(level = "9999"))
  expect_error(gisco_get_urban_audit(spatialtype = "BN"))
  expect_error(gisco_get_urban_audit(year = 2001))
})

test_that("Mock offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_get_urban_audit(
      update_cache = TRUE
    ),
    "Error"
  )
  expect_null(n)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})


test_that("Urban Audit online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_urban_audit(level = "CITIES"))
  fromurl <- expect_silent(gisco_get_urban_audit(
    level = "CITIES",
    cache = FALSE
  ))

  expect_s3_class(fromurl, "sf")
  expect_s3_class(fromurl, "tbl_df")

  expect_silent(gisco_get_urban_audit(level = "CITIES", spatialtype = "LB"))

  # Test CITIES vs GREATER_CITIES for regex
  a <- gisco_get_urban_audit(
    year = 2020,
    spatialtype = "LB",
    level = "CITIES"
  )
  b <- gisco_get_urban_audit(
    year = 2020,
    spatialtype = "LB",
    level = "GREATER_CITIES"
  )
  expect_false(nrow(a) == nrow(b))

  check <- expect_silent(
    gisco_get_urban_audit(
      level = "GREATER_CITIES",
      spatialtype = "LB",
      year = 2020,
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )

  expect_identical(sf::st_crs(check)$epsg, sf::st_crs(3857)$epsg)

  expect_length(
    setdiff(unique(check$CNTR_CODE), c("IT", "PL")),
    0
  )

  check <- expect_silent(
    gisco_get_urban_audit(
      year = 2014,
      spatialtype = "LB",
      level = "GREATER_CITIES",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )
  expect_identical(sf::st_crs(check)$epsg, sf::st_crs(3857)$epsg)

  expect_length(
    setdiff(unique(check$CNTR_CODE), c("IT", "PL")),
    0
  )

  check <- expect_silent(gisco_get_urban_audit(
    year = 2018,
    epsg = 3857,
    level = "GREATER_CITIES",
    country = c("ITA", "POL")
  ))

  expect_identical(sf::st_crs(check)$epsg, sf::st_crs(3857)$epsg)

  expect_length(
    setdiff(unique(check$CNTR_CODE), c("IT", "PL")),
    0
  )

  expect_message(
    gisco_get_urban_audit(
      year = 2018,
      spatialtype = "LB",
      epsg = 3857,
      country = c("ITA", "POL"),
      verbose = TRUE
    )
  )

  check <- expect_silent(
    gisco_get_urban_audit(
      year = 2020,
      spatialtype = "LB",
      level = "GREATER_CITIES",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )

  expect_identical(sf::st_crs(check)$epsg, sf::st_crs(3857)$epsg)

  expect_length(
    setdiff(unique(check$CNTR_CODE), c("IT", "PL")),
    0
  )
})

test_that("Test inputs", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(gisco_get_urban_audit(ext = "docx"), error = TRUE)
  expect_snapshot(gisco_get_urban_audit(level = "docx"), error = TRUE)

  # NULL is working
  db_null <- gisco_get_urban_audit(country = "LU", level = NULL)
  db_all <- gisco_get_urban_audit(country = "LU", level = "all")
  expect_identical(db_null, db_all)
})

test_that("Cache vs non-cached", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testurbanaudit")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )
  expect_message(
    db_online <- gisco_get_urban_audit(
      level = "CITIES",
      cache = FALSE,
      verbose = TRUE,
      country = "LU",
      cache_dir = cdir
    ),
    "Reading from"
  )

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  # vs cache TRUE
  expect_silent(
    db_cached <- gisco_get_urban_audit(
      level = "CITIES",
      cache = TRUE,
      verbose = FALSE,
      country = "LU",
      cache_dir = cdir
    )
  )

  expect_identical(db_online$URAU_CODE, db_cached$URAU_CODE)
  expect_s3_class(db_online, "sf")
  expect_s3_class(db_online, "tbl_df")
  expect_identical(
    list.files(cdir, recursive = TRUE),
    "urban_audit/URAU_RG_100K_2024_4326_CITIES.gpkg"
  )

  # shp is always cached
  expect_length(list.files(cdir, recursive = TRUE, pattern = "shp"), 0)

  f <- gisco_get_urban_audit(
    cache_dir = cdir,
    ext = "shp",
    country = "LU",
    cache = FALSE
  )
  expect_length(list.files(cdir, recursive = TRUE, pattern = "shp"), 1)

  # Cleanup
  unlink(cdir, recursive = TRUE, force = TRUE)
})
test_that("Extensions", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testurbanaudit")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  db_geojson <- gisco_get_urban_audit(
    cache_dir = cdir,
    ext = "geojson",
    spatialtype = "LB"
  )
  expect_s3_class(db_geojson, "sf")
  expect_s3_class(db_geojson, "tbl_df")

  expect_length(
    list.files(cdir, recursive = TRUE, pattern = "geojson"),
    1
  )

  db_zip <- gisco_get_urban_audit(
    spatialtype = "LB",
    cache_dir = cdir,
    verbose = TRUE,
    ext = "shp"
  )

  expect_s3_class(db_zip, "sf")
  expect_s3_class(db_zip, "tbl_df")

  expect_length(
    list.files(cdir, recursive = TRUE, pattern = "shp.zip"),
    1
  )

  # Cleanup
  unlink(cdir, recursive = TRUE, force = TRUE)
})
