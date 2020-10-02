#' @title Download Geospatial Local Administrative Units Data from GISCO
#' @description Downloads a simple feature (\code{sf}) object.
#' @param year Release year. One of
#'    "2016", "2017", "2018" or "2019"
#' @param epsg projection of the map: 4-digit \href{https://spatialreference.org/ref/epsg/}{EPSG code}. One of:
#' \itemize{
#' \item "4326" - WGS84
#' \item "3035" - ETRS89 / ETRS-LAEA
#' \item "3857" - Pseudo-Mercator
#' }
#' @param update_cache a logical whether to update cache.
#' @param cache_dir a path to a cache directory. The directory have to exist.  The \code{NULL} (default) uses and creates \code{/gisco} directory in the temporary directory from \code{\link{tempdir}}. The directory can also be set with \code{options(gisco_cache_dir = <path>)}.
#' @param country_iso3 Optional. A character vector of ISO-3 country codes.
#' @param gisco_id Optional. A character vector of GISCO_ID LAU values.
#' @export
#' @details See \url{https://ec.europa.eu/eurostat/web/nuts/local-administrative-units} for more detail about LAUs.
#'
#' If you experience any problem on download, try to download the file by any other method and set \code{cache_dir = <folder>}.
#'
#' You can convert Eurostat country codes to ISO3 codes using the \code{\link[countrycode]{countrycode}} function:
#'
#' eurostat_codes <- c("ES","UK","EL","PL","PT")\cr
#' countrycode::countrycode(\cr
#'   eurostat_codes,\cr
#'   origin = "eurostat",\cr
#'   destination = "iso3c"\cr
#' )
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/lau/}{GISCO Local Administrative Units}
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @return a \code{POLYGON} object on \code{sf} format.
#' @note Please check the download and usage provisions on \link{gisco_attributions}.
#' @seealso \link{gisco_get_communes}
#' @examples
#' \donttest{
#' library(sf)
#'
#' lau_esp <- gisco_get_lau(country_iso3 = "ESP")
#'
#' plot(
#'   st_geometry(lau_esp),
#'   xlim = c(0, 4),
#'   ylim = c(39, 42),
#'   bg = "lightskyblue1",
#'   col = "wheat",
#'   border = "grey50"
#' )
#'
#' box()
#'
#' title(
#'   main = "Spain LAU",
#'   sub = gisco_attributions(copyright = FALSE),
#'   line = 1,
#'   cex.sub = 0.8,
#'   font.sub = 3
#' )
#' }
#' @export
gisco_get_lau <- function(year = "2016",
                          epsg = "4326",
                          update_cache = FALSE,
                          cache_dir = NULL,
                          country_iso3 = NULL,
                          gisco_id = NULL) {
  # Check year is of correct format
  year <- as.character(year)
  if (!as.numeric(year) %in% c(2016:2019)) {
    stop("Year should be one of 2016, 2017, 2018 or 2019")
  }
  # Check crs is of correct format
  crs <- as.character(epsg)
  if (!as.numeric(crs) %in% c(4326, 3035, 3857)) {
    stop("epsg should be one of 4326, 3035 or 3857")
  }
  # nocov start

  # Downloading data
  filename <-
    paste0("LAU_RG_01M_",
           year,
           "_",
           crs,
           ".geojson")
  url <-
    paste0("https://gisco-services.ec.europa.eu/distribution/v2/lau/geojson/",
           filename)

  data.sf <- gsc_helper_dwnl_caching(cache_dir,
                                     update_cache,
                                     filename,
                                     url, epsg)

  if (!is.null(country_iso3) & "CNTR_CODE" %in% names(data.sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <-
      countrycode::countrycode(country_iso3, origin = "iso3c", destination = "eurostat")
    data.sf <- data.sf[data.sf$CNTR_CODE %in% country,]
  }

  if (!is.null(gisco_id) & "GISCO_ID" %in% names(data.sf)) {
    data.sf <- data.sf[data.sf$GISCO_ID %in% gisco_id,]
  }
  data.sf <- sf::st_make_valid(data.sf)
  return(data.sf)
  # nocov end
}
