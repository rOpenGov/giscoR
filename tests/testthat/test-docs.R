test_that("Check docs", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(for_docs("communes", "year"))
  expect_snapshot(for_docs("communes", "year", decreasing = TRUE))
  expect_snapshot(for_docs("communes", "ext"))
  expect_snapshot(for_docs("communes", "spatialtype", formatted = FALSE))
})
