test_that("Metadata returns NULL when offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(fend <- gisco_get_metadata())
  expect_null(fend)
})

test_that("Metadata returns NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(n <- gisco_get_metadata(), "Error")
  expect_null(n)
})

test_that("Metadata helpers build URL and read CSV", {
  db <- data.frame(
    id_giscor = c("countries", "countries"),
    year = c("2024", "2024"),
    ext = c("csv", "gpkg"),
    api_entry = c("https://example.com/csv", "https://example.com/gpkg"),
    api_file = c("CNTR_AT_2024.csv", "CNTR_RG_2024.gpkg")
  )
  expect_identical(
    metadata_url("countries", "2024", db),
    "https://example.com/csv/CNTR_AT_2024.csv"
  )

  csv_file <- tempfile(fileext = ".csv")
  write.csv(
    data.frame(id = "ES", name = "Spain"),
    csv_file,
    row.names = FALSE,
    fileEncoding = "UTF-8"
  )
  metadata <- read_metadata_csv(csv_file)
  expect_s3_class(metadata, "tbl_df")
  expect_identical(metadata$id, "ES")
})

test_that("Metadata downloads to the metadata cache", {
  local_mocked_bindings(download_url = function(
    url,
    name,
    cache_dir,
    subdir,
    verbose = FALSE,
    ...
  ) {
    expect_match(url, "_AT")
    expect_match(name, "[.]csv$")
    expect_identical(cache_dir, tempdir())
    expect_identical(subdir, "gisco_metadata")
    expect_true(verbose)

    csv_file <- tempfile(fileext = ".csv")
    write.csv(
      data.frame(id = "ES", name = "Spain"),
      csv_file,
      row.names = FALSE,
      fileEncoding = "UTF-8"
    )
    csv_file
  })

  metadata <- gisco_get_metadata("countries", year = 2024, verbose = TRUE)
  expect_s3_class(metadata, "tbl_df")
  expect_identical(metadata$id, "ES")
})

test_that("Metadata reports downloads in verbose mode", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_message(n <- gisco_get_metadata(verbose = TRUE), "Cache directory")
  expect_s3_class(n, "tbl_df")
})

test_that("Metadata validates dataset and year inputs", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(gisco_get_metadata("grids"), error = TRUE)

  expect_snapshot(gisco_get_metadata("urban_audit", year = 1990), error = TRUE)
})

test_that("Metadata is available for every NUTS year", {
  skip_on_cran()
  skip_if_gisco_offline()
  val_years <- db_values("nuts", "year", formatted = FALSE)
  for (i in val_years) {
    db <- gisco_get_metadata("nuts", i)
    expect_s3_class(db, "tbl_df")
  }
})

test_that("Metadata is available for every countries year", {
  skip_on_cran()
  skip_if_gisco_offline()
  val_years <- db_values("countries", "year", formatted = FALSE)
  for (i in val_years) {
    db <- gisco_get_metadata("countries", i)
    expect_s3_class(db, "tbl_df")
  }
})

test_that("Metadata is available for every urban audit year", {
  skip_on_cran()
  skip_if_gisco_offline()
  val_years <- db_values("urban_audit", "year", formatted = FALSE)
  for (i in val_years) {
    db <- gisco_get_metadata("urban_audit", i)
    expect_s3_class(db, "tbl_df")
  }
})
