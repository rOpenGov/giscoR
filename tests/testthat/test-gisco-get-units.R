test_that("Deprecate df mode", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(df1 <- gisco_get_units("nuts", year = 2016, mode = "df"))
  expect_identical(df1, gisco_get_metadata("nuts", 2016))
})

test_that("Deprecate nuts", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(
    df1 <- gisco_get_units(
      "nuts",
      unit = "ES416",
      year = 2016,
      spatialtype = "LB",
      cache = FALSE
    )
  )
  expect_identical(
    df1,
    gisco_get_unit_nuts(
      unit = "ES416",
      year = 2016,
      spatialtype = "LB",
      cache = FALSE
    )
  )
})

test_that("Deprecate country", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(
    df1 <- gisco_get_units(
      "countries",
      unit = "LU",
      year = 2016,
      spatialtype = "LB",
      cache = FALSE
    )
  )
  expect_identical(
    df1,
    gisco_get_unit_country(
      unit = "LU",
      year = 2016,
      cache = FALSE,
      spatialtype = "LB"
    )
  )
})

test_that("Deprecate urban audit", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(
    df1 <- gisco_get_units(
      "urban_audit",
      unit = "ES001F",
      year = 2021,
      spatialtype = "LB",
      cache = FALSE
    )
  )
  expect_identical(
    df1,
    gisco_get_unit_urban_audit(
      unit = "ES001F",
      year = 2021,
      spatialtype = "LB",
      cache = FALSE
    )
  )
})

test_that("Deprecated unit downloads forward the cache directory", {
  cdir <- local_test_cache_dir("deprecated-units-")
  local_mocked_bindings(gisco_get_unit_nuts = function(...) list(...))

  expect_warning(
    result <- gisco_get_units("nuts", cache_dir = cdir),
    class = "lifecycle_warning_deprecated"
  )

  expect_identical(result$cache_dir, cdir)
})
