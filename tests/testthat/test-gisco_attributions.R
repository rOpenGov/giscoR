test_that("Display cache dir", {
  d <- gsc_helper_detect_cache_dir()
  expect_equal(Sys.getenv("GISCO_CACHE_DIR"), d)
  cat("Cache dir on tests is\n", d)
})




test_that("Testing attributions", {
  expect_message(gisco_attributions(copyright = TRUE))
  expect_silent(gisco_attributions())
  expect_identical(class(gisco_attributions()), "character")
  expect_identical(gisco_attributions("eN"), gisco_attributions("xxx"))
  expect_identical(class(gisco_attributions("da")), "character")
  expect_identical(class(gisco_attributions("de")), "character")
  expect_identical(class(gisco_attributions("es")), "character")
  expect_identical(class(gisco_attributions("FR")), "character")
  expect_identical(class(gisco_attributions("fi")), "character")
  expect_identical(class(gisco_attributions("no")), "character")
  expect_identical(class(gisco_attributions("sv")), "character")
})
