test_that("Attribution text is exposed as package data", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_attributions())
  expect_identical(class(gisco_attributions()), "character")
  expect_identical(gisco_attributions("eN"), gisco_attributions("xxx"))

  expect_snapshot(gisco_attributions(copyright = TRUE))
  expect_snapshot(gisco_attributions("da"))
  expect_snapshot(gisco_attributions("de"))
  expect_snapshot(gisco_attributions("es"))
  expect_snapshot(gisco_attributions("FR"))
  expect_snapshot(gisco_attributions("fi"))
  expect_snapshot(gisco_attributions("no"))
  expect_snapshot(gisco_attributions("sv"))
  expect_snapshot(gisco_attributions("xx"))
})
