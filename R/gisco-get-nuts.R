#' Territorial units for statistics (NUTS) dataset
#'
#' @description
#' The GISCO statistical unit dataset represents the NUTS (nomenclature of
#' territorial units for statistics) and statistical regions by means of
#' multipart polygon, polyline and point topology. The NUTS geographical
#' information is completed by attribute tables and a set of cartographic
#' help lines to better visualise multipart polygonal regions.
#'
#' The NUTS are a hierarchical system divided into 3 levels:
#'  - NUTS 1: major socio-economic regions
#'  - NUTS 2: basic regions for the application of regional policies
#'  - NUTS 3: small regions for specific diagnoses.
#'
#' Also, there is a NUTS 0 level, which usually corresponds to the national
#' boundaries.
#'
#' @family stats
#' @inheritParams gisco_get_countries
#' @inheritSection gisco_get_countries Note
#' @inherit gisco_get_communes source return
#' @export
#'
#' @seealso
#' [gisco_nuts_2024], [eurostat::get_eurostat_geospatial()].
#'
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' See [gisco_get_unit_nuts()] to download single files.
#'
#' @param year character string or number. Release year of the file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("nuts",
#'   "year",TRUE)}.
#' @param spatialtype character string. Type of geometry to be returned. Options
#'   available are:
#'   * `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#'   * `"LB"`: Labels - `POINT` object.
#'   * `"BN"`: Boundaries - `LINESTRING` object.
#'
#'   **Note that** arguments `country`, `nuts_level` and `nuts_id` would be
#'   only applied when `spatialtype` is `"RG"` or `"LB"`.
#' @param nuts_level character string. NUTS level. One of `0`,
#'   `1`, `2`, `3` or `all` for all levels.
#' @param nuts_id Optional. A character vector of NUTS IDs.
#' @param ext character. Extension of the file (default `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("nuts",
#'   "ext",TRUE)}.
#'
#' @details
#' The NUTS nomenclature is a hierarchical classification of statistical
#' regions and subdivides the EU economic territory into regions of three
#' different levels (NUTS 1, 2 and 3, moving respectively from larger to smaller
#' territorial units). NUTS 1 is the most aggregated level. An additional
#' Country level (NUTS 0) is also available for countries where the nation at
#' statistical level does not coincide with the administrative boundaries.
#'
#' The NUTS classification has been officially established through Commission
#' Delegated Regulation 2019/1755. A non-official NUTS-like classification has
#' been defined for the EFTA countries, candidate countries and potential
#' candidates based on a bilateral agreement between Eurostat and the respective
#' statistical agencies.
#'
#' An introduction to the NUTS classification is available here:
#' <https://ec.europa.eu/eurostat/web/nuts/overview>.
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

  api_entry <- get_url_db(
    id = "nuts",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = spatialtype,
    nuts_level = nuts_level,
    ext = ext,
    fn = "gisco_get_nuts"
  )

  filename <- basename(api_entry)

  # Check if data is already available
  checkdata <- grepl("NUTS_RG_20M_2024_4326.*.gpkg$", filename)
  if (all(isFALSE(update_cache), checkdata)) {
    data_sf <- giscoR::gisco_nuts_2024

    make_msg(
      "info",
      verbose,
      "Loaded from {.help giscoR::gisco_nuts_2024} dataset.",
      "Use {.arg update_cache = TRUE} to re-load from file"
    )

    if (nuts_level %in% c("0", "1", "2", "3")) {
      data_sf <- data_sf[data_sf$LEVL_CODE == nuts_level, ]
    }

    data_sf <- filter_country_nuts(data_sf, country, nuts_id)

    return(data_sf)
  }

  # Not cached are read from url
  if (all(isFALSE(cache), ext != "shp")) {
    msg <- paste0("{.url ", api_entry, "}.")
    make_msg("info", verbose, "Reading from", msg)

    data_sf <- read_geo_file_sf(api_entry)

    if ("NUTS_ID" %in% names(data_sf)) {
      data_sf$geo <- data_sf$NUTS_ID
      data_sf <- sanitize_sf(data_sf)
    }
    data_sf <- filter_country_nuts(data_sf, country, nuts_id)

    return(data_sf)
  }

  # Cache
  file_local <- download_url(
    api_entry,
    filename,
    cache_dir,
    "nuts",
    update_cache,
    verbose
  )
  if (is.null(file_local)) {
    return(NULL)
  }

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun
  filter_col_cnt <- get_col_name(file_local)
  filter_col_id <- get_col_name(file_local, "NUTS_ID")
  if (
    all(!is.null(country), !is.null(filter_col_cnt)) ||
      all(!is.null(nuts_id), !is.null(filter_col_id))
  ) {
    make_msg("info", verbose, "Speed up using {.pkg sf} query")
    if (!is.null(country)) {
      country <- convert_country_code(country)
    }

    # Get layer name
    layer <- get_sf_layer_name(file_local)

    # Construct query
    q <- paste0("SELECT * from \"", layer, "\" WHERE")

    where <- NULL

    if (all(!is.null(country), !is.null(filter_col_cnt))) {
      where <- c(
        where,
        paste0(
          filter_col_cnt,
          " IN (",
          paste0("'", country, "'", collapse = ", "),
          ")"
        )
      )
    }

    if (all(!is.null(nuts_id), !is.null(filter_col_id))) {
      where <- c(
        where,
        paste0(
          filter_col_id,
          " IN (",
          paste0("'", nuts_id, "'", collapse = ", "),
          ")"
        )
      )
    }

    where <- paste(where, collapse = " AND ")
    q <- paste(q, where)

    msg <- paste0("{.code ", q, "}")
    make_msg("info", verbose, "Using query:\n   ", msg)
    data_sf <- read_geo_file_sf(file_local, q = q)
  } else {
    data_sf <- read_geo_file_sf(file_local)
  }
  if ("NUTS_ID" %in% names(data_sf)) {
    data_sf$geo <- data_sf$NUTS_ID
    data_sf <- sanitize_sf(data_sf)
  }

  data_sf
}

filter_country_nuts <- function(data_sf, country = NULL, nuts_id = NULL) {
  if (all(is.null(country), is.null(nuts_id))) {
    return(data_sf)
  }

  if (all(!is.null(country), "CNTR_CODE" %in% names(data_sf))) {
    country <- convert_country_code(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }

  if (all(!is.null(nuts_id), "NUTS_ID" %in% names(data_sf))) {
    data_sf <- data_sf[data_sf$NUTS_ID %in% nuts_id, ]
  }
  data_sf
}
