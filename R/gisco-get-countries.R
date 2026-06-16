#' Countries dataset
#'
#' @description
#' This dataset contains world administrative boundaries at the country level.
#' It provides two feature classes, regions and boundaries, at five scale
#' levels: 1M, 3M, 10M, 20M and 60M.
#'
#' Downloads data from the aggregated GISCO country file. To download
#' single-unit country files, use [gisco_get_unit_country()].
#'
#' @aliases gisco_get
#' @family admin
#' @encoding UTF-8
#' @param year A character string or numeric value with the release year of the
#'   file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("countries",
#'   "year",TRUE)}.
#' @param epsg A character string or numeric value with the coordinate
#'   reference system as a 4-digit [EPSG code](https://epsg.io/). One of:
#' - `"4326"`: [WGS84](https://epsg.io/4326).
#' - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).
#' - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).
#' @param cache A logical value indicating whether to cache results. Defaults
#'   to `TRUE`. See **Caching strategies** section in [gisco_set_cache_dir()].
#' @param update_cache A logical value indicating whether to refresh the
#'   cached file. Defaults to `FALSE`. When set to `TRUE`, it forces a new
#'   download.
#' @param cache_dir A character string with a path to a cache directory. See
#'   **Caching strategies** section in [gisco_set_cache_dir()].
#' @param spatialtype A character string with the type of geometry to return.
#'   Options available are:
#' - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#' - `"LB"`: Labels - `POINT` object.
#' - `"BN"`: Boundaries - `LINESTRING` object.
#' - `"COASTL"`: Coastal lines - `LINESTRING` object.
#' - `"INLAND"`: Inland boundaries - `LINESTRING` object.
#'
#'   Arguments `country` and `region` are only applied when `spatialtype` is
#'   `"RG"` or `"LB"`.
#'
#' @param country A character vector of country codes. It can be either a
#'   vector of country names, a vector of ISO 3166-1 alpha-3 country codes or a
#'   vector of Eurostat country codes. See also [countrycode::countrycode()].
#' @param verbose A logical value. If `TRUE` displays informational messages.
#' @param resolution A character string or numeric value with the geospatial
#'   data resolution. One of:
#' - `"60"`: 1:60 million.
#' - `"20"`: 1:20 million.
#' - `"10"`: 1:10 million.
#' - `"03"`: 1:3 million.
#' - `"01"`: 1:1 million.
#' @param region An optional character vector of UN M49 region codes or
#'   European Union membership. Possible values are `"Africa"`, `"Americas"`,
#'   `"Asia"`, `"Europe"`, `"Oceania"` or `"EU"` for countries belonging to
#'   the European Union as of 2021. See **World Regions** and
#'   [gisco_countrycode].
#' @param ext A character value with the extension of the file (default
#'   `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("countries",
#'   "ext",TRUE)}.
#'
#' @return A [`sf`][sf::st_sf] object.
#'
#' @details
#'
#' # World Regions
#'
#' Regions follow the UN geographic regions
#' (see <https://unstats.un.org/unsd/methodology/m49/>).
#' Under this scheme Cyprus is assigned to Asia.
#'
#' # Note
#' Check the download and usage provisions in [gisco_attributions()].
#' @source
#' <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' Copyright:
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.
#'
#' @seealso
#' [gisco_countrycode], [gisco_countries_2024], [gisco_get_metadata()],
#' [countrycode::countrycode()].
#'
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' See [gisco_get_unit_country()] to download single-unit files.
#'
#' See [gisco_id_api_country()] to download via GISCO ID service API.
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
#' @export
#'
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
  valid_ext <- db_values("countries", "ext", formatted = FALSE)
  ext <- match_arg_pretty(ext, valid_ext)

  file <- resolve_gisco_file(
    id = "countries",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = spatialtype,
    ext = ext,
    fn = "gisco_get_countries"
  )

  data_sf <- read_packaged_gisco_dataset(
    filename = file$name,
    pattern = "CNTR_RG_20M_2024_4326.gpkg",
    data = giscoR::gisco_countries_2024,
    data_name = "gisco_countries_2024",
    update_cache = update_cache,
    verbose = verbose,
    post_process = function(data_sf) {
      filter_country_region(data_sf, country, region)
    }
  )
  if (!is.null(data_sf)) {
    return(data_sf)
  }

  cnt_region <- get_countrycodes_region(country, region)
  cnt_region <- sort(cnt_region)
  read_gisco_dataset(
    url = file$url,
    name = file$name,
    cache = cache,
    cache_dir = cache_dir,
    subdir = "countries",
    update_cache = update_cache,
    verbose = verbose,
    filters = function(file_local) {
      make_sf_filter(file_local, cnt_region)
    },
    post_process = function(data_sf) {
      filter_country_region(data_sf, country, region)
    }
  )
}

#' Filter `sf` data by country and/or region
#'
#' @param data_sf An `sf` object.
#' @param country A character vector of country codes or names.
#' @param region A character vector of region codes or names.
#'
#' @return An `sf` object filtered by country and/or region.
#'
#' @noRd
filter_country_region <- function(data_sf, country = NULL, region = NULL) {
  if (!"CNTR_ID" %in% names(data_sf)) {
    return(data_sf)
  }
  fil_codes <- get_countrycodes_region(country, region)
  if (is.null(fil_codes)) {
    return(data_sf)
  }

  data_sf <- filter_by_country_col(data_sf, fil_codes, "CNTR_ID")
  data_sf <- data_sf[order(data_sf$CNTR_ID), ]

  data_sf
}
