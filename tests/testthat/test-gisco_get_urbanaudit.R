test_that("Urban Audit offline", {
  expect_error(gisco_get_urban_audit(year = "1999"))
  expect_error(gisco_get_urban_audit(epsg = "9999"))
  expect_error(gisco_get_urban_audit(level = "9999"))
  expect_error(gisco_get_urban_audit(spatialtype = "BN"))
  expect_error(gisco_get_urban_audit(year = 2001))
})

test_that("Urban Audit online", {
  skip_on_cran()
  skip_if_not(
    gisco_check_access(),
    "Skipping... GISCO not reachable."
  )

  expect_silent(gisco_get_urban_audit(level = "GREATER_CITIES"))
  expect_warning(gisco_get_urban_audit(
    level = "GREATER_CITIES",
    cache = FALSE
  ))

  expect_silent(gisco_get_urban_audit(level = "CITIES", spatialtype = "LB"))

  a <- gisco_get_urban_audit(
    year = 2020, spatialtype = "LB",
    level = "CITIES"
  )
  b <- gisco_get_urban_audit(
    year = 2020, spatialtype = "LB",
    level = "GREATER_CITIES"
  )
  expect_false(nrow(a) == nrow(b))


  expect_silent(gisco_get_urban_audit(
    spatialtype = "LB",
    level = "GREATER_CITIES"
  ))

  expect_silent(
    gisco_get_urban_audit(
      level = "GREATER_CITIES",
      spatialtype = "LB",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )

  expect_silent(
    gisco_get_urban_audit(
      year = 2014,
      spatialtype = "LB",
      level = "GREATER_CITIES",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )

  expect_silent(gisco_get_urban_audit(
    year = 2018,
    epsg = 3857,
    level = "GREATER_CITIES",
    country = c("ITA", "POL")
  ))

  expect_message(
    gisco_get_urban_audit(
      year = 2018,
      spatialtype = "LB",
      epsg = 3857,
      country = c("ITA", "POL"),
      verbose = TRUE
    )
  )

  expect_silent(
    gisco_get_urban_audit(
      year = 2020,
      spatialtype = "LB",
      level = "GREATER_CITIES",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )
})
