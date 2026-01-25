test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_get_ports(update_cache = TRUE),
    "Error"
  )
  expect_null(n)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Get ports", {
  expect_error(gisco_get_ports(year = 2020))
  expect_error(gisco_get_ports(year = 2020, country = "ES"))

  skip_on_cran()
  skip_if_gisco_offline()

  all <- expect_silent(gisco_get_ports())
  expect_true(all(sf::st_geometry_type(all) == "POINT"))

  expect_silent(gisco_get_ports())
  es <- expect_silent(gisco_get_ports(country = "ES"))
  expect_s3_class(es, "tbl_df")
  expect_s3_class(es, "sf")
  expect_true("CNTR_ISO2" %in% names(es))
  expect_lt(nrow(es), nrow(all))

  expect_identical(
    sf::st_crs(all),
    sf::st_crs(4326)
  )

  expect_identical(
    sf::st_crs(es),
    sf::st_crs(4326)
  )

  expect_identical(as.character(unique(es$CNTR_ISO2)), "ES")

  # 2009
  all <- expect_silent(gisco_get_ports(2009))
  expect_true(all(sf::st_geometry_type(all) == "POINT"))

  expect_silent(gisco_get_ports(2009))
  es <- expect_silent(gisco_get_ports(country = "ES"))
  expect_s3_class(es, "tbl_df")
  expect_s3_class(es, "sf")
  expect_true("CNTR_ISO2" %in% names(es))
  expect_lt(nrow(es), nrow(all))

  expect_identical(
    sf::st_crs(all),
    sf::st_crs(4326)
  )

  expect_identical(
    sf::st_crs(es),
    sf::st_crs(4326)
  )

  expect_identical(as.character(unique(es$CNTR_ISO2)), "ES")
})
