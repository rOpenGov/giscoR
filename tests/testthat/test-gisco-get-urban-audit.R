test_that("Urban Audit offline", {
  skip_on_cran()

  expect_error(gisco_get_urban_audit(year = "1999"))
  expect_error(gisco_get_urban_audit(epsg = "9999"))
  expect_error(gisco_get_urban_audit(level = "9999"))
  expect_error(gisco_get_urban_audit(spatialtype = "BN"))
  expect_error(gisco_get_urban_audit(year = 2001))
})

test_that("Mock offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  db <- gisco_get_latest_db()

  options(gisco_test_err = TRUE)
  expect_message(
    n <- gisco_get_urban_audit(
      update_cache = TRUE
    ),
    "Error"
  )
  expect_null(n)
  options(gisco_test_err = FALSE)
})


test_that("Urban Audit online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_urban_audit(level = "CITIES"))
  fromurl <- expect_silent(gisco_get_urban_audit(
    level = "CITIES",
    cache = FALSE
  ))

  expect_s3_class(fromurl, "sf")
  expect_s3_class(fromurl, "tbl_df")

  expect_silent(gisco_get_urban_audit(level = "CITIES", spatialtype = "LB"))

  # Test CITIES vs GREATER_CITIES for regex
  a <- gisco_get_urban_audit(
    year = 2020,
    spatialtype = "LB",
    level = "CITIES"
  )
  b <- gisco_get_urban_audit(
    year = 2020,
    spatialtype = "LB",
    level = "GREATER_CITIES"
  )
  expect_false(nrow(a) == nrow(b))

  check <- expect_silent(
    gisco_get_urban_audit(
      level = "GREATER_CITIES",
      spatialtype = "LB",
      year = 2020,
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )

  expect_identical(sf::st_crs(check)$epsg, sf::st_crs(3857)$epsg)

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
  expect_identical(sf::st_crs(check)$epsg, sf::st_crs(3857)$epsg)

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

  expect_identical(sf::st_crs(check)$epsg, sf::st_crs(3857)$epsg)

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

  expect_identical(sf::st_crs(check)$epsg, sf::st_crs(3857)$epsg)

  expect_length(
    setdiff(unique(check$CNTR_CODE), c("IT", "PL")),
    0
  )
})
