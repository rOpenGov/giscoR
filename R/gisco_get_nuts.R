#' @title Download Geospatial NUTS Data from GISCO
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
#'    "2003", "2006", "2010", "2013", "2016" or "2021".
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
#' }
#' @param nuts_level NUTS level. One of "0" (Country-level), "1", "2" or "3". See \url{https://ec.europa.eu/eurostat/web/nuts/background}.#'
#' @param cache a logical whether to do caching. Default is \code{TRUE}.
#' @param update_cache a logical whether to update cache.
#' @param cache_dir a path to a cache directory. The directory have to exist.  The \code{NULL} (default) uses and creates \code{/gisco} directory in the temporary directory from \code{\link{tempdir}}. The directory can also be set with \code{options(gisco_cache_dir = <path>)}.
#' @param country Optional. A character vector of ISO-3 country codes. See Details
#' @param nuts_id Optional. A character vector of NUTS IDs.
#' @export
#' @details \code{country} only available when applicable.
#' Some \code{spatialtype} datasets (as Multilines data-types) may not have country-level identifies.
#' @source \url{https://gisco-services.ec.europa.eu/distribution/v2/nuts/}
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @return a \code{sf} object.
#' @seealso \link{gisco_countrycode}, \link{gisco_nuts_20M_2016}
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
#' library(eurostat)
#' library(sf)
#' map <- gisco_get_nuts(year = "2016",
#'                       nuts_level = 2,
#'                       crs = "3035")
#'
#' #For the borders only
#' brds <- gisco_get_nuts(
#'   year = "2016",
#'   spatialtype = "BN",
#'   nuts_level = 0,
#'   crs = "3035"
#' )
#'
#' pps <- get_eurostat("tgs00026")
#' pps <- pps[grep("2016", pps$time),]
#'
#' map.join <- merge(map,
#'                   pps,
#'                   by.x = "NUTS_ID",
#'                   by.y = "geo",
#'                   all.x = TRUE)
#'
#' library(cartography)
#' br <- getBreaks(map.join$values, method = "jenks")
#'
#' library(colorspace)
#' pal <- sequential_hcl(n = (length(br) - 1),
#'                       pal = "Inferno",
#'                       rev = TRUE)
#' opar <- par(no.readonly = TRUE)
#' par(mar = c(1, 1, 1, 1))
#' plot(
#'   st_geometry(map.join),
#'   col = NA,
#'   bg = "aliceblue",
#'   xlim = c(2200000, 7150000),
#'   ylim = c(1380000, 5500000)
#' )
#' choroLayer(
#'   map.join,
#'   var = "values",
#'   border = "grey60",
#'   breaks = br,
#'   col = pal,
#'   add = TRUE,
#'   legend.pos = "n"
#' )
#' plot(st_geometry(brds),
#'      col = "black",
#'      add = TRUE,
#'      lwd = 1.2)
#' att <- paste0("Data extracted from package eurostat \n",
#'               gisco_attributions(copyright = FALSE))
#'
#' legendChoro(
#'   title.txt = NA,
#'   breaks = paste0(br / 1000, "K EUR"),
#'   col = pal
#' )
#' layoutLayer("Purchase Parity Power, NUTS 2 regions (2016)",
#'             col = pal[3],
#'             sources = att)
#' par(opar)
#' }
#' @export
gisco_get_nuts <- function(resolution = "20",
                           year = "2016",
                           crs = "4326",
                           nuts_level = "all",
                           cache = TRUE,
                           update_cache = FALSE,
                           cache_dir = NULL,
                           spatialtype = "RG",
                           country = NULL,
                           nuts_id = NULL) {
  # Check resolution is of correct format
  resolution <- as.character(resolution)
  resolution <- gsub("^0+", "", resolution)
  if (!as.numeric(resolution) %in% c(1, 3, 10, 20, 60)) {
    stop("Resolution should be one of 01, 1, 03, 3, 10, 20, 60")
  }
  resolution <- gsub("^1$", "01", resolution)
  resolution <- gsub("^3$", "03", resolution)

  # Check nuts level

  nuts_level <- as.character(nuts_level)
  if (!(nuts_level %in% c("all", "0", "1", "2", "3"))) {
    stop('nuts_level should be one of "all","0", "1", "2", "3"')
  }

  # Check year is of correct format
  year <- as.character(year)
  if (!as.numeric(year) %in% c(2003, 2006, 2010, 2013, 2016, 2021)) {
    stop("Year should be one of 2003, 2006, 2010, 2013, 2016 or 2021")
  }

  if (as.numeric(year) == 2003 & as.numeric(resolution) == 60) {
    stop(
      "NUTS 2003 is not provided at 1:60 million resolution. Try 1:1 million, 1:3 million, 1:10 million or 1:20 million"
    )
  }
  # Check spatialtype
  if (!spatialtype %in% c("RG", "LB", "BN")) {
    stop("spatialtype should be one of 'RG', 'LB', 'BN'")
  }
  # Check if data is already available
  if (isFALSE(update_cache)) {
    if (year == "2016" &
        resolution == "20" &
        crs == "4326" & spatialtype %in% c("RG")) {
      dwnload <- FALSE
      nuts_aux <- giscoR::gisco_nuts_20M_2016
      if (nuts_level == "all") {
        data.sf <- nuts_aux
      } else {
        data.sf <- nuts_aux[nuts_aux$LEVL_CODE == as.integer(nuts_level), ]
      }
    } else {
      dwnload <- TRUE
    }
  } else {
    dwnload <- TRUE
  }
  if (isTRUE(dwnload)) {
    if (nuts_level == "all") {
      ext <- ".geojson"
    } else {
      ext <- paste0("_LEVL_", as.integer(nuts_level), ".geojson")
    }

    if (spatialtype == "LB") {
      pre <- "LB_"
    } else {
      pre <- paste0(spatialtype, "_", resolution, "M_")
    }

    filename <-
      paste0("NUTS_",
             pre,
             year,
             "_",
             crs,
             ext)

    url <-
      paste0(
        "https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/",
        filename
      )

    data.sf <-
      gsc_helper_dwnl_nocaching(cache,
                                cache_dir,
                                update_cache,
                                filename,
                                url)

  }
  if (!is.null(country) & "CNTR_CODE" %in% names(data.sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <-
      countrycode::countrycode(country, origin = "iso3c", destination = "eurostat")
    data.sf <- data.sf[data.sf$CNTR_CODE %in% country, ]
  }

  if (!is.null(nuts_id) & "NUTS_ID" %in% names(data.sf)) {
    data.sf <- data.sf[data.sf$NUTS_ID %in% nuts_id, ]
  }

  data.sf <- sf::st_make_valid(data.sf)
  return(data.sf)
}
