test_that("ID API returns NULL when offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(fend <- gisco_id_api_geonames(x = 4, y = 52))
  expect_null(fend)

  # json
  expect_snapshot(fend <- gisco_id_api_nuts(x = 4, y = 52, geometry = FALSE))
  expect_null(fend)
})

test_that("ID API returns NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(n <- gisco_id_api_geonames(x = 4, y = 52))
  expect_null(n)

  expect_snapshot(n <- gisco_id_api_nuts(x = 4, y = 52, geometry = TRUE))
  expect_null(n)

  expect_snapshot(n <- gisco_id_api_lau(x = 4, y = 52, geometry = TRUE))
  expect_null(n)

  expect_snapshot(n <- gisco_id_api_country(x = 4, y = 52, geometry = FALSE))
  expect_null(n)
})

test_that("ID API delegates GeoJSON responses to the spatial reader", {
  local_mocked_bindings(read_id_api_geojson = function(url, verbose = FALSE) {
    expect_match(url, "format=geojson")
    expect_true(verbose)
    data.frame(id = "ES")
  })

  out <- gisco_id_api_country(x = 1, y = 2, verbose = TRUE)
  expect_identical(out$id, "ES")
})

test_that("ID API delegates JSON responses to the JSON helper", {
  local_mocked_bindings(call_gisco_json_api = function(
    custom_query,
    apiurl,
    result_field,
    verbose = FALSE
  ) {
    expect_identical(custom_query$format, "json")
    expect_identical(custom_query$geometry, "no")
    expect_match(apiurl, "country")
    expect_identical(result_field, "attributes")
    expect_true(verbose)
    data.frame(id = "ES")
  })

  out <- gisco_id_api_country(x = 1, y = 2, geometry = FALSE, verbose = TRUE)
  expect_identical(out$id, "ES")
})

test_that("ID API spatial reader downloads and reads GeoJSON", {
  local_mocked_bindings(
    download_url = function(url,
                            name,
                            cache_dir,
                            subdir,
                            update_cache = FALSE,
                            verbose = FALSE) {
      expect_identical(url, "https://example.com/file.geojson")
      expect_match(name, "[.]geojson$")
      expect_identical(cache_dir, tempdir())
      expect_identical(subdir, "gisco_id_api")
      expect_true(update_cache)
      expect_true(verbose)
      "local.geojson"
    },
    read_geo_file_sf = function(file_local) {
      expect_identical(file_local, "local.geojson")
      data.frame(id = "ES")
    }
  )

  out <- read_id_api_geojson("https://example.com/file.geojson", verbose = TRUE)
  expect_identical(out$id, "ES")
})

test_that("gisco_id_api_geonames online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_id_api_geonames(x = 14.90691902084116, y = 49.63074884786084)
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

  expect_snapshot(n <- gisco_id_api_nuts(nuts_level = 2, epsg = 4258))
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
  expect_true(any(grepl("lau", names(n), fixed = TRUE)))
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
  expect_true(any(grepl("lau", names(n), fixed = TRUE)))
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
  expect_true(any(grepl("sizevalue", names(n), fixed = TRUE)))

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
  expect_true(any(grepl("biogeo", names(n), fixed = TRUE)))

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
  expect_true(any(grepl("grid", names(n), fixed = TRUE)))

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
  expect_true(any(grepl("grid", names(n), fixed = TRUE)))

  expect_s3_class(n, "tbl_df")

  expect_true(inherits(n, "sf"))
})
