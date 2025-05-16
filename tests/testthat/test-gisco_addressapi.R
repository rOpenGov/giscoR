test_that("Test offline", {
  options(giscoR_test_offline = TRUE)
  expect_message(
    n <- gisco_addressapi_bbox(),
    "not reachable"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_cities(),
    "not reachable"
  )

  expect_message(
    n <- gisco_addressapi_copyright(),
    "not reachable"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_countries(),
    "not reachable"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_housenumbers(),
    "not reachable"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_postcodes(),
    "not reachable"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_provinces(),
    "not reachable"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_reverse(x = 0, y = 0),
    "not reachable"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_roads(),
    "not reachable"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_search(),
    "not reachable"
  )
  expect_null(n)

  options(giscoR_test_offline = FALSE)
})


test_that("gisco_addressapi_bbox online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_bbox(
    country = "Spain",
    city = "NIEVA"
  ))
  expect_s3_class(n, "sf")
  expect_message(n <- gisco_addressapi_bbox(
    country = "Spain",
    city = "NIEVA", verbose = TRUE
  ))


  expect_null(gisco_addressapi_bbox("Namibia"))
})


test_that("gisco_addressapi_search online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_search(
    country = "ES",
    province = "CASTILLA Y LEON",
    city = "NIEVA",
    road = "MAYOR"
  ))
  expect_s3_class(n, "sf")
  expect_null(gisco_addressapi_search(country = "ES"))

  expect_null(gisco_addressapi_search(country = "XYZ"))
})


test_that("gisco_addressapi_reverse online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_reverse(
    x = 14.90691902084116,
    y = 49.63074884786084
  ))
  expect_s3_class(n, "sf")
  expect_null(gisco_addressapi_reverse(-10, -30))
})


test_that("gisco_addressapi_country online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_countries())
  expect_s3_class(n, "data.frame")
  expect_identical("L0", names(n))
})

test_that("gisco_addressapi_provinces online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_provinces(country = "LU"))
  expect_s3_class(n, "data.frame")
})
test_that("gisco_addressapi_cities online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_cities(
    country = "ES",
    province = "MURCIA"
  ))
  expect_s3_class(n, "data.frame")
})
test_that("gisco_addressapi_roads online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_roads(
    country = "ES",
    province = "CASTILLA Y LEON",
    city = "CODORNIZ"
  ))
  expect_s3_class(n, "data.frame")
})
test_that("gisco_addressapi_housenumbers online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_housenumbers(
    country = "ES",
    province = "MADRID",
    city = "MADRID",
    road = "USERA",
    postcode = 28019
  ))
  expect_s3_class(n, "data.frame")
})
test_that("gisco_addressapi_postcodes online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_postcodes(
    country = "ES",
    province = "CASTILLA Y LEON",
    city = "CODORNIZ"
  ))
  expect_s3_class(n, "data.frame")
})

test_that("gisco_addressapi_copyright online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_copyright())
  expect_s3_class(n, "data.frame")
})
