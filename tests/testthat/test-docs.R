test_that("Check docs", {
  skip_on_cran()
  skip_if_gisco_offline()
  # Load databases now
  db <- gisco_get_cached_db()

  expect_snapshot(db_values("communes", "year"))
  expect_snapshot(db_values("communes", "year", decreasing = TRUE))
  expect_snapshot(db_values("communes", "ext"))
  expect_snapshot(db_values("communes", "spatialtype", formatted = FALSE))
})

test_that("Check GISCO ID docs", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(docs_id_years("nuts"))
  expect_snapshot(docs_id_years("riverbasin"))
})

test_that("GISCO ID docs handle unavailable API", {
  local_mocked_bindings(
    gisco_perform_request = function(...) NULL
  )

  expect_identical(docs_id_years("nuts"), "are unavailable")
})
