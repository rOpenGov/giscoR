test_that("Countries errors", {
  expect_error(gisco_get_countries(year = 2001, resolution = 60))
  expect_error(gisco_get_countries(year = 2011))
  expect_error(gisco_get_countries(epsg = 2819))
  expect_error(gisco_get_countries(spatialtype = "aa"))
  expect_error(gisco_get_countries(res = 15))
})

test_that("Country names", {

  # Test names
  expect_error(gisco_get_countries(country = "Z"))
  expect_warning(expect_warning(gisco_get_countries(country = "ZZ")))
  expect_silent(gisco_get_countries(country = "ES"))
  expect_true(nrow(gisco_get_countries(country = "Spain")) == 1)
  expect_true(nrow(gisco_get_countries(country = "ES")) == 1)
  expect_silent(gisco_get_countries(region = c("Africa", "Americas")))
  expect_true(nrow(gisco_get_countries(region = c("EU"))) == 27)
  expect_true(nrow(gisco_get_countries(country = c("Spain", "Italia"))) == 2)
  expect_true(nrow(gisco_get_countries(country = c("ES", "IT"))) == 2)
  expect_true(nrow(gisco_get_countries(country = c("ESP", "ITA"))) == 2)
  expect_warning(
    expect_warning(gisco_get_countries(country = c("ESP", "Italia")))
  )

  expect_identical(
    giscoR:::gsc_helper_countrynames(c("ESP", "ITA")),
    c("ES", "IT")
  )
})

test_that("Countries offline", {
  # Test
  expect_silent(gisco_get_countries())
  expect_message(gisco_get_countries(verbose = TRUE))
  expect_true(sf::st_is_longlat(gisco_get_countries()))
})

test_that("Countries online", {
  skip_if_gisco_offline()
  skip_on_cran()
  
  expect_silent(gisco_get_countries(
    spatialtype = "LB",
    country = c("Spain", "Italia")
  ))

  expect_warning(gisco_get_countries(
    spatialtype = "LB",
    cache = FALSE
  ))

  expect_silent(gisco_get_countries(
    spatialtype = "COASTL",
    country = c("ESP", "ITA")
  ))

  expect_silent(gisco_get_countries(
    resolution = "10",
    country = c("ESP", "ITA")
  ))

  expect_silent(gisco_get_countries(resolution = 60, country = c("ES", "IT")))
  expect_silent(gisco_get_countries(spatialtype = "COASTL", resolution = "60"))

  expect_silent(gisco_get_countries(resolution = "60", country = "DNK"))

  expect_silent(gisco_get_countries(spatialtype = "COASTL", resolution = 3))
  expect_silent(gisco_get_countries(
    spatialtype = "COASTL",
    resolution = "60",
    update_cache = TRUE
  ))


  expect_silent(gisco_get_countries(
    year = "2013",
    resolution = "60",
    spatialtype = "RG"
  ))
})
