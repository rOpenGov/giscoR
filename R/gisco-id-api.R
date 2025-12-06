#' GISCO ID service API
#'
#' @description
#' Functions to interact with the [GISCO ID service
#' API](https://gisco-services.ec.europa.eu/id/api-docs/), which returns
#' attributes and, optionally, geometry for different datasets at specified
#' longitude and latitude coordinates.
#'
#' Each endpoint available is implemented through a specific function, see
#' **Details**.
#'
#' @name gisco_id_api
#' @rdname gisco_id_api
#' @inheritParams gisco_address_api
#' @family API tools
#' @export
#'
#' @source
#' <https://gisco-services.ec.europa.eu/id/api-docs/>.
#'
#' @param x,y character string or numeric. x and y coordinates (as longitude
#'   and latitude) to be identified.
#' @param xmin,ymin,xmax,ymax character string or numeric. Bounding box
#'   coordinates to identify all geonames within the box.
#' @param nuts_id character. NUTS ID code.
#' @param epsg character string or numeric. EPSG code for the coordinate
#'   reference system.
#' @param geometry logical. Whether to return geometry. On `TRUE` a
#'   [`sf`][sf::st_sf] object would be returned. On `FALSE` a
#'   [tibble][tibble::tbl_df] would be returned.
#' @param year character string or numeric. Year of the dataset, see
#'   **Details**.
#' @param nuts_level character string. NUTS level. One of `0`,
#'   `1`, `2` or `3`.
#'
#' @returns
#' A [tibble][tibble::tbl_df] or a [`sf`][sf::st_sf] object.
#'
#' @details
#' The available endpoints are:
#'
#' * `gisco_id_api_geonames()`: Get geographic placenames either from x/y
#'   coordinates or a bounding box.
#' * `gisco_id_api_nuts()`: Returns NUTS regions from either a specified
#'   longitude and latitude (x,y) or id. Accepted `year`
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("nuts")}.
#' * `gisco_id_api_lau()`: Returns the id and - optionally - geometry for Large
#'   Urban Areas (LAU) at specified longitude and latitude (x,y). Accepted
#'   `year`
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("lau")}.
#' * `gisco_id_api_country()`: Returns the id and - optionally - geometry for
#'   countries at specified longitude and latitude (x,y). Accepted `year`
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("country")}.
#' * `gisco_id_api_river_basin()`: Returns the id and - optionally - geometry
#'   for river basins at specified longitude and latitude (x,y), based on the
#'   Water Framework Directive (WFD) reference spatial data sets. Accepted
#'   `year`
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("riverbasin")}.
#' * `gisco_id_api_biogeo_region()`: Returns the id and - optionally - geometry
#'   for biogeo regions at specified longitude and latitude (x,y). The
#'  biogeographical regions dataset contains the official delineations used in
#'  the Habitats Directive (92/43/EEC) and for the EMERALD Network. Accepted
#'  `year`
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("biogeoregion")}.
#' * `gisco_id_api_census_grid()`: Returns the id and - optionally - geometry
#'   for census grid cells at specified longitude and latitude (x,y). Accepted
#'    `year`
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("censusgrid")}.
#' @seealso
#' [gisco_get_nuts()], [gisco_get_lau()], [gisco_get_countries()],
#' [gisco_get_census()].
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#' gisco_id_api_geonames(x = -2.5, y = 43.06)
#'
#' lau <- gisco_id_api_lau(x = -2.5, y = 43.06)
#' nuts3 <- gisco_id_api_nuts(x = -2.5, y = 43.06, nuts_level = 3)
#'
#' if (all(!is.null(lau), !is.null(nuts3))) {
#'   library(ggplot2)
#'
#'   ggplot(nuts3) +
#'     geom_sf(fill = "lightblue", color = "black") +
#'     geom_sf(data = lau, fill = "orange", color = "red") +
#'     labs(
#'       title = "NUTS3 and LAU boundaries",
#'       subtitle = "Arrasate, Basque Country, Spain",
#'       caption = "Source: GISCO ID service API"
#'     )
#' }
#' }
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

#' @rdname gisco_id_api
#' @export
gisco_id_api_nuts <- function(
  x = NULL,
  y = NULL,
  year = 2024,
  epsg = c(4326, 4258, 3035),
  verbose = FALSE,
  nuts_id = NULL,
  nuts_level = NULL,
  geometry = TRUE
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

#' @rdname gisco_id_api
#' @export
gisco_id_api_lau <- function(
  x,
  y,
  year = 2024,
  epsg = c(4326, 4258, 3035),
  verbose = FALSE,
  geometry = TRUE
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

#' @rdname gisco_id_api
#' @export
gisco_id_api_country <- function(
  x,
  y,
  year = 2024,
  epsg = c(4326, 4258, 3035),
  verbose = FALSE,
  geometry = TRUE
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

#' @rdname gisco_id_api
#' @export
gisco_id_api_river_basin <- function(
  x,
  y,
  year = 2019,
  epsg = c(4326, 4258, 3035),
  verbose = FALSE,
  geometry = TRUE
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

#' @rdname gisco_id_api
#' @export
gisco_id_api_biogeo_region <- function(
  x,
  y,
  year = 2016,
  epsg = c(4326, 4258, 3035),
  verbose = FALSE,
  geometry = TRUE
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

#' @rdname gisco_id_api
#' @export
gisco_id_api_census_grid <- function(
  x,
  y,
  year = 2021,
  epsg = c(4326, 4258, 3035),
  verbose = FALSE,
  geometry = TRUE
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
