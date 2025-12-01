test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_err = TRUE)
  expect_message(
    n <- gisco_bulk_download(update_cache = TRUE),
    "Error"
  )
  expect_null(n)

  options(gisco_test_err = FALSE)
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
      id_giscor = "coastal_lines",
      resolution = 60,
      cache_dir = cdir,
      verbose = TRUE
    )
  )
  expect_identical(s, s1)

  expect_snapshot(
    gisco_bulk_download(
      "nuts",
      resolution = 60,
      recursive = TRUE,
      cache_dir = cdir
    )
  )
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
})

test_that("Errors on bulk download", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_error(gisco_bulk_download(year = "2000"))
  expect_error(gisco_bulk_download(resolution = "35"))
  expect_snapshot(gisco_bulk_download(id_giscoR = "nutes"), error = TRUE)
  expect_error(gisco_bulk_download(ext = "aa"))
})

test_that("Bulk download online", {
  skip_on_cran()
  skip_if_gisco_offline()

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
    y <- for_docs(iii, "year", formatted = FALSE) |>
      sort() |>
      range()

    aa <- lapply(y, function(x) {
      s <- gisco_bulk_download(
        iii,
        year = x,
        resolution = 20,
        cache_dir = cdir,
        ext = "shp"
      )

      expect_true(all(file.exists(s)))
    })
  }

  # Additional and extensions
  ss <- gisco_bulk_download(
    "communes",
    year = 2004,
    ext = "svg",
    cache_dir = cdir
  )

  expect_true(all(file.exists(ss)))
  ss <- gisco_bulk_download(
    "countries",
    year = 2024,
    ext = "json",
    cache_dir = cdir,
    resolution = 60
  )
  expect_true(all(file.exists(ss)))
  ss <- gisco_bulk_download(
    "countries",
    year = 2024,
    ext = "gdb",
    cache_dir = cdir,
    resolution = 60
  )
  expect_true(all(file.exists(ss)))

  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
})
