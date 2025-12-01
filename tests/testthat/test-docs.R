test_that("Check docs", {
  skip_on_cran()
  skip_if_gisco_offline()
  # Load databases now
  db <- gisco_get_latest_db()
  db <- gisco_get_latest_db_units()
  expect_snapshot(for_docs("communes", "year"))
  expect_snapshot(for_docs("communes", "year", decreasing = TRUE))
  expect_snapshot(for_docs("communes", "ext"))
  expect_snapshot(for_docs("communes", "spatialtype", formatted = FALSE))
})
