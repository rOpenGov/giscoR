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
#' @param epsg projection of the map: 4-digit \href{https://spatialreference.org/ref/epsg/}{EPSG code}. One of:
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
#' @param country_iso3 Optional. A character vector of ISO-3 country codes. See Details
#' @param region Optional. A character vector of UN M49 region codes. Possible values are "Africa", "Americas", "Asia", "Europe", "Oceania". See Details and \link{gisco_countrycode}
#' @export
#' @details \code{country_iso3} and \code{region} only available when applicable.
#' You can convert Eurostat country codes to ISO3 codes using the \code{\link[countrycode]{countrycode}} function:
#'
#' eurostat_codes <- c("ES","UK","EL","PL","PT")\cr
#' \cr
#' countrycode::countrycode(\cr
#'   eurostat_codes,\cr
#'   origin = "eurostat",\cr
#'   destination = "iso3c"\cr
#' )
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/countries/}{GISCO Countries}
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @return a \code{sf} object.
#' @seealso \link{gisco_countrycode}
#' @note Please check the download and usage provisions on \link{gisco_attributions}.
#' @examples
#'
#' library(sf)
#'
#' sf_world <- gisco_get_countries()
#' sf_africa <- gisco_get_countries(region = 'Africa')
#' sf_benelux <-
#'   gisco_get_countries(resolution = "20",
#'                       country_iso3 = c('BEL', 'NLD', 'LUX'))
#'
#' plot(st_geometry(sf_world), col = "seagreen2")
#' title(sub = gisco_attributions(), line = 1)
#'
#' plot(st_geometry(sf_africa),
#'      col = c("springgreen4", "darkgoldenrod1", "red2"))
#' title(sub = gisco_attributions(), line = 1)
#'
#' plot(st_geometry(sf_benelux),
#'      col = c("grey10", "deepskyblue2", "orange"))
#' title(sub = gisco_attributions(), line = 1)
#' @export
gisco_get_countries <- function(resolution = "60",
                                year = "2016",
                                epsg = "4326",
                                cache = TRUE,
                                update_cache = FALSE,
                                cache_dir = NULL,
                                spatialtype = "RG",
                                country_iso3 = NULL,
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
  crs <- as.character(epsg)
  if (!as.numeric(crs) %in% c(4326, 3035, 3857)) {
    stop("epsg should be one of 4326, 3035 or 3857")
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
  if (!is.null(country_iso3) & "ISO3_CODE" %in% names(data.sf)) {
    data.sf <- data.sf[data.sf$ISO3_CODE %in% country_iso3,]
  }
  if (!is.null(region) & "ISO3_CODE" %in% names(data.sf)) {
    region.df <- giscoR::gisco_countrycode
    region.df <- region.df[region.df$un.region.name %in% region,]
    data.sf <- data.sf[data.sf$ISO3_CODE %in% region.df$ISO3_CODE,]
  }
  if (is.na(sf::st_crs(data.sf)$epsg)) {
    # Sometimes data saved does not have epsg - investigate
    data.sf <- sf::st_set_crs(data.sf, as.integer(crs))
  }
  data.sf <- sf::st_make_valid(data.sf)
  return(data.sf)
}
