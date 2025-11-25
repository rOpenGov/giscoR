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
