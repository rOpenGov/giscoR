test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "nuts/geojson/NUTS_LB_2016_4326_LEVL_0.geojson"
  )
  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_snapshot(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = FALSE
    )
  )
  expect_null(fend)
  expect_length(list.files(cdir, recursive = TRUE), 0)
  unlink(cdir, recursive = TRUE, force = TRUE)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Test 404", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/countries/",
    "shp/CNTR_LB_2024_4326.shp.zip"
  )
  expect_message(
    s <- download_url(
      url,
      verbose = FALSE,
      cache_dir = cdir,
      update_cache = TRUE
    ),
    "Error "
  )
  expect_null(s)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })

  # Otherwise work
  expect_silent(
    s <- download_url(
      url,
      verbose = FALSE,
      cache_dir = cdir,
      update_cache = TRUE
    )
  )
  expect_length(s, 1)
  expect_true(is.character(s))
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})


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
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "Cache dir is"
  )

  expect_length(list.files(cdir, recursive = TRUE), 1)

  expect_message(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "File already"
  )

  expect_message(
    fend <- download_url(
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
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = FALSE
    ),
    "Error"
  )

  expect_null(fend)

  # Warn if size of download is huge

  url <- get_url_db("lau", ext = "gpkg", year = 2024, fn = "a_fun")

  expect_message(
    download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = FALSE
    ),
    "The file to be downloaded has size"
  )

  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Get urls", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_error(get_url_db(
    "postal_codes",
    year = "1991",
    fn = "gisco_get_postalcodes"
  ))

  expect_snapshot(
    get_url_db("communes", "9999", fn = "gisco_get_communes"),
    error = TRUE
  )

  expect_snapshot(
    get_url_db(
      "communes",
      "2016",
      epsg = "1111",
      ext = "csv",
      fn = "gisco_get_communes"
    ),
    error = TRUE
  )

  ss1 <- get_url_db("nuts", "2016", resolution = 20, fn = "gisco_get_communes")
  ss2 <- get_url_db(
    "nuts",
    "2016",
    resolution = "20",
    fn = "gisco_get_communes"
  )
  expect_identical(ss1, ss2)

  expect_message(
    ss <- get_url_db("communes", "2016", fn = "gisco_get_communes"),
    "results with params"
  )
  expect_type(ss, "character")

  expect_silent(
    url <- get_url_db(
      "nuts",
      "2024",
      epsg = 4326,
      ext = "gpkg",
      nuts_level = "all",
      spatialtype = "RG",
      resolution = "60",
      fn = "gisco_get_communes"
    )
  )

  # Valid URL with HEAD
  req <- httr2::request(url)
  req <- httr2::req_method(req, "HEAD")
  resp <- httr2::req_perform(req)
  expect_equal(httr2::resp_status(resp), 200)

  # Try with label
  expect_silent(
    url_lb <- get_url_db(
      "nuts",
      "2024",
      epsg = 4326,
      ext = "gpkg",
      nuts_level = "all",
      spatialtype = "LB",
      resolution = "60",
      fn = "gisco_get_communes"
    )
  )

  # Valid URL with HEAD
  req <- httr2::request(url_lb)
  req <- httr2::req_method(req, "HEAD")
  resp <- httr2::req_perform(req)
  expect_equal(httr2::resp_status(resp), 200)
})

test_that("No connection body", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "themes.json"
  )

  expect_snapshot(
    fend <- get_request_body(url, verbose = FALSE)
  )
  expect_null(fend)
  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Error body", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "themes.json"
  )

  expect_snapshot(
    fend <- get_request_body(url, verbose = FALSE)
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})


test_that("Tests body", {
  skip_on_cran()
  skip_if_gisco_offline()

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "themes.json"
  )

  expect_message(
    fend <- get_request_body(url, verbose = TRUE),
    "GET"
  )

  expect_s3_class(fend, "httr2_response")

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "themes_fake.json"
  )

  expect_message(
    fend <- get_request_body(url, verbose = TRUE),
    "GET"
  )

  expect_null(fend)
})

test_that("Test import jsonlite", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(p <- for_import_jsonlite())
  expect_null(for_import_jsonlite())
})

test_that("Test timeout", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testthat_timeout")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "countries/geojson/CNTR_BN_20M_2020_4326.geojson"
  )

  withr::local_options(gisco_timeout = 0.01)
  expect_error(
    download_url(url = url, verbose = FALSE, cache_dir = cdir),
    "Failed to perform HTTP request(.*)Timeout(.*)after 10 milliseconds"
  )

  withr::local_options(gisco_timeout = 300L)
  expect_silent(
    ff <- download_url(url = url, verbose = FALSE, cache_dir = cdir)
  )

  expect_true(file.exists(ff))
  unlink(cdir, recursive = TRUE, force = TRUE)
  expect_false(file.exists(ff))
})
