library(tinytest)

expect_error(gisco_bulk_download(year = "2000"))
expect_error(gisco_bulk_download(resolution = "35"))
expect_error(gisco_bulk_download(what = "nutes"))
expect_error(gisco_bulk_download(ext = "aa"))


if (gisco_check_access()) {
  expect_silent(gisco_bulk_download(resolution = 60))
  expect_message(gisco_bulk_download(resolution = 60, verbose = TRUE))
  expect_message(gisco_bulk_download(
    resolution = 60 ,
    verbose = TRUE,
    ext = "json"
  ))
  expect_message(gisco_bulk_download(
    resolution = 60 ,
    verbose = TRUE,
    ext = "shp"
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    ext = "shp"
  ))
  expect_silent(gisco_bulk_download(resolution = 60, update_cache = TRUE))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    ext = "shp",
    recursive = TRUE
  ))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    ext = "shp",
    recursive = FALSE
  ))
  expect_silent(gisco_bulk_download(
    id_giscoR = "countries",
    verbose = TRUE,
    resolution = 60
  ))
}
