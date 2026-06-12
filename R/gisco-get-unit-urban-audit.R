#' @rdname gisco_get_unit
#' @encoding UTF-8
#' @examplesIf gisco_check_access()
#' # Get metadata.
#' cities <- gisco_get_metadata("urban_audit", year = 2024)
#'
#' # Valencia, Spain.
#' valencia <- cities[grep("Valencia", cities$URAU_NAME, fixed = TRUE), ]
#' valencia
#' library(dplyr)
#' # Get `sf` objects and order by `AREA_SQM`.
#' valencia_sf <- gisco_get_unit_urban_audit(
#'   unit = valencia$URAU_CODE,
#'   year = 2024
#' ) |>
#'   arrange(desc(AREA_SQM))
#' # Plot.
#' library(ggplot2)
#'
#' ggplot(valencia_sf) +
#'   geom_sf(aes(fill = URAU_CATG)) +
#'   scale_fill_viridis_d() +
#'   labs(
#'     title = "Valencia",
#'     subtitle = "Urban Audit 2020",
#'     fill = "Category"
#'   )
#' @export
#'
gisco_get_unit_urban_audit <- function(
  unit = "ES001F",
  year = 2024,
  epsg = c(4326, 3857, 3035),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = c("RG", "LB")
) {
  valid_years <- db_values(
    "urban_audit",
    "year",
    formatted = FALSE,
    decreasing = TRUE
  )

  year <- as.numeric(match_arg_pretty(year, valid_years))
  epsg <- match_arg_pretty(epsg)
  res_txt <- format_urau_unit_resolution(year)

  spatialtype <- match_arg_pretty(spatialtype)
  type <- unit_spatialtype_to_file_type(spatialtype)
  # Names have this structure:
  # RG: AD-region-01m-3035-2024.geojson
  # LB: AD-label-3035-2024.geojson

  unit_code <- unique(unit)

  unit_names <- build_unit_filenames(unit_code, type, epsg, year, res_txt)
  unit_labels <- unit[seq_along(unit_names)]

  get_unit_files(
    dataset = "urban_audit",
    api_id = "urau",
    unit_names = unit_names,
    unit_labels = unit_labels,
    year = year,
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
