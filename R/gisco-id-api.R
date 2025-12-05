#' GISCO ID service API
#'
#' @description
#' Functions to interact with the [GISCO ID service
#' API](https://gisco-services.ec.europa.eu/id/api-docs/), which returns
#' attributes and, optionally, geometry for different datasets at specified
#' longitude and latitude coordinates.
#'
#' @noRd
gisco_id_api_geonames <- function(
  x = NULL,
  y = NULL,
  xmin = NULL,
  ymin = NULL,
  xmax = NULL,
  ymax = NULL,
  verbose = FALSE
) {
  apiurl <- "https://gisco-services.ec.europa.eu/id/geonames?"
  custom_query <- list(
    x = x,
    y = y,
    xmin = xmin,
    ymin = ymin,
    xmax = xmax,
    ymax = ymax
  )

  call_id_api(custom_query, apiurl, verbose)
}

gisco_id_api_nuts <- function(
  nuts_id = NULL,
  x = NULL,
  y = NULL,
  epsg = c(4326, 4258, 3035),
  geometry = TRUE,
  year = 2024,
  nuts_level = NULL,
  verbose = FALSE
) {
  prepare_id_query(
    nuts_id = nuts_id,
    x = x,
    y = y,
    epsg = epsg,
    geometry = geometry,
    year = year,
    nuts_level = nuts_level,
    verbose = verbose,
    endpoint = "nuts"
  )
}


gisco_id_api_lau <- function(
  x,
  y,
  epsg = c(4326, 4258, 3035),
  geometry = TRUE,
  year = 2024,
  verbose = FALSE
) {
  prepare_id_query(
    x = x,
    y = y,
    epsg = epsg,
    geometry = geometry,
    year = year,
    verbose = verbose,
    endpoint = "lau"
  )
}

gisco_id_api_country <- function(
  x,
  y,
  epsg = c(4326, 4258, 3035),
  geometry = TRUE,
  year = 2024,
  verbose = FALSE
) {
  prepare_id_query(
    x = x,
    y = y,
    epsg = epsg,
    geometry = geometry,
    year = year,
    verbose = verbose,
    endpoint = "country"
  )
}

gisco_id_api_river_basin <- function(
  x,
  y,
  epsg = c(4326, 4258, 3035),
  geometry = TRUE,
  year = 2019,
  verbose = FALSE
) {
  prepare_id_query(
    x = x,
    y = y,
    epsg = epsg,
    geometry = geometry,
    year = year,
    verbose = verbose,
    endpoint = "riverbasin"
  )
}

gisco_id_api_biogeo_region <- function(
  x,
  y,
  epsg = c(4326, 4258, 3035),
  geometry = TRUE,
  year = 2016,
  verbose = FALSE
) {
  prepare_id_query(
    x = x,
    y = y,
    epsg = epsg,
    geometry = geometry,
    year = year,
    verbose = verbose,
    endpoint = "biogeoregion"
  )
}

gisco_id_api_census_grid <- function(
  x,
  y,
  epsg = c(4326, 4258, 3035),
  geometry = TRUE,
  year = 2021,
  verbose = FALSE
) {
  prepare_id_query(
    x = x,
    y = y,
    epsg = epsg,
    geometry = geometry,
    year = year,
    verbose = verbose,
    endpoint = "censusgrid"
  )
}

#' Helper function to prepare the ID API query
#'
#' @param nuts_id NUTS ID code.
#' @param x Longitude coordinate.
#' @param y Latitude coordinate.
#' @param epsg EPSG code for the coordinate reference system.
#' @param geometry Logical. Whether to return geometry.
#' @param year Year of the dataset.
#' @param nuts_level NUTS level.
#' @param verbose Logical. Whether to print verbose output.
#' @param endpoint The specific endpoint to query.
#'
#' @noRd
prepare_id_query <- function(
  nuts_id = NULL,
  x = NULL,
  y = NULL,
  epsg = c(4326, 4258, 3035),
  geometry = TRUE,
  year = 2024,
  nuts_level = NULL,
  verbose = FALSE,
  endpoint
) {
  if (length(nuts_id) > 1) {
    msg <- paste0(
      "{.arg nuts_id} should have length {.val 1}, ",
      "not {.val ",
      length(nuts_id),
      "}."
    )
    make_msg("warning", TRUE, msg)
    msg2 <- paste0("Using {.arg nuts_id = {.str ", nuts_id[1], "}}.")
    make_msg("info", TRUE, msg2)

    nuts_id <- nuts_id[1]
  }

  # Should geometry be returned?
  if (geometry) {
    format <- "geojson"
    geom <- "yes"
  } else {
    format <- "json"
    geom <- "no"
  }

  apiurl <- paste0("https://gisco-services.ec.europa.eu/id/", endpoint, "?")
  custom_query <- list(
    id = nuts_id,
    x = x,
    y = y,
    epsg = match_arg_pretty(epsg),
    year = as.character(year),
    nuts_level = nuts_level,
    format = format,
    geometry = geom
  )

  call_id_api(custom_query, apiurl, verbose)
}


#' Helper function to prepare and call the ID API
#'
#' @param custom_query A named list with the query parameters.
#' @param apiurl The API endpoint URL.
#' @param verbose Logical. Whether to print verbose output.
#'
#' @noRd
call_id_api <- function(custom_query, apiurl, verbose = FALSE) {
  # Identify endpoint
  endpoint <- gsub("?", "", basename(apiurl), fixed = TRUE)

  # Prepare the query
  clean_q <- unlist(custom_query)
  url <- httr2::url_modify(apiurl, query = as.list(clean_q))

  # On spatial download file
  if (any(custom_query$format == "geojson", endpoint == "geonames")) {
    tmp <- basename(tempfile(fileext = ".geojson"))
    resp <- download_url(
      url,
      tmp,
      cache_dir = tempdir(),
      subdir = "gisco_id_api",
      update_cache = TRUE,
      verbose = verbose
    )
    if (is.null(resp)) {
      return(NULL)
    }

    return(read_geo_file_sf(resp))
  }

  resp <- get_request_body(url, verbose)
  if (is.null(resp)) {
    return(NULL)
  }

  resp_df <- httr2::resp_body_json(resp, simplifyVector = TRUE)
  resp_df <- tibble::as_tibble(resp_df$attributes)
  resp_df
}
