#' @title Get the healthcare services in Europe.
#' @description The dataset contains information on main healthcare services considered to be 'hospitals' by Member States.
#' @return A \code{POINT} object.
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @source \href{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/healthcare-services}{GISCO Healthcare services}
#' @param cache,update_cache,cache_dir,verbose,country See \link{gisco_get}
#' @details Files are distributed on EPSG:4326. \href{https://gisco-services.ec.europa.eu/pub/healthcare/metadata.pdf}{Link to metadata}
#' @examples
#' library(sf)
#'
#' if (gisco_check_access()) {
#'   HospitalBENELUX <- gisco_get_healthcare(country = c("BE", "NL", "LU"))
#'   BENELUX <- gisco_get_countries(country = c("BE", "NL", "LU"))
#'   plot(st_geometry(BENELUX))
#'   plot(
#'     st_geometry(HospitalBENELUX),
#'     pch = 20,
#'     col = "steelblue1",
#'     add = TRUE
#'   )
#'   title(main = "Hospitals in Benelux",
#'         sub = gisco_attributions(),
#'         line = 1)
#' }
#' @seealso \link{gisco_get}
#' @export
gisco_get_healthcare <- function(cache = TRUE,
                                 update_cache = FALSE,
                                 cache_dir = NULL,
                                 verbose = FALSE,
                                 country = NULL) {
  # Given vars
  epsg = "4326"
  ext <- "gpkg"

  geturl <-
    list(api.url = "https://gisco-services.ec.europa.eu/pub/healthcare/gpkg/all.gpkg",
         namefile = "gisco_healthcare.gpkg")


  if (cache) {
    # Guess source to load
    namefileload <-
      gsc_api_cache(geturl$api.url,
                    geturl$namefile,
                    cache_dir,
                    update_cache,
                    verbose)
  } else {
    namefileload <- geturl$api.url
  }
  data.sf <-
    gsc_api_load(namefileload, epsg, ext, cache, verbose)

  if (!is.null(country) & "cc" %in% names(data.sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data.sf <- data.sf[data.sf$cc %in% country, ]
  }
  return(data.sf)
}
