#' GISCO Address API
#'
#' @description
#' Functions to interact with the [GISCO Address
#' API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home), which
#' supports geocoding and reverse geocoding with a pan-European address
#' database.
#'
#' Each endpoint supported by \CRANpkg{giscoR} has a specific function. See
#' **Details**. Search supports structured queries and freeform queries with
#' `q`. Autocomplete through `/search?suggest=` is not implemented in
#' \CRANpkg{giscoR}.
#'
#' Structured searches support approximate string matching. The API's
#' freeform query parameter `q` does not support approximate string matching.
#'
#' @name gisco_address_api
#' @rdname gisco_address_api
#' @aliases gisco_addressapi
#' @family api
#'
#' @inheritParams gisco_get_countries verbose
#' @param country A country code (`country = "LU"`).
#' @param x,y Longitude and latitude coordinates to convert into
#'   human-readable addresses. Reverse geocoding returns at most five results.
#' @param province A province within a country. This is a generic term whose
#'   administrative level varies by country. For a list of provinces within a
#'   country, use the provinces endpoint
#'   (`gisco_address_api_provinces(country = "LU")`).
#' @param city A city within a province. This is a generic term whose
#'   administrative level varies by country. For a list of cities within a
#'   province, use the cities endpoint
#'   (`gisco_address_api_cities(province = "capellen")`).
#' @param road A road within a city.
#' @param housenumber The house number or house name within a road or street.
#' @param postcode A postcode to use with the previous arguments.
#' @param q A single non-empty string for a freeform address search, or `NULL`
#'   for a structured search. The string can contain a street, house number,
#'   city or postcode. Freeform queries do not support approximate matching.
#'
#' @return
#' A [tibble][tibble::tbl_df] in most cases, except
#' `gisco_address_api_search()`, `gisco_address_api_reverse()` and
#' `gisco_address_api_bbox()`, which return an [`sf`][sf::st_sf] object when
#' geometry is available. Searches with no results return an empty
#' [tibble][tibble::tbl_df]. `gisco_address_api_bbox()` returns `NULL` when
#' no bounding box is found. Failed requests return `NULL`.
#'
#' `gisco_address_api_most_populated_cell()` returns a one-row
#' [tibble][tibble::tbl_df] for the most populated census grid cell, or `NULL`
#' when no cell is found or the request fails. Its numeric `X` and `Y` columns
#' preserve the API coordinates, whose CRS is not specified in the API
#' documentation.
#'
#' @details
#'
#' For `gisco_address_api_most_populated_cell()`, supply a non-empty string
#' for `province` or `city`. If both are supplied, the search is restricted
#' to the city within the province.
#'
#' ```{r child = "man/chunks/address_api.Rmd"}
#' ```
#'
#' @source
#' <https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.
#'
#' @seealso
#' [gisco_id_api] for GISCO ID service API lookups.
#'
#' See the GISCO Address API documentation at
#' <https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.
#'
#' @encoding UTF-8
#' @export
#' @examplesIf gisco_check_access()
#' # Cities in a region.
#'
#' gisco_address_api_cities(country = "PT", province = "LISBOA")
#'
#' # Geocode and reverse geocode with `sf` objects.
#' # Structured search.
#' struct <- gisco_address_api_search(
#'   country = "LU", city = "Luxembourg",
#'   road = "Rue Alphonse Weicker"
#' )
#'
#' struct
#'
#' # Freeform search.
#' gisco_address_api_search(q = "alphonse weicker luxembourg")
#'
#' # Reverse geocoding.
#' reverse <- gisco_address_api_reverse(x = struct$X[1], y = struct$Y[1])
#'
#' reverse
#'
#' # Most populated census grid cell in Madrid.
#' gisco_address_api_most_populated_cell(city = "Madrid")
gisco_address_api_search <- function(
  country = NULL,
  province = NULL,
  city = NULL,
  road = NULL,
  housenumber = NULL,
  postcode = NULL,
  verbose = FALSE,
  q = NULL
) {
  cli_abort_if_not(
    "{.arg q} must be a non-empty string or NULL." = is.null(q) ||
      is.character(q) && length(q) == 1L && !is.na(q) && nzchar(trimws(q))
  )

  apiurl <- paste0(gisco_address_url(), "search?")
  custom_query <- list(
    country = country,
    province = province,
    city = city,
    road = road,
    housenumber = housenumber,
    postcode = postcode,
    q = q
  )

  call_address_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_address_api
#' @export
gisco_address_api_reverse <- function(x, y, country = NULL, verbose = FALSE) {
  apiurl <- paste0(gisco_address_url(), "reverse?")
  custom_query <- list(x = x, y = y, country = country)

  call_address_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_address_api
#' @export
gisco_address_api_bbox <- function(
  country = NULL,
  province = NULL,
  city = NULL,
  road = NULL,
  postcode = NULL,
  verbose = FALSE
) {
  apiurl <- paste0(gisco_address_url(), "bbox?")
  custom_query <- list(
    country = country,
    province = province,
    city = city,
    road = road,
    postcode = postcode
  )

  res <- call_address_api(custom_query, apiurl, verbose)

  if (is.null(res) || nrow(res) == 0 || is.null(res$bbox) || anyNA(res$bbox)) {
    cli::cli_alert_warning("No results found. Returning {.val NULL}.")

    return(NULL)
  }

  # Create polygon from WKT.
  wkt_str <- res$bbox

  wkt_str <- gsub("[A-Za-z]|\\(|\\)", "", wkt_str)

  bbox <- as.double(unlist(strsplit(wkt_str, " |,")))

  # Create a template bounding box class.
  mock <- sf::st_as_sfc("POINT (10 10)", crs = 4326)
  bboxclass <- sf::st_bbox(mock)
  # Add the input values.
  bboxclass[1:4] <- bbox

  bbox <- sf::st_as_sfc(bboxclass)
  res <- sf::st_sf(x = "bbox", geometry = bbox)
  res <- sanitize_sf(res)
  res
}

#' @rdname gisco_address_api
#' @export
gisco_address_api_countries <- function(verbose = FALSE) {
  apiurl <- paste0(gisco_address_url(), "countries")

  res <- call_address_api(list(NULL), apiurl, verbose)
  if (is.null(res)) {
    return(res)
  }
  res <- tibble::tibble(L0 = unlist(res[, 1]))

  res
}

#' @rdname gisco_address_api
#' @export
gisco_address_api_provinces <- function(
  country = NULL,
  city = NULL,
  verbose = FALSE
) {
  apiurl <- paste0(gisco_address_url(), "provinces?")
  custom_query <- list(country = country, city = city)

  call_address_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_address_api
#' @export
gisco_address_api_cities <- function(
  country = NULL,
  province = NULL,
  verbose = FALSE
) {
  apiurl <- paste0(gisco_address_url(), "cities?")
  custom_query <- list(country = country, province = province)

  call_address_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_address_api
#' @export
gisco_address_api_roads <- function(
  country = NULL,
  province = NULL,
  city = NULL,
  verbose = FALSE
) {
  apiurl <- paste0(gisco_address_url(), "roads?")
  custom_query <- list(country = country, province = province, city = city)

  call_address_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_address_api
#' @export
gisco_address_api_housenumbers <- function(
  country = NULL,
  province = NULL,
  city = NULL,
  road = NULL,
  postcode = NULL,
  verbose = FALSE
) {
  apiurl <- paste0(gisco_address_url(), "housenumbers?")
  custom_query <- list(
    country = country,
    province = province,
    city = city,
    road = road,
    postcode = postcode
  )

  call_address_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_address_api
#' @export
gisco_address_api_postcodes <- function(
  country = NULL,
  province = NULL,
  city = NULL,
  verbose = FALSE
) {
  apiurl <- paste0(gisco_address_url(), "postcodes?")
  custom_query <- list(country = country, province = province, city = city)

  call_address_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_address_api
#' @export
gisco_address_api_copyright <- function(verbose = FALSE) {
  apiurl <- paste0(gisco_address_url(), "copyright")
  call_address_api(custom_query = NULL, apiurl, verbose)
}

#' @rdname gisco_address_api
#' @export
# nolint start: object_length_linter.
gisco_address_api_most_populated_cell <- function(
  province = NULL,
  city = NULL,
  verbose = FALSE
) {
  # nolint end: object_length_linter.
  cli_abort_if_not(
    "{.arg province} must be a non-empty string or NULL." = is.null(province) ||
      is.character(province) &&
        length(province) == 1L &&
        !is.na(province) &&
        nzchar(trimws(province)),
    "{.arg city} must be a non-empty string or NULL." = is.null(city) ||
      is.character(city) &&
        length(city) == 1L &&
        !is.na(city) &&
        nzchar(trimws(city)),
    "Supply {.arg province} or {.arg city}." = !is.null(province) ||
      !is.null(city),
    "{.arg verbose} must be logical." = is_bool(verbose)
  )

  url <- httr2::url_modify(
    paste0(gisco_address_url(), "most-populated-cell"),
    query = as.list(unlist(list(province = province, city = city)))
  )
  resp <- get_request_body(url, verbose)
  if (is.null(resp) || !httr2::resp_has_body(resp)) {
    return(NULL)
  }

  cell <- gisco_resp_body_json(resp, simplifyVector = TRUE)
  if (is.null(cell)) {
    return(NULL)
  }

  cell <- lapply(cell, function(x) {
    if (is.null(x)) NA else x
  })
  xy <- as.double(cell$XY)
  cell$XY <- NULL
  cell$X <- xy[1]
  cell$Y <- xy[2]
  tibble::as_tibble(cell)
}

#' Prepare and call the Address API
#'
#' @param custom_query A named list with the query arguments.
#' @param apiurl The API endpoint URL.
#' @param verbose A logical value indicating whether to print verbose output.
#'
#' @return
#' An [`sf`][sf::st_sf] object or a [tibble][tibble::tbl_df]. Failed requests
#' return `NULL`.
#'
#' @noRd
call_address_api <- function(
  custom_query,
  apiurl,
  verbose = FALSE,
  .envir = parent.frame()
) {
  cli_abort_if_not(
    "{.arg verbose} must be logical." = is_bool(verbose),
    .envir = .envir
  )

  resp_df <- call_gisco_json_api(custom_query, apiurl, "results", verbose)
  if (is.null(resp_df)) {
    return(NULL)
  }

  if (!"XY" %in% names(resp_df)) {
    return(resp_df)
  }

  # Convert responses with XY coordinates to sf.
  xy_coords <- as.data.frame(matrix(unlist(resp_df$XY), ncol = 2, byrow = TRUE))
  names(xy_coords) <- c("X", "Y")
  resp_df <- cbind(resp_df, xy_coords)
  resp_df <- resp_df[setdiff(names(resp_df), "XY")]
  geometry <- sf::st_as_sf(xy_coords, coords = c("X", "Y"), crs = 4326)
  resp_sf <- sf::st_as_sf(resp_df, geometry = sf::st_geometry(geometry))
  resp_sf <- sanitize_sf(resp_sf)
  resp_sf
}

# Export alias ----

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_bbox <- gisco_address_api_bbox

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_cities <- gisco_address_api_cities

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_copyright <- gisco_address_api_copyright

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_countries <- gisco_address_api_countries

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_housenumbers <- gisco_address_api_housenumbers

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_postcodes <- gisco_address_api_postcodes

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_provinces <- gisco_address_api_provinces

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_reverse <- gisco_address_api_reverse

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_roads <- gisco_address_api_roads

#' @rdname gisco_address_api
#' @usage NULL
#' @export
gisco_addressapi_search <- gisco_address_api_search
