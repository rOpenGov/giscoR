#' Get GISCO coastlines `sf` polygons
#'
#' Downloads worldwide coastlines
#'
#' @concept political
#' @family political
#'
#' @param year Release year. One of "2006", "2010", "2013" or "2016"
#'
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#'
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>
#'
#' @return A `sf` `POLYGON` object.
#'
#' @note
#' Please check the download and usage provisions on [gisco_attributions()].
#'
#' @seealso [gisco_coastallines]
#'
#' @examplesIf gisco_check_access()
#' coast <- gisco_get_coastallines()
#'
#' library(ggplot2)
#'
#' ggplot(coast) +
#'   geom_sf(color = "#1278AB", fill = "#FDFBEA") +
#'   # Zoom on Caribe
#'   coord_sf(
#'     xlim = c(-99, -49),
#'     ylim = c(4, 30)
#'   ) +
#'   theme_minimal() +
#'   theme(panel.background = element_rect(fill = "#C7E7FB", color = "black"))
#' @export
gisco_get_coastallines <- function(year = "2016",
                                   epsg = "4326",
                                   cache = TRUE,
                                   update_cache = FALSE,
                                   cache_dir = NULL,
                                   verbose = FALSE,
                                   resolution = "20") {
  ext <- "geojson"

  api_entry <- gsc_api_url(
    id_giscoR = "coastallines",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = NULL,
    ext = ext,
    nuts_level = NULL,
    level = NULL,
    verbose = verbose
  )

  filename <- basename(api_entry)

  # Check if data is already available
  checkdata <- grep("COAS_RG_20M_2016_4326", api_entry)
  if (isFALSE(update_cache) && length(checkdata)) {
    dwnload <- FALSE
    data_sf <- giscoR::gisco_coastallines

    gsc_message(
      verbose,
      "Loaded from gisco_coastallines dataset. Use update_cache = TRUE",
      "to load the shapefile from the .geojson file"
    )
  } else {
    dwnload <- TRUE
  }
  if (dwnload) {
    if (cache) {
      # Guess source to load
      namefileload <-
        gsc_api_cache(
          api_entry,
          filename,
          cache_dir,
          update_cache,
          verbose
        )
    } else {
      namefileload <- api_entry
    }

    if (is.null(namefileload)) {
      return(NULL)
    }

    # Load - geojson only so far
    data_sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }
  return(data_sf)
}
