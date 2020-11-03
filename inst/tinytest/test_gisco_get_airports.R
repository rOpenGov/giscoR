library(tinytest)

expect_silent(gisco_get_airports())
expect_silent(gisco_get_airports(year = 2013))
expect_silent(gisco_get_airports(year = 2006))
expect_silent(gisco_get_airports(country = "ES"))
expect_error(gisco_get_airports(year = 2020))


expect_silent(gisco_get_ports())
expect_silent(gisco_get_ports(year = 2013))
expect_silent(gisco_get_ports(year = 2009))
expect_error(gisco_get_ports(year = 2020))

