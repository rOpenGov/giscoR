#' Country data
#'
#' @description
#' This data set contains the administrative boundaries at country level of the
#' world. This dataset consists of 2 feature classes (regions, boundaries) per
#' scale level and there are 5 different scale levels (1M, 3M, 10M, 20M and
#' 60M).
#'
#' @aliases gisco_get
#' @family admin
#' @export
#'
#' @param year character string or number. Release year of the file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("countries",
#'   "year",TRUE)}.
#' @param epsg character string or number. Projection of the map: 4-digit
#'   [EPSG code](https://epsg.io/). One of:
#'   * `"4326"`: [WGS84](https://epsg.io/4326)
#'   * `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035)
#'   * `"3857"`: [Pseudo-Mercator](https://epsg.io/3857)
#' @param cache logical. Whether to do caching. Default is `TRUE`. See
#'   **Caching strategies** section in [gisco_set_cache_dir()].
#' @param update_cache logical. Should the cached file be refreshed?. Default
#'   is `FALSE`. When set to `TRUE` it would force a new download.
#' @param cache_dir character string. A path to a cache directory. See
#'   **Caching strategies** section in [gisco_set_cache_dir()].
#' @param spatialtype character string. Type of geometry to be returned.
#'   Options available are:
#'   * `"BN"`: Boundaries - `LINESTRING` object.
#'   * `"COASTL"`: coastlines - `LINESTRING` object.
#'   * `"INLAND"`: inland boundaries - `LINESTRING` object.
#'   * `"LB"`: Labels - `POINT` object.
#'   * `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#' @param country Optional. A character vector of country codes. It could be
#'   either a vector of country names, a vector of ISO3 country codes or a
#'   vector of Eurostat country codes. See also [countrycode::countrycode()].
#' @param verbose logical. If `TRUE` displays informational messages.
#' @param resolution character string or number. Resolution of the geospatial
#'   data. One of:
#'   * `"60"`: 1:60million
#'   * `"20"`: 1:20million
#'   * `"10"`: 1:10million
#'   * `"03"`: 1:3million
#'   * `"01"`: 1:1million
#' @param region Optional. A character vector of UN M49 region codes or
#'   European Union membership. Possible values are `"Africa"`, `"Americas"`,
#'   `"Asia"`, `"Europe"`, `"Oceania"` or `"EU"` for countries belonging to the
#'   European Union (as per 2021). See **World regions** and
#'   [gisco_countrycode].
#' @param ext character. Extension of the file (default `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("countries",
#'   "ext",TRUE)}.
#' @return A [`sf`][sf::st_sf] object.
#'
#' @seealso
#' [gisco_countrycode], [gisco_countries_2024], [countrycode::countrycode()]
#'
#' @source
#' <https://gisco-services.ec.europa.eu/distribution/v2/>
#'
#' Copyright:
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>
#'
#' @examples
#' \donttest{
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
#' }
gisco_get_countries <- function(
  year = 2024,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = 20,
  spatialtype = "RG",
  country = NULL,
  region = NULL,
  ext = "gpkg"
) {
  valid_ext <- c("geojson", "gpkg", "shp")
  ext <- match_arg_pretty(ext, valid_ext)

  api_entry <- get_url_db(
    id = "countries",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = spatialtype,
    ext = ext,
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
  if (ext == "shp") {
    data_sf <- read_shp_zip(namefileload)
  } else {
    data_sf <- read_geo_file_sf(namefileload)
  }

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
