#' @title Download Geospatial Country Data from GISCO
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
#'    "2001", "2006", "2010", "2013", "2016" or "2020"
#' @param crs projection of the map: 4-digit \href{http://spatialreference.org/ref/epsg/}{EPSG code}. One of:
#' \itemize{
#' \item "4326" - WGS84
#' \item "3035" - ETRS89 / ETRS-LAEA
#' \item "3857" - Pseudo-Mercator
#' }
#' @param spatialtype Type of geometry to be returned:
#' \itemize{
#'  \item RG: Regions - Multipolygon
#'  \item LB: Labels - Point
#'  \item BN: Boundaries - Multilines
#'  \item COASTL: coastlines - Multilines
#'  \item INLAND: inland boundaries - Multilines
#' }
#' @param cache a logical whether to do caching. Default is \code{TRUE}.
#' @param update_cache a logical whether to update cache.
#' @param cache_dir a path to a cache directory. The directory have to exist.  The \code{NULL} (default) uses and creates \code{/gisco} directory in the temporary directory from \code{\link{tempdir}}. The directory can also be set with \code{options(gisco_cache_dir = <path>)}.
#' @param country Optional. A character vector of ISO-3 country codes. See Details
#' @param region Optional. A character vector of UN M49 region codes. Possible values are "Africa", "Americas", "Asia", "Europe", "Oceania". See Details and \link{gisco_countrycode}
#' @export
#' @details \code{country} and \code{region} only available when applicable.
#' Some \code{spatialtype} datasets (as Multilines data-types) may not have country-level identifies.
#' @source \url{https://gisco-services.ec.europa.eu/distribution/v2/countries/}
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @return a \code{sf} object.
#' @seealso \link{gisco_countrycode}
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
#' library(sf)
#'
#' # Some data are already available for speed up the process
#' africa2016 <-  gisco_get_countries(region = "Africa")
#' angola_namibia <-  gisco_get_countries(country = c("AGO", "NAM"))
#'
#' plot(st_geometry(africa2016), bg = "#C6ECFF", col = NA)
#' plot(st_geometry(gisco_countries_20M_2016),
#'      col = "#E0E0E0",
#'      add = TRUE)
#' plot(st_geometry(africa2016), col = "#F6E1B9", add = TRUE)
#' plot(st_geometry(angola_namibia), col = "#FEFEE9", add = TRUE)
#' # Change crs and resolution
#' \donttest{
#' cntries2020 <-
#'   gisco_get_countries(year = 2020,
#'                       crs = 3035,
#'                       resolution = 20)
#' plot(st_geometry(cntries2020), bg = "#C6ECFF", col = "#E0E0E0")
#'
#' # Several geometry types
#' coastl <-
#'   gisco_get_countries(spatialtype = "COASTL")
#'
#' inland <-
#'   gisco_get_countries(spatialtype = "INLAND")
#'
#' labl <-
#'   gisco_get_countries(spatialtype = "LB")
#'
#' opar <- par(no.readonly = TRUE)
#' par(bg = "black", mar = c(0, 0, 0, 0))
#' plot(st_geometry(coastl), col = "blue")
#' plot(st_geometry(inland), col = "green", add = TRUE)
#' plot(st_geometry(labl),
#'      col = "red",
#'      add = TRUE,
#'      pch = 19)
#' par(opar)
#' }
#' @export
gisco_get_countries <- function(resolution = "20",
                                year = "2016",
                                crs = "4326",
                                cache = TRUE,
                                update_cache = FALSE,
                                cache_dir = NULL,
                                spatialtype = "RG",
                                country = NULL,
                                region = NULL) {
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
  if (!as.numeric(year) %in% c(2001, 2006, 2010, 2013, 2016, 2020)) {
    stop("Year should be one of 2001, 2006, 2010, 2013, 2016 or 2020")
  }
  if (as.numeric(year) == 2001 & as.numeric(resolution) == 60) {
    stop(
      "Countries 2001 is not provided at 1:60 million resolution. Try 1:1 million, 1:3 million, 1:10 million or 1:20 million"
    )
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

  # Check if data is already available
  if (isFALSE(update_cache)) {
    if (year == "2016" &
        resolution == "20" &
        crs == "4326" & spatialtype %in% c("RG", "COASTL")) {
      dwnload <- FALSE
      if (spatialtype == "RG") {
        data.sf <- giscoR::gisco_countries_20M_2016
      } else if (spatialtype == "COASTL") {
        data.sf <- giscoR::gisco_coastallines_20M_2016
      }
    } else {
      dwnload <- TRUE
    }
  } else {
    dwnload <- TRUE
  }
  if (isTRUE(dwnload)) {
    # Downloading data
    if (spatialtype %in% c("COASTL", "INLAND")) {
      filename <-
        paste0("CNTR_BN_",
               resolution,
               "M_",
               year,
               "_",
               crs,
               "_",
               spatialtype,
               ".geojson")

    } else if (spatialtype == "LB")
      (filename <-
         paste0("CNTR_",
                spatialtype,
                "_",
                year,
                "_",
                crs,
                ".geojson"))

    else {
      filename <-
        paste0("CNTR_",
               spatialtype,
               "_",
               resolution,
               "M_",
               year,
               "_",
               crs,
               ".geojson")
    }
    url <-
      paste0(
        "https://gisco-services.ec.europa.eu/distribution/v2/countries/geojson/",
        filename
      )

    data.sf <-
      gsc_helper_dwnl_nocaching(cache,
                                cache_dir,
                                update_cache,
                                filename,
                                url)
  }
  if (!is.null(country) & "ISO3_CODE" %in% names(data.sf)) {
    data.sf <- data.sf[data.sf$ISO3_CODE %in% country, ]
  }
  if (!is.null(region) & "ISO3_CODE" %in% names(data.sf)) {
    region.df <- giscoR::gisco_countrycode
    region.df <- region.df[region.df$un.region.name %in% region, ]
    data.sf <- data.sf[data.sf$ISO3_CODE %in% region.df$ISO3_CODE, ]
  }
  data.sf <- sf::st_make_valid(data.sf)
  return(data.sf)
}
