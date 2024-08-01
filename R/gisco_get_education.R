#' Get locations of education services in Europe
#'
#' @family infrastructure
#'
#' @description
#' The dataset contains information on main education services by Member States.
#'
#' @return A `POINT` [`sf`][sf::st_sf] object.
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/basic-services>
#'
#' @inheritParams gisco_get_healthcare
#'
#' @inheritSection gisco_get_countries About caching
#'
#' @details
#' Files are distributed on EPSG:4326. Metadata available on
#' <https://gisco-services.ec.europa.eu/pub/education/metadata.pdf>.
#'
#' @seealso [gisco_get_countries()]
#' @examplesIf gisco_check_access()
#' \donttest{
#'
#' edu_BEL <- gisco_get_education(country = "Belgium")
#'
#' # Plot if downloaded
#' if (nrow(edu_BEL) > 3) {
#'   library(ggplot2)
#'   ggplot(edu_BEL) +
#'     geom_sf(shape = 21, size = 0.15)
#' }
#' }
#' @export
gisco_get_education <- function(year = c("2023", "2020"),
                                cache = TRUE, update_cache = FALSE,
                                cache_dir = NULL, verbose = FALSE,
                                country = NULL) {
  # Given vars
  year <- match.arg(year)
  epsg <- "4326"
  ext <- "gpkg"

  if (!is.null(country)) {
    country_get <- gsc_helper_countrynames(country, "eurostat")
  } else {
    country_get <- "EU"
  }


  api_entry <- paste0(
    "https://gisco-services.ec.europa.eu/pub/education/", year, "/gpkg/",
    country_get, ".gpkg"
  )

  n_cnt <- seq_len(length(api_entry))

  ress <- lapply(n_cnt, function(x) {
    api <- api_entry[x]
    filename <- paste0("edu_", year, "_", basename(api_entry))


    if (cache) {
      # Guess source to load
      namefileload <- gsc_api_cache(
        api, filename, cache_dir, update_cache,
        verbose
      )
    } else {
      namefileload <- api
    }

    if (is.null(namefileload)) {
      return(NULL)
    }

    data_sf <- gsc_api_load(namefileload, epsg, ext, cache, verbose)

    data_sf
  })

  data_sf_all <- do.call("rbind", ress)

  return(data_sf_all)
}
