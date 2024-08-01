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
gisco_get_healthcare <- function(year = c("2023", "2020"), cache = TRUE,
                                 update_cache = FALSE, cache_dir = NULL,
                                 verbose = FALSE, country = NULL) {
  # Given vars
  year <- match.arg(year)
  epsg <- "4326"
  ext <- "gpkg"

  api_entry <- paste0(
    "https://gisco-services.ec.europa.eu/pub/healthcare/", year,
    "/gpkg/EU.gpkg"
  )
  filename <- paste0("health_", year, "_", basename(api_entry))


  if (cache) {
    # Guess source to load
    namefileload <- gsc_api_cache(
      api_entry, filename, cache_dir, update_cache,
      verbose
    )
  } else {
    namefileload <- api_entry
  }

  if (is.null(namefileload)) {
    return(NULL)
  }

  data_sf <- gsc_api_load(namefileload, epsg, ext, cache, verbose)

  if (!is.null(country) && "cntr_id" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$cntr_id %in% country, ]
  }
  return(data_sf)
}
