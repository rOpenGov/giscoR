test_that("No conexion", {
  skip_on_cran()
  skip_if_gisco_offline()
  db <- gisco_get_latest_db(update_cache = TRUE)

  options(gisco_test_off = TRUE)

  expect_snapshot(
    fend <- gisco_get_metadata()
  )
  expect_null(fend)

  options(gisco_test_off = FALSE)
})

test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_err = TRUE)
  expect_message(
    n <- gisco_get_metadata(),
    "Error"
  )
  expect_null(n)
  options(gisco_test_err = FALSE)
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
  val_years <- for_docs("nuts", "year", formatted = FALSE)
  for (i in val_years) {
    db <- gisco_get_metadata("nuts", i)
    expect_s3_class(db, "tbl_df")
  }
})

test_that("Check all countries", {
  skip_on_cran()
  skip_if_gisco_offline()
  val_years <- for_docs("countries", "year", formatted = FALSE)
  for (i in val_years) {
    db <- gisco_get_metadata("countries", i)
    expect_s3_class(db, "tbl_df")
  }
})

test_that("Check all urban_audit", {
  skip_on_cran()
  skip_if_gisco_offline()
  val_years <- for_docs("urban_audit", "year", formatted = FALSE)
  for (i in val_years) {
    db <- gisco_get_metadata("urban_audit", i)
    expect_s3_class(db, "tbl_df")
  }
})
