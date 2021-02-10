library(tinytest)


expect_error(gisco_get_countries(year = 2001, resolution = 60))
expect_error(gisco_get_countries(year = 2011))
expect_error(gisco_get_countries(epsg = 2819))
expect_error(gisco_get_countries(spatialtype = "aa"))
expect_error(gisco_get_countries(res = 15))


# Test names
expect_error(gisco_get_countries(country = "Z"))
expect_warning(gisco_get_countries(country = "ZZ"))
expect_silent(gisco_get_countries(country = "ES"))
expect_true(nrow(gisco_get_countries(country = "Spain")) == 1)
expect_true(nrow(gisco_get_countries(country = "ES")) == 1)
expect_silent(gisco_get_countries(region = c("Africa", "Americas")))
expect_true(nrow(gisco_get_countries(region = c("EU"))) == 27)
expect_true(nrow(gisco_get_countries(country = c("Spain", "Italia"))) == 2)
expect_true(nrow(gisco_get_countries(country = c("ES", "IT"))) == 2)
expect_true(nrow(gisco_get_countries(country = c("ESP", "ITA"))) == 2)
expect_warning(gisco_get_countries(country = c("ESP", "Italia")))

expect_identical(giscoR:::gsc_helper_countrynames(c("ESP", "ITA")),
                 c("ES", "IT"))


# Test
expect_silent(gisco_get_countries())
expect_message(gisco_get_countries(verbose = TRUE))
expect_true(sf::st_is_longlat(gisco_get_countries()))
