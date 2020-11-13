library(tinytest)

expect_error(gisco_get_urban_audit(year = "1999"))
expect_error(gisco_get_urban_audit(epsg = "9999"))
expect_error(gisco_get_urban_audit(level = "9999"))
expect_error(gisco_get_urban_audit(spatialtype = "BN"))
expect_error(gisco_get_urban_audit(year = 2001))

# See if there is access
if (gisco_check_access()) {
  expect_silent(gisco_get_urban_audit(level = "GREATER_CITIES"))
  expect_silent(gisco_get_urban_audit(spatialtype = "LB",
                                      level = "GREATER_CITIES"))

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

  expect_silent(
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
}
