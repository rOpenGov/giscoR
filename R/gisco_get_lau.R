#' Get GISCO urban areas `sf` polygons, points and lines
#'
#' @description
#' [gisco_get_communes()] and [gisco_get_lau()] download shapes of Local
#' Urban Areas, that correspond roughly with towns and cities.
#'
#' @order 2
#'
#' @note
#' Please check the download and usage provisions on [gisco_attributions()].
#' @concept political
#'
#' @return A `sf` object specified by `spatialtype`. In the case of
#'   [gisco_get_lau()], a `POLYGON` object.
#'
#' @param year Release year of the file. See Details.
#'
#' @param gisco_id Optional. A character vector of GISCO_ID LAU values.
#'
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#'
#' @details
#' Valid years for eacg function are:
#' * **`gisco_get_communes`**: one of "2001", "2004", "2006", "2008", "2010",
#' "2013" or "2016".
#' * **`gisco_get_lau`**: one of "2016", "2017", "2018" or "2019"
#'
#' @export
gisco_get_lau <- function(year = "2016",
                          epsg = "4326",
                          cache = TRUE,
                          update_cache = FALSE,
                          cache_dir = NULL,
                          verbose = FALSE,
                          country = NULL,
                          gisco_id = NULL) {
  ext <- "geojson"

  geturl <- gsc_api_url(
    id_giscoR = "lau",
    year = year,
    epsg = epsg,
    resolution = 0,
    # Not neccesary
    spatialtype = "RG",
    ext = ext,
    nuts_level = NULL,
    level = NULL,
    verbose = verbose
  )

  # nocov start
  # There are not data file on this
  dwnload <- TRUE
  if (dwnload) {
    if (cache) {
      # Guess source to load
      namefileload <-
        gsc_api_cache(
          geturl$api_url,
          geturl$namefile,
          cache_dir,
          update_cache,
          verbose
        )
    } else {
      namefileload <- geturl$api_url
    }

    # Load - geojson only so far
    data_sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }

  if (!is.null(country) & "CNTR_CODE" %in% names(data_sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }

  if (!is.null(country) & "CNTR_ID" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_ID %in% country, ]
  }

  if (!is.null(gisco_id) & "GISCO_ID" %in% names(data_sf)) {
    data_sf <- data_sf[data_sf$GISCO_ID %in% gisco_id, ]
  }
  return(data_sf)
  # nocov end
}


#' @rdname gisco_get_lau
#' @name gisco_get_lau
#'
#' @order 1
#'
#' @examples
#' \donttest{
#' if (gisco_check_access()) {
#'   ire_lau <- gisco_get_communes(spatialtype = "LB", country = "Ireland")
#'
#'   library(ggplot2)
#'
#'   ggplot(ire_lau) +
#'     geom_sf(shape = 21, col = "#009A44", size = 0.5) +
#'     labs(
#'       title = "Communes in Ireland",
#'       subtitle = "Year 2016",
#'       caption = gisco_attributions()
#'     ) +
#'     theme_void() +
#'     theme(text = element_text(colour = "#009A44", family = "serif", face = "bold"))
#' }
#' }
#' @export
gisco_get_communes <- function(year = "2016",
                               epsg = "4326",
                               cache = TRUE,
                               update_cache = FALSE,
                               cache_dir = NULL,
                               verbose = FALSE,
                               spatialtype = "RG",
                               country = NULL) {
  ext <- "geojson"

  geturl <- gsc_api_url(
    id_giscoR = "communes",
    year = year,
    epsg = epsg,
    resolution = 0,
    # Not neccesary
    spatialtype = spatialtype,
    ext = ext,
    nuts_level = NULL,
    level = NULL,
    verbose = verbose
  )
  # There are not data file on this
  dwnload <- TRUE
  if (dwnload) {
    if (cache) {
      # Guess source to load
      namefileload <-
        gsc_api_cache(
          geturl$api_url,
          geturl$namefile,
          cache_dir,
          update_cache,
          verbose
        )
    } else {
      namefileload <- geturl$api_url
    }

    # Load - geojson only so far
    data_sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }

  if (!is.null(country) & "CNTR_CODE" %in% names(data_sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }
  return(data_sf)
}
