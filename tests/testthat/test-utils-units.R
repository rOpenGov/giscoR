test_that("Unit filename helpers work", {
  expect_identical(unit_spatialtype_to_file_type("RG"), "region")
  expect_identical(unit_spatialtype_to_file_type("LB"), "label")

  expect_identical(
    build_unit_filenames("ES", "region", 4326, 2024, "20m"),
    "ES-region-20m-4326-2024.geojson"
  )
  expect_identical(
    build_unit_filenames("ES", "label", 4326, 2024, "20m"),
    "ES-label-4326-2024.geojson"
  )
})

test_that("Unit reader handles NULL inputs", {
  expect_null(read_unit_file_sf(NULL))
})

test_that("Missing unit files warn before they are skipped", {
  response <- httr2::response(
    headers = list("content-type" = "application/json"),
    body = charToRaw('["available.geojson"]')
  )
  local_mocked_bindings(get_request_body = function(...) response)

  expect_warning(
    out <- get_unit_files(
      dataset = "countries",
      api_id = "CNTR",
      unit_names = "missing.geojson",
      unit_labels = "Missing",
      year = 2024,
      cache = FALSE,
      update_cache = FALSE,
      cache_dir = withr::local_tempdir(),
      verbose = FALSE
    ),
    class = "giscoR_warning_missing_unit"
  )

  expect_null(out)
})
