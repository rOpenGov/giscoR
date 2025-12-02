test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_offline = TRUE)

  expect_snapshot(
    fend <- gisco_get_metadata()
  )
  expect_null(fend)

  options(gisco_test_offline = FALSE)
})

test_that("Test 404", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_404 = TRUE)
  expect_message(
    n <- gisco_get_metadata(),
    "Error"
  )
  expect_null(n)
  options(gisco_test_404 = FALSE)
})

test_that("Messages", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_message(
    n <- gisco_get_metadata(verbose = TRUE)
  )
  expect_s3_class(n, "tbl_df")
})

test_that("Errors", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(
    gisco_get_metadata("grids"),
    error = TRUE
  )

  expect_snapshot(
    gisco_get_metadata("urban_audit"),
    error = TRUE
  )
})


test_that("Check all nuts", {
  skip_on_cran()
  skip_if_gisco_offline()
  val_years <- db_values("nuts", "year", formatted = FALSE)
  for (i in val_years) {
    db <- gisco_get_metadata("nuts", i)
    expect_s3_class(db, "tbl_df")
  }
})

test_that("Check all countries", {
  skip_on_cran()
  skip_if_gisco_offline()
  val_years <- db_values("countries", "year", formatted = FALSE)
  for (i in val_years) {
    db <- gisco_get_metadata("countries", i)
    expect_s3_class(db, "tbl_df")
  }
})

test_that("Check all urban_audit", {
  skip_on_cran()
  skip_if_gisco_offline()
  val_years <- db_values("urban_audit", "year", formatted = FALSE)
  for (i in val_years) {
    db <- gisco_get_metadata("urban_audit", i)
    expect_s3_class(db, "tbl_df")
  }
})
