test_that("Errors on bulk download", {
  expect_error(gisco_bulk_download(year = "2000"))
  expect_error(gisco_bulk_download(resolution = "35"))
  expect_error(gisco_bulk_download(id_giscoR = "nutes"))
  expect_error(gisco_bulk_download(ext = "aa"))
})

test_that("Bulk download online", {
  
  skip_if_gisco_offline()
  skip_on_cran()

  expect_silent(gisco_bulk_download(resolution = 60, cache_dir = tempdir()))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    cache_dir = tempdir(),
    ext = "shp"
  ))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    cache_dir = tempdir(),
    ext = "svg"
  ))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    cache_dir = tempdir(),
    ext = "json"
  ))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    cache_dir = tempdir(),
    ext = "gdb"
  ))
  expect_silent(gisco_bulk_download(
    id_giscoR = "urban_audit",
    cache_dir = tempdir(),
    year = 2004
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    cache_dir = tempdir(),
    verbose = TRUE
  ))
  expect_message(
    gisco_bulk_download(
      resolution = 60,
      verbose = TRUE,
      cache_dir = tempdir(),
      ext = "json"
    )
  )
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    cache_dir = tempdir(),
    ext = "shp"
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    cache_dir = tempdir(),
    ext = "shp"
  ))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    update_cache = TRUE,
    cache_dir = tempdir(),
  ))
  expect_silent(
    gisco_bulk_download(
      resolution = 60,
      cache_dir = tempdir(),
      ext = "shp",
      recursive = TRUE
    )
  )
  expect_silent(
    gisco_bulk_download(
      resolution = 60,
      cache_dir = tempdir(),
      ext = "shp",
      recursive = FALSE
    )
  )
  expect_message(
    gisco_bulk_download(
      id_giscoR = "countries",
      cache_dir = tempdir(),
      verbose = TRUE,
      resolution = 60
    )
  )
})
