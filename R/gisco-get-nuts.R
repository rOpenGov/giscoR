#' NUTS statistical units dataset
#'
#' @description
#' The GISCO statistical unit dataset represents the NUTS (nomenclature of
#' territorial units for statistics) and statistical regions by means of
#' multipart polygon, polyline and point topology. The NUTS geographical
#' information is completed by attribute tables and a set of cartographic
#' help lines to better visualize multipart polygonal regions.
#'
#' NUTS is a hierarchical system divided into three levels:
#' - NUTS 1: major socio-economic regions.
#' - NUTS 2: basic regions for the application of regional policies.
#' - NUTS 3: small regions for specific diagnoses.
#'
#' There is also a NUTS 0 level, which usually corresponds to national
#' boundaries.
#'
#' Downloads data from the aggregated GISCO NUTS file, which contains data for
#' all countries at the requested NUTS level or levels. To download single-unit
#' NUTS files, use [gisco_get_unit_nuts()].
#'
#' @family stats
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("nuts",
#'   "year",TRUE)}.
#' @param spatialtype A character string with the type of geometry to return.
#'   Options available are:
#' - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#' - `"LB"`: Labels - `POINT` object.
#' - `"BN"`: Boundaries - `LINESTRING` object.
#'
#'   Arguments `country`, `nuts_level` and `nuts_id` are only applied when
#'   `spatialtype` is `"RG"` or `"LB"`.
#' @param nuts_level A character string with the NUTS level. One of `0`,
#'   `1`, `2`, `3` or `all` for all levels.
#' @param nuts_id An optional character vector of NUTS IDs.
#' @param ext A character value with the extension of the file (default
#'   `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("nuts",
#'   "ext",TRUE)}.
#'
#' @inherit gisco_get_communes return
#' @details
#' The NUTS nomenclature is a hierarchical classification of statistical
#' regions and subdivides the EU economic territory into regions of three
#' different levels (NUTS 1, 2 and 3, moving respectively from larger to
#' smaller territorial units). NUTS 1 is the most aggregated level. Additional
#' country-level NUTS 0 data are also available for countries where the
#' statistical national level does not coincide with the administrative
#' boundaries.
#'
#' The NUTS classification has been officially established through Commission
#' Delegated Regulation 2019/1755. A non-official NUTS-like classification has
#' been defined for the EFTA countries, candidate countries and potential
#' candidates based on a bilateral agreement between Eurostat and the
#' respective statistical agencies.
#'
#' An introduction to the NUTS classification is available here:
#' <https://ec.europa.eu/eurostat/web/nuts/overview>.
#'
#' @inheritSection gisco_get_countries Note
#' @inherit gisco_get_communes source
#' @seealso
#' [gisco_nuts_2024], [eurostat::get_eurostat_geospatial()].
#'
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' See [gisco_get_unit_nuts()] to download single-unit files.
#'
#' See [gisco_id_api_nuts()] to download via GISCO ID service API.
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
#'   labs(title = "NUTS 2 levels")
#' # NUTS 3 for Germany.
#' germany_nuts3 <- gisco_get_nuts(nuts_level = 3, country = "Germany")
#'
#' ggplot(germany_nuts3) +
#'   geom_sf() +
#'   labs(
#'     title = "NUTS 3 levels",
#'     subtitle = "Germany",
#'     caption = gisco_attributions()
#'   )
#'
#' # Select specific regions
#' select_nuts <- gisco_get_nuts(nuts_id = c("ES2", "FRJ", "FRL", "ITC"))
#'
#' ggplot(select_nuts) +
#'   geom_sf(aes(fill = CNTR_CODE)) +
#'   scale_fill_viridis_d()
#' @export
#'
gisco_get_nuts <- function(
  year = 2024,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = 20,
  spatialtype = "RG",
  country = NULL,
  nuts_id = NULL,
  nuts_level = c("all", "0", "1", "2", "3"),
  ext = "gpkg"
) {
  valid_ext <- db_values("nuts", "ext", formatted = FALSE)
  ext <- match_arg_pretty(ext, valid_ext)
  nuts_level <- match_arg_pretty(nuts_level)

  resolution <- as.character(resolution)

  file <- resolve_gisco_file(
    id = "nuts",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = spatialtype,
    nuts_level = nuts_level,
    ext = ext,
    fn = "gisco_get_nuts"
  )

  data_sf <- read_packaged_gisco_dataset(
    filename = file$name,
    pattern = "NUTS_RG_20M_2024_4326.*.gpkg$",
    data = giscoR::gisco_nuts_2024,
    data_name = "gisco_nuts_2024",
    update_cache = update_cache,
    verbose = verbose,
    post_process = function(data_sf) {
      filter_country_nuts_level(data_sf, country, nuts_id, nuts_level)
    }
  )
  if (!is.null(data_sf)) {
    return(data_sf)
  }

  country_filter <- NULL
  if (!is.null(country)) {
    country_filter <- convert_country_code(country)
  }

  read_gisco_dataset(
    url = file$url,
    name = file$name,
    cache = cache,
    cache_dir = cache_dir,
    subdir = "nuts",
    update_cache = update_cache,
    verbose = verbose,
    filters = function(file_local) {
      c(
        make_sf_filter(file_local, country_filter),
        make_sf_filter(file_local, nuts_id, "NUTS_ID")
      )
    },
    post_process = function(data_sf) {
      filter_country_nuts_level(data_sf, country, nuts_id, nuts_level)
    }
  )
}

#' Filter NUTS `sf` data by country and/or NUTS ID
#'
#' @param data_sf An `sf` object.
#' @param country A character vector of country codes or names.
#' @param nuts_id A character vector of NUTS IDs.
#' @param nuts_level A character string with the NUTS level. One of `0`,
#'   `1`, `2`, `3` or `all` for all levels.
#'
#' @return An `sf` object filtered by country and/or NUTS ID.
#' @noRd
filter_country_nuts_level <- function(
  data_sf,
  country = NULL,
  nuts_id = NULL,
  nuts_level = "all"
) {
  if ("NUTS_ID" %in% names(data_sf)) {
    data_sf$geo <- data_sf$NUTS_ID
    data_sf <- sanitize_sf(data_sf)
  }

  if (nuts_level %in% c("0", "1", "2", "3")) {
    data_sf <- data_sf[data_sf$LEVL_CODE == nuts_level, ]
  }

  if (all(is.null(country), is.null(nuts_id))) {
    return(data_sf)
  }

  if (all(!is.null(country), "CNTR_CODE" %in% names(data_sf))) {
    country <- convert_country_code(country, "eurostat")
    data_sf <- filter_by_country_col(data_sf, country, "CNTR_CODE")
  }

  if (all(!is.null(nuts_id), "NUTS_ID" %in% names(data_sf))) {
    data_sf <- data_sf[data_sf$NUTS_ID %in% nuts_id, ]
  }
  data_sf
}
