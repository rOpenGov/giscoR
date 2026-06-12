test_that("GISCO URL helpers work", {
  expect_identical(
    gisco_services_url(),
    "https://gisco-services.ec.europa.eu"
  )
  expect_identical(
    gisco_distribution_url(),
    "https://gisco-services.ec.europa.eu/distribution/v2/"
  )
  expect_identical(
    gisco_id_url(),
    "https://gisco-services.ec.europa.eu/id/"
  )
  expect_identical(
    gisco_address_url(),
    "https://gisco-services.ec.europa.eu/addressapi/"
  )
  expect_identical(
    gisco_pub_url(),
    "https://gisco-services.ec.europa.eu/pub/"
  )
  expect_identical(
    eurostat_gisco_geodata_url("PORT_2013_SH.zip"),
    paste0(
      "https://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/",
      "PORT_2013_SH.zip"
    )
  )
})

test_that("Packaged dataset helper returns matching data", {
  data <- data.frame(x = 1:2)
  expect_null(read_packaged_gisco_dataset(
    filename = "other.gpkg",
    pattern = "CNTR_RG_20M_2024_4326.gpkg",
    data = data,
    data_name = "test_data"
  ))

  out <- read_packaged_gisco_dataset(
    filename = "CNTR_RG_20M_2024_4326.gpkg",
    pattern = "CNTR_RG_20M_2024_4326.gpkg",
    data = data,
    data_name = "test_data",
    post_process = function(x) x[1, , drop = FALSE]
  )
  expect_identical(out, data[1, , drop = FALSE])
})

test_that("GISCO file resolver returns URL and file name", {
  local_mocked_bindings(
    get_url_db = function(...) {
      "https://example.com/path/file.gpkg"
    }
  )

  file <- resolve_gisco_file("countries", year = 2024, fn = "test")
  expect_identical(file$url, "https://example.com/path/file.gpkg")
  expect_identical(file$name, "file.gpkg")
})

test_that("Request helper handles offline before performing", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)

  req <- gisco_request("https://example.com", cache = FALSE, retry = FALSE)
  expect_null(gisco_perform_request(
    req,
    "https://example.com",
    offline_verbose = FALSE
  ))
})

test_that("Dataset reader delegates cache and non-cache paths", {
  local_mocked_bindings(
    read_geo_file_sf = function(file_local, q = NULL, ...) {
      data.frame(source = file_local)
    },
    download_url = function(...) {
      "cached.gpkg"
    },
    read_geo_file_sf_filtered = function(file_local,
                                         filters = NULL,
                                         operator = "AND",
                                         verbose = FALSE) {
      data.frame(source = file_local, operator = operator)
    }
  )

  uncached <- read_gisco_dataset(
    "https://example.com/file.gpkg",
    cache = FALSE,
    subdir = "mock"
  )
  expect_identical(uncached$source, "https://example.com/file.gpkg")

  cached <- read_gisco_dataset(
    "https://example.com/file.gpkg",
    cache = TRUE,
    subdir = "mock",
    filters = list(CNTR_ID = "ES"),
    operator = "OR"
  )
  expect_identical(cached$source, "cached.gpkg")
  expect_identical(cached$operator, "OR")
})

test_that("JSON API helper returns requested field", {
  response <- list(results = data.frame(id = 1:2, name = c("a", "b")))
  local_mocked_bindings(
    get_request_body = function(url, verbose = FALSE) {
      expect_match(url, "q=test")
      structure(response, class = "mock_response")
    }
  )
  local_mocked_bindings(
    .package = "httr2",
    resp_body_json = function(resp, ...) {
      args <- list(...)
      expect_s3_class(resp, "mock_response")
      expect_true(args$simplifyVector)
      unclass(resp)
    }
  )

  result <- call_gisco_json_api(
    custom_query = list(q = "test"),
    apiurl = "https://example.com/search?",
    result_field = "results"
  )

  expect_s3_class(result, "tbl_df")
  expect_identical(result$id, 1:2)
})

test_that("JSON API helper returns NULL for missing responses", {
  local_mocked_bindings(
    get_request_body = function(...) NULL
  )

  expect_null(call_gisco_json_api(
    custom_query = list(q = "test"),
    apiurl = "https://example.com/search?",
    result_field = "results"
  ))
})

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
  expect_type(s, "character")
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
    "Cache directory is"
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
    "The file to download is"
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
    "results with these parameters"
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

  expect_snapshot(fend <- get_request_body(url, verbose = FALSE))
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

  expect_snapshot(fend <- get_request_body(url, verbose = FALSE))
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

  expect_message(fend <- get_request_body(url, verbose = TRUE), "GET")

  expect_s3_class(fend, "httr2_response")

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "themes_fake.json"
  )

  expect_message(fend <- get_request_body(url, verbose = TRUE), "GET")

  expect_null(fend)
})

test_that("Test import jsonlite with missing response", {
  local_mocked_bindings(
    get_request_body = function(...) NULL
  )

  expect_null(for_import_jsonlite())
})

test_that("Test import jsonlite with mocked response body", {
  local_mocked_bindings(
    get_request_body = function(url, verbose = FALSE) {
      expect_identical(
        url,
        "https://ropengov.github.io/giscoR/search.json"
      )
      expect_false(verbose)
      structure(list(), class = "mock_response")
    }
  )
  local_mocked_bindings(
    .package = "httr2",
    resp_body_string = function(resp) {
      expect_s3_class(resp, "mock_response")
      "{\"items\":[]}"
    }
  )

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
    "Failed to perform HTTP request(.*)Timeout(.*)after(.*)milliseconds"
  )

  withr::local_options(gisco_timeout = 300L)
  expect_silent(
    ff <- download_url(url = url, verbose = FALSE, cache_dir = cdir)
  )

  expect_true(file.exists(ff))
  unlink(cdir, recursive = TRUE, force = TRUE)
  expect_false(file.exists(ff))
})
