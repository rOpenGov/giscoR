#' @rdname gisco_get_unit
#' @export
#'
#' @examplesIf gisco_check_access()
#' # Get metadata
#' cities <- gisco_get_metadata("urban_audit", year = 2024)
#'
#'
#' # Valencia, Spain
#' valencia <- cities[grep("Valencia", cities$URAU_NAME), ]
#' valencia
#' library(dplyr)
#' # Now get the sf objects and order by AREA_SQM
#' valencia_sf <- gisco_get_unit_urban_audit(
#'   unit = valencia$URAU_CODE,
#'   year = 2024,
#' ) |>
#'   arrange(desc(AREA_SQM))
#' # Plot
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
  if (year < 2014) {
    res_txt <- "03M"
  } else if (year == 2014) {
    res_txt <- "100K"
  } else {
    res_txt <- "100k"
  }

  spatialtype <- match_arg_pretty(spatialtype)
  # Prepare inputs
  type <- switch(spatialtype,
    "RG" = "region",
    "LB" = "label"
  )
  # Names has the structure:
  # RG: AD-region-01m-3035-2024.geojson
  # LB: AD-label-3035-2024.geojson

  unit_code <- unique(unit)

  unit_names <- paste0(unit_code, "-", type)
  if (type == "region") {
    unit_names <- paste0(unit_names, "-", res_txt)
  }
  unit_names <- paste0(unit_names, "-", epsg)
  unit_names <- paste0(unit_names, "-", year)
  unit_names <- paste0(unit_names, ".geojson")

  iter <- seq_along(unit_names)

  alldata <- lapply(iter, function(i) {
    single_unit <- unit_names[i]
    unit_txt <- unit[i] # nolint
    make_msg(
      "info",
      verbose,
      paste0("File {.str ", single_unit, "} requested.")
    )

    # First look in cache
    guess_path <- file.path(
      create_cache_dir(cache_dir),
      "urban_audit",
      "units",
      single_unit
    )
    is_cached <- file.exists(guess_path)

    if (all(cache, !update_cache, is_cached)) {
      msg <- paste0("File already cached: {.file ", guess_path, "}.")
      make_msg("success", verbose, msg)
      data_sf <- read_geo_file_sf(guess_path)
      return(data_sf)
    }

    # Now check online
    db_path <- paste0(
      "https://gisco-services.ec.europa.eu/distribution/",
      "v2/urau/urau-",
      year,
      "-units.json"
    )

    resp <- get_request_body(db_path, FALSE)
    if (is.null(resp)) {
      return(NULL)
    }
    resp_json <- httr2::resp_body_json(resp)
    db <- unname(unlist(resp_json))

    if (!single_unit %in% db) {
      cli::cli_alert_warning(c(
        "Skipping {.arg unit = {.str {unit_txt}}} (not found online)"
      ))
      return(NULL)
    }

    # Now create urls and queries

    api_entry <- paste0(
      "https://gisco-services.ec.europa.eu/",
      "distribution/v2/urau/distribution/"
    )
    url <- file.path(api_entry, single_unit)

    if (!cache) {
      msg <- paste0("{.url ", url, "}.")
      make_msg("info", verbose, "Reading from", msg)

      data_sf <- read_geo_file_sf(url)
      return(data_sf)
    }

    file_local <- download_url(
      url,
      cache_dir = cache_dir,
      subdir = "urban_audit/units",
      verbose = verbose,
      update_cache = update_cache
    )
    read_geo_file_sf(file_local)
  })
  alldata <- rbind_fill(alldata)
  if (is.null(alldata)) {
    return(NULL)
  }
  alldata <- sanitize_sf(alldata)
  alldata
}
