test_that("ID API returns NULL when connection fails", {
  local_mocked_bindings(gisco_req_perform = mock_connection_failure)

  expect_snapshot(fend <- gisco_id_api_geonames(x = 4, y = 52))
  expect_null(fend)

  # JSON response.
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

  # Bounding box.
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
  expect_s3_class(n, "sf")
  # EPSG code.
  expect_snapshot(gisco_id_api_nuts(epsg = 222), error = TRUE)

  expect_silent(
    n <- gisco_id_api_nuts(-2.5, 43.06, nuts_level = 2, epsg = 4258)
  )
  expect_identical(n$nuts_id, "ES21")
  expect_equal(n$stat_levl_code, 2L)
  expect_equal(sf::st_crs(n)$epsg, 4258)
  expect_snapshot(
    n <- gisco_id_api_nuts(epsg = 3035, nuts_id = c("ES11", "ES12"))
  )

  expect_s3_class(n, "tbl_df")
  expect_s3_class(n, "sf")
  expect_identical(n$nuts_id, "ES11")
  expect_equal(sf::st_crs(n)$epsg, 3035)

  # Without geometry.
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
  expect_s3_class(n, "sf")
  expect_gt(length(grep("lau", names(n), fixed = TRUE)), 0)
  # EPSG code.
  expect_snapshot(gisco_id_api_lau(epsg = 222, x = 1, y = 1), error = TRUE)

  # Without geometry.
  expect_message(
    n <- gisco_id_api_lau(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_s3_class(n, "tbl_df")
  expect_gt(length(grep("lau", names(n), fixed = TRUE)), 0)
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
  expect_s3_class(n, "sf")
  expect_identical(n$cntr_id, "CZ")
  # EPSG code.
  expect_snapshot(gisco_id_api_country(epsg = 222, x = 1, y = 1), error = TRUE)

  # Without geometry.
  expect_message(
    n <- gisco_id_api_country(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_s3_class(n, "tbl_df")
  expect_identical(n$cntr_id, "CZ")
  expect_false(inherits(n, "sf"))
})

test_that("gisco_id_api_river_basin online", {
  skip_on_cran()
  skip_if_gisco_offline()
  # Without geometry.
  expect_message(
    n <- gisco_id_api_river_basin(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_gt(length(grep("sizevalue", names(n), fixed = TRUE)), 0)

  expect_s3_class(n, "tbl_df")

  expect_false(inherits(n, "sf"))
})

test_that("gisco_id_api_biogeo_region online", {
  skip_on_cran()
  skip_if_gisco_offline()
  # Without geometry.
  expect_message(
    n <- gisco_id_api_biogeo_region(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_gt(nrow(n), 0L)

  expect_s3_class(n, "tbl_df")

  expect_false(inherits(n, "sf"))
})

test_that("gisco_id_api_census_grid online", {
  skip_on_cran()
  skip_if_gisco_offline()
  # Without geometry.
  expect_message(
    n <- gisco_id_api_census_grid(
      x = 14.90691902084116,
      y = 49.63074884786084,
      geometry = FALSE,
      verbose = TRUE
    )
  )
  expect_gt(length(grep("grid", names(n), fixed = TRUE)), 0)

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
  expect_gt(length(grep("grid", names(n), fixed = TRUE)), 0)

  expect_s3_class(n, "tbl_df")

  expect_s3_class(n, "sf")
})

test_that("ID queries warn before truncating NUTS identifiers", {
  local_mocked_bindings(call_id_api = function(custom_query, ...) custom_query)

  expect_warning(
    query <- prepare_id_query(nuts_id = c("ES11", "ES12"), endpoint = "nuts"),
    class = "giscoR_warning_truncated_input"
  )

  expect_identical(query$id, "ES11")
})

test_that("ID queries send the input CRS and NUTS level using API names", {
  query <- NULL
  local_mocked_bindings(
    get_request_body = function(url, verbose) {
      query <<- httr2::url_parse(url)$query
      httr2::response(
        headers = list(`content-type` = "application/json"),
        body = charToRaw(paste0(
          '[{"attributes":{"nuts_id":"ES21","stat_levl_code":2}}]'
        ))
      )
    }
  )

  nuts <- gisco_id_api_nuts(
    x = 3305138,
    y = 2301725,
    epsg = 3035,
    nuts_level = 2,
    geometry = FALSE
  )

  expect_identical(
    query,
    list(
      x = "3305138",
      y = "2301725",
      proj = "3035",
      year = "2024",
      level = "2",
      format = "json",
      geometry = "no"
    )
  )
  expect_identical(nuts$nuts_id, "ES21")
  expect_equal(nuts$stat_levl_code, 2L)
})

test_that("spatial ID queries also send the selected CRS and level", {
  query <- NULL
  local_mocked_bindings(read_id_api_geojson = function(url, verbose) {
    query <<- httr2::url_parse(url)$query
    sf::st_as_sf(
      data.frame(x = -2.5, y = 43.06),
      coords = c("x", "y"),
      crs = 4326
    )
  })

  nuts <- gisco_id_api_nuts(nuts_id = "ES21", epsg = 3035, nuts_level = 2)

  expect_identical(
    query,
    list(
      id = "ES21",
      proj = "3035",
      year = "2024",
      level = "2",
      format = "geojson",
      geometry = "yes"
    )
  )
  expect_s3_class(nuts, "sf")
})

test_that("ID service identifies the same country from projected coordinates", {
  skip_on_cran()
  skip_if_gisco_offline()

  point <- sf::st_as_sf(
    data.frame(x = -2.5, y = 43.06),
    coords = c("x", "y"),
    crs = 4326
  )
  xy <- sf::st_coordinates(sf::st_transform(point, 3035))

  expect_silent(
    country <- gisco_id_api_country(xy[1], xy[2], epsg = 3035, geometry = FALSE)
  )
  expect_identical(country$cntr_id, "ES")

  expect_silent(
    nuts <- gisco_id_api_nuts(-2.5, 43.06, nuts_level = 2, geometry = FALSE)
  )
  expect_identical(nuts$nuts_id, "ES21")
  expect_equal(nuts$stat_levl_code, 2L)
})

test_that("ID GeoJSON reader preserves a projected CRS before validation", {
  file_local <- withr::local_tempfile(fileext = ".geojson")
  writeLines(
    paste0(
      '{"type":"FeatureCollection","features":[{"type":"Feature",',
      '"properties":{"cntr_id":"ES"},"geometry":{"type":"Point",',
      '"crs":{"type":"name","properties":{"name":"EPSG:3035"}},',
      '"coordinates":[3305138,2301725]}}]}'
    ),
    file_local
  )
  local_mocked_bindings(download_url = function(...) file_local)

  expect_silent(
    country <- read_id_api_geojson("https://example.com/country?proj=3035")
  )

  expect_equal(sf::st_crs(country)$epsg, 3035)
  expect_identical(country$cntr_id, "ES")
  expect_equal(
    unname(sf::st_coordinates(country)),
    matrix(c(3305138, 2301725), 1)
  )
})
