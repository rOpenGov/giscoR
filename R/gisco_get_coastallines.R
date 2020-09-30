#' @title Download Coastal Lines from GISCO
#' @description Downloads a simple feature (\code{sf}) object.
#' @param resolution Resolution of the geospatial data. One of
#' \itemize{
#'    \item "60" (1:60million),
#'    \item "20" (1:20million)
#'    \item "10" (1:10million)
#'    \item "03" (1:3million) or
#'    \item "01" (1:1million).
#'    }
#' @param year Release year. One of
#'    "2006", "2010", "2013" or "2016"
#' @param epsg projection of the map: 4-digit \href{http://spatialreference.org/ref/epsg/}{EPSG code}. One of:
#' \itemize{
#' \item "4326" - WGS84
#' \item "3035" - ETRS89 / ETRS-LAEA
#' \item "3857" - Pseudo-Mercator
#' }
#' @param cache a logical whether to do caching. Default is \code{TRUE}.
#' @param update_cache a logical whether to update cache.
#' @param cache_dir a path to a cache directory. The directory have to exist.  The \code{NULL} (default) uses and creates \code{/gisco} directory in the temporary directory from \code{\link{tempdir}}. The directory can also be set with \code{options(gisco_cache_dir = <path>}.
#' @export
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/coas/}{GISCO Coastal Lines}
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @return a \code{POLYGON} object on \code{sf} format.
#' @note Please check the download and usage provisions on \link{gisco_attributions}.
#' @examples
#' library(sf)
#' \donttest{
#' coastlines <- gisco_get_coastallines(resolution = "60")
#' plot(st_geometry(coastlines), col = "red", border = "orange")
#'
#' coastlinesrobin <- gisco_get_coastallines(epsg = "3857")
#' coastlinesrobin <- st_transform(coastlinesrobin, "+proj=robin")
#' plot(st_geometry(coastlinesrobin), col = "black", bg = "grey", border = "white")
#' }
#' @export
gisco_get_coastallines <- function(resolution = "20",
                                   year = "2016",
                                   epsg = "4326",
                                   cache = TRUE,
                                   update_cache = FALSE,
                                   cache_dir = NULL) {
  # Check resolution is of correct format
  resolution <- as.character(resolution)
  resolution <- gsub("^0+", "", resolution)
  if (!as.numeric(resolution) %in% c(1, 3, 10, 20, 60)) {
    stop("Resolution should be one of 01, 1, 03, 3, 10, 20, 60")
  }
  resolution <- gsub("^1$", "01", resolution)
  resolution <- gsub("^3$", "03", resolution)

  # Check year is of correct format
  year <- as.character(year)
  if (!as.numeric(year) %in% c(2006, 2010, 2013, 2016)) {
    stop("Year should be one of 2006, 2010, 2013 or 2016")
  }
  # Check crs is of correct format
  crs <- as.character(epsg)
  if (!as.numeric(crs) %in% c(4326, 3035, 3857)) {
    stop("epsg should be one of 4326, 3035 or 3857")
  }

  # Downloading data
  filename <-
    paste0("COAS_RG_",
           resolution,
           "M_",
           year,
           "_",
           crs,
           ".geojson")
  url <-
    paste0("https://gisco-services.ec.europa.eu/distribution/v2/coas/geojson/",
           filename)

  data.sf <-
    gsc_helper_dwnl_nocaching(cache,
                              cache_dir,
                              update_cache,
                              filename,
                              url)
  data.sf <- sf::st_make_valid(data.sf)
  return(data.sf)
}
