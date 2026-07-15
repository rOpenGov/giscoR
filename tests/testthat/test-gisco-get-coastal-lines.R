test_that("Coastal lines return NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_test_cached_db("coastal-db-")

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(
    n <- gisco_get_coastal_lines(update_cache = TRUE, resolution = 60)
  )
  expect_null(n)
})

test_that("Coastal lines use resolved GISCO files", {
  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/COAS_RG_20M_2016_4326.gpkg",
        name = "COAS_RG_20M_2016_4326.gpkg"
      )
    },
    read_packaged_gisco_dataset = function(...) NULL,
    read_gisco_dataset = function(url,
                                  name,
                                  cache = TRUE,
                                  cache_dir = NULL,
                                  subdir,
                                  update_cache = FALSE,
                                  verbose = FALSE,
                                  ...) {
      expect_match(url, "COAS_RG_20M_2016_4326[.]gpkg$")
      expect_identical(name, "COAS_RG_20M_2016_4326.gpkg")
      expect_false(cache)
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "coastal")
      expect_true(update_cache)
      expect_true(verbose)
      data.frame(id = 1, name = "coast")
    }
  )

  coast <- gisco_get_coastal_lines(
    cache = FALSE,
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(coast$id, 1)
})

test_that("Coastal lines validate unsupported extensions", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(gisco_get_coastal_lines(ext = "docx"), error = TRUE)
})

test_that("Coastal lines can refresh an existing cached dataset", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("testcoast-")

  expect_identical(list.files(cdir, recursive = TRUE), character(0))
  expect_snapshot(db_cached <- gisco_get_coastal_lines(verbose = TRUE))

  # Force download

  db_cached2 <- gisco_get_coastal_lines(update_cache = TRUE, cache_dir = cdir)

  expect_s3_class(db_cached, "sf")
  expect_s3_class(db_cached, "tbl_df")

  expect_identical(
    list.files(cdir, recursive = TRUE),
    "coastal/COAS_RG_20M_2016_4326.gpkg"
  )
})

test_that("Coastal lines return matching data with and without cache", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("testcoast-")

  expect_identical(list.files(cdir, recursive = TRUE), character(0))
  expect_message(
    db_online <- gisco_get_coastal_lines(
      resolution = "60",
      cache = FALSE,
      verbose = TRUE,
      cache_dir = cdir
    ),
    "Reading from"
  )

  expect_identical(list.files(cdir, recursive = TRUE), character(0))

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
})

test_that("Coastal lines support GeoJSON and zipped shapefile downloads", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("testcoast-")

  expect_identical(list.files(cdir, recursive = TRUE), character(0))

  db_geojson <- gisco_get_coastal_lines(
    resolution = "60",
    cache_dir = cdir,
    ext = "geojson"
  )
  expect_s3_class(db_geojson, "sf")
  expect_s3_class(db_geojson, "tbl_df")

  expect_length(list.files(cdir, recursive = TRUE, pattern = "geojson"), 1)

  db_zip <- gisco_get_coastal_lines(
    resolution = "60",
    cache_dir = cdir,
    verbose = TRUE,
    ext = "shp"
  )

  expect_s3_class(db_zip, "sf")
  expect_s3_class(db_zip, "tbl_df")

  expect_length(list.files(cdir, recursive = TRUE, pattern = "shp.zip"), 1)
})

test_that("Coastal lines keep deprecated alias behavior online", {
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
