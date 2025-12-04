test_that("Testing attributions", {
  skip_on_cran()

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
