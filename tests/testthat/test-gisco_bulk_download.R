test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  db <- gisco_get_latest_db(update_cache = TRUE)

  options(gisco_test_err = TRUE)
  expect_message(
    n <- gisco_bulk_download(update_cache = TRUE),
    "Error"
  )
  expect_null(n)

  options(gisco_test_err = FALSE)
})


test_that("Errors on bulk download", {
  expect_error(gisco_bulk_download(year = "2000"))
  expect_error(gisco_bulk_download(resolution = "35"))
  expect_error(gisco_bulk_download(id_giscoR = "nutes"))
  expect_error(gisco_bulk_download(ext = "aa"))
})

test_that("Bulk download online", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testthat", "bulk")
  if (dir.exists(cdir)) {
    unlink(cdir, force = TRUE, recursive = TRUE)
  }
  expect_silent(
    ss <- gisco_bulk_download(
      resolution = 60,
      cache_dir = cdir,
      ext = "shp"
    )
  )
  expect_silent(gisco_bulk_download(
    resolution = 60,
    cache_dir = cdir,
    ext = "geojson"
  ))
  expect_message(gisco_bulk_download(
    id_giscor = "urban_audit",
    year = 2018,
    cache_dir = cdir,
    ext = "shp"
  ))
  expect_silent(gisco_bulk_download(
    id_giscor = "urban_audit",
    cache_dir = cdir,
    year = 2004
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    cache_dir = cdir,
    verbose = TRUE
  ))
  expect_message(
    gisco_bulk_download(
      resolution = 60,
      verbose = TRUE,
      cache_dir = cdir,
      ext = "shp"
    )
  )
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    cache_dir = cdir,
    ext = "shp"
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    cache_dir = cdir,
    ext = "shp"
  ))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    update_cache = TRUE,
    cache_dir = cdir,
  ))
  expect_silent(
    gisco_bulk_download(
      resolution = 60,
      cache_dir = cdir,
      ext = "shp",
      recursive = TRUE
    )
  )
  expect_silent(
    gisco_bulk_download(
      resolution = 60,
      cache_dir = cdir,
      ext = "shp",
      recursive = FALSE
    )
  )
  expect_message(
    gisco_bulk_download(
      id_giscor = "countries",
      cache_dir = cdir,
      verbose = TRUE,
      resolution = 60
    )
  )

  expect_message(
    gisco_bulk_download(
      id_giscor = "postal_codes",
      cache_dir = cdir,
      verbose = TRUE,
      year = 2024,
      resolution = 60
    )
  )

  expect_message(
    gisco_bulk_download(
      id_giscor = "nuts",
      cache_dir = cdir,
      verbose = TRUE,
      year = 2024,
      resolution = 60
    )
  )

  if (dir.exists(cdir)) unlink(cdir, force = TRUE, recursive = TRUE)
})
