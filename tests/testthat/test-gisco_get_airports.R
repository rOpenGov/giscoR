test_that("Get airports", {
  expect_error(gisco_get_ports(year = 2020))
  expect_error(gisco_get_airports(year = 2020))
  expect_error(gisco_get_ports(year = 2020, country = "ES"))

  skip_if_gisco_offline()
  # skip_on_cran()

  all <- expect_silent(gisco_get_airports())
  expect_silent(gisco_get_airports(year = 2013))
  es <- expect_silent(gisco_get_airports(country = "ES"))

  expect_identical(
    sf::st_crs(all),
    sf::st_crs(4326)
  )


  expect_identical(
    sf::st_crs(es),
    sf::st_crs(4326)
  )

  expect_identical(as.character(unique(es$CNTR_CODE)), "ES")
  expect_true(nrow(all) > nrow(es))

  # PORTS
  all <- expect_silent(gisco_get_ports())
  expect_silent(gisco_get_ports(year = 2013))
  es <- expect_silent(gisco_get_ports(country = "ES"))

  expect_true("CNTR_ISO2" %in% names(es))


  expect_identical(
    sf::st_crs(all),
    sf::st_crs(4326)
  )


  expect_identical(
    sf::st_crs(es),
    sf::st_crs(4326)
  )

  expect_identical(as.character(unique(es$CNTR_ISO2)), "ES")
  expect_true(nrow(all) > nrow(es))
})
