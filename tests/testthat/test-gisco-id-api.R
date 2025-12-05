test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  options(gisco_test_offline = TRUE)

  expect_snapshot(
    fend <- gisco_id_api_geonames(x = 4, y = 52)
  )
  expect_null(fend)

  # json
  expect_snapshot(
    fend <- gisco_id_api_nuts(x = 4, y = 52, geometry = FALSE)
  )
  expect_null(fend)

  options(gisco_test_offline = FALSE)
})


test_that("Test 404", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_404 = TRUE)
  expect_message(
    n <- gisco_id_api_geonames(x = 4, y = 52),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_id_api_nuts(x = 4, y = 52, geometry = TRUE),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_id_api_lau(x = 4, y = 52, geometry = TRUE),
    "Error"
  )
  expect_null(n)

  expect_message(
    n <- gisco_id_api_country(x = 4, y = 52, geometry = FALSE),
    "Error"
  )
  expect_null(n)
  options(gisco_test_404 = FALSE)
})


test_that("gisco_id_api_geonames online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_id_api_geonames(
      x = 14.90691902084116,
      y = 49.63074884786084
    )
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")

  # Bbox
  expect_message(
    n <- gisco_id_api_geonames(
      xmin = 14.90691902084116,
      xmax = 15,
      ymin = 49.63074884786084,
      ymax = 50,
      verbose = TRUE
    )
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
})


test_that("gisco_id_api_nuts online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_id_api_nuts(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = TRUE
    )
  )

  expect_s3_class(n, "tbl_df")
  expect_true(inherits(n, "sf"))
  # epsg
  expect_snapshot(gisco_id_api_nuts(epsg = 222), error = TRUE)

  expect_snapshot(
    n <- gisco_id_api_nuts(nuts_level = 2, epsg = 4258)
  )
  expect_null(n)
  expect_snapshot(
    n <- gisco_id_api_nuts(epsg = 3035, nuts_id = c("ES11", "ES12"))
  )

  expect_s3_class(n, "tbl_df")
  expect_true(inherits(n, "sf"))
  expect_identical(n$nuts_id, "ES11")

  # no geometry
  expect_message(
    n <- gisco_id_api_nuts(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_s3_class(n, "tbl_df")

  expect_false(inherits(n, "sf"))
})


test_that("gisco_id_api_lau online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_id_api_lau(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = TRUE
    )
  )

  expect_s3_class(n, "tbl_df")
  expect_true(inherits(n, "sf"))
  expect_true(any(grepl("lau", names(n))))
  # epsg
  expect_snapshot(gisco_id_api_lau(epsg = 222, x = 1, y = 1), error = TRUE)

  # no geometry
  expect_message(
    n <- gisco_id_api_lau(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_s3_class(n, "tbl_df")
  expect_true(any(grepl("lau", names(n))))
  expect_false(inherits(n, "sf"))
})

test_that("gisco_id_api_country online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_id_api_country(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = TRUE
    )
  )

  expect_s3_class(n, "tbl_df")
  expect_true(inherits(n, "sf"))
  expect_identical(n$id, "CZ")
  # epsg
  expect_snapshot(gisco_id_api_country(epsg = 222, x = 1, y = 1), error = TRUE)

  # no geometry
  expect_message(
    n <- gisco_id_api_country(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_s3_class(n, "tbl_df")
  expect_identical(n$id, "CZ")
  expect_false(inherits(n, "sf"))
})

test_that("gisco_id_api_river_basin online", {
  skip_on_cran()
  skip_if_gisco_offline()
  # no geometry
  expect_message(
    n <- gisco_id_api_river_basin(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_true(any(grepl("sizevalue", names(n))))

  expect_s3_class(n, "tbl_df")

  expect_false(inherits(n, "sf"))
})

test_that("gisco_id_api_biogeo_region online", {
  skip_on_cran()
  skip_if_gisco_offline()
  # no geometry
  expect_message(
    n <- gisco_id_api_biogeo_region(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_true(any(grepl("biogeo", names(n))))

  expect_s3_class(n, "tbl_df")

  expect_false(inherits(n, "sf"))
})

test_that("gisco_id_api_census_grid online", {
  skip_on_cran()
  skip_if_gisco_offline()
  # no geometry
  expect_message(
    n <- gisco_id_api_census_grid(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_true(any(grepl("grid", names(n))))

  expect_s3_class(n, "tbl_df")

  expect_false(inherits(n, "sf"))

  # geometry
  expect_silent(
    n <- gisco_id_api_census_grid(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = TRUE,
      verbose = FALSE
    )
  )
  expect_true(any(grepl("grid", names(n))))

  expect_s3_class(n, "tbl_df")

  expect_true(inherits(n, "sf"))
})
