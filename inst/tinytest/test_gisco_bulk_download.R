library(tinytest)

expect_error(gisco_bulk_download(year = "2000"))
expect_error(gisco_bulk_download(resolution = "35"))
expect_error(gisco_bulk_download(what = "nutes"))
expect_error(gisco_bulk_download(ext = "aa"))
