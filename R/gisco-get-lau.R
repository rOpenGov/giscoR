#' Local Administrative Units (LAU) dataset
#'
#' @description
#' This dataset shows pan-European administrative boundaries down to commune
#' level. Local Administrative Units are equivalent to communes. See
#' [gisco_get_communes()].
#'
#' @family stats
#' @encoding UTF-8
#'
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("lau",
#'   "year",TRUE)}.
#' @param cache `r lifecycle::badge('deprecated')`. Always caches the result
#'   due to its size. See **Caching strategies** section in
#'   [gisco_set_cache_dir()].
#' @param gisco_id An optional character vector of `GISCO_ID` LAU values.
#' @param ext A character value with the extension of the file (default
#'   `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("lau",
#'   "ext",TRUE)}.
#'
#' @inherit gisco_get_coastal_lines return
#' @details
#' The Nomenclature of Territorial Units for Statistics (NUTS) and the LAU
#' nomenclature are hierarchical classifications of statistical regions that
#' together subdivide the EU economic territory into regions of five different
#' levels, moving from larger to smaller territorial units: NUTS 1, 2 and 3
#' and LAU.
#'
#' The LAU classification is not covered by any legislative act. Geographical
#' extent covers the European Union, EFTA countries and candidate countries.
#' The scale of the dataset is 1:100 000.
#'
#' The data contain the National Statistical Agency LAU code, which can be
#' joined to LAU lists. They also contain a `GISCO_ID` field, which is a
#' unique identifier consisting of the country code and LAU code.
#'
#' Total resident population figures (31 December) have also been added in
#' some versions based on the associated LAU lists.
#'
#' @inheritSection gisco_get_coastal_lines Note
#' @inherit gisco_get_coastal_lines source
#' @seealso
#' [gisco_get_communes()].
#'
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' See [gisco_id_api_lau()] to download via GISCO ID service API.
#'
#' @examplesIf gisco_check_access()
#' \dontrun{
#'
#' lu_lau <- gisco_get_lau(year = 2024, country = "Luxembourg")
#'
#' if (!is.null(lu_lau)) {
#'   library(ggplot2)
#'
#'   ggplot(lu_lau) +
#'     geom_sf(aes(fill = POP_DENS_2024)) +
#'     labs(
#'       title = "Population density in Luxembourg",
#'       subtitle = "Year 2024",
#'       caption = gisco_attributions()
#'     ) +
#'     scale_fill_viridis_b(
#'       option = "cividis",
#'       label = \(x) prettyNum(x, big.mark = ",")
#'     ) +
#'     theme_void() +
#'     labs(fill = "pop/km2")
#' }
#' }
#' @export
#'
gisco_get_lau <- function(
  year = 2024,
  epsg = 4326,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL,
  gisco_id = NULL,
  ext = "gpkg"
) {
  warn_deprecated_cache(cache, "giscoR::gisco_get_lau(cache)")

  valid_ext <- c("geojson", "gpkg", "shp")
  ext <- match_arg_pretty(ext, valid_ext)

  file <- resolve_gisco_file(
    "lau",
    year = year,
    epsg = epsg,
    ext = ext,
    fn = "gisco_get_lau"
  )

  country <- convert_country_code_or_null(country)

  read_gisco_dataset(
    url = file$url,
    name = file$name,
    cache = TRUE,
    cache_dir = cache_dir,
    subdir = "lau",
    update_cache = update_cache,
    verbose = verbose,
    filters = function(file_local) {
      c(
        make_sf_filter(file_local, country),
        make_sf_filter(file_local, gisco_id, "GISCO_ID")
      )
    },
    operator = "OR"
  )
}
