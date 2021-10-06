test_that("Errors on units", {
  expect_error(gisco_get_units(year = "2001"))
  expect_error(gisco_get_units(unit = NULL))
  expect_error(gisco_get_units(epsg = 3456))
  expect_error(gisco_get_units(resolution = "35"))
  expect_error(gisco_get_units(id_giscoR = "lau"))
  expect_error(gisco_get_units(spatialtype = "aa"))
  expect_error(gisco_get_units(mode = "aa"))
})

test_that("Units sf online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_units(
    year = "2001",
    id_giscoR = "countries",
    unit = "ES"
  ))
  expect_silent(gisco_get_units(
    year = "2001",
    id_giscoR = "countries",
    unit = "ES",
    cache = FALSE
  ))

  expect_message(gisco_get_units(
    year = "2001",
    id_giscoR = "countries",
    unit = "DK",
    cache = FALSE,
    verbose = TRUE
  ))

  # Check that the file was not downloaded
  file <- file.path(
    gsc_helper_detect_cache_dir(),
    "DNK-cntry-region-20m-4326-2001.geojson"
  )

  expect_false(file.exists(file))

  expect_silent(gisco_get_units(
    id_giscoR = "countries",
    unit = "Spain",
    spatialtype = "LB"
  ))

  expect_silent(gisco_get_units(
    id_giscoR = "countries",
    unit = "ESP"
  ))

  expect_silent(
    gisco_get_units(
      year = "2001",
      id_giscoR = "countries",
      unit = "ES",
      spatialtype = "LB"
    )
  )
  expect_error(
    gisco_get_units(
      year = "2001",
      id_giscoR = "countries",
      unit = "Spain",
      resolution = "60"
    )
  )
  expect_silent(gisco_get_units(id_giscoR = "nuts", unit = "ES"))


  dups <- expect_silent(gisco_get_units(
    id_giscoR = "nuts",
    unit = c("ES", "IT", "ES")
  ))

  expect_equal(nrow(dups), 2)

  expect_silent(gisco_get_units(
    id_giscoR = "nuts",
    year = 2016,
    unit = "PT",
    update_cache = TRUE
  ))
  r <-
    gisco_get_units(
      id_giscoR = "nuts",
      unit = c("FR", "ES", "xt", "PT")
    )
  expect_true(nrow(r) == 3)
  expect_message(gisco_get_units(
    id_giscoR = "nuts",
    unit = c("FR", "ES", "xt", "PT")
  ))
  expect_message(gisco_get_units(verbose = TRUE))
  df <- gisco_get_units(mode = "df")
  expect_true(class(df) == "data.frame")
  sf <-
    gisco_get_units(
      id_giscoR = "urban_audit",
      year = "2020",
      unit = "ES002L2"
    )
  expect_true(class(sf)[1] == "sf")
  expect_message(gisco_get_units(unit = c("ES1", "ES345", "FFRE3")))
  expect_silent(gisco_get_units(
    id_giscoR = "urban_audit",
    year = "2004",
    mode = "df"
  ))
  expect_message(gisco_get_units(
    id_giscoR = "urban_audit",
    year = "2014",
    mode = "df",
    verbose = TRUE
  ))
  expect_silent(gisco_get_units(
    id_giscoR = "countries",
    year = "2001",
    mode = "df"
  ))

  expect_silent(gisco_get_units(
    id_giscoR = "nuts",
    year = "2016",
    update_cache = TRUE,
    unit = "ES"
  ))

  expect_message(gisco_get_units(
    id_giscoR = "countries",
    year = "2016",
    verbose = TRUE,
    unit = c("DK", "ES")
  ))

  expect_error(gisco_get_units(
    id_giscoR = "nuts",
    year = "2016",
    verbose = TRUE,
    unit = "XXXXX"
  ))

  expect_silent(gisco_get_units(
    id_giscoR = "countries",
    year = 2016,
    mode = "df"
  ))
  expect_silent(gisco_get_units(
    id_giscoR = "urban_audit",
    year = 2018,
    mode = "df"
  ))
})



test_that("Units df online", {
  skip_on_cran()
  skip_if_gisco_offline()

  test <- expect_silent(gisco_get_units(
    year = "2001",
    id_giscoR = "countries",
    unit = "ES",
    mode = "df"
  ))

  expect_s3_class(test, "data.frame", exact = TRUE)
  expect_true(nrow(test) > 5)


  test <- expect_silent(gisco_get_units(
    id_giscoR = "countries",
    unit = "Spain",
    spatialtype = "LB",
    mode = "df"
  ))

  expect_s3_class(test, "data.frame", exact = TRUE)
  expect_true(nrow(test) > 5)


  test <- expect_silent(gisco_get_units(
    id_giscoR = "nuts",
    unit = "ES",
    mode = "df"
  ))


  expect_s3_class(test, "data.frame", exact = TRUE)
  expect_true(nrow(test) > 5)

  expect_message(gisco_get_units(
    id_giscoR = "nuts", unit = "ES",
    mode = "df", verbose = TRUE
  ))


  test <- expect_silent(gisco_get_units(
    id_giscoR = "urban_audit",
    year = 2001,
    unit = "ES",
    mode = "df"
  ))

  expect_s3_class(test, "data.frame", exact = TRUE)
  expect_true(nrow(test) > 5)

  test <- expect_silent(gisco_get_units(
    id_giscoR = "urban_audit",
    year = 2014,
    unit = "ES",
    mode = "df"
  ))

  expect_s3_class(test, "data.frame", exact = TRUE)
  expect_true(nrow(test) > 5)

  test <- expect_silent(gisco_get_units(
    id_giscoR = "urban_audit",
    year = 2020,
    unit = "ES",
    mode = "df"
  ))

  expect_s3_class(test, "data.frame", exact = TRUE)
  expect_true(nrow(test) > 5)

  test <- expect_silent(gisco_get_units(
    id_giscoR = "urban_audit",
    year = 2004,
    unit = "ES",
    mode = "df"
  ))

  expect_s3_class(test, "data.frame", exact = TRUE)
  expect_true(nrow(test) > 5)
})
