test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_404 = TRUE)
  expect_message(
    n <- gisco_get_coastal_lines(
      update_cache = TRUE,
      resolution = 60
    ),
    "Error"
  )
  expect_null(n)
  options(gisco_test_404 = FALSE)
})


test_that("Errors", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(gisco_get_coastal_lines(ext = "docx"), error = TRUE)
})

test_that("Cached dataset vs updated", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testcoast")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )
  expect_snapshot(db_cached <- gisco_get_coastal_lines(verbose = TRUE))

  # Force download

  db_cached2 <- gisco_get_coastal_lines(
    update_cache = TRUE,
    cache_dir = cdir
  )

  expect_s3_class(db_cached, "sf")
  expect_s3_class(db_cached, "tbl_df")

  expect_identical(
    list.files(cdir, recursive = TRUE),
    "coastal/COAS_RG_20M_2016_4326.gpkg"
  )

  # Cleanup
  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Cache vs non-cached", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testcoast")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )
  expect_message(
    db_online <- gisco_get_coastal_lines(
      resolution = "60",
      cache = FALSE,
      verbose = TRUE,
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
    db_cached <- gisco_get_coastal_lines(
      resolution = "60",
      cache = TRUE,
      cache_dir = cdir
    )
  )

  expect_identical(db_online, db_cached)
  expect_s3_class(db_online, "sf")
  expect_s3_class(db_online, "tbl_df")
  expect_identical(
    list.files(cdir, recursive = TRUE),
    "coastal/COAS_RG_60M_2016_4326.gpkg"
  )

  # shp is always cached
  expect_length(list.files(cdir, recursive = TRUE, pattern = "shp"), 0)

  f <- gisco_get_coastal_lines(
    resolution = 60,
    cache_dir = cdir,
    ext = "shp",
    cache = FALSE
  )
  expect_length(list.files(cdir, recursive = TRUE, pattern = "shp"), 1)

  # Cleanup
  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Extensions", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testcoast")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  db_geojson <- gisco_get_coastal_lines(
    resolution = "60",
    cache_dir = cdir,
    ext = "geojson"
  )
  expect_s3_class(db_geojson, "sf")
  expect_s3_class(db_geojson, "tbl_df")

  expect_length(
    list.files(cdir, recursive = TRUE, pattern = "geojson"),
    1
  )

  db_zip <- gisco_get_coastal_lines(
    resolution = "60",
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


test_that("Coastal online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_coastallines(resolution = 3))
  expect_message(gisco_get_coastallines(
    resolution = 60,
    year = 2013,
    verbose = TRUE
  ))

  # Projections
  a <- gisco_get_coastal_lines(resolution = 60, epsg = 3035)
  b <- gisco_get_coastallines(resolution = 60, epsg = "3857")
  c <- gisco_get_coastallines(resolution = 60, epsg = "4326")

  epsg3035 <- sf::st_crs(3035)$epsg
  epsg3857 <- sf::st_crs(3857)$epsg
  epsg4326 <- sf::st_crs(4326)$epsg

  expect_identical(epsg3035, sf::st_crs(a)$epsg)
  expect_identical(epsg3857, sf::st_crs(b)$epsg)
  expect_identical(epsg4326, sf::st_crs(c)$epsg)
})
