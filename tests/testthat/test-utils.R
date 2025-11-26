test_that("Messages", {
  skip_on_cran()
  expect_silent(make_msg(verbose = FALSE))
  expect_snapshot(make_msg(
    "generic",
    TRUE,
    "Hi",
    "I am a generic.",
    "See {.var avar}."
  ))
  expect_snapshot(make_msg("info", TRUE, "Info here.", "See {.pkg igoR}."))

  expect_snapshot(make_msg(
    "warning",
    TRUE,
    "Caution! A warning.",
    "But still OK."
  ))

  expect_snapshot(make_msg("danger", TRUE, "OOPS!", "I did it again :("))

  expect_snapshot(make_msg("success", TRUE, "Hooray!", "5/5 ;)"))
})


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
