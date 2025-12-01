#' Healthcare services in Europe
#'
#' @description
#' The dataset contains information on main healthcare services considered to
#' be 'hospitals' by Member States. The definition varies slightly from country
#' to country, but roughly includes the following:
#'
#' *"'Hospitals' comprises licensed establishments primarily engaged in
#' providing medical, diagnostic, and treatment services that include physician,
#' nursing, and other health services to in-patients and the specialised
#' accommodation services required by inpatients*.
#'
#' @family services
#' @inherit gisco_get_education return source
#' @inheritParams gisco_get_countries
#' @encoding UTF-8
#' @export
#'
#' @param year character string or number. Release year of the file. One of
#'   `2023`, `2020`.
#'
#'
#' @details
#' Files are distributed [EPSG:4326](https://epsg.io/4326).
#'
#' ```{r child = "man/chunks/healthcare_meta.Rmd"}
#' ```
#'
#' @examplesIf gisco_check_access()
#' health_be <- gisco_get_healthcare(country = "Belgium")
#'
#' # Plot if downloaded
#' if (inherits(health_be, "sf")) {
#'   library(ggplot2)
#'   ggplot(health_be) +
#'     geom_sf()
#' }
gisco_get_healthcare <- function(
  year = c(2023, 2020),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL
) {
  # Given vars
  year <- match_arg_pretty(year)

  api_entry <- paste0(
    "https://gisco-services.ec.europa.eu/pub/healthcare/",
    year,
    "/gpkg/EU.gpkg"
  )
  filename <- paste0("health_", year, "_", basename(api_entry))

  if (cache) {
    # Guess source to load
    namefileload <- download_url(
      api_entry,
      filename,
      cache_dir,
      "health",
      update_cache,
      verbose
    )
  } else {
    namefileload <- api_entry
  }

  if (is.null(namefileload)) {
    return(NULL)
  }

  data_sf <- read_geo_file_sf(namefileload)

  if (!is.null(country) && "cntr_id" %in% names(data_sf)) {
    country <- get_country_code(country)
    data_sf <- data_sf[data_sf$cntr_id %in% country, ]
  }

  data_sf
}
