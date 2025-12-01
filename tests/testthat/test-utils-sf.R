test_that("Read shp", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/countries/",
    "shp/CNTR_LB_2024_4326.shp.zip"
  )

  fake_local <- load_url(
    url,
    basename(url),
    cdir,
    "fake",
    update_cache = FALSE,
    verbose = FALSE
  )
  nm <- get_geo_file_colnames(fake_local)
  expect_identical(find_colname(fake_local), "CNTR_ID")
  expect_null(find_colname(fake_local, "A_FAKE_COL"))
  expect_true("geometry" %in% nm)
  expect_true("CNTR_ID" %in% nm)
  s <- read_geo_file_sf(fake_local)

  expect_s3_class(s, "sf")
  expect_s3_class(s, "tbl_df")
  expect_true(file.exists(fake_local))

  # With query
  sq <- read_geo_file_sf(
    fake_local,
    q = "SELECT * from \"CNTR_LB_2024_4326\" LIMIT 1"
  )
  expect_equal(sq, s[1, ])
  unlink(cdir, recursive = TRUE, force = TRUE)
  expect_false(dir.exists(cdir))
})

test_that("Read gpkg", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/countries/",
    "gpkg/CNTR_LB_2024_4326.gpkg"
  )

  fake_local <- load_url(
    url,
    basename(url),
    cdir,
    "fake",
    update_cache = FALSE,
    verbose = FALSE
  )

  nm <- get_geo_file_colnames(fake_local)
  expect_true("geometry" %in% nm)
  expect_true("CNTR_ID" %in% nm)
  s <- read_geo_file_sf(fake_local)

  expect_s3_class(s, "sf")
  expect_s3_class(s, "tbl_df")
  expect_true(file.exists(fake_local))

  # With query
  sq <- read_geo_file_sf(
    fake_local,
    q = "SELECT * from \"CNTR_LB_2024_4326.gpkg\" LIMIT 1"
  )
  expect_equal(sq, s[1, ])

  # Expect a message here with verbose being a large file > 20Mb
  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "urau/gpkg/URAU_RG_100K_2021_4326.gpkg"
  )

  file_local <- load_url(
    url,
    cache_dir = cdir,
    subdir = "fixme",
    verbose = FALSE
  )
  expect_message(af <- read_geo_file_sf(file_local), "Reading large file")
  # With query doesn't warn

  q <- paste0(
    "SELECT * from \"URAU_RG_100K_2021_4326.gpkg\" ",
    "WHERE CNTR_CODE IN ('LU')"
  )
  expect_silent(af <- read_geo_file_sf(file_local, q = q))

  # From url doesn't warn
  expect_silent(f2 <- read_geo_file_sf(url))

  unlink(cdir, recursive = TRUE, force = TRUE)
  expect_false(dir.exists(cdir))
})
