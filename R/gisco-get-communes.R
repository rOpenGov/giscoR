#' Communes data set
#'
#' @description
#' This data set shows pan European administrative boundaries down to commune
#' level version 2016. Communes are equivalent to Local Administrative Units,
#' see [gisco_get_lau()].
#'
#' @family admin
#' @inheritParams gisco_get_countries
#' @inherit gisco_get_countries source return note
#' @encoding UTF-8
#' @seealso
#' [gisco_get_lau()].
#' @export
#'
#' @param year character string or number. Release year of the file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("countries",
#'   "year",TRUE)}.
#' @param ext character. Extension of the file (default `"shp"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("communes",
#'   "ext",TRUE)}.
#'
#' @details
#' The Nomenclature of Territorial Units for Statistics (NUTS) and the LAU
#' nomenclature are hierarchical classifications of statistical regions that
#' together subdivide the EU economic territory into regions of five different
#' levels (NUTS 1, 2 and 3 and LAU , respectively, moving from larger to smaller
#' territorial units).
#'
#' The data set is based on EuroBoundaryMap from
#' [EuroGeographics](https://eurogeographics.org/). Geographical extent covers
#' the European Union 28, EFTA countries, and candidate countries. The scale of
#' the data set is 1:100 000.
#'
#' The LAU classification is not covered by any legislative act.
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#'
#' ire_lau <- gisco_get_communes(spatialtype = "LB", country = "Ireland")
#'
#' if (!is.null(ire_lau)) {
#'   library(ggplot2)
#'
#'   ggplot(ire_lau) +
#'     geom_sf(shape = 21, col = "#009A44", size = 0.5) +
#'     labs(
#'       title = "Communes in Ireland",
#'       subtitle = "Year 2016",
#'       caption = gisco_attributions()
#'     ) +
#'     theme_void() +
#'     theme(text = element_text(
#'       colour = "#009A44",
#'       family = "serif", face = "bold"
#'     ))
#' }
#' }
#' @export
gisco_get_communes <- function(
  year = 2016,
  epsg = 4326,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = "RG",
  country = NULL,
  ext = "shp"
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
  valid_ext <- c("geojson", "gpkg", "shp")
  ext <- match_arg_pretty(ext, valid_ext)
  url <- get_url_db(
    "communes",
    year = year,
    epsg = epsg,
    ext = ext,
    spatialtype = spatialtype,
    fn = "gisco_get_communes"
  )

  basename <- basename(url)

  file_local <- load_url(
    url,
    basename,
    cache_dir = cache_dir,
    subdir = "communes",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun

  filter_col <- find_colname(file_local)
  if (all(!is.null(country), !is.null(filter_col))) {
    make_msg("info", verbose, "Speed up using {.pkg sf} query")

    country <- get_country_code(country)

    # Get layer name
    layer <- get_sf_layer_name(file_local)

    # Construct query
    q <- paste0(
      "SELECT * from \"",
      layer,
      "\" WHERE ",
      filter_col[1],
      " IN (",
      paste0("'", country, "'", collapse = ", "),
      ")"
    )

    msg <- paste0("{.code ", q, "}")
    make_msg("info", verbose, "Using query:\n   ", msg)

    data_sf <- try(
      suppressWarnings(
        read_geo_file_sf(file_local, q)
      ),
      silent = TRUE
    )
    if (inherits(data_sf, "try-error")) {
      make_msg(
        "danger",
        TRUE,
        "Problem with the query",
        "retrying without country filters."
      )
      data_sf <- read_geo_file_sf(file_local)
    }
  } else {
    data_sf <- read_geo_file_sf(file_local)
  }

  data_sf
}
