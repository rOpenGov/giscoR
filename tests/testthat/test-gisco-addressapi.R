test_that("No conexion", {
  skip_on_cran()
  skip_if_gisco_offline()
  options(gisco_test_off = TRUE)

  expect_snapshot(
    fend <- gisco_addressapi_bbox(),
  )
  expect_null(fend)

  options(gisco_test_off = FALSE)
})


test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  db <- gisco_get_latest_db()
  options(gisco_test_err = TRUE)
  expect_message(
    n <- gisco_addressapi_bbox(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_cities(),
    "Error"
  )

  expect_message(
    n <- gisco_addressapi_copyright(),
    "Error"
  )
  expect_null(n)

  expect_null(n)

  expect_message(
    n <- gisco_addressapi_housenumbers(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_postcodes(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_provinces(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_reverse(x = 0, y = 0),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_roads(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_search(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_countries(),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_addressapi_copyright(),
    "Error"
  )
  expect_null(n)

  options(gisco_test_err = FALSE)
})


test_that("gisco_addressapi_bbox online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_addressapi_bbox(
      country = "Spain",
      city = "NIEVA"
    )
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_message(
    n <- gisco_addressapi_bbox(
      country = "Spain",
      city = "NIEVA",
      verbose = TRUE
    )
  )

  expect_message(n <- gisco_addressapi_bbox("Namibia"), "No results. Returning")

  expect_null(n)
})


test_that("gisco_addressapi_search online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_addressapi_search(
      country = "ES",
      province = "CASTILLA Y LEON",
      city = "NIEVA",
      road = "MAYOR"
    )
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")

  expect_null(gisco_addressapi_search(country = "ES"))

  expect_null(gisco_addressapi_search(country = "XYZ"))
})


test_that("gisco_addressapi_reverse online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_addressapi_reverse(
      x = 14.90691902084116,
      y = 49.63074884786084
    )
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_true(all("X" %in% names(n), "Y" %in% names(n)))

  expect_shape(
    gisco_addressapi_reverse(-10, -30),
    nrow = 0
  )
})


test_that("gisco_addressapi_country online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_countries())
  expect_s3_class(n, "tbl_df")
  expect_identical("L0", names(n))
})

test_that("gisco_addressapi_provinces online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_provinces(country = "LU"))
  expect_s3_class(n, "tbl_df")
})

test_that("gisco_addressapi_cities online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_addressapi_cities(
      country = "ES",
      province = "MURCIA"
    )
  )

  expect_s3_class(n, "tbl_df")
})

test_that("gisco_addressapi_roads online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_addressapi_roads(
      country = "ES",
      province = "CASTILLA Y LEON",
      city = "CODORNIZ"
    )
  )

  expect_s3_class(n, "tbl_df")
})

test_that("gisco_addressapi_housenumbers online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_addressapi_housenumbers(
      country = "ES",
      province = "MADRID",
      city = "MADRID",
      road = "CL MARCELO USERA",
      postcode = 28026
    )
  )

  expect_s3_class(n, "tbl_df")
})

test_that("gisco_addressapi_postcodes online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_addressapi_postcodes(
      country = "ES",
      province = "CASTILLA Y LEON",
      city = "CODORNIZ"
    )
  )

  expect_s3_class(n, "tbl_df")
})

test_that("gisco_addressapi_copyright online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_addressapi_copyright())
  expect_s3_class(n, "tbl_df")
})
