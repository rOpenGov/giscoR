#' Get location of airports and ports from GISCO API
#'
#' Loads a `sf` object from GISCO API or your local library.
#'
#' @concept infrastructure
#' @family infrastructure
#'
#' @return A `POINT` object on EPSG:4326.
#'
#' @param year Year of reference. Only year available right now is "2013".
#'
#' @inheritParams gisco_get_countries
#'
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/transport-networks>
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @details
#'  Datasets refer to Europe. All shapefiles provided in EPSG:4326
#'
#' @examplesIf gisco_check_access()
#'
#' library(sf)
#'
#' Greece <- gisco_get_countries(country = "EL", resolution = "1")
#' AirP_GC <- gisco_get_airports(country = "EL")
#' AirP_GC <- st_transform(AirP_GC, st_crs(Greece))
#'
#' library(ggplot2)
#'
#'
#' ggplot(Greece) +
#'   geom_sf(fill = "grey80") +
#'   geom_sf(data = AirP_GC, color = "blue") +
#'   labs(
#'     title = "Airports on Greece",
#'     shape = NULL,
#'     color = NULL,
#'     caption = gisco_attributions()
#'   )
#' @export
gisco_get_airports <- function(year = "2013",
                               country = NULL,
                               cache_dir = NULL,
                               update_cache = FALSE,
                               verbose = FALSE) {
  year <- as.character(year)
  if (!(year %in% c("2013"))) {
    stop("Year should be 2013")
  }

  if (year == "2013") {
    url <- "https://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/Airports-2013-SHP.zip"
  }

  cache_dir <- gsc_helper_detect_cache_dir()

  name <- basename(url)

  basename <- gsc_api_cache(
    url = url, name = name, cache_dir = cache_dir,
    update_cache = update_cache, verbose = verbose
  )


  gsc_unzip(basename, cache_dir,
    ext = "*", verbose = verbose,
    update_cache = update_cache
  )

  destfile <- basename

  zipfiles <- unzip(destfile, list = TRUE)
  shpfile <- basename(zipfiles[grep(".shp$", zipfiles[[1]]), 1])


  data_sf <- sf::st_read(file.path(cache_dir, shpfile), quiet = !verbose)
  data_sf <- sf::st_make_valid(data_sf)


  if (!is.null(country) & "CNTR_CODE" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }
  return(data_sf)
}

#' @rdname gisco_get_airports
#'
#' @export
gisco_get_ports <- function(year = "2013", cache_dir = NULL,
                            update_cache = FALSE,
                            verbose = FALSE) {
  year <- as.character(year)
  if (!(year %in% c("2013"))) {
    stop("Year should be 2013")
  }

  if (year == "2013") {
    url <- "https://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/PORT_2013_SH.zip"
  }

  cache_dir <- gsc_helper_detect_cache_dir()

  name <- basename(url)

  basename <- gsc_api_cache(
    url = url, name = name, cache_dir = cache_dir,
    update_cache = update_cache, verbose = verbose
  )


  gsc_unzip(basename, cache_dir,
    ext = "*", verbose = verbose,
    update_cache = update_cache
  )

  destfile <- basename

  zipfiles <- unzip(destfile, list = TRUE)
  shpfile <- basename(zipfiles[grep(".shp$", zipfiles[[1]]), 1])


  data_sf <- sf::st_read(file.path(cache_dir, shpfile), quiet = !verbose)
  data_sf <- sf::st_make_valid(data_sf)
  return(data_sf)
}
