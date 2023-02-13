#' Get GISCO world country `sf` polygons, points and lines
#'
#' @description
#' Returns world country polygons, lines and points at a specified scale, as
#' provided by GISCO. Also, specific areas as Gibraltar or Antarctica are
#' presented separately. The definition of country used on GISCO
#' correspond roughly with territories with an official
#' [ISO-3166](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
#' code.
#'
#' @rdname gisco_get
#'
#' @note
#' Please check the download and usage provisions on [gisco_attributions()].
#'
#' @concept political
#' @family political
#'
#' @details
#' # About caching
#'
#' You can set your `cache_dir` with [gisco_set_cache_dir()].
#'
#' Sometimes cached files may be corrupt. On that case, try re-downloading
#' the data setting `update_cache = TRUE`.
#'
#'  If you experience any problem on download, try to download the
#'  corresponding .geojson file by any other method and save it on your
#'  `cache_dir`. Use the option `verbose = TRUE` for debugging the API query.
#'
#' For a complete list of files available check [gisco_db].
#'
#'
#' # World Regions
#'
#' Regions are defined as per the geographic regions defined by the
#' UN (see <https://unstats.un.org/unsd/methodology/m49/>.
#' Under this scheme Cyprus is assigned to Asia. You may use
#' `region = "EU"` to get the EU members (reference date: 2021).
#'
#'
#' @return A `sf` object specified by `spatialtype`.
#'
#' @param year Release year of the file. One of "2001", "2006",
#'   "2010", "2013", "2016" or "2020".
#'
#' @param epsg projection of the map: 4-digit [EPSG code](https://epsg.io/).
#'  One of:
#'  * "4258": ETRS89
#'  * "4326": WGS84
#'  * "3035": ETRS89 / ETRS-LAEA
#'  * "3857": Pseudo-Mercator
#'
#' @param cache A logical whether to do caching. Default is `TRUE`. See
#'   **About caching**.
#'
#' @param update_cache A logical whether to update cache. Default is `FALSE`.
#'  When set to `TRUE` it would force a fresh download of the source
#'  .geojson file.
#'
#' @param cache_dir A path to a cache directory. See **About caching**.
#'
#' @param spatialtype Type of geometry to be returned:
#'  * **"BN"**: Boundaries - `LINESTRING` object.
#'  * **"COASTL"**: coastlines - `LINESTRING` object.
#'  * **"INLAND"**: inland boundaries - `LINESTRING` object.
#'  * **"LB"**: Labels - `POINT` object.
#'  * **"RG"**: Regions - `MULTIPOLYGON/POLYGON` object.
#'
#' @param country Optional. A character vector of country codes. It could be
#'  either a vector of country names, a vector of ISO3 country codes or a
#'  vector of Eurostat country codes. Mixed types (as `c("Turkey","US","FRA")`)
#'  would not work. See also [countrycode::countrycode()].
#'
#' @param verbose Logical, displays information. Useful for debugging,
#'   default is `FALSE`.
#'
#' @param resolution Resolution of the geospatial data. One of
#'  * "60": 1:60million
#'  * "20": 1:20million
#'  * "10": 1:10million
#'  * "03": 1:3million
#'  * "01": 1:1million
#'
#' @param region Optional. A character vector of UN M49 region codes or
#'  European Union membership. Possible values are "Africa", "Americas",
#'  "Asia", "Europe", "Oceania" or "EU" for countries belonging to the European
#'  Union (as per 2021). See **About world regions** and [gisco_countrycode]
#'
#' @seealso [gisco_countrycode()], [gisco_countries],
#'   [countrycode::countrycode()]
#'
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>
#' @export
#'
#' @examples
#' cntries <- gisco_get_countries()
#'
#' library(ggplot2)
#' ggplot(cntries) +
#'   geom_sf()
#'
#' # Get a region
#'
#' africa <- gisco_get_countries(region = "Africa")
#' ggplot(africa) +
#'   geom_sf(fill = "#078930", col = "white") +
#'   theme_minimal()
#' \donttest{
#' if (gisco_check_access()) {
#'   # Extract points
#'   asia_pol <- gisco_get_countries(region = "Asia", resolution = "3")
#'   asia_lb <- gisco_get_countries(spatialtype = "LB", region = "Asia")
#'   ggplot(asia_pol) +
#'     geom_sf(fill = "gold3") +
#'     geom_sf(data = asia_lb, color = "#007FFF")
#' }
#' }
gisco_get_countries <- function(year = "2016",
                                epsg = "4326",
                                cache = TRUE,
                                update_cache = FALSE,
                                cache_dir = NULL,
                                verbose = FALSE,
                                resolution = "20",
                                spatialtype = "RG",
                                country = NULL,
                                region = NULL) {
  ext <- "geojson"

  api_entry <- gsc_api_url(
    id_giscoR = "countries",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = spatialtype,
    ext = ext,
    nuts_level = NULL,
    level = NULL,
    verbose = verbose
  )

  filename <- basename(api_entry)

  # Check if data is already available
  checkdata <- grep("CNTR_RG_20M_2016_4326", filename)
  if (isFALSE(update_cache) && length(checkdata)) {
    dwnload <- FALSE
    data_sf <- giscoR::gisco_countries

    gsc_message(
      verbose,
      "Loaded from gisco_countries dataset. Use update_cache = TRUE
    to load the shapefile from the .geojson file"
    )
  } else {
    dwnload <- TRUE
  }
  if (dwnload) {
    # Speed up if requesting units
    if (!is.null(country) && spatialtype %in% c("RG", "LB")) {
      data_sf <- gisco_get_units(
        id_giscoR = "countries",
        unit = country,
        mode = "sf",
        year = year,
        epsg = epsg,
        cache = cache,
        cache_dir = cache_dir,
        update_cache = update_cache,
        verbose = verbose,
        resolution = resolution,
        spatialtype = spatialtype
      )
    } else {
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

      # Load - geojson only so far
      data_sf <-
        gsc_api_load(namefileload, epsg, ext, cache, verbose)
    }
  }

  if (!is.null(country) && "CNTR_ID" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_ID %in% country, ]
  }
  if (!is.null(region) && "CNTR_ID" %in% names(data_sf)) {
    region_df <- giscoR::gisco_countrycode
    cntryregion <- region_df[region_df$un.region.name %in% region, ]

    if ("EU" %in% region) {
      eu <- region_df[region_df$eu, ]
      cntryregion <- unique(rbind(cntryregion, eu))
    }

    data_sf <- data_sf[data_sf$CNTR_ID %in% cntryregion$CNTR_CODE, ]
  }

  return(data_sf)
}
