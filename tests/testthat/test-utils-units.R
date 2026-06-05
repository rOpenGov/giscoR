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
