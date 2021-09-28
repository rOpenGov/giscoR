test_that("Errors on units", {
  expect_error(gisco_get_units(year = "2001"))
  expect_error(gisco_get_units(unit = NULL))
  expect_error(gisco_get_units(epsg = 3456))
  expect_error(gisco_get_units(resolution = "35"))
  expect_error(gisco_get_units(id_giscoR = "lau"))
  expect_error(gisco_get_units(spatialtype = "aa"))
  expect_error(gisco_get_units(mode = "aa"))
})

test_that("Units online", {
  skip_on_cran()
  skip_if_not(
    gisco_check_access(),
    "Skipping... GISCO not reachable."
  )
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
      mode = "df",
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
