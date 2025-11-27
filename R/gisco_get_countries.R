#' Get GISCO world country [`sf`][sf::st_sf] polygons, points and lines
#'
#' @description
#' Returns world country polygons, lines and points at a specified scale, as
#' provided by GISCO. Also, specific areas as Gibraltar or Antarctica are
#' presented separately. The definition of country used on GISCO
#' correspond roughly with territories with an official
#' [ISO-3166](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
#' code.
#'
#' @aliases gisco_get
#'
#' @note
#' Please check the download and usage provisions on [gisco_attributions()].
#'
#' @family admin
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
#'  corresponding file by any other method and save it on your
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
#' @return A [`sf`][sf::st_sf] object specified by `spatialtype`.
#'
#' @param year Release year of the file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("countries",
#'   "year",TRUE)}`.
#'
#' @param epsg projection of the map: 4-digit [EPSG code](https://epsg.io/).
#'  One of:
#'  * `"4326"`: WGS84
#'  * `"3035"`: ETRS89 / ETRS-LAEA
#'  * `"3857"`: Pseudo-Mercator
#'
#' @param cache A logical whether to do caching. Default is `TRUE`. See
#'   **About caching**.
#'
#' @param update_cache A logical whether to update cache. Default is `FALSE`.
#'  When set to `TRUE` it would force a fresh download of the source
#'  `.gpkg` file.
#'
#' @param cache_dir A path to a cache directory. See **About caching**.
#'
#' @param spatialtype Type of geometry to be returned:
#'  * `"BN"`: Boundaries - `LINESTRING` object.
#'  * `"COASTL"`: coastlines - `LINESTRING` object.
#'  * `"INLAND"`: inland boundaries - `LINESTRING` object.
#'  * `"LB"`: Labels - `POINT` object.
#'  * `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#'
#'  **Note that** parameters `country` and `region` would be only applied
#'  when `spatialtype` is `"BN"` or `"RG"`.
#'
#' @param country Optional. A character vector of country codes. It could be
#'  either a vector of country names, a vector of ISO3 country codes or a
#'  vector of Eurostat country codes. Mixed types (as `c("Italy","ES","FRA")`)
#'  would not work. See also [countrycode::countrycode()].
#'
#' @param verbose Logical, displays information. Useful for debugging,
#'   default is `FALSE`.
#'
#' @param resolution Resolution of the geospatial data. One of
#'  * `"60"`: 1:60million
#'  * `"20"`: 1:20million
#'  * `"10"`: 1:10million
#'  * `"03"`: 1:3million
#'  * `"01"`: 1:1million
#'
#' @param region Optional. A character vector of UN M49 region codes or
#'  European Union membership. Possible values are `"Africa"`, `"Americas"`,
#'  `"Asia"`, `"Europe"`, `"Oceania"` or `"EU"` for countries belonging to the
#'  European Union (as per 2021). See **About world regions** and
#'  [gisco_countrycode].
#'
#' @seealso [gisco_countrycode()], [gisco_countries],
#'   [countrycode::countrycode()]
#'
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>
#' @export
#'
#' @examples
#'
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
#'
gisco_get_countries <- function(
  year = "2024",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = "20",
  spatialtype = "RG",
  country = NULL,
  region = NULL
) {
  api_entry <- get_url_db(
    id = "countries",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = spatialtype,
    ext = "gpkg",
    fn = "gisco_get_countries"
  )

  filename <- basename(api_entry)

  # Check if data is already available
  checkdata <- grepl("CNTR_RG_20M_2024_4326.gpkg", filename)
  if (all(isFALSE(update_cache), checkdata)) {
    data_sf <- giscoR::gisco_countries_2024

    make_msg(
      "info",
      verbose,
      "Loaded from {.help giscoR::gisco_countries_2024} dataset.",
      "Use {.arg update_cache = TRUE} to re-load from file"
    )
    data_sf <- filter_countryregion(data_sf, country, region)

    return(data_sf)
  }
  # Speed up if requesting units
  # If country and  spatialtype %in% c("RG", "LB")
  if (all(!is.null(country), is.null(region), spatialtype %in% c("RG", "LB"))) {
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
    data_sf <- filter_countryregion(data_sf, country, region)

    return(data_sf)
  }

  if (cache) {
    # Guess source to load
    namefileload <- load_url(
      api_entry,
      filename,
      cache_dir,
      "countries",
      update_cache,
      verbose
    )
  } else {
    msg <- paste0("{.url ", api_entry, "}.")
    make_msg("info", verbose, "Reading from", msg)
    namefileload <- api_entry
  }

  if (is.null(namefileload)) {
    return(NULL)
  }
  # Load
  data_sf <- read_geo_file_sf(namefileload)
  data_sf <- filter_countryregion(data_sf, country, region)

  data_sf
}

filter_countryregion <- function(data_sf, country = NULL, region = NULL) {
  if (!"CNTR_ID" %in% names(data_sf)) {
    return(data_sf)
  }
  if (all(is.null(country), is.null(region))) {
    return(data_sf)
  }

  data_sf <- data_sf[order(data_sf$CNTR_ID), ]

  if (!is.null(country)) {
    country <- get_country_code(country)
    data_sf <- data_sf[data_sf$CNTR_ID %in% country, ]
  }

  if (!is.null(region)) {
    region_df <- giscoR::gisco_countrycode
    cntryregion <- region_df[region_df$un.region.name %in% region, ]

    if ("EU" %in% region) {
      eu <- region_df[region_df$eu, ]
      cntryregion <- unique(rbind(cntryregion, eu))
    }

    data_sf <- data_sf[data_sf$CNTR_ID %in% cntryregion$CNTR_CODE, ]
  }
  data_sf
}
