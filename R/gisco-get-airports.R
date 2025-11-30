#' Airports dataset
#'
#' @description
#' This dataset includes the location of over 11,800 Pan European airports and
#' heliports. The airports are identified using the International Civil
#' Aviation Organisation (ICAO) airport codes.
#'
#' @family transport
#' @inherit gisco_get_countries return
#' @inheritParams gisco_get_countries
#' @encoding UTF-8
#' @export
#'
#' @param year character string or number. Release year of the file. One of
#'   `2013`, `2006`.
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/transport-networks>
#'
#' Copyright:
#' <https://ec.europa.eu/eurostat/web/gisco/geodata>
#'
#' @details
#' Dataset includes objects in [EPSG:4326](https://epsg.io/4326).
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
#' }
gisco_get_airports <- function(
  year = c(2013, 2006),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
) {
  year <- as.character(year)
  valid_years <- as.character(c(2013, 2006))
  year <- match_arg_pretty(year, valid_years)
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
