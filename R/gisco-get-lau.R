#' Get GISCO urban areas [`sf`][sf::st_sf] polygons, points and lines
#'
#' @rdname gisco_get_lau
#' @name gisco_get_lau
#'
#' @description
#' [gisco_get_communes()] and [gisco_get_lau()] download shapes of Local
#' Urban Areas, that correspond roughly with towns and cities.
#'
#'
#' @note
#' Please check the download and usage provisions on [gisco_attributions()].
#' @family stats
#'
#' @return A [`sf`][sf::st_sf] object specified by `spatialtype`. In the case of
#'   [gisco_get_lau()], a `POLYGON` object.
#'
#' @param year Release year of the file:
#'   - For `gisco_get_communes()` one of
#'    \Sexpr[stage=render,results=rd]{giscoR:::for_docs("communes",
#'    "year",TRUE)}.
#'   - For `gisco_get_lau()` one of
#'     \Sexpr[stage=render,results=rd]{giscoR:::for_docs("lau",
#'     "year",TRUE)}.
#'
#' @param epsg projection of the map: 4-digit [EPSG code](https://epsg.io/).
#'  One of:
#'  * `"4326"`: WGS84
#'  * `"3035"`: ETRS89 / ETRS-LAEA
#'  * `"3857"`: Pseudo-Mercator
#'
#' @param cache `r lifecycle::badge('deprecated')`. These functions always
#'   caches the result due to the size. `cache_dir` can be set to
#'  [base::tempdir()], so the file would be deleted when the **R** session is
#'  closed.
#' @param gisco_id Optional. A character vector of GISCO_ID LAU values.
#'
#' @inheritParams gisco_get_countries
#'
#'
#'
#' @export
gisco_get_lau <- function(
  year = "2024",
  epsg = "4326",
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL,
  gisco_id = NULL
) {
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "giscoR::gisco_get_lau(cache)",
      details = paste0(
        "Results are always cached. To avoid persistency use ",
        "`cache_dir = tempdir()`."
      )
    )
  }
  year <- as.character(year)

  url <- get_url_db(
    "lau",
    year = year,
    epsg = epsg,
    ext = "gpkg",
    fn = "gisco_get_lau"
  )

  basename <- basename(url)

  file_local <- load_url(
    url,
    basename,
    cache_dir = cache_dir,
    subdir = "lau",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun
  filter_col_cnt <- find_colname(file_local)
  filter_col_id <- find_colname(file_local, "GISCO_ID")
  if (
    all(!is.null(country), !is.null(filter_col_cnt)) ||
      all(!is.null(gisco_id), !is.null(filter_col_id))
  ) {
    make_msg("info", verbose, "Speed up using {.pkg sf} query")
    if (!is.null(country)) {
      country <- get_country_code(country)
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

    if (all(!is.null(gisco_id), !is.null(filter_col_id))) {
      where <- c(
        where,
        paste0(
          filter_col_id,
          " IN (",
          paste0("'", gisco_id, "'", collapse = ", "),
          ")"
        )
      )
    }

    where <- paste(where, collapse = " OR ")
    q <- paste(q, where)

    msg <- paste0("{.code ", q, "}")
    make_msg("info", verbose, "Using query:\n   ", msg)
    data_sf <- read_geo_file_sf(file_local, query = q)
  } else {
    data_sf <- read_geo_file_sf(file_local)
  }

  data_sf
}
