#' Get the healthcare services in Europe.
#'
#' @concept infrastructure
#'
#' @description
#' The dataset contains information on main healthcare services considered to
#' be 'hospitals' by Member States.
#'
#' @return A `POINT` object.
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/healthcare-services>
#'
#' @inheritParams gisco_get
#'
#' @details
#' Files are distributed on EPSG:4326. Metadata available on
#' <https://gisco-services.ec.europa.eu/pub/healthcare/metadata.pdf>.
#'
#' @seealso [gisco_get]
#'
#' @export
gisco_get_healthcare <- function(cache = TRUE,
                                 update_cache = FALSE,
                                 cache_dir = NULL,
                                 verbose = FALSE,
                                 country = NULL) {
  # Given vars
  epsg <- "4326"
  ext <- "gpkg"

  geturl <-
    list(
      api.url =
        "https://gisco-services.ec.europa.eu/pub/healthcare/gpkg/all.gpkg",
      namefile = "all.gpkg"
    )


  if (cache) {
    # Guess source to load
    namefileload <-
      gsc_api_cache(
        geturl$api.url,
        geturl$namefile,
        cache_dir,
        update_cache,
        verbose
      )
  } else {
    namefileload <- geturl$api.url
  }
  data_sf <-
    gsc_api_load(namefileload, epsg, ext, cache, verbose)

  if (!is.null(country) & "cc" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$cc %in% country, ]
  }
  return(data_sf)
}
