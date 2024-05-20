#' Get location of airports and ports from GISCO API
#'
#' Loads a [`sf`][sf::st_sf] object from GISCO API or your local library.
#'
#' @family infrastructure
#'
#' @return A `POINT` object on EPSG:4326.
#'
#' @param year Year of reference. Only year available right now is `"2013"`.
#'
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/transport-networks>
#'
#' @details
#'  [gisco_get_airports()] refer to Europe. All shapefiles provided in
#'  [EPSG:4326](https://epsg.io/4326).
#'
#' @examplesIf gisco_check_access()
#' \donttest{
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
#'
#'
#' ##############################
#' #         Plot ports         #
#' ##############################
#'
#' ports <- gisco_get_ports()
#' coast <- giscoR::gisco_coastallines
#'
#' # To Equal Earth projection :)
#'
#' library(sf)
#' coast <- st_transform(coast, 8857)
#' ports <- st_transform(ports, st_crs(coast))
#'
#'
#' ggplot(coast) +
#'   geom_sf(fill = "#F6E1B9", color = "#0978AB") +
#'   geom_sf(data = ports, fill = "red", shape = 21) +
#'   theme_void() +
#'   theme(
#'     panel.background = element_rect(fill = "#C6ECFF"),
#'     panel.grid = element_blank(),
#'     plot.title = element_text(face = "bold", hjust = 0.5),
#'     plot.subtitle = element_text(face = "italic", hjust = 0.5)
#'   ) +
#'   labs(
#'     title = "Ports Worldwide", subtitle = "Year 2013",
#'     caption = "(c) European Union, 1995 - today"
#'   )
#' }
#' @export
gisco_get_airports <- function(year = "2013", country = NULL, cache_dir = NULL,
                               update_cache = FALSE, verbose = FALSE) {
  year <- as.character(year)
  if (year != "2013") {
    stop("Year should be 2013")
  }

  if (year == "2013") {
    url <- paste0(
      "https://ec.europa.eu/eurostat/cache/GISCO/",
      "geodatafiles/Airports-2013-SHP.zip"
    )
  }

  data_sf <- gsc_load_shp(url, cache_dir, verbose, update_cache)
  data_sf <- sf::st_make_valid(data_sf)

  # Normalize to lonlat
  data_sf <- sf::st_transform(data_sf, 4326)


  if (!is.null(country) && "CNTR_CODE" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }
  return(data_sf)
}

#' @rdname gisco_get_airports
#'
#' @details
#'
#' [gisco_get_ports()] adds a new field `CNTR_ISO2` to the original data
#' identifying the country of the port. Worldwide information available.
#' The port codes are aligned with
#' [UN/LOCODE](https://unece.org/trade/uncefact/unlocode) standard.
#'
#' @export
gisco_get_ports <- function(year = "2013", country = NULL, cache_dir = NULL,
                            update_cache = FALSE, verbose = FALSE) {
  year <- as.character(year)
  if (year != "2013") {
    stop("Year should be 2013")
  }

  if (year == "2013") {
    url <- paste0(
      "https://ec.europa.eu/eurostat/cache/GISCO/",
      "geodatafiles/PORT_2013_SH.zip"
    )
  }

  data_sf <- gsc_load_shp(url, cache_dir, verbose, update_cache)
  data_sf <- sf::st_make_valid(data_sf)

  # Normalize to lonlat
  data_sf <- sf::st_transform(data_sf, 4326)

  # Add ISO2 country
  data_sf$CNTR_ISO2 <- substr(data_sf$PORT_ID, 1, 2)

  if (!is.null(country) && "PORT_ID" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "iso2c")
    data_sf <- data_sf[data_sf$CNTR_ISO2 %in% country, ]
  }
  return(data_sf)
}
