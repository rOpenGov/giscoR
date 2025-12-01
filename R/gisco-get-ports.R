#' Ports dataset
#'
#' @description
#' This dataset includes the location of over 2,440 Pan European ports. The
#' ports are identified following the UN LOCODE list.
#'
#' @family transport
#' @inherit gisco_get_airports
#' @inheritParams gisco_get_countries
#' @encoding UTF-8
#' @export
#'
#' @param year character string or number. Release year of the file. One of
#'   `2013`, `2009`.
#'
#' @details
#' Dataset includes objects in [EPSG:4326](https://epsg.io/4326).
#'
#' [gisco_get_ports()] adds a new field CNTR_ISO2 to the original data
#' identifying the country of the port.
#'
#' @examplesIf gisco_check_access()
#' library(sf)
#'
#' ports <- gisco_get_ports(2013)
#' coast <- giscoR::gisco_coastallines
#'
#' if (inherits(ports, "sf")) {
#'   library(ggplot2)
#'
#'   ggplot(coast) +
#'     geom_sf(fill = "grey10", color = "grey20") +
#'     geom_sf(
#'       data = ports, color = "#6bb857",
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
#'       title = "Ports Worldwide", subtitle = "Year 2013",
#'       caption = "(c) European Union, 1995 - today"
#'     ) +
#'     coord_sf(crs = "ESRI:54030")
#' }
gisco_get_ports <- function(
  year = c(2013, 2009),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
) {
  year <- as.character(year)
  valid_years <- as.character(c(2013, 2009))
  year <- match_arg_pretty(year, valid_years)

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
