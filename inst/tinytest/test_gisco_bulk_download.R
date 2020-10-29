library(tinytest)

expect_error(gisco_bulk_download(year = "2000"))
expect_error(gisco_bulk_download(resolution = "35"))
expect_error(gisco_bulk_download(what = "nutes"))
expect_error(gisco_bulk_download(ext = "aa"))


if (gisco_check_access()) {
  expect_silent(gisco_bulk_download())
  expect_message(gisco_bulk_download(verbose = TRUE))
  expect_message(gisco_bulk_download(verbose = TRUE, ext = "shp"))
  expect_message(gisco_bulk_download(verbose = TRUE, ext = "shp"))
  expect_silent(gisco_bulk_download(update_cache = TRUE))
  expect_silent(gisco_bulk_download(ext = "shp", recursive = TRUE))
  expect_silent(gisco_bulk_download(id_giscoR = "countries", verbose = TRUE))
}
