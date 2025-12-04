#' Get geospatial units data from GISCO API
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function is deprecated. Use:
#'
#' - [gisco_get_metadata()] (equivalent to `mode = "df"`).
#' - [`?gisco_get_unit`][gisco_get_unit]functions (equivalent to
#'   `mode = "sf"`)
#' @family deprecated functions
#' @encoding UTF-8
#' @inheritParams gisco_get_unit
#' @inherit gisco_get_unit source
#' @inheritSection gisco_get_unit Note
#' @export
#'
#' @seealso
#' [gisco_get_metadata()], [`?gisco_get_unit`][gisco_get_unit] functions.
#'
#' @return
#' A [`sf`][sf::st_sf] object on `mode = "sf"` or a [tibble][tibble::tbl_df]
#' on `mode = "df"`.
#'
#' @param id_giscoR Select the `unit` type to be downloaded. Accepted values are
#'  `"nuts"`, `"countries"` or `"urban_audit"`.
#' @param unit Unit ID to be downloaded.
#' @param mode Controls the output of the function. Possible values are `"sf"`
#'  or `"df"`. See **Value**.
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#' # mode df
#' gisco_get_units("nuts", mode = "df", year = 2016)
#' # ->
#' gisco_get_metadata("nuts", year = 2016)
#'
#' # mode sf for NUTS
#' gisco_get_units("nuts", unit = "ES111", mode = "sf", year = 2016)
#' # ->
#' gisco_get_unit_nuts(unit = "ES111", year = 2016)
#' }
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

  if (id == "nuts") {
    lifecycle::deprecate_warn(
      "1.0.0",
      "giscoR::gisco_get_units()",
      "giscoR::gisco_get_unit_nuts()"
    )

    data_sf <- gisco_get_unit_nuts(
      unit = unit,
      year = year,
      epsg = epsg,
      cache = cache,
      update_cache = update_cache,
      verbose = verbose,
      resolution = resolution,
      spatialtype = spatialtype
    )
    return(data_sf)
  }

  if (id == "countries") {
    lifecycle::deprecate_warn(
      "1.0.0",
      "giscoR::gisco_get_units()",
      "giscoR::gisco_get_unit_country()"
    )

    data_sf <- gisco_get_unit_country(
      unit = unit,
      year = year,
      epsg = epsg,
      cache = cache,
      update_cache = update_cache,
      verbose = verbose,
      resolution = resolution,
      spatialtype = spatialtype
    )
    return(data_sf)
  }
  # Else if urban_audit
  lifecycle::deprecate_warn(
    "1.0.0",
    "giscoR::gisco_get_units()",
    "giscoR::gisco_get_unit_country()"
  )

  gisco_get_unit_urban_audit(
    unit = unit,
    year = year,
    epsg = epsg,
    cache = cache,
    update_cache = update_cache,
    verbose = verbose,
    spatialtype = spatialtype
  )
}
