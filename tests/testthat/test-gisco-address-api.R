test_that("Address API returns NULL when connection fails", {
  local_mocked_bindings(gisco_req_perform = mock_connection_failure)

  expect_snapshot(fend <- gisco_address_api_bbox())
  expect_null(fend)
})

test_that("Address API returns NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(n <- gisco_address_api_bbox())
  expect_null(n)

  expect_snapshot(n <- gisco_address_api_cities())

  expect_snapshot(n <- gisco_address_api_copyright())
  expect_null(n)

  expect_snapshot(n <- gisco_address_api_housenumbers())
  expect_null(n)

  expect_snapshot(n <- gisco_address_api_postcodes())
  expect_null(n)

  expect_snapshot(n <- gisco_address_api_provinces())
  expect_null(n)

  expect_snapshot(n <- gisco_address_api_reverse(x = 0, y = 0))
  expect_null(n)

  expect_snapshot(n <- gisco_address_api_roads())
  expect_null(n)

  expect_snapshot(n <- gisco_address_api_search())
  expect_null(n)

  expect_snapshot(n <- gisco_address_api_countries())
  expect_null(n)

  expect_snapshot(n <- gisco_address_api_copyright())
  expect_null(n)
})

test_that("gisco_address_api_bbox online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(n <- gisco_address_api_bbox(country = "ES", city = "NIEVA"))
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
    "No results found. Returning"
  )

  expect_null(n)
})

test_that("gisco_address_api_search online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_address_api_search(
      country = "LU",
      city = "Luxembourg",
      road = "Rue Alphonse Weicker"
    )
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")

  expect_null(gisco_address_api_search(country = "ES"))

  expect_null(gisco_address_api_search(country = "XYZ"))
})

test_that("gisco_address_api_reverse preserves empty responses", {
  local_mocked_bindings(
    get_request_body = function(...) {
      httr2::response(
        headers = list(`content-type` = "application/json"),
        body = charToRaw('{"results":[]}')
      )
    }
  )

  n <- gisco_address_api_reverse(-10, -30)

  expect_s3_class(n, "tbl_df")
  expect_shape(n, nrow = 0)
})

