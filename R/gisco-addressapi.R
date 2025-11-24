#' GISCO Address API
#'
#' @description
#' Access the [GISCO Address
#' API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home), that
#' allows to carry out both geocoding and reverse geocoding using a pan-european
#' address database.
#'
#' Each endpoint available is implemented through a specific function, see
#' **Details**.
#'
#' The API supports fuzzy searching (also referred to as approximate string
#' matching) for all parameters of each endpoint.
#'
#' @name gisco_addressapi
#' @rdname gisco_addressapi
#'
#' @param country Country code (`country = "LU"`).
#' @param x,y x and y coordinates (as longitude and latitude) to be converted
#'  into a human-readable address.
#' @param province A province within a country. For a list of provinces within a
#'  certain country use the provinces endpoint
#'  (`gisco_addressapi_provinces(country = "LU")`).
#' @param city A city within a province. For a list of cities within a certain
#'   province use the cities endpoint
#'   (`gisco_addressapi_cities(province = "capellen")`).
#' @param road A road within a city.
#' @param housenumber The house number or house name within a road or street.
#' @param postcode Can be used in combination with the previous parameters.
#'
#' @inheritParams gisco_get_nuts
#'
#' @returns
#'
#' A [tibble][tibble::tbl_df] in most cases, except
#' `gisco_addressapi_search()`, `gisco_addressapi_reverse()` and
#' `gisco_addressapi_bbox()`, that return a [`sf`][sf::st_sf] object.
#'
#'
#' @details
#'
#' ```{r child = "man/chunks/addressapi.Rmd"}
#' ```
#'
#' @seealso
#'
#' See the docs:
#' <https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.
#'
#' @family tools
#'
#' @export
#' @examplesIf gisco_check_access()
#' \donttest{
#' # Cities in a region
#'
#' gisco_addressapi_cities(country = "PT", province = "LISBOA")
#'
#'
#' # Geocode and reverse geocode with sf objects
#' # Structured search
#' struct <- gisco_addressapi_search(
#'   country = "ES", city = "BARCELONA",
#'   road = "GRACIA"
#' )
#'
#' struct
#'
#' # Reverse geocoding
#' reverse <- gisco_addressapi_reverse(x = struct$X[1], y = struct$Y[1])
#'
#' reverse
#' }
gisco_addressapi_search <- function(
    country = NULL,
    province = NULL,
    city = NULL,
    road = NULL,
    housenumber = NULL,
    postcode = NULL,
    verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/search?"
  custom_query <- list(
    country = country,
    province = province,
    city = city,
    road = road,
    housenumber = housenumber,
    postcode = postcode
  )

  call_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_addressapi
#' @export
gisco_addressapi_reverse <- function(x, y, country = NULL, verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/reverse?"
  custom_query <- list(
    x = x,
    y = y,
    country = country
  )

  call_api(custom_query, apiurl, verbose)
}


#' @rdname gisco_addressapi
#' @export
gisco_addressapi_bbox <- function(
    country = NULL,
    province = NULL,
    city = NULL,
    road = NULL,
    postcode = NULL,
    verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/bbox?"
  custom_query <- list(
    country = country,
    province = province,
    city = city,
    road = road,
    postcode = postcode
  )

  res <- call_api(custom_query, apiurl, verbose)

  if (any(nrow(res) == 0, is.na(res$bbox), is.null(res$bbox))) {
    cli::cli_alert_warning("No results. Returning {.val NULL}")

    return(NULL)
  }

  # Create polygon from WKT
  wkt_str <- res$bbox

  wkt_str <- gsub("[A-Za-z]|\\(|\\)", "", wkt_str)

  bbox <- as.double(unlist(strsplit(wkt_str, " |,")))

  # Mock class
  mock <- sf::st_as_sfc("POINT (10 10)", crs = 4326)
  bboxclass <- sf::st_bbox(mock)
  # Input values
  bboxclass[1:4] <- bbox

  bbox <- sf::st_as_sfc(bboxclass)
  res <- sf::st_sf(x = "bbox", geometry = bbox)
  res <- gsc_helper_utf8(res)
  res
}

#' @rdname gisco_addressapi
#' @export
gisco_addressapi_countries <- function(verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/countries"

  res <- call_api(list(NULL), apiurl, verbose)
  if (is.null(res)) {
    return(res)
  }
  res <- tibble::tibble(L0 = unlist(res[, 1]))

  res
}

#' @rdname gisco_addressapi
#' @export
gisco_addressapi_provinces <- function(
    country = NULL,
    city = NULL,
    verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/provinces?"
  custom_query <- list(
    country = country,
    city = city
  )

  call_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_addressapi
#' @export
gisco_addressapi_cities <- function(
    country = NULL,
    province = NULL,
    verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/cities?"
  custom_query <- list(
    country = country,
    province = province
  )

  call_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_addressapi
#' @export
gisco_addressapi_roads <- function(
    country = NULL,
    province = NULL,
    city = NULL,
    verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/roads?"
  custom_query <- list(
    country = country,
    province = province,
    city = city
  )

  call_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_addressapi
#' @export
gisco_addressapi_housenumbers <- function(
    country = NULL,
    province = NULL,
    city = NULL,
    road = NULL,
    postcode = NULL,
    verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/housenumbers?"
  custom_query <- list(
    country = country,
    province = province,
    city = city,
    road = road,
    postcode = postcode
  )

  call_api(custom_query, apiurl, verbose)
}


#' @rdname gisco_addressapi
#' @export
gisco_addressapi_postcodes <- function(
    country = NULL,
    province = NULL,
    city = NULL,
    verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/postcodes?"
  custom_query <- list(
    country = country,
    province = province,
    city = city
  )

  call_api(custom_query, apiurl, verbose)
}

#' @rdname gisco_addressapi
#' @export
gisco_addressapi_copyright <- function(verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/copyright"
  call_api(custom_query = NULL, apiurl, verbose)
}

# Helpers
# General ----

call_api <- function(custom_query, apiurl, verbose = FALSE) {
  # Prepare the query
  clean_q <- unlist(custom_query)
  get_url <- httr2::url_modify(apiurl, query = as.list(clean_q))
  if (verbose) {
    cli::cli_alert_info("GET {.url {get_url}}")
  }

  req <- httr2::request(get_url)
  req <- httr2::req_error(req, is_error = function(x) {
    FALSE
  })
  req <- httr2::req_timeout(req, 100000)
  resp <- httr2::req_perform(req)

  # Testing purposes only
  # Mock the behavior of offline
  test_offline <- getOption("giscoR_test_offline", NULL)
  if (any(httr2::resp_is_error(resp), test_offline)) {
    get_status_code <- httr2::resp_status(resp) # nolint
    get_status_desc <- httr2::resp_status_desc(resp) # nolint

    cli::cli_alert_danger(
      c(
        "{.strong Error {.num {get_status_code}}} ({get_status_desc}):",
        " {.url {get_url}}."
      )
    )
    cli::cli_alert_warning(
      c(
        "If you think this is a bug please consider opening an issue on ",
        "{.url https://github.com/ropengov/giscoR/issues}"
      )
    )
    cli::cli_alert("Returning {.val NULL}")
    return(NULL)
  }

  resp_df <- httr2::resp_body_json(resp, simplifyVector = TRUE)
  resp_df <- tibble::as_tibble(resp_df$results)

  if (!"XY" %in% names(resp_df)) {
    return(resp_df)
  }

  # If XY then can convert to sf
  xy_coords <- as.data.frame(matrix(unlist(resp_df$XY), ncol = 2, byrow = TRUE))
  names(xy_coords) <- c("X", "Y")
  resp_df <- cbind(resp_df, xy_coords)
  resp_df <- resp_df[setdiff(names(resp_df), "XY")]
  geometry <- sf::st_as_sf(xy_coords, coords = c("X", "Y"), crs = 4326)
  resp_sf <- sf::st_as_sf(resp_df, geometry = sf::st_geometry(geometry))
  resp_sf <- gsc_helper_utf8(resp_sf)
  resp_sf
}
