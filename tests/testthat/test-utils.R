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


test_that("Pretty match", {
  skip_on_cran()
  my_fun <- function(
    arg_one = c(10, 1000, 3000, 5000)
  ) {
    match_arg_pretty(arg_one)
  }

  # OK, returns character
  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")
  # Some errors here
  # Single value no match
  expect_snapshot(
    my_fun("error here"),
    error = TRUE
  )

  # Several values no match
  expect_snapshot(
    my_fun(c("an", "error")),
    error = TRUE
  )

  # One value regex
  expect_snapshot(
    my_fun("5"),
    error = TRUE
  )
  # Several value regex
  expect_snapshot(
    my_fun("00"),
    error = TRUE
  )

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  # Pass more options than expected
  expect_snapshot(
    my_fun2(c(1, 2)),
    error = TRUE
  )

  # With custom options
  my_fun3 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun3(), "20")
  expect_snapshot(my_fun3("3"), error = TRUE)
  # Pass more options than expected
  expect_snapshot(
    my_fun2(c(1, 2)),
    error = TRUE
  )

  # Live action
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(gisco_get_airports(2050), error = TRUE)
  expect_s3_class(gisco_get_airports(2013), "sf")
})
