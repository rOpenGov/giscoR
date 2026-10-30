test_that("Dataset documentation includes current metadata", {
  skip_on_cran()
  skip_if_gisco_offline()
  # Load the databases.
  gisco_get_cached_db()

  expect_snapshot(db_values("communes", "year"))
  expect_snapshot(db_values("communes", "year", decreasing = TRUE))
  expect_snapshot(db_values("communes", "ext"))
  expect_snapshot(db_values("communes", "spatialtype", formatted = FALSE))
})
