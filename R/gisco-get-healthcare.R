#' Healthcare services in Europe
#'
#' @description
#' The dataset contains information on healthcare services considered
#' hospitals by Member States. The definition varies slightly from country to
#' country, but roughly includes the following:
#'
#' - Hospitals comprise licensed establishments primarily engaged in
#' providing medical, diagnostic and treatment services that include
#' physician, nursing and other health services to inpatients and the
#' specialized accommodation services required by inpatients.
#'
#' @family services
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file. One of
#'   `2023`, `2020`.
#'
#' @inherit gisco_get_education return
#' @details
#' Files are distributed in [EPSG:4326](https://epsg.io/4326).
#'
#' ```{r child = "man/chunks/healthcare_meta.Rmd"}
#' ```
#'
#' @inherit gisco_get_education source
#' @examplesIf gisco_check_access()
#' health_benelux <- gisco_get_healthcare(
#'   country = c("BE", "NL", "LU"),
#'   year = 2023
#' )
#'
#' # Plot if downloaded.
#' if (!is.null(health_benelux)) {
#'   benelux <- gisco_get_countries(country = c("BE", "NL", "LU"))
#'
#'   library(ggplot2)
#'   ggplot(benelux) +
#'     geom_sf(fill = "grey10", color = "grey20") +
#'     geom_sf(
#'       data = health_benelux, color = "red",
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
#'       title = "Healthcare services", subtitle = "Benelux (2023)",
#'       caption = "Source: Eurostat, Healthcare 2023 dataset."
#'     ) +
#'     coord_sf(crs = 3035)
#' }
#' @export
#'
gisco_get_healthcare <- function(
  year = c(2023, 2020),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL
) {
  # Set required variables.
  year <- match_arg_pretty(year)

  api_entry <- basic_service_url("healthcare", year)
  filename <- basic_service_filename("health", year, api_entry)

  country <- convert_country_code_or_null(country)
  read_gisco_dataset(
    url = api_entry,
    name = filename,
    cache = cache,
    cache_dir = cache_dir,
    subdir = "health",
    update_cache = update_cache,
    verbose = verbose,
    post_process = function(data_sf) {
      filter_by_country_col(data_sf, country, "cntr_id")
    }
  )
}
