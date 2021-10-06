test_that("Urban Audit offline", {
  expect_error(gisco_get_urban_audit(year = "1999"))
  expect_error(gisco_get_urban_audit(epsg = "9999"))
  expect_error(gisco_get_urban_audit(level = "9999"))
  expect_error(gisco_get_urban_audit(spatialtype = "BN"))
  expect_error(gisco_get_urban_audit(year = 2001))
})

test_that("Urban Audit online", {
  skip_if_gisco_offline()
  #  skip_on_cran()

  expect_silent(gisco_get_urban_audit(level = "GREATER_CITIES"))
  fromurl <- expect_silent(gisco_get_urban_audit(
    level = "GREATER_CITIES",
    cache = FALSE
  ))

  expect_s3_class(fromurl, "sf")

  expect_silent(gisco_get_urban_audit(level = "CITIES", spatialtype = "LB"))

  # Test CITIES vs GREATER_CITIES for regex
  a <- gisco_get_urban_audit(
    year = 2020, spatialtype = "LB",
    level = "CITIES"
  )
  b <- gisco_get_urban_audit(
    year = 2020, spatialtype = "LB",
    level = "GREATER_CITIES"
  )
  expect_false(nrow(a) == nrow(b))


  check <- expect_silent(
    gisco_get_urban_audit(
      level = "GREATER_CITIES",
      spatialtype = "LB",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )

  expect_identical(sf::st_crs(check), sf::st_crs(3857))

  expect_length(
    setdiff(unique(check$CNTR_CODE), c("IT", "PL")),
    0
  )


  check <- expect_silent(
    gisco_get_urban_audit(
      year = 2014,
      spatialtype = "LB",
      level = "GREATER_CITIES",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )
  expect_identical(sf::st_crs(check), sf::st_crs(3857))

  expect_length(
    setdiff(unique(check$CNTR_CODE), c("IT", "PL")),
    0
  )


  check <- expect_silent(gisco_get_urban_audit(
    year = 2018,
    epsg = 3857,
    level = "GREATER_CITIES",
    country = c("ITA", "POL")
  ))

  expect_identical(sf::st_crs(check), sf::st_crs(3857))

  expect_length(
    setdiff(unique(check$CNTR_CODE), c("IT", "PL")),
    0
  )

  expect_message(
    gisco_get_urban_audit(
      year = 2018,
      spatialtype = "LB",
      epsg = 3857,
      country = c("ITA", "POL"),
      verbose = TRUE
    )
  )

  check <- expect_silent(
    gisco_get_urban_audit(
      year = 2020,
      spatialtype = "LB",
      level = "GREATER_CITIES",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )

  expect_identical(sf::st_crs(check), sf::st_crs(3857))

  expect_length(
    setdiff(unique(check$CNTR_CODE), c("IT", "PL")),
    0
  )
})
