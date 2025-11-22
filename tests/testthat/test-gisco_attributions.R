test_that("Display cache dir", {
  d <- gsc_helper_detect_cache_dir()
  expect_equal(Sys.getenv("GISCO_CACHE_DIR"), d)
  cat("Cache dir on tests is\n", d)
})


test_that("Testing attributions", {
  skip_on_cran()

  expect_message(gisco_attributions(copyright = TRUE))
  expect_silent(gisco_attributions())
  expect_identical(class(gisco_attributions()), "character")
  expect_identical(gisco_attributions("eN"), gisco_attributions("xxx"))
  expect_snapshot_output(gisco_attributions("da"))
  expect_snapshot_output(gisco_attributions("de"))
  expect_snapshot_output(gisco_attributions("es"))
  expect_snapshot_output(gisco_attributions("FR"))
  expect_snapshot_output(gisco_attributions("fi"))
  expect_snapshot_output(gisco_attributions("no"))
  expect_snapshot_output(gisco_attributions("sv"))
  expect_snapshot_output(gisco_attributions("xx"))
})
