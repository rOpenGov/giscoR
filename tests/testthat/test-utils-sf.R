test_that("Read shp", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  url <- paste0(
    "https://gisco-services.ec.europa.eu/distribution/v2/countries/",
    "shp/CNTR_LB_2024_4326.shp.zip"
  )

  fake_local <- load_url(
    url,
    basename(url),
    cdir,
    "fake",
    update_cache = FALSE,
    verbose = FALSE
  )

  s <- read_shp_zip(fake_local)

  expect_s3_class(s, "sf")
  expect_s3_class(s, "tbl_df")
  expect_true(file.exists(fake_local))

  # With query
  sq <- read_shp_zip(
    fake_local,
    q = "SELECT * from \"CNTR_LB_2024_4326\" LIMIT 1"
  )
  expect_equal(sq, s[1, ])
  unlink(cdir, recursive = TRUE, force = TRUE)
  expect_false(dir.exists(cdir))
})
