#' Get location of airports and ports from GISCO API
#'
#' Loads a [`sf`][sf::st_sf] object from GISCO API or your local library.
#'
#' @family infrastructure
#'
#' @return A `POINT` object on EPSG:4326.
#'
#' @param year Year of reference.
#'
#' @inheritParams gisco_get_countries
#'
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
#' greece <- gisco_get_countries(country = "EL", resolution = 3)
#' airp_gc <- gisco_get_airports(2013, country = "EL")
#'
#' library(ggplot2)
#'
#' if (inherits(airp_gc, "sf")) {
#'   ggplot(greece) +
#'     geom_sf(fill = "grey80") +
#'     geom_sf(data = airp_gc, color = "blue") +
#'     labs(
#'       title = "Airports on Greece",
#'       shape = NULL,
#'       color = NULL,
#'       caption = gisco_attributions()
#'     )
#' }
#'
#' # Plot ports
#'
#' ports <- gisco_get_ports(2013)
#' coast <- giscoR::gisco_coastallines
#'
#' # To Robinson projection :)
#'
#' library(sf)
#' coast <- st_transform(coast, "ESRI:54030")
#' ports <- st_transform(ports, st_crs(coast))
#'
#' if (inherits(ports, "sf")) {
#'   ggplot(coast) +
#'     geom_sf(fill = "#F6E1B9", color = "#0978AB") +
#'     geom_sf(data = ports, fill = "red", shape = 21) +
#'     theme_void() +
#'     theme(
#'       panel.background = element_rect(fill = "#C6ECFF"),
#'       panel.grid = element_blank(),
#'       plot.title = element_text(face = "bold", hjust = 0.5),
#'       plot.subtitle = element_text(face = "italic", hjust = 0.5)
#'     ) +
#'     labs(
#'       title = "Ports Worldwide", subtitle = "Year 2013",
#'       caption = "(c) European Union, 1995 - today"
#'     )
#' }
#' }
#' @export
gisco_get_airports <- function(
  year = c("2013", "2006"),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
) {
  year <- match_arg_pretty(year)
  if (year == "2006") {
    url <- paste0(
      "https://ec.europa.eu/eurostat/cache/GISCO/",
      "geodatafiles/AIRP_SH.zip"
    )
  }

  if (year == "2013") {
    url <- paste0(
      "https://ec.europa.eu/eurostat/cache/GISCO/",
      "geodatafiles/Airports-2013-SHP.zip"
    )
  }

  filename <- basename(url)
  namefileload <- load_url(
    url,
    filename,
    cache_dir,
    "airports",
    update_cache,
    verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  data_sf <- read_geo_file_sf(namefileload)

  # Normalize to lonlat
  data_sf <- sf::st_transform(data_sf, 4326)

  if (!is.null(country) && "CNTR_CODE" %in% names(data_sf)) {
    country <- get_country_code(country)
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }
  data_sf
}

#' @rdname gisco_get_airports
#'
#' @details
#'
#' [gisco_get_ports()] adds a new field `CNTR_ISO2` to the original data
#' identifying the country of the port. Worldwide information available.
#' The port codes are aligned with UN/LOCODE standard.
#'
#' @export
gisco_get_ports <- function(
  year = c("2013", "2009"),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
) {
  year <- match_arg_pretty(year)
  if (year == "2009") {
    url <- paste0(
      "https://ec.europa.eu/eurostat/cache/GISCO/",
      "geodatafiles/PORT_2009_SH.zip"
    )
  }
  if (year == "2013") {
    url <- paste0(
      "https://ec.europa.eu/eurostat/cache/GISCO/",
      "geodatafiles/PORT_2013_SH.zip"
    )
  }

  filename <- basename(url)
  namefileload <- load_url(
    url,
    filename,
    cache_dir,
    "ports",
    update_cache,
    verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  data_sf <- read_geo_file_sf(namefileload)

  # Normalize to lonlat
  data_sf <- sf::st_transform(data_sf, 4326)

  # Add ISO2 country
  data_sf$CNTR_ISO2 <- substr(data_sf$PORT_ID, 1, 2)

  if (!is.null(country) && "PORT_ID" %in% names(data_sf)) {
    country <- get_country_code(country, "iso2c")
    data_sf <- data_sf[data_sf$CNTR_ISO2 %in% country, ]
  }
  data_sf
}
