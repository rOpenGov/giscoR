test_that("Get airports", {
  expect_error(gisco_get_ports(year = 2020))
  expect_error(gisco_get_airports(year = 2020))

  skip_if_not(
    gisco_check_access(),
    "Skipping... GISCO not reachable."
  )
  expect_silent(gisco_get_airports())
  expect_silent(gisco_get_airports(year = 2013))
  expect_silent(gisco_get_airports(country = "ES"))



  expect_silent(gisco_get_ports())
  expect_silent(gisco_get_ports(year = 2013))
})
