test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })
  expect_message(n <- gisco_bulk_download(update_cache = TRUE), "No internet")
  expect_null(n)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
})

test_that("Test 404", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(n <- gisco_bulk_download(update_cache = TRUE), "Error")
  expect_null(n)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Deprecations", {
  skip_on_cran()
  skip_if_gisco_offline()
  cdir <- file.path(tempdir(), "testthat", "bulk")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }

  expect_snapshot(
    s <- gisco_bulk_download(
      id_giscoR = "coastal_lines",
      resolution = 60,
      cache_dir = cdir
    )
  )

  expect_message(
    s1 <- gisco_bulk_download(
      id = "coastal_lines",
      resolution = 60,
      cache_dir = cdir,
      verbose = TRUE
    )
  )
  expect_identical(s, s1)

  expect_snapshot(gisco_bulk_download(
    "nuts",
    resolution = 60,
    recursive = TRUE,
    cache_dir = cdir
  ))
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
})

test_that("Bulk download helpers build names and routes", {
  route <- paste0(
    gisco_distribution_url(),
    "countries/shp/CNTR_RG_60M_2024_4326.shp.zip"
  )
  expect_identical(
    bulk_download_api_entry(route),
    paste0(gisco_distribution_url(), "countries/download")
  )
  expect_identical(bulk_download_subdir("coastal_lines"), "coastal")
  expect_identical(bulk_download_subdir("countries"), "countries")

  expect_identical(
    build_bulk_zip_name("countries", "2024", 60, "geojson"),
    "ref-countries-2024-60m.geojson.zip"
  )
  expect_identical(
    build_bulk_zip_name("coastal_lines", "2016", 20, "shp"),
    "ref-coastline-2016-20m.shp.zip"
  )
  expect_identical(
    build_bulk_zip_name("urban_audit", "2021", "100", "json"),
    "ref-urau-2021-100k.json.zip"
  )
  expect_identical(
    build_bulk_zip_name("postal_codes", "2024", NULL, "shp"),
    "ref-pcode-2024.shp.zip"
  )
})

test_that("Bulk download orchestrates download and extraction", {
  cdir <- file.path(tempdir(), "testthat", "bulk-mock")
  unlink(cdir, force = TRUE, recursive = TRUE)

  local_mocked_bindings(
    get_url_db = function(...) {
      paste0(
        gisco_distribution_url(),
        "countries/shp/CNTR_RG_60M_2024_4326.shp.zip"
      )
    },
    download_url = function(
      url,
      name,
      cache_dir,
      subdir,
      update_cache = FALSE,
      verbose = FALSE
    ) {
      expect_match(url, "countries/download/ref-countries-2024-60m.geojson.zip")
      expect_identical(name, "ref-countries-2024-60m.geojson.zip")
      expect_identical(cache_dir, cdir)
      expect_identical(subdir, "countries")
      expect_true(update_cache)
      create_cache_dir(file.path(cache_dir, subdir))
      file.path(cache_dir, subdir, name)
    },
    list_bulk_zip_files = function(zipfile) {
      expect_match(zipfile, "ref-countries-2024-60m.geojson.zip$")
      data.frame(
        Name = c("country.geojson", "country.txt"),
        Length = c(1, 1)
      )
    },
    extract_bulk_zip_files = function(zipfile, files, exdir) {
      expect_identical(files, "country.geojson")
      file.create(file.path(exdir, files))
    }
  )

  out <- gisco_bulk_download(
    "countries",
    year = 2024,
    resolution = 60,
    ext = "geojson",
    cache_dir = cdir,
    update_cache = TRUE
  )
  expect_identical(basename(out), "country.geojson")
  expect_true(file.exists(out))
})

test_that("Errors", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_error(gisco_bulk_download(year = "2000"))
  expect_error(gisco_bulk_download(resolution = "35"))
  expect_snapshot(gisco_bulk_download(id_giscoR = "nutes"), error = TRUE)
  expect_error(gisco_bulk_download(ext = "aa"))
})

test_that("Online mocked", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(
    download_url = function(url = url, ...) {
      url <- basename(url)
      cli::cli_alert_info("Mocked {.str {url}}.")
      NULL
    }
  )

  cdir <- file.path(tempdir(), "testthat", "bulk")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }

  id <- c(
    "countries",
    "coastal_lines",
    "communes",
    "lau",
    "nuts",
    "urban_audit",
    "postal_codes"
  )

  for (iii in id) {
    y <- db_values(iii, "year", formatted = FALSE) |>
      sort() |>
      range()

    aa <- lapply(y, function(x) {
      expect_message(
        s <- gisco_bulk_download(
          iii,
          year = x,
          resolution = 20,
          cache_dir = cdir,
          ext = "shp"
        ),
        "shp.zip"
      )
    })
  }

  # Additional and extensions
  expect_message(
    gisco_bulk_download(
      "communes",
      year = 2004,
      ext = "svg",
      cache_dir = cdir
    ),
    "svg.zip"
  )

  expect_message(
    gisco_bulk_download(
      "countries",
      year = 2024,
      ext = "json",
      cache_dir = cdir,
      resolution = 60
    ),
    "json.zip"
  )

  expect_message(
    gisco_bulk_download(
      "countries",
      year = 2024,
      ext = "gdb",
      cache_dir = cdir,
      resolution = 60
    ),
    "gdb.zip"
  )
})
