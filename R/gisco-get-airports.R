#' Airports dataset
#'
#' @description
#' This function accesses the GISCO airport and heliport datasets. Airports are
#' identified using International Civil Aviation Organization (ICAO) airport
#' codes.
#'
#' @family transport
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file. One of `2024`, `2013`, `2006`.
#'
#' @inherit gisco_get_countries return
#' @details
#' The returned object is transformed to [EPSG:4326](https://epsg.io/4326).
#'
#' # Copyright
#'
#' See the Eurostat general copyright and licence provisions:
#' <https://ec.europa.eu/eurostat/web/gisco/geodata>.
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/transport-networks>.
#'
#' @encoding UTF-8
#' @export
#' @examplesIf gisco_check_access()
#' airp <- gisco_get_airports(year = 2024)
#' coast <- giscoR::gisco_get_countries(year = 2024)
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
#'       title = "Airports in Europe", subtitle = "Year 2024",
#'       caption = "Source: Eurostat, Airports 2024 dataset."
#'     ) +
#'     # Center on Europe with EPSG 3035.
#'     coord_sf(
#'       crs = 3035,
#'       xlim = c(2377294, 7453440),
#'       ylim = c(1313597, 5628510)
#'     )
#' }
#'
gisco_get_airports <- function(
  year = c(2024, 2013, 2006),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
) {
  year <- as.character(year)
  valid_years <- as.character(c(2024, 2013, 2006))
  year <- match_arg_pretty(year, valid_years)
  files <- c(
    "2006" = "AIRP_SH.zip",
    "2013" = "Airports-2013-SHP.zip",
    "2024" = "airp-pt-2024-sh"
  )
  if (year == "2024") {
    url <- "https://ec.europa.eu/eurostat/documents/d/gisco/airp-pt-2024-sh"
    name <- "AIRP-PT-2024-SH.zip"
  } else {
    url <- eurostat_gisco_geodata_url(files[[year]])
    name <- basename(url)
  }

  data_sf <- read_gisco_dataset(
    url,
    name = name,
    cache_dir = cache_dir,
    subdir = "airports",
    update_cache = update_cache,
    verbose = verbose,
    post_process = transform_to_wgs84
  )
  if (is.null(data_sf)) {
    return(NULL)
  }

  country <- convert_country_code_or_null(country)
  filter_by_country_col(data_sf, country, "CNTR_CODE")
}
