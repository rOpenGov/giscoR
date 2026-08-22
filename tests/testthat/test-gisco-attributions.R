test_that("Attribution text is exposed as package data", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_attributions())
  expect_identical(class(gisco_attributions()), "character")
  expect_warning(
    fallback <- gisco_attributions("xxx"),
    class = "giscoR_warning_unsupported_language"
  )
  expect_identical(gisco_attributions("eN"), fallback)

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

test_that("Unsupported attribution languages warn with a package class", {
  expect_warning(
    fallback <- gisco_attributions("xx"),
    class = "giscoR_warning_unsupported_language"
  )

  expect_identical(fallback, gisco_attributions("en"))
})
