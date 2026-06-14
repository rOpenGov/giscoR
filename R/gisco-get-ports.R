#' Ports dataset
#'
#' @description
#' This dataset includes the location of over 2,440 pan-European ports. The
#' ports are identified following the UN LOCODE list.
#'
#' @family transport
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file. One of
#'   `2013`, `2009`.
#'
#' @inherit gisco_get_airports return
#' @details
#' Files are distributed in [EPSG:4326](https://epsg.io/4326).
#'
#' [gisco_get_ports()] adds a new field, `CNTR_ISO2`, to identify the country
#' of the port.
#'
#' @inherit gisco_get_airports source
#' @examplesIf gisco_check_access()
#' library(sf)
#'
#' ports <- gisco_get_ports(2013)
#' coast <- giscoR::gisco_coastal_lines
#'
#' if (!is.null(ports)) {
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
#'       title = "Ports worldwide", subtitle = "Year 2013",
#'       caption = "Source: Eurostat, Ports 2013 dataset."
#'     ) +
#'     coord_sf(crs = "ESRI:54030")
#' }
#' @export
#'
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
  files <- c(
    "2009" = "PORT_2009_SH.zip",
    "2013" = "PORT_2013_SH.zip"
  )
  url <- eurostat_gisco_geodata_url(files[[year]])
  data_sf <- read_gisco_dataset(
    url,
    cache_dir = cache_dir,
    subdir = "ports",
    update_cache = update_cache,
    verbose = verbose,
    post_process = transform_to_wgs84
  )
  if (is.null(data_sf)) {
    return(NULL)
  }

  country <- convert_country_code_or_null(country, "iso2c")
  data_sf$CNTR_ISO2 <- substr(data_sf$PORT_ID, 1, 2)
  filter_by_country_col(data_sf, country, "CNTR_ISO2")
}
