#' @title Download Geospatial Urban Audit Data from GISCO
#' @description Downloads a simple feature (\code{sf}) object.
#' @param year Release year. One of
#'    "2014", "2018" or "2020"
#' @param crs projection of the map: 4-digit \href{http://spatialreference.org/ref/epsg/}{EPSG code}. One of:
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
#' @param country Optional. A character vector of ISO-3 country codes.
#' @details \code{level = NULL} would download the whole dataset including all levels
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/urau/}{GISCO Urban Audit}
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @return a \code{sf} object.
#' @note COPYRIGHT NOTICE
#'
#' When data downloaded from this page
#' \url{http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units}
#' is used in any printed or electronic publication,
#' in addition to any other provisions
#' applicable to the whole Eurostat website,
#' data source will have to be acknowledged
#' in the legend of the map and
#' in the introductory page of the publication
#' with the following copyright notice:
#' \itemize{
#' 	\item EN: (C) EuroGeographics for the administrative boundaries
#' 	\item FR: (C) EuroGeographics pour les limites administratives
#' 	\item DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen
#' }
#' For publications in languages other than
#' English, French or German,
#' the translation of the copyright notice
#' in the language of the publication shall be used.
#'
#' If you intend to use the data commercially,
#' please contact EuroGeographics for
#' information regarding their licence agreements.
#' @examples
#' \donttest{
#' library(sf)
#' library(cartography)
#' europe <-
#'   gisco_get_countries(
#'     crs = 3857,
#'     year = "2020",
#'     region = "Europe",
#'     resolution = "03"
#'   )
#' cities <-
#'   gisco_get_urban_audit(
#'     year = 2020,
#'     crs = 3857,
#'     level = "GREATER_CITIES",
#'     country = "BEL"
#'   )
#'
#' # Focus on Belgium
#' bbox <-
#'   st_bbox(c(
#'     xmin = 150000,
#'     xmax = 950000,
#'     ymax = 6900000,
#'     ymin = 6300000
#'   ),
#'   crs = st_crs(europe))
#' bbox <- st_bbox(cities)
#'
#' # Plot
#' opar <- par(no.readonly = TRUE)
#' par(mar = c(1, 1, 1, 1))
#' plot(
#'   st_geometry(europe),
#'   xlim = bbox[c(1, 3)],
#'   ylim = bbox[c(2, 4)],
#'   col = "antiquewhite",
#'   graticule = TRUE
#' )
#' box()
#' plot(st_geometry(cities),
#'      col = "darkblue",
#'      border = "white",
#'      add = TRUE)
#'
#' # Labels
#' labelLayer(
#'   st_crop(europe, bbox),
#'   txt = "NAME_ENGL",
#'   family = "serif",
#'   font = 3,
#'   cex = 0.8
#' )
#' labelLayer(
#'   cities,
#'   txt = "URAU_NAME",
#'   overlap = FALSE,
#'   col = "darkblue",
#'   halo = TRUE
#' )
#' layoutLayer(
#'   "Greater Cities of Belgium - Eurostat (2020)",
#'   col = "darkblue",
#'   sources = gisco_attributions(copyright = FALSE),
#'   horiz = FALSE,
#'   posscale = "bottomleft"
#' )
#' par(opar)
#' }
#' @export
gisco_get_urban_audit <- function(year = "2018",
                                  crs = "4326",
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
  crs <- as.character(crs)
  if (!as.numeric(crs) %in% c(4326, 3035, 3857)) {
    stop("crs should be one of 4326, 3035 or 3857")
  }
  if (is.null(level)) {
    level <- ""
  }
  # Check level is of correct format
  if (!level %in% c("", "CITIES", "FUA", "GREATER_CITIES")) {
    stop("crs should be one of 'CITIES', 'FUA', 'GREATER_CITIES' or NULL")
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
                                     url)

  if (!is.null(country) & "CNTR_CODE" %in% names(data.sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <-
      countrycode::countrycode(country, origin = "iso3c", destination = "eurostat")
    data.sf <- data.sf[data.sf$CNTR_CODE %in% country, ]
  }
  data.sf <- sf::st_make_valid(data.sf)
  return(data.sf)
}
