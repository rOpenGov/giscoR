#' GISCO ID service API
#'
#' @description
#' Functions to interact with the [GISCO ID service
#' API](https://gisco-services.ec.europa.eu/id/api-docs/), which returns
#' attributes and, optionally, geometry for different datasets at specified
#' longitude and latitude coordinates.
#'
#' Each available endpoint is implemented through a specific function. See
#' **Details**.
#'
#' @name gisco_id_api
#' @rdname gisco_id_api
#' @family API tools
#' @encoding UTF-8
#' @inheritParams gisco_address_api
#' @param x,y A character string or numeric value with the longitude and
#'   latitude coordinates to identify.
#' @param xmin,ymin,xmax,ymax A character string or numeric value with bounding
#'   box coordinates to identify all geonames within the box.
#' @param nuts_id A character value with the NUTS ID code.
#' @param epsg A character string or numeric value with the EPSG code for the
#'   coordinate reference system.
#' @param geometry A logical value indicating whether to return geometry. If
#'   `TRUE`, a [`sf`][sf::st_sf] object is returned. If `FALSE`, a
#'   [tibble][tibble::tbl_df] is returned.
#' @param year A character string or numeric value with the dataset year, see
#'   **Details**.
#' @param nuts_level A character string with the NUTS level. One of `0`,
#'   `1`, `2` or `3`.
#'
#' @return
#' A [tibble][tibble::tbl_df] or a [`sf`][sf::st_sf] object.
#'
#' @details
#' The available endpoints are:
#'
#' - `gisco_id_api_geonames()`: Get geographic placenames from longitude and
#'   latitude coordinates or a bounding box.
#' - `gisco_id_api_nuts()`: Return NUTS regions from longitude and latitude
#'   coordinates or an ID. Accepted values for `year` are
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("nuts")}.
#' - `gisco_id_api_lau()`: Return the ID and, optionally, geometry for Local
#'   Administrative Units (LAU) at specified longitude and latitude coordinates.
#'   Accepted values for `year` are
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("lau")}.
#' - `gisco_id_api_country()`: Return the ID and, optionally, geometry for
#'   countries at specified longitude and latitude coordinates. Accepted values
#'   for `year` are
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("country")}.
#' - `gisco_id_api_river_basin()`: Return the ID and, optionally, geometry
#'   for river basins at specified longitude and latitude coordinates, based on
#'   the Water Framework Directive (WFD) reference spatial datasets. Accepted
#'   values for `year` are
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("riverbasin")}.
#' - `gisco_id_api_biogeo_region()`: Return the ID and, optionally,
#'   geometry for biogeographical regions at specified longitude and latitude
#'   coordinates. The biogeographical regions dataset contains the official
#'   delineations used in the Habitats Directive (92/43/EEC) and for the
#'   EMERALD Network. Accepted values for `year` are
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("biogeoregion")}.
#' - `gisco_id_api_census_grid()`: Return the ID and, optionally, geometry
#'   for census grid cells at specified longitude and latitude coordinates.
#'   Accepted values for `year` are
#'   \Sexpr[stage=render,results=rd]{giscoR:::docs_id_years("censusgrid")}.
#' @source
#' <https://gisco-services.ec.europa.eu/id/api-docs/>.
#'
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
#'       title = "NUTS 3 and LAU boundaries",
#'       subtitle = "Arrasate, Basque Country, Spain",
#'       caption = "Source: GISCO ID service API"
#'     )
#' }
#' }
#' @export
#'
gisco_id_api_geonames <- function(
  x = NULL,
  y = NULL,
  xmin = NULL,
  ymin = NULL,
  xmax = NULL,
  ymax = NULL,
  verbose = FALSE
) {
  apiurl <- paste0(gisco_id_url(), "geonames?")
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

#' Prepare the ID API query
#'
#' @param nuts_id A NUTS ID code.
#' @param x A longitude coordinate.
#' @param y A latitude coordinate.
#' @param epsg A numeric EPSG code for the coordinate reference system.
#' @param geometry A logical value indicating whether to return geometry.
#' @param year A character string or numeric value with the dataset year.
#' @param nuts_level A character string with the NUTS level.
#' @param verbose A logical value indicating whether to print verbose output.
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
      "{.arg nuts_id} should have length {.val {1}}, ",
      "not {.val {",
      length(nuts_id),
      "}}."
    )
    make_msg("warning", TRUE, msg)
    msg2 <- paste0("Using {.arg nuts_id} = {.str ", nuts_id[1], "}.")
    make_msg("info", TRUE, msg2)

    nuts_id <- nuts_id[1]
  }

  # Choose the response format based on geometry.
  if (geometry) {
    format <- "geojson"
    geom <- "yes"
  } else {
    format <- "json"
    geom <- "no"
  }

  apiurl <- paste0(gisco_id_url(), endpoint, "?")
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

#' Prepare and call the ID API
#'
#' @param custom_query A named list with the query arguments.
#' @param apiurl The API endpoint URL.
#' @param verbose A logical value indicating whether to print verbose output.
#'
#' @noRd
call_id_api <- function(custom_query, apiurl, verbose = FALSE) {
  # Identify endpoint.
  endpoint <- gsub("?", "", basename(apiurl), fixed = TRUE)

  # Prepare the query.
  clean_q <- unlist(custom_query)
  url <- httr2::url_modify(apiurl, query = as.list(clean_q))

  # Read spatial download files.
  if (any(custom_query$format == "geojson", endpoint == "geonames")) {
    return(read_id_api_geojson(url, verbose))
  }

  call_gisco_json_api(custom_query, apiurl, "attributes", verbose)
}

#' Download and read an ID API GeoJSON response
#'
#' @param url A GISCO ID service API URL.
#' @param verbose A logical value indicating whether to print verbose output.
#'
#' @return An `sf` object, or `NULL` when the response cannot be downloaded.
#' @noRd
read_id_api_geojson <- function(url, verbose = FALSE) {
  tmp <- basename(tempfile(fileext = ".geojson"))
  file_local <- download_url(
    url,
    tmp,
    cache_dir = tempdir(),
    subdir = "gisco_id_api",
    update_cache = TRUE,
    verbose = verbose
  )
  if (is.null(file_local)) {
    return(NULL)
  }

  read_geo_file_sf(file_local)
}
