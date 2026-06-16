#' Get geospatial unit data from GISCO
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' Deprecated. Use one of these replacements:
#'
#' - [gisco_get_metadata()] for `mode = "df"`.
#' - [`?gisco_get_unit`][gisco_get_unit] functions for `mode = "sf"`.
#'
#' @family deprecated functions
#' @encoding UTF-8
#' @inheritParams gisco_get_unit
#' @param id_giscoR A character string with the `unit` type to download.
#'   Accepted values are `"nuts"`, `"countries"` or `"urban_audit"`.
#' @param unit A unit ID to download.
#' @param mode A character string controlling the output of the function.
#'   Possible values are `"sf"` or `"df"`. See **Value**.
#'
#' @return
#' A [`sf`][sf::st_sf] object when `mode = "sf"` or a
#' [tibble][tibble::tbl_df] when `mode = "df"`.
#'
#' @inheritSection gisco_get_unit Note
#' @inherit gisco_get_unit source
#' @seealso
#' [gisco_get_metadata()], [`?gisco_get_unit`][gisco_get_unit] functions.
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#' # Equivalent metadata call.
#' gisco_get_units("nuts", mode = "df", year = 2016)
#' # ->
#' gisco_get_metadata("nuts", year = 2016)
#'
#' # Equivalent `sf` call for NUTS.
#' gisco_get_units("nuts", unit = "ES111", mode = "sf", year = 2016)
#' # ->
#' gisco_get_unit_nuts(unit = "ES111", year = 2016)
#' }
#' @export
#'
gisco_get_units <- function(
  id_giscoR = c("nuts", "countries", "urban_audit"),
  unit = "ES4",
  mode = c("sf", "df"),
  year = 2016,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = 20,
  spatialtype = "RG"
) {
  id <- match_arg_pretty(id_giscoR)
  mode <- match_arg_pretty(mode)
  if (mode == "df") {
    lifecycle::deprecate_warn(
      "1.0.0",
      "giscoR::gisco_get_units()",
      "giscoR::gisco_get_metadata()"
    )

    df <- gisco_get_metadata(id, year, verbose = verbose)
    return(df)
  }

  unit_args <- list(
    unit = unit,
    year = year,
    epsg = epsg,
    cache = cache,
    update_cache = update_cache,
    verbose = verbose,
    spatialtype = spatialtype
  )
  dispatch <- list(
    nuts = list(
      replacement = "giscoR::gisco_get_unit_nuts()",
      fun = gisco_get_unit_nuts,
      args = c(unit_args, resolution = resolution)
    ),
    countries = list(
      replacement = "giscoR::gisco_get_unit_country()",
      fun = gisco_get_unit_country,
      args = c(unit_args, resolution = resolution)
    ),
    urban_audit = list(
      replacement = "giscoR::gisco_get_unit_urban_audit()",
      fun = gisco_get_unit_urban_audit,
      args = unit_args
    )
  )
  selection <- dispatch[[id]]

  lifecycle::deprecate_warn(
    "1.0.0",
    "giscoR::gisco_get_units()",
    selection$replacement
  )

  do.call(selection$fun, selection$args)
}
