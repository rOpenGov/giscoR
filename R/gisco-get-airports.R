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
#' airp <- gisco_get_airports(year = 2013)
#' coast <- giscoR::gisco_coastal_lines
#'
#' if (!is.null(airp)) {
#'   library(ggplot2)
#'
#'   ggplot(coast) +
#'     geom_sf(fill = "grey10", color = "grey20") +
#'     geom_sf(
#'       data = airp, color = "#00F0FF",
#'       size = 0.2, alpha = 0.25
#'     ) +
#'     theme_void() +
#'     theme(
#'       plot.background = element_rect(fill = "black"),
#'       text = element_text(color = "white"),
#'       panel.grid = element_blank(),
#'       plot.title = element_text(face = "bold", hjust = 0.5),
#'       plot.subtitle = element_text(face = "italic", hjust = 0.5)
#'     ) +
#'     labs(
#'       title = "Airports in Europe", subtitle = "Year 2013",
#'       caption = "Source: Eurostat, Airports 2013 dataset."
#'     ) +
#'     # Center in Europe: EPSG 3035
#'     coord_sf(
#'       crs = 3035,
#'       xlim = c(2377294, 7453440),
#'       ylim = c(1313597, 5628510)
#'     )
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
  namefileload <- download_url(
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
    country <- convert_country_code(country)
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }
  data_sf
}