test_that("gisco_address_api_reverse online", {
  skip_on_cran()
  skip_if_gisco_offline()
  expect_silent(
    n <- gisco_address_api_reverse(x = 14.90691902084116, y = 49.63074884786084)
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_equal(setdiff(c("X", "Y"), names(n)), character(0))

  expect_gt(nrow(n), 0)
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
    n <- gisco_address_api_cities(country = "ES", province = "MURCIA")
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

test_that("most populated cell scopes queries and preserves API coordinates", {
  queries <- list()
  local_mocked_bindings(
    get_request_body = function(url, verbose) {
      parsed <- httr2::url_parse(url)
      expect_match(parsed$path, "/most-populated-cell$")
      queries[[length(queries) + 1L]] <<- parsed$query
      httr2::response(
        headers = list(`content-type` = "application/json"),
        body = charToRaw(paste0(
          '{"L1":"MADRID","L2":"MADRID","L0":"ES","I3":"ESP",',
          '"XY":[3159500,2027500],"OL":"CRX2X2X2+X2X"}'
        ))
      )
    }
  )

  cell <- gisco_address_api_most_populated_cell(city = "Madrid")
  gisco_address_api_most_populated_cell(province = "Castilla y Leon")
  gisco_address_api_most_populated_cell(province = "Madrid", city = "Madrid")

  expect_identical(
    queries,
    list(
      list(city = "Madrid"),
      list(province = "Castilla y Leon"),
      list(province = "Madrid", city = "Madrid")
    )
  )
  expect_s3_class(cell, "tbl_df")
  expect_equal(nrow(cell), 1L)
  expect_identical(cell$L0, "ES")
  expect_identical(cell$I3, "ESP")
  expect_identical(cell$X, 3159500)
  expect_identical(cell$Y, 2027500)
  expect_equal(intersect(names(cell), "XY"), character())
})

test_that("most populated cell returns NULL without a result", {
  local_mocked_bindings(get_request_body = function(...) NULL)
  expect_null(gisco_address_api_most_populated_cell(city = "Madrid"))

  local_mocked_bindings(
    get_request_body = function(...) {
      httr2::response(
        headers = list(`content-type` = "application/json"),
        body = charToRaw("null")
      )
    }
  )
  expect_null(gisco_address_api_most_populated_cell(city = "Unknown"))

  local_mocked_bindings(
    get_request_body = function(...) {
      httr2::response(body = raw())
    }
  )
  expect_null(gisco_address_api_most_populated_cell(city = "Unknown"))
})

test_that("most populated cell validates its inputs before requesting data", {
  local_mocked_bindings(get_request_body = function(...) {
    stop("Unexpected request", call. = FALSE)
  })

  expect_error(gisco_address_api_most_populated_cell(), class = "giscoR_error")
  for (invalid in list("", " ", NA_character_, c("A", "B"), 1, character())) {
    expect_error(
      gisco_address_api_most_populated_cell(city = invalid),
      class = "giscoR_error"
    )
    expect_error(
      gisco_address_api_most_populated_cell(province = invalid),
      class = "giscoR_error"
    )
  }
  expect_error(
    gisco_address_api_most_populated_cell(city = "Madrid", verbose = NA),
    class = "giscoR_error"
  )
})

test_that("most populated cell online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(cell <- gisco_address_api_most_populated_cell(city = "Madrid"))
  expect_s3_class(cell, "tbl_df")
  expect_equal(nrow(cell), 1L)
  expect_identical(cell$L0, "ES")
  expect_type(cell$X, "double")
  expect_type(cell$Y, "double")
  expect_length(cell$X, 1L)
  expect_length(cell$Y, 1L)
})

test_that("most populated cell retains nullable metadata in one row", {
  local_mocked_bindings(
    get_request_body = function(...) {
      httr2::response(
        headers = list(`content-type` = "application/json"),
        body = charToRaw('{"L1":null,"L2":"MADRID","XY":[3159500,2027500]}')
      )
    }
  )

  cell <- gisco_address_api_most_populated_cell(city = "Madrid")

  expect_equal(nrow(cell), 1L)
  expect_identical(cell$L1, NA)
  expect_identical(cell$L2, "MADRID")
  expect_identical(cell$X, 3159500)
  expect_identical(cell$Y, 2027500)
  expect_equal(intersect(names(cell), "XY"), character())
})

test_that("freeform searches encode query text and return address points", {
  urls <- character()
  local_mocked_bindings(
    get_request_body = function(url, verbose) {
      urls <<- c(urls, url)
      httr2::response(
        headers = list(`content-type` = "application/json"),
        body = charToRaw(paste0(
          '{"count":1,"results":[{"L0":"LU","TF":"RUE ALPHONSE WEICKER",',
          '"XY":[6.1696,49.6317]}]}'
        ))
      )
    }
  )

  address <- gisco_address_api_search(q = "Rue de l'Église & 6")
  gisco_address_api_search(q = "alphonse weicker", country = "LU")

  expect_identical(
    httr2::url_parse(urls[1])$query,
    list(q = "Rue de l'Église & 6")
  )
  expect_identical(
    httr2::url_parse(urls[2])$query,
    list(country = "LU", q = "alphonse weicker")
  )
  expect_s3_class(address, "sf")
  expect_equal(nrow(address), 1L)
  expect_identical(address$L0, "LU")
  expect_equal(address$X, 6.1696)
  expect_equal(address$Y, 49.6317)
  expect_equal(
    unname(sf::st_coordinates(address)),
    matrix(c(6.1696, 49.6317), 1)
  )
  expect_equal(sf::st_crs(address)$epsg, 4326)
})

test_that("search keeps its existing positional arguments", {
  query <- NULL
  local_mocked_bindings(
    get_request_body = function(url, verbose) {
      query <<- httr2::url_parse(url)$query
      httr2::response(
        headers = list(`content-type` = "application/json"),
        body = charToRaw('{"results":[]}')
      )
    }
  )

  result <- gisco_address_api_search(
    "LU",
    "Luxembourg",
    "Luxembourg",
    "Rue Alphonse Weicker",
    "6",
    "2721",
    FALSE
  )

  expect_identical(
    query,
    list(
      country = "LU",
      province = "Luxembourg",
      city = "Luxembourg",
      road = "Rue Alphonse Weicker",
      housenumber = "6",
      postcode = "2721"
    )
  )
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0L)
})

test_that("freeform searches validate query text before requesting data", {
  local_mocked_bindings(get_request_body = function(...) {
    stop("Unexpected request", call. = FALSE)
  })

  for (invalid in list("", " ", NA_character_, c("A", "B"), 1, character())) {
    expect_error(gisco_address_api_search(q = invalid), class = "giscoR_error")
  }
})

test_that("freeform search online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(
    address <- gisco_address_api_search(q = "alphonse weicker luxembourg")
  )
  expect_s3_class(address, "sf")
  expect_gt(nrow(address), 0L)
  expect_equal(sf::st_crs(address)$epsg, 4326)
  expect_contains(address$L0, "LU")
})

test_that("freeform searches handle empty results and failed requests", {
  local_mocked_bindings(
    get_request_body = function(...) {
      httr2::response(
        headers = list(`content-type` = "application/json"),
        body = charToRaw('{"count":0,"results":[]}')
      )
    }
  )

  address <- gisco_address_api_search(q = "Unknown address")
  expect_s3_class(address, "tbl_df")
  expect_equal(nrow(address), 0L)

  local_mocked_bindings(get_request_body = function(...) NULL)
  expect_null(gisco_address_api_search(q = "Unknown address"))
})
