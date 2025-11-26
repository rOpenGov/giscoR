#' Get locations of healthcare services in Europe
#'
#' @family infrastructure
#'
#' @description
#' The dataset contains information on main healthcare services considered to
#' be 'hospitals' by Member States.
#'
#' @return A `POINT` [`sf`][sf::st_sf] object.
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/basic-services>
#'
#' @param year Release year of the file. One of `"2020"`, `"2023"` (default).
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#'
#' @details
#' Files are distributed on EPSG:4326. Metadata available on
#' <https://gisco-services.ec.europa.eu/pub/healthcare/metadata.pdf>.
#'
#' @seealso [gisco_get_countries()]
#' @examplesIf gisco_check_access()
#' \donttest{
#'
#' health_be <- gisco_get_healthcare(country = "Belgium")
#'
#' # Plot if downloaded
#' if (inherits(health_be, "sf")) {
#'   library(ggplot2)
#'   ggplot(health_be) +
#'     geom_sf()
#' }
#' }
#' @export
gisco_get_healthcare <- function(
  year = c("2023", "2020"),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL
) {
  # Given vars
  year <- as.character(year)
  year <- match.arg(year)

  api_entry <- paste0(
    "https://gisco-services.ec.europa.eu/pub/healthcare/",
    year,
    "/gpkg/EU.gpkg"
  )
  filename <- paste0("health_", year, "_", basename(api_entry))

  if (cache) {
    # Guess source to load
    namefileload <- load_url(
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
