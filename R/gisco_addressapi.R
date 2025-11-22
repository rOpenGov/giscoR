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
#' @param country	Country code (`country = "LU"`).
#' @param x,y x and y coordinates (as longitude and latitude) to be converted
#'  into a human-readable address.
#' @param province	A province within a country. For a list of provinces within a
#'  certain country use the provinces endpoint
#'  (`gisco_addressapi_provinces(country = "LU")`).
#' @param city	A city within a province. For a list of cities within a certain
#'   province use the cities endpoint
#'   (`gisco_addressapi_cities(province = "capellen")`).
#' @param road	A road within a city.
#' @param housenumber	The house number or house name within a road or street.
#' @param postcode Can be used in combination with the previous parameters.
#'
#' @inheritParams gisco_get_nuts
#'
#' @returns
#'
#' A `data.frame` object in most cases, except  `gisco_addressapi_search()`,
#' `gisco_addressapi_reverse()` and `gisco_addressapi_bbox()`, that return a
#' [`sf`][sf::st_sf] object.
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
  verbose = FALSE
) {
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
  verbose = FALSE
) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/bbox?"
  custom_query <- list(
    country = country,
    province = province,
    city = city,
    road = road,
    postcode = postcode
  )

  apiurl <- add_custom_query(custom_query, apiurl)
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl,
    filename,
    cache_dir = tempdir(),
    update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(
    namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  res <- as.data.frame(res)
  if (any(nrow(res) == 0, results$count == 0, is.na(res))) {
    message("No results, returning NULL")
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
  res <- sf::st_sf(bbox)
  res <- gsc_helper_utf8(res)

  res
}

#' @rdname gisco_addressapi
#' @export
gisco_addressapi_countries <- function(verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/countries"
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl,
    filename,
    cache_dir = tempdir(),
    update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(
    namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  res <- data.frame(L0 = unlist(res))

  return(res)
}

#' @rdname gisco_addressapi
#' @export
gisco_addressapi_provinces <- function(
  country = NULL,
  city = NULL,
  verbose = FALSE
) {
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
  verbose = FALSE
) {
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
  verbose = FALSE
) {
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
  verbose = FALSE
) {
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
  verbose = FALSE
) {
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
  apiurl <- add_custom_query(custom_query, apiurl)
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl,
    filename,
    cache_dir = tempdir(),
    update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(
    namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  res <- as.data.frame(res)
  res <- tibble::as_tibble(res)
  if (nrow(res) == 0) {
    message("No results, returning NULL")
    return(NULL)
  }

  if ("XY" %in% names(res)) {
    # Extract XY coordinates as matrix
    xy_coords <- as.data.frame(matrix(unlist(res$XY), ncol = 2, byrow = TRUE))
    names(xy_coords) <- c("X", "Y")
    res_clean <- res[, setdiff(names(res), "XY")]
    geometry <- sf::st_as_sf(xy_coords, coords = c("X", "Y"), crs = 4326)

    res_clean <- cbind(res_clean, xy_coords)

    res <- cbind(geometry, res_clean)
    res <- gsc_helper_utf8(res)
  }

  res
}

add_custom_query <- function(custom_query = list(), url) {
  # Remove NULLs and not populated
  custom_query <- custom_query[lengths(custom_query) > 0]

  if (any(length(custom_query) == 0)) {
    return(url)
  }

  # Collapse
  custom_query <- lapply(custom_query, paste0, collapse = ",")

  opts <- paste0(names(custom_query), "=", custom_query, collapse = "&")

  end_url <- paste0(url, opts)

  URLencode(end_url)
}
