#' GISCO geodata single-unit download
#'
#' @description
#' Download individual files for the requested countries, NUTS regions or
#' Urban Audit areas. By default, files are saved to the
#' [cache directory][gisco_set_cache_dir()].
#'
#' Downloading individual units can be faster than downloading the
#' aggregated datasets with [gisco_get_countries()], [gisco_get_nuts()] or
#' [gisco_get_urban_audit()] and filtering the results.
#'
#' @name gisco_get_unit
#' @rdname gisco_get_unit
#' @family downloads
#' @inheritParams gisco_get_countries
#' @param unit A character vector of unit IDs to download. See **Details**.
#' @param year A character string or numeric value with the release year of the
#'   file.
#' @param spatialtype A character string giving the geometry type. Use `"RG"`
#'   for regions (polygons or multipolygons) or `"LB"` for labels (points).
#'
#' @return An [`sf`][sf::st_sf] object with the units that could be read, or
#'   `NULL` if none could be read.
#' @details
#' Check the available `unit` IDs for the required argument combination with
#' [gisco_get_metadata()].
#'
#' # Copyright
#'
#' See the GISCO copyright provisions for administrative and statistical
#' units:
#' - Administrative units:
#'   <https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.
#' - Statistical units:
#'   <https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>.
#'
#' @inheritSection gisco_get_countries Note
#' @source
#' GISCO countries distribution API:
#' <https://gisco-services.ec.europa.eu/distribution/v2/countries/>.
#'
#' GISCO NUTS distribution API:
#' <https://gisco-services.ec.europa.eu/distribution/v2/nuts/>.
#'
#' GISCO Urban Audit distribution API:
#' <https://gisco-services.ec.europa.eu/distribution/v2/urau/>.
#'
#' All source files are `.geojson` files.
#'
#' @seealso
#' [gisco_get_metadata()], [gisco_get_countries()],
#' [gisco_get_nuts()], [gisco_get_urban_audit()].
#'
#' See [gisco_id_api] to download via the GISCO ID service API.
#'
#' @encoding UTF-8
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
