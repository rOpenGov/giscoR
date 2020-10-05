#' @title Download Geospatial Urban Audit Data from GISCO
#' @description Downloads a simple feature (\code{sf}) object.
#' @param year Release year. One of
#'    "2014", "2018" or "2020"
#' @param epsg projection of the map: 4-digit \href{https://spatialreference.org/ref/epsg/}{EPSG code}. One of:
#' \itemize{
#' \item "4326" - WGS84
#' \item "3035" - ETRS89 / ETRS-LAEA
#' \item "3857" - Pseudo-Mercator
#' }
#' @param update_cache a logical whether to update cache.
#' @param cache_dir a path to a cache directory. The directory have to exist.  The \code{NULL} (default) uses and creates \code{/gisco} directory in the temporary directory from \code{\link{tempdir}}. The directory can also be set with \code{options(gisco_cache_dir = <path>)}.
#' @param spatialtype Type of geometry to be returned:
#' \itemize{
#'  \item RG: Regions - Multipolygon
#'  \item LB: Labels - Point
#' }
#' @param level Level of Urban Audit. Possible values are 'CITIES', 'FUA', 'GREATER_CITIES' or \code{NULL}. See Details.
#' @param country Optional. A character vector of country codes. See details.
#' @details \code{level = NULL} would download the whole dataset including all levels
#'
#' \code{country} could be either a vector of country names, a vector of ISO3 country codes or
#' a vector of Eurostat country codes.
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/urau/}{GISCO Urban Audit}
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @return a \code{sf} object.
#' @note Please check the download and usage provisions on \link{gisco_attributions}.
#' @examples
#' \donttest{
#' library(sf)
#'
#' FUA <-
#'   gisco_get_urban_audit(year = "2020",
#'                         epsg = "3035",
#'                         level = "FUA")
#'
#'
#'
#'
#'
#' countries <- gisco_get_countries(year = "2020",
#'                                  epsg = "3035")
#'
#' plot(
#'   st_geometry(countries)  ,
#'   xlim = c(2200000, 7150000),
#'   ylim = c(1380000, 5500000),
#'   col = "grey10",
#'   bgc = "grey30",
#'   border = NA,
#' )
#' box()
#' plot(st_geometry(FUA),
#'      add = TRUE,
#'      col = "darkgoldenrod3",
#'      border = NA,)
#' title(
#'   main = "FUA (Functional Urban Areas) \non Europe (2020)",
#'   sub = gisco_attributions(copyright = FALSE),
#'   cex.main = 0.8,
#'   cex.sub = 0.7,
#'   line = 1
#' )
#' }
#' @export
gisco_get_urban_audit <- function(year = "2018",
                                  epsg = "4326",
                                  update_cache = FALSE,
                                  cache_dir = NULL,
                                  spatialtype = "RG",
                                  level = NULL,
                                  country = NULL) {
  # Check year is of correct format
  year <- as.character(year)
  if (!as.numeric(year) %in% c(2014, 2018, 2020)) {
    stop("Year should be one of 2014, 2018 or 2020")
  }
  # Check crs is of correct format
  crs <- as.character(epsg)
  if (!as.numeric(crs) %in% c(4326, 3035, 3857)) {
    stop("epsg should be one of 4326, 3035 or 3857")
  }
  if (is.null(level)) {
    level <- ""
  }
  # Check level is of correct format
  if (!level %in% c("", "CITIES", "FUA", "GREATER_CITIES")) {
    stop("level should be one of 'CITIES', 'FUA', 'GREATER_CITIES' or NULL")
  }

  # Check spatialtype
  if (!spatialtype %in% c("RG", "LB")) {
    stop("spatialtype should be 'RG' or 'LB'")
  }


  # Downloading data
  filename <-
    gsc_helper_urau_url(year, crs, spatialtype, level)

  url <-
    paste0("https://gisco-services.ec.europa.eu/distribution/v2/urau/geojson/",
           filename)

  data.sf <- gsc_helper_dwnl_caching(cache_dir,
                                     update_cache,
                                     filename,
                                     url, epsg)

  if (!is.null(country) & "CNTR_CODE" %in% names(data.sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data.sf <- data.sf[data.sf$CNTR_CODE %in% country, ]
  }
  data.sf <- sf::st_make_valid(data.sf)
  return(data.sf)
}
