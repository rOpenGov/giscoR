test_that("Errors on bulk download", {
  expect_error(gisco_bulk_download(year = "2000"))
  expect_error(gisco_bulk_download(resolution = "35"))
  expect_error(gisco_bulk_download(id_giscoR = "nutes"))
  expect_error(gisco_bulk_download(ext = "aa"))
})

test_that("Bulk download online", {
  skip_if_not(
    gisco_check_access(),
    "Skipping... GISCO not reachable."
  )

  expect_silent(gisco_bulk_download(resolution = 60))
  expect_silent(gisco_bulk_download(id_giscoR = "urban_audit", year = 2004))
  expect_message(gisco_bulk_download(resolution = 60, verbose = TRUE))
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    ext = "json"
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    ext = "shp"
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    ext = "shp"
  ))
  expect_silent(gisco_bulk_download(resolution = 60, update_cache = TRUE))
  expect_message(gisco_bulk_download(
    resolution = 60,
    ext = "shp",
    recursive = TRUE
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    ext = "shp",
    recursive = FALSE
  ))
  expect_message(gisco_bulk_download(
    id_giscoR = "countries",
    verbose = TRUE,
    resolution = 60
  ))
})
