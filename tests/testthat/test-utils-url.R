test_that("No conexion", {
  skip_on_cran()
  skip_if_gisco_offline()
  options(gisco_test_off = TRUE)

  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/",
    "nuts/geojson/NUTS_LB_2016_4326_LEVL_0.geojson"
  )
  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_snapshot(
    fend <- load_url(
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

  options(gisco_test_off = FALSE)
})
test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  options(gisco_test_err = TRUE)
  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/countries/",
    "shp/CNTR_LB_2024_4326.shp.zip"
  )
  expect_message(
    s <- load_url(
      url,
      verbose = FALSE,
      cache_dir = cdir,
      update_cache = TRUE
    ),
    "Error "
  )
  expect_null(s)

  options(gisco_test_err = FALSE)

  # Otherwise work
  expect_silent(
    s <- load_url(
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
    fend <- load_url(
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
    fend <- load_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "File already"
  )

  expect_message(
    fend <- load_url(
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
    fend <- load_url(
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
    load_url(
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

  expect_snapshot(
    ss <- get_url_db("communes", "2016", fn = "gisco_get_communes")
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

  # Valid URL
  library(httr2)
  resp <- request(url) |>
    req_perform()
  expect_equal(resp_status(resp), 200)
})

test_that("Old tests", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_error(get_url_db(
    "urban_audit",
    year = 2020,
    spatialtype = "LB",
    level = "aaa",
    fn = "a_fun"
  ))

  expect_message(
    n <- load_url(
      "https://github.com/dieghernan/a_fake_thing_here",
      verbose = FALSE
    ),
    "404"
  )

  expect_null(n)
  expect_message(
    dwn <- get_url_db(
      "urban_audit",
      year = 2020,
      spatialtype = "LB",
      resolution = 20000,
      ext = "json",
      fn = "a_fun"
    )
  )

  expect_silent(load_url(dwn, update_cache = FALSE, verbose = FALSE))

  expect_message(get_url_db(
    "urban_audit",
    year = 2020,
    spatialtype = "LB",
    fn = "a_fun"
  ))
})
