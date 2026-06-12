#' @rdname gisco_get_unit
#' @encoding UTF-8
#' @export
gisco_get_unit_nuts <- function(
  unit = "ES416",
  year = 2024,
  epsg = c(4326, 3857, 3035),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = c(1, 3, 10, 20, 60),
  spatialtype = c("RG", "LB")
) {
  valid_years <- db_values("nuts", "year", formatted = FALSE, decreasing = TRUE)

  year <- match_arg_pretty(year, valid_years)
  epsg <- match_arg_pretty(epsg)
  resolution <- match_arg_pretty(resolution)

  res_txt <- format_unit_resolution(resolution)
  spatialtype <- match_arg_pretty(spatialtype)
  type <- unit_spatialtype_to_file_type(spatialtype)
  # Names have this structure:
  # RG: AD-region-01m-3035-2024.geojson
  # LB: AD-label-3035-2024.geojson

  unit_code <- unique(unit)

  unit_names <- build_unit_filenames(unit_code, type, epsg, year, res_txt)
  unit_labels <- unit[seq_along(unit_names)]

  add_nuts_geo <- function(data_sf) {
    data_sf$geo <- data_sf$NUTS_ID
    data_sf
  }

  get_unit_files(
    dataset = "nuts",
    api_id = "nuts",
    unit_names = unit_names,
    unit_labels = unit_labels,
    year = year,
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose,
    post_process = add_nuts_geo
  )
}
