#' GISCO geodata single-unit download
#'
#' @name gisco_get_unit
#' @rdname gisco_get_unit
#' @description
#' Download datasets of single spatial units from GISCO to the
#' [`cache_dir`][gisco_set_cache_dir()].
#'
#' Unlike [gisco_get_countries()], [gisco_get_nuts()] or
#' [gisco_get_urban_audit()] (which downloads a full dataset and applies
#' filters), these functions download a single file per unit, reducing the time
#' needed to download and read data into your \R session.
#'
#' @family extra
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @param unit A character vector of unit IDs to be downloaded. See **Details**.
#' @param year A character string or numeric value with the release year of the
#'   file.
#' @param spatialtype A character string with the type of geometry to return.
#'   Options available are:
#' - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#' - `"LB"`: Labels - `POINT` object.
#'
#' @inherit gisco_get_countries return
#' @inheritSection gisco_get_countries Note
#' @details
#' Check the available `unit` IDs for the required argument combination with
#' [gisco_get_metadata()].
#'
#' @source
#' <https://gisco-services.ec.europa.eu/distribution/v2/>
#'
#' All source files are `.geojson` files.
#'
#' @seealso
#' [gisco_get_metadata()], [gisco_get_countries()],
#' [gisco_get_nuts()], [gisco_get_urban_audit()].
#'
#' See [`gisco_id_api`][giscoR::gisco_id_api] to download via GISCO ID service
#' API.
#'
#' @export
#'
gisco_get_unit_country <- function(
  unit = "ES",
  year = 2024,
  epsg = c(4326, 3857, 3035),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = c(1, 3, 10, 20, 60),
  spatialtype = c("RG", "LB")
) {
  valid_years <- db_values(
    "countries",
    "year",
    formatted = FALSE,
    decreasing = TRUE
  )

  year <- match_arg_pretty(year, valid_years)
  epsg <- match_arg_pretty(epsg)
  resolution <- match_arg_pretty(resolution)

  res_txt <- format_unit_resolution(resolution)

  spatialtype <- match_arg_pretty(spatialtype)

  type <- unit_spatialtype_to_file_type(spatialtype)
  # Names have this structure:
  # RG: AD-region-01m-3035-2024.geojson
  # LB: AD-label-3035-2024.geojson

  use_code <- switch(year,
    "2001" = "iso3c",
    "2006" = "iso2c",
    "eurostat"
  )
  unit_code <- convert_country_code(unit, use_code)

  unit_names <- build_unit_filenames(unit_code, type, epsg, year, res_txt)

  get_unit_files(
    dataset = "countries",
    api_id = "countries",
    unit_names = unit_names,
    unit_labels = unit,
    year = year,
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
