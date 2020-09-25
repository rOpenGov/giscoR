#' @title Download Geospatial Communes Data from GISCO
#' @description Downloads a simple feature (\code{sf}) object.
#' @param year Release year. One of
#'    "2001", "2004", "2006", "2008", "2010", "2013" or 2016
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
#'  \item BN: Boundaries - Multilines
#'  \item COASTL: coastlines - Multilines
#'  \item INLAND: inland boundaries - Multilines
#' }
#' @param country Optional. A character vector of ISO-3 country codes. See Details.
#' @export
#' @details \code{country} only available when applicable.
#'
#' Some \code{spatialtype} datasets (as Multilines data-types) may not have country-level identifies.
#' If you experience any problem on download, try to download the file by any other method and set \code{cache_dir = <folder>}.
#' @source \url{https://gisco-services.ec.europa.eu/distribution/v2/communes/}
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
#'
#' communes <- gisco_get_communes(spatialtype = "COASTL")
#' world <- gisco_countries_20M_2016
#' opar <- par(no.readonly = TRUE)
#' par(mar = c(2, 2, 2, 2))
#' plot(
#'   st_geometry(world),
#'   axes = TRUE,
#'   xlim = c(-20, 40),
#'   ylim = c(40, 75),
#'   bg = "aliceblue",
#'   col = "antiquewhite"
#' )
#' box()
#' typoLayer(
#'   communes,
#'   var = "EFTA_FLAG",
#'   col = c(NA, "red"),
#'   legend.pos = "n",
#'   lwd = 2,
#'   add = TRUE
#' )
#' layoutLayer("EFTA Coastlines",
#'             col = "red",
#'             sources = gisco_attributions(copyright = FALSE))
#' }
#' @export
gisco_get_communes <- function(year = "2016",
                               crs = "4326",
                               update_cache = FALSE,
                               cache_dir = NULL,
                               spatialtype = "RG",
                               country = NULL) {
  # Check year is of correct format
  year <- as.character(year)
  if (!as.numeric(year) %in% c(2001, 2004, 2006, 2008, 2010, 2013, 2016)) {
    stop("Year should be one of 2001, 2004, 2006, 2008, 2010, 2013 or 2016")
  }
  # Check crs is of correct format
  crs <- as.character(crs)
  if (!as.numeric(crs) %in% c(4326, 3035, 3857)) {
    stop("crs should be one of 4326, 3035 or 3857")
  }

  # Check spatialtype
  if (!spatialtype %in% c("RG", "LB", "BN", "COASTL", "INLAND")) {
    stop("spatialtype should be one of 'RG', 'LB', 'BN', 'COASTL', 'INLAND'")
  }

  # nocov start

  # Downloading data
  filename <- gsc_helper_communes_url(year, crs, spatialtype)
  url <-
    paste0(
      "https://gisco-services.ec.europa.eu/distribution/v2/communes/geojson/",
      filename
    )

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
  # nocov end
}
