#' Get GISCO NUTS `sf` polygons, points and lines
#'
#' @description
#' Returns
#' [NUTS regions](https://en.wikipedia.org/wiki/Nomenclature_of_Territorial_Units_for_Statistics)
#' polygons, lines and points at a specified scale, as provided by GISCO.
#'
#' NUTS are provided at three different levels:
#' * **"0"**: Country level
#' * **"1"**: Groups of states/regions
#' * **"2"**: States/regions
#' * **"3"**: Counties/provinces/districts
#'
#' Note that NUTS-level definition may vary across countries. See also
#' <https://ec.europa.eu/eurostat/web/nuts/background>.
#'
#' @concept political
#' @family political
#'
#' @return A `sf` object specified by `spatialtype`. The resulting `sf` object
#' would present an additional column `geo` (equal to `NUTS_ID`) for
#' improving compatibility with \CRANpkg{eurostat} package. See
#' [eurostat::get_eurostat_geospatial()]). See also [gisco_nuts] to
#' understand the columns and values provided.
#'
#' @param year Release year of the file. One of "2003", "2006,
#'   "2010", "2013", "2016" or "2021".
#'
#' @param spatialtype Type of geometry to be returned:
#'  * **"BN"**: Boundaries - `LINESTRING` object.
#'  * **"LB"**: Labels - `POINT` object.
#'  * **"RG"**: Regions - `MULTIPOLYGON/POLYGON` object.
#'
#' @param nuts_level NUTS level. One of "0", "1", "2" or "3".
#' See Description.
#'
#' @param nuts_id Optional. A character vector of NUTS IDs.
#'
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#'
#' @seealso [gisco_nuts], [gisco_get_countries()],
#' [eurostat::get_eurostat_geospatial()]
#'
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>
#'
#' @export
#'
#' @examples
#' nuts2 <- gisco_get_nuts(nuts_level = 2)
#'
#' library(ggplot2)
#'
#' ggplot(nuts2) +
#'   geom_sf() +
#'   # ETRS89 / ETRS-LAEA
#'   coord_sf(
#'     crs = 3035, xlim = c(2377294, 7453440),
#'     ylim = c(1313597, 5628510)
#'   ) +
#'   labs(title = "NUTS-2 levels")
#' \donttest{
#' # NUTS-3 for Germany
#' germany_nuts3 <- gisco_get_nuts(nuts_level = 3, country = "Germany")
#'
#' ggplot(germany_nuts3) +
#'   geom_sf() +
#'   labs(
#'     title = "NUTS-3 levels",
#'     subtitle = "Germany",
#'     caption = gisco_attributions()
#'   )
#'
#'
#' # Select specific regions
#' select_nuts <- gisco_get_nuts(nuts_id = c("ES2", "FRJ", "FRL", "ITC"))
#'
#' ggplot(select_nuts) +
#'   geom_sf(aes(fill = CNTR_CODE)) +
#'   scale_fill_viridis_d()
#' }
gisco_get_nuts <- function(year = "2016",
                           epsg = "4326",
                           cache = TRUE,
                           update_cache = FALSE,
                           cache_dir = NULL,
                           verbose = FALSE,
                           resolution = "20",
                           spatialtype = "RG",
                           country = NULL,
                           nuts_id = NULL,
                           nuts_level = "all") {
  ext <- "geojson"

  nuts_level <- as.character(nuts_level)

  api_entry <- gsc_api_url(
    id_giscoR = "nuts", year = year, epsg = epsg,
    resolution = resolution, spatialtype = spatialtype, ext = ext,
    nuts_level = nuts_level, level = NULL, verbose = verbose
  )

  filename <- basename(api_entry)

  # Check if data is already available
  checkdata <- grep("NUTS_RG_20M_2016_4326", filename)
  if (isFALSE(update_cache) && length(checkdata)) {
    dwnload <- FALSE
    data_sf <- giscoR::gisco_nuts

    gsc_message(
      verbose,
      "Loaded from gisco_nuts dataset. Use update_cache = TRUE to load",
      " the shapefile from the .geojson file"
    )

    if (nuts_level %in% c("0", "1", "2", "3")) {
      data_sf <- data_sf[data_sf$LEVL_CODE == nuts_level, ]
    }
  } else {
    dwnload <- TRUE
  }
  if (dwnload) {
    # Speed up if requesting units
    if (!is.null(nuts_id) && spatialtype %in% c("RG", "LB")) {
      data_sf <- gisco_get_units(
        id_giscoR = "nuts", unit = nuts_id,
        mode = "sf", year = year, epsg = epsg, cache = cache,
        cache_dir = cache_dir, update_cache = update_cache, verbose = verbose,
        resolution = resolution, spatialtype = spatialtype
      )
    } else {
      if (cache) {
        # Guess source to load
        namefileload <- gsc_api_cache(
          api_entry, filename, cache_dir,
          update_cache, verbose
        )
      } else {
        namefileload <- api_entry
      }

      if (is.null(namefileload)) {
        return(NULL)
      }
      # Load - geojson only so far
      data_sf <- gsc_api_load(namefileload, epsg, ext, cache, verbose)
    }
  }
  if (!is.null(country) && "CNTR_CODE" %in% names(data_sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }

  if (!is.null(nuts_id) && "NUTS_ID" %in% names(data_sf)) {
    data_sf <- data_sf[data_sf$NUTS_ID %in% nuts_id, ]
  }

  # Add geo field for compatibility with eurostat
  if ("NUTS_ID" %in% names(data_sf)) {
    data_sf$geo <- data_sf$NUTS_ID

    # Recompute position
    allnams <- names(data_sf)
    geo_col <- attr(data_sf, "sf_column")
    # geo_col last
    neword <- unique(c(setdiff(allnams, geo_col), geo_col))

    data_sf <- data_sf[, neword]
  }
  return(data_sf)
}
