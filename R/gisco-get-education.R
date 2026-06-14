#' Education services in Europe
#'
#' @description
#' This dataset integrates Member States' official data on the location of
#' education services. Additional information on these services is included
#' when available. See **Details**.
#'
#' @family services
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file. One of
#'   `2023`, `2020`.
#'
#' @inherit gisco_get_countries return
#' @details
#' Files are distributed in [EPSG:4326](https://epsg.io/4326).
#'
#' ```{r child = "man/chunks/education_meta.Rmd"}
#' ```
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/basic-services>.
#'
#' There are no specific download rules for the datasets shown below. However,
#' please refer to [the general copyright
#' notice](https://ec.europa.eu/eurostat/web/gisco/geodata) and license
#' provisions, which apply to these datasets. Permission to download and use
#' these data is subject to acceptance of those rules.
#'
#' The data are extracted from official national registers. They may contain
#' inconsistencies, inaccuracies and gaps due to the heterogeneity of the
#' national input data.
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#' edu_austria <- gisco_get_education(country = "Austria", year = 2023)
#'
#' # Plot if downloaded.
#' if (!is.null(edu_austria)) {
#'   austria_nuts3 <- gisco_get_nuts(country = "Austria", nuts_level = 3)
#'
#'   library(ggplot2)
#'   ggplot(austria_nuts3) +
#'     geom_sf(fill = "grey10", color = "grey60") +
#'     geom_sf(
#'       data = edu_austria, aes(color = rev(public_private)),
#'       alpha = 0.25
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
#'       title = "Education", subtitle = "Austria (2023)",
#'       caption = "Source: Eurostat, Education 2023 dataset.",
#'       color = "Type"
#'     ) +
#'     coord_sf(crs = 3035)
#' }
#' }
#'
#' @export
#'
gisco_get_education <- function(
  year = c(2023, 2020),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL
) {
  # Set required variables.
  year <- match_arg_pretty(year)

  country_get <- convert_country_code_or_null(country)
  if (is.null(country_get)) {
    country_get <- "EU"
  }

  api_entry <- basic_service_url("education", year, country_get)

  n_cnt <- seq_along(api_entry)

  ress <- lapply(n_cnt, function(x) {
    api <- api_entry[x]
    filename <- basic_service_filename("edu", year, api)

    read_gisco_dataset(
      url = api,
      name = filename,
      cache = cache,
      cache_dir = cache_dir,
      subdir = "education",
      update_cache = update_cache,
      verbose = verbose
    )
  })

  data_sf_all <- rbind_fill(ress)
  if (is.null(data_sf_all)) {
    return(NULL)
  }

  data_sf_all
}

#' Build a basic service dataset URL
#'
#' @param service A basic service name.
#' @param year A dataset year.
#' @param country A country code.
#'
#' @return A character string with the dataset URL.
#' @noRd
basic_service_url <- function(service, year, country = "EU") {
  paste0(gisco_pub_url(), service, "/", year, "/gpkg/", country, ".gpkg")
}

#' Build a cached basic service file name
#'
#' @param prefix A cache file prefix.
#' @param year A dataset year.
#' @param url A dataset URL.
#'
#' @return A character string with the cache file name.
#' @noRd
basic_service_filename <- function(prefix, year, url) {
  paste0(prefix, "_", year, "_", basename(url))
}
