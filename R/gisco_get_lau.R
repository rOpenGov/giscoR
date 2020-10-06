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
#' @param country Optional. A character vector of country codes. See details
#' @param gisco_id Optional. A character vector of GISCO_ID LAU values.
#' @export
#' @details See \url{https://ec.europa.eu/eurostat/web/nuts/local-administrative-units} for more detail about LAUs.
#'
#' If you experience any problem on download, try to download the file by any other method and set \code{cache_dir = <folder>}.
#'
#' \code{country} could be either a vector of country names, a vector of ISO3 country codes or
#' a vector of Eurostat country codes.
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/lau/}{GISCO Local Administrative Units}
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @return a \code{POLYGON} object on \code{sf} format.
#' @note Please check the download and usage provisions on \link{gisco_attributions}.
#' @seealso \link{gisco_get_communes}
#' @examples
#' library(sf)
#'
#' lau <- gisco_get_lau(country = "Belgique")
#'
#' plot(
#'   st_geometry(lau),
#'   col = c("black", "gold", "brown2"),
#'   border = "grey90"
#' )
#'
#' title(
#'   main = "Local Administrative Units on Belgium (2016)",
#'   sub = gisco_attributions(copyright = FALSE),
#'   line = 1,
#'   cex.sub = 0.8
#' )
#' @export
gisco_get_lau <- function(year = "2016",
                          epsg = "4326",
                          update_cache = FALSE,
                          cache_dir = NULL,
                          country = NULL,
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

  # Try internal data

  if (isFALSE(update_cache)) {
    if (!is.null(country) & length(country == 1)) {
      country_test <- gsc_helper_countrynames(country, "eurostat")
      if (year == "2016" &
          epsg == "4326" &
          country_test == "BE") {
        data.sf <- gisco_lau_BE.sf
        dwnload <- FALSE
      } else {
        dwnload <- TRUE
      }
    } else {
      dwnload <- TRUE
    }
  } else {
    dwnload <- TRUE
  }

  # nocov start

  # Downloading data
  if (dwnload) {
    filename <-
      paste0("LAU_RG_01M_",
             year,
             "_",
             crs,
             ".geojson")
    url <-
      paste0(
        "https://gisco-services.ec.europa.eu/distribution/v2/lau/geojson/",
        filename
      )

    data.sf <- gsc_helper_dwnl_caching(cache_dir,
                                       update_cache,
                                       filename,
                                       url, epsg)

    if (!is.null(country) & "CNTR_CODE" %in% names(data.sf)) {
      # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
      country <- gsc_helper_countrynames(country, "eurostat")
      data.sf <- data.sf[data.sf$CNTR_CODE %in% country, ]
    }
  }
  if (!is.null(gisco_id) & "GISCO_ID" %in% names(data.sf)) {
    data.sf <- data.sf[data.sf$GISCO_ID %in% gisco_id, ]
  }
  data.sf <- sf::st_make_valid(data.sf)
  return(data.sf)
  # nocov end
}
