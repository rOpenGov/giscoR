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

test_that("Pretty match", {
  skip_on_cran()
  my_fun <- function(arg_one = c(10, 1000, 3000, 5000)) {
    match_arg_pretty(arg_one)
  }

  # OK, returns character
  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")
  # Some errors here
  # Single value no match
  expect_snapshot(my_fun("error here"), error = TRUE)

  # Several values no match
  expect_snapshot(my_fun(c("an", "error")), error = TRUE)

  # One value regex
  expect_snapshot(my_fun("5"), error = TRUE)
  # Several value regex
  expect_snapshot(my_fun("00"), error = TRUE)

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)

  # With custom options
  my_fun3 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun3(), "20")
  expect_snapshot(my_fun3("3"), error = TRUE)
  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)

  # Live action
  skip_on_cran()
  skip_if_gisco_offline()
  expect_snapshot(gisco_get_airports(2050), error = TRUE)
  expect_s3_class(gisco_get_airports(2013), "sf")
})

test_that("Argument matching returns defaults and exact values", {
  match_year <- function(year = c(2020, 2024)) {
    match_arg_pretty(year)
  }

  expect_identical(match_year(), "2020")
  expect_identical(match_year(NULL), "2020")
  expect_identical(match_year(2024), "2024")
})

test_that("Argument matching reports invalid values", {
  match_year <- function(year = c(2020, 2024)) {
    match_arg_pretty(year)
  }

  expect_error(match_year(2030), "must be")
  expect_error(match_year(c(2020, 2030)), "must be")
})

test_that("Resolution format helpers work", {
  expect_identical(format_unit_resolution(1), "01m")
  expect_identical(format_unit_resolution("20"), "20m")
  expect_identical(format_bulk_resolution("100"), "100k")
  expect_identical(format_bulk_resolution("3"), "03m")
  expect_identical(format_urau_unit_resolution(2013), "03M")
  expect_identical(format_urau_unit_resolution(2014), "100K")
  expect_identical(format_urau_unit_resolution(2024), "100k")
})

test_that("Deprecated cache helper warns only when cache is supplied", {
  expect_silent(warn_deprecated_cache(lifecycle::deprecated(), "x(cache)"))
  expect_snapshot(warn_deprecated_cache(TRUE, "x(cache)"))
})

test_that("Bind and fill sf", {
  skip_on_cran()
  gb <- giscoR::gisco_countries_2024[1, ]
  cos <- giscoR::gisco_nuts_2024[1, ]
  a_list <- list(gb, cos, gb, cos)
  expect_error(err <- do.call(rbind, a_list))
  expect_silent(binded <- rbind_fill(a_list))
  expect_s3_class(binded, "sf")
  expect_s3_class(binded, "tbl_df")
  expect_equal(nrow(binded), 4)
})

test_that("Bind and fill tibbles", {
  skip_on_cran()
  gb <- giscoR::gisco_countries_2024[1, ]
  gb <- sf::st_drop_geometry(gb)
  cos <- giscoR::gisco_nuts_2024[1, ]
  cos <- sf::st_drop_geometry(cos)
  a_list <- list(gb, cos, gb, cos)
  expect_error(err <- do.call(rbind, a_list))
  expect_silent(binded <- rbind_fill(a_list))
  expect_s3_class(binded, "tbl_df")
  expect_equal(nrow(binded), 4)
})

test_that("Bind and fill sf removes NULL", {
  skip_on_cran()
  gb <- giscoR::gisco_countries_2024[1, ]
  cos <- giscoR::gisco_nuts_2024[1, ]
  a_list <- list(gb, cos, gb, cos)
  a_list[[3]] <- NULL
  expect_error(err <- do.call(rbind, a_list))
  expect_silent(binded <- rbind_fill(a_list))
  expect_s3_class(binded, "sf")
  expect_s3_class(binded, "tbl_df")
  expect_equal(nrow(binded), 3)
})

test_that("Bind and fill tibble removes NULL", {
  skip_on_cran()
  gb <- giscoR::gisco_countries_2024[1, ]
  gb <- sf::st_drop_geometry(gb)
  cos <- giscoR::gisco_nuts_2024[1, ]
  cos <- sf::st_drop_geometry(cos)

  a_list <- list(gb, cos, gb, cos)
  a_list[[3]] <- NULL
  expect_error(err <- do.call(rbind, a_list))
  expect_silent(binded <- rbind_fill(a_list))
  expect_s3_class(binded, "tbl_df")
  expect_equal(nrow(binded), 3)

  # All NULLs return NULL
  new_l <- list(a = NULL, b = NULL)

  expect_null(rbind_fill(new_l))
})
test_that("Ensure NULL", {
  expect_null(ensure_null(NULL))
  expect_null(ensure_null(c(NULL, NA)))
  expect_null(ensure_null(c(NULL, NA, "")))
  expect_null(ensure_null(c("", character(0))))
  expect_identical(ensure_null(c(1, 2)), c(1, 2))
  expect_identical(letters, letters)
})

test_that("Ensure NULL", {
  expect_null(ensure_null(NULL))
  expect_null(ensure_null(c(NULL, NA)))
  expect_null(ensure_null(c(NULL, NA, "")))
  expect_null(ensure_null(c("", character(0))))
  expect_identical(ensure_null(c(1, 2)), c(1, 2))
  expect_identical(letters, letters)
})
