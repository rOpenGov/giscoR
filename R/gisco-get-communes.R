#' Communes dataset
#'
#' @description
#' This dataset shows pan-European administrative boundaries down to commune
#' level. Communes are equivalent to Local Administrative Units. See
#' [gisco_get_lau()].
#'
#' @family admin
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("communes",
#'   "year",TRUE)}.
#' @param cache `r lifecycle::badge('deprecated')`. These functions always
#'   cache the result because of its size. See **Caching strategies** section
#'   in [gisco_set_cache_dir()].
#'
#' @param spatialtype A character string with the type of geometry to return.
#'   Options available are:
#' - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#' - `"LB"`: Labels - `POINT` object.
#' - `"BN"`: Boundaries - `LINESTRING` object.
#'
#'   Argument `country` is only applied when `spatialtype` is `"RG"` or
#'   `"LB"`.
#' @param ext A character value with the extension of the file (default
#'   `"shp"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("communes",
#'   "ext",TRUE)}.
#'
#' @inherit gisco_get_countries return
#' @details
#' The Nomenclature of Territorial Units for Statistics (NUTS) and the LAU
#' nomenclature are hierarchical classifications of statistical regions that
#' together subdivide the EU economic territory into regions of five different
#' levels, moving from larger to smaller territorial units: NUTS 1, 2 and 3
#' and LAU.
#'
#' The dataset is based on EuroBoundaryMap from
#' [EuroGeographics](https://eurogeographics.org/). Geographical extent covers
#' the European Union 28, EFTA countries and candidate countries. The scale of
#' the dataset is 1:100 000.
#'
#' The LAU classification is not covered by any legislative act.
#'
#' @inheritSection gisco_get_countries Note
#' @inherit gisco_get_countries source
#' @seealso
#' [gisco_get_lau()].
#'
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' @examplesIf gisco_check_access()
#' ire_comm <- gisco_get_communes(spatialtype = "LB", country = "Ireland")
#'
#' if (!is.null(ire_comm)) {
#'   library(ggplot2)
#'
#'   ggplot(ire_comm) +
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
#' @export
#'
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
  warn_deprecated_cache(cache, "giscoR::gisco_get_communes(cache)")

  valid_ext <- c("geojson", "gpkg", "shp")
  ext <- match_arg_pretty(ext, valid_ext)
  file <- resolve_gisco_file(
    "communes",
    year = year,
    epsg = epsg,
    ext = ext,
    spatialtype = spatialtype,
    fn = "gisco_get_communes"
  )

  country <- convert_country_code_or_null(country)
  read_gisco_dataset(
    url = file$url,
    name = file$name,
    cache = TRUE,
    cache_dir = cache_dir,
    subdir = "communes",
    update_cache = update_cache,
    verbose = verbose,
    filters = function(file_local) {
      make_sf_filter(file_local, country)
    }
  )
}
