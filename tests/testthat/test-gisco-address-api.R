test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(
    fend <- gisco_address_api_bbox(),
  )
  expect_null(fend)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
})


test_that("Test 404", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_address_api_bbox(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_address_api_cities(),
    "Error"
  )

  expect_message(
    n <- gisco_address_api_copyright(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_address_api_housenumbers(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_address_api_postcodes(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_address_api_provinces(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_address_api_reverse(x = 0, y = 0),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_address_api_roads(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_address_api_search(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_address_api_countries(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_address_api_copyright(),
    "Error"
  )
  expect_null(n)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})


test_that("gisco_address_api_bbox online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_address_api_bbox(
      country = "Spain",
      city = "NIEVA"
    )
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_message(
    n <- gisco_address_api_bbox(
      country = "Spain",
      city = "NIEVA",
      verbose = TRUE
    )
  )

  expect_message(
    n <- gisco_address_api_bbox("Namibia"),
    "No results. Returning"
  )

  expect_null(n)
})


test_that("gisco_address_api_search online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_address_api_search(
      country = "ES",
      province = "CASTILLA Y LEON",
      city = "NIEVA",
      road = "MAYOR"
    )
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")

  expect_null(gisco_address_api_search(country = "ES"))

  expect_null(gisco_address_api_search(country = "XYZ"))
})


test_that("gisco_address_api_reverse online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_address_api_reverse(
      x = 14.90691902084116,
      y = 49.63074884786084
    )
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_true(all("X" %in% names(n), "Y" %in% names(n)))

  expect_shape(
    gisco_address_api_reverse(-10, -30),
    nrow = 0
  )
})


test_that("gisco_address_api_country online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_address_api_countries())
  expect_s3_class(n, "tbl_df")
  expect_identical("L0", names(n))
})

test_that("gisco_address_api_provinces online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_address_api_provinces(country = "LU"))
  expect_s3_class(n, "tbl_df")
})

test_that("gisco_address_api_cities online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_address_api_cities(
      country = "ES",
      province = "MURCIA"
    )
  )

  expect_s3_class(n, "tbl_df")
})

test_that("gisco_address_api_roads online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_address_api_roads(
      country = "ES",
      province = "CASTILLA Y LEON",
      city = "CODORNIZ"
    )
  )

  expect_s3_class(n, "tbl_df")
})

test_that("gisco_address_api_housenumbers online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_address_api_housenumbers(
      country = "ES",
      province = "MADRID",
      city = "MADRID",
      road = "CL MARCELO USERA",
      postcode = 28026
    )
  )

  expect_s3_class(n, "tbl_df")
})

test_that("gisco_address_api_postcodes online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_address_api_postcodes(
      country = "ES",
      province = "CASTILLA Y LEON",
      city = "CODORNIZ"
    )
  )

  expect_s3_class(n, "tbl_df")
})

test_that("gisco_address_api_copyright online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_address_api_copyright())
  expect_s3_class(n, "tbl_df")
})
