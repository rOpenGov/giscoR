#' GISCO Address API
#'
#' @description
#' Functions to interact with the [GISCO Address
#' API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home), which
#' supports geocoding and reverse geocoding with a pan-European address
#' database.
#'
#' Each endpoint is implemented through a specific function. See **Details**.
#'
#' The API supports fuzzy searching, also referred to as approximate string
#' matching, for all arguments of each endpoint.
#'
#' @name gisco_address_api
#' @rdname gisco_address_api
#' @aliases gisco_addressapi
#' @family API tools
#' @encoding UTF-8
#'
#' @inheritParams gisco_get_nuts
#' @param country A country code (`country = "LU"`).
#' @param x,y Longitude and latitude coordinates to convert into a
#'   human-readable address.
#' @param province A province within a country. For a list of provinces within
#'   a country, use the provinces endpoint
#'   (`gisco_address_api_provinces(country = "LU")`).
#' @param city A city within a province. For a list of cities within a
#'   province, use the cities endpoint
#'   (`gisco_address_api_cities(province = "capellen")`).
#' @param road A road within a city.
#' @param housenumber The house number or house name within a road or street.
#' @param postcode A postcode to use with the previous arguments.
#'
#' @return
#' A [tibble][tibble::tbl_df] in most cases, except
#' `gisco_address_api_search()`, `gisco_address_api_reverse()` and
#' `gisco_address_api_bbox()`, which return a [`sf`][sf::st_sf] object.
#'
#' @details
#'
#' ```{r child = "man/chunks/address_api.Rmd"}
#' ```
#'
#' @source
#' <https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.
#'
#' @seealso
#' See the GISCO Address API documentation at
#' <https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.
#'
#' @examplesIf gisco_check_access()
#' # Cities in a region.
#'
#' gisco_address_api_cities(country = "PT", province = "LISBOA")
#'
#' # Geocode and reverse geocode with `sf` objects.
#' # Structured search.
#' struct <- gisco_address_api_search(
#'   country = "ES", city = "BARCELONA",
#'   road = "GRACIA"
#' )
#'
#' struct
#'
#' # Reverse geocoding.
#' reverse <- gisco_address_api_reverse(x = struct$X[1], y = struct$Y[1])
#'
#' reverse
#' @export
gisco_address_api_search <- function(
  country = NULL,
  province = NULL,
  city = NULL,
  road = NULL,
  housenumber = NULL,
  postcode = NULL,
  verbose = FALSE
) {
  apiurl <- paste0(gisco_address_url(), "search?")
  custom_query <- list(
    country = country,
    province = province,
    city = city,
    road = road,
    housenumber = housenumber,
    postcode = postcode
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

  if (any(nrow(res) == 0, is.na(res$bbox), is.null(res$bbox))) {
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

#' Prepare and call the Address API
#'
#' @param custom_query A named list with the query arguments.
#' @param apiurl The API endpoint URL.
#' @param verbose A logical value indicating whether to print verbose output.
#'
#' @return
#' A `sf` object or tibble.
#'
#' @noRd
call_address_api <- function(custom_query, apiurl, verbose = FALSE) {
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
