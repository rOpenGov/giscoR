test_that("Utils names", {
  skip_on_cran()

  expect_snapshot(get_country_code(c("Espagne", "United Kingdom")))
  expect_snapshot(get_country_code("U"), error = TRUE)
  expect_snapshot(get_country_code(
    c("ESP", "POR", "RTA", "USA"),
    "iso3c"
  ))
  expect_snapshot(get_country_code(c("ESP", "Alemania")))
})

test_that("Problematic names", {
  skip_on_cran()

  expect_snapshot(get_country_code(c("Espagne", "Antartica")))
  expect_snapshot(get_country_code(c("spain", "antartica")))

  # Special case for Kosovo
  expect_snapshot(get_country_code(c("Spain", "Kosovo", "Antartica")))
  expect_snapshot(get_country_code(c("Spain", "Kosovo", "Antartica"), "iso3c"))
  expect_snapshot(get_country_code(c("ESP", "XKX", "DEU")))
  expect_snapshot(
    get_country_code(c("Spain", "Rea", "Kosovo", "Antartica", "Murcua"))
  )

  expect_snapshot(
    get_country_code("Kosovo")
  )
  expect_snapshot(
    get_country_code("XKX")
  )
  expect_snapshot(
    get_country_code("XK", "iso3c")
  )
  expect_identical(
    get_country_code("ES"),
    "ES"
  )
})

test_that("Test mixed countries", {
  skip_on_cran()

  expect_snapshot(get_country_code(c(
    "Germany",
    "USA",
    "Greece",
    "united Kingdom"
  )))
})

test_that("Get regions and countries", {
  skip_on_cran()

  expect_null(get_countrycodes_region())
  expect_identical(get_countrycodes_region(c("Japan", "Spain")), c("JP", "ES"))

  expect_identical(
    get_countrycodes_region(c("Japan", "Spain"), code = "iso3c"),
    c("JPN", "ESP"),
  )

  expect_identical(
    get_countrycodes_region(
      c("Japan", "Spain"),
      region = "Asia",
      code = "iso3c"
    ),
    "JPN"
  )

  expect_identical(
    get_countrycodes_region(
      c("Japan", "Spain"),
      region = c("Americas", "EU"),
      code = "iso3c"
    ),
    "ESP"
  )
  l <- get_countrycodes_region(
    region = "Americas"
  )

  eu <- get_countrycodes_region(
    region = "EU"
  )
  expect_length(eu, 27)
  l_and_eu <- get_countrycodes_region(region = c("Americas", "EU"))

  expect_identical(length(l_and_eu), length(eu) + length(l))
})
