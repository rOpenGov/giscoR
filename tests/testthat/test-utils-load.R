test_that("Caching tests", {
  skip_on_cran()
  skip_if_gisco_offline()

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "nuts/geojson/NUTS_LB_2016_4326_LEVL_0.geojson"
  )
  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_message(
    fend <- api_cache(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "Cache dir is"
  )

  expect_message(
    fend <- api_cache(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "File already"
  )

  expect_message(
    fend <- api_cache(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = TRUE,
      verbose = TRUE
    ),
    "Updating cached"
  )

  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Caching errors", {
  skip_on_cran()
  skip_if_gisco_offline()

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "fake-file.txt"
  )
  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_message(
    fend <- api_cache(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = FALSE
    ),
    "Error"
  )

  expect_null(fend)
  unlink(cdir, recursive = TRUE, force = TRUE)
})

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

  fake_local <- api_cache(
    url,
    basename(url),
    cdir,
    "fake",
    update_cache = FALSE,
    verbose = FALSE
  )

  s <- read_shp_zip(fake_local)

  expect_s3_class(s, "sf")
  expect_s3_class(s, "tbl_df")
  expect_true(file.exists(fake_local))
  unlink(cdir, recursive = TRUE, force = TRUE)
  expect_false(dir.exists(cdir))
})
