#' Census dataset
#'
#' This dataset provides 2011 census units as region or point geometries.
#'
#' @family stats
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file.
#'   Currently only `"2011"` is provided.
#' @param spatialtype The type of geometry to return:
#' - `"PT"`: Points - `POINT` object.
#' - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#'
#' @inherit gisco_get_countries return
#' @details
#' # Copyright
#'
#' See the GISCO statistical unit copyright provisions:
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>.
#'
#' @inheritSection gisco_get_countries Note
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units/census>.
#'
#' @seealso
#'
#' See [gisco_id_api_census_grid()] to download via GISCO ID service API.
#'
#' @encoding UTF-8
#' @export
#' @examplesIf gisco_check_access()
#' \donttest{
#' library(sf)
#'
#' pts <- gisco_get_census(spatialtype = "PT")
#'
#' pts
#' }
#'
gisco_get_census <- function(
  year = 2011,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  spatialtype = c("RG", "PT")
) {
  year <- match_arg_pretty(year)

  spatialtype <- match_arg_pretty(spatialtype)
  files <- c(
    "PT" = "CENSUS_UNITS_PT_2011_SH.zip",
    "RG" = "CENSUS_UNITS_2011_RG_SH.zip"
  )
  url <- eurostat_gisco_geodata_url(files[[spatialtype]])
  read_gisco_dataset(
    url,
    cache_dir = cache_dir,
    subdir = "census",
    update_cache = update_cache,
    verbose = verbose,
    post_process = transform_to_wgs84
  )
}
