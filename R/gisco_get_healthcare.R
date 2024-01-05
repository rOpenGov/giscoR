#' Get locations of healthcare services in Europe.
#'
#' @concept infrastructure
#' @family infrastructure
#'
#' @description
#' The dataset contains information on main healthcare services considered to
#' be 'hospitals' by Member States.
#'
#' @return A `POINT` \CRANpkg{sf} object.
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/healthcare-services>
#'
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
#' health_BEL <- gisco_get_healthcare(country = "Belgium")
#' health_BEL
#' }
#' @export
gisco_get_healthcare <- function(cache = TRUE,
                                 update_cache = FALSE,
                                 cache_dir = NULL,
                                 verbose = FALSE,
                                 country = NULL) {
  # Given vars
  epsg <- "4326"
  ext <- "gpkg"

  api_entry <- paste0(
    "https://gisco-services.ec.europa.eu/pub/healthcare",
    "/gpkg/EU.gpkg"
  )
  filename <- basename(api_entry)


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

  if (!is.null(country) && "cc" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$cc %in% country, ]
  }
  return(data_sf)
}
