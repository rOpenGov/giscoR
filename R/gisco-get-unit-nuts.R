#' @rdname gisco_get_unit
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
  valid_years <- db_values(
    "nuts",
    "year",
    formatted = FALSE,
    decreasing = TRUE
  )

  year <- match_arg_pretty(year, valid_years)
  epsg <- match_arg_pretty(epsg)
  resolution <- match_arg_pretty(resolution)

  res_txt <- sprintf("%02dm", as.numeric(resolution))
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
      "nuts",
      "units",
      single_unit
    )
    is_cached <- file.exists(guess_path)

    if (all(cache, !update_cache, is_cached)) {
      msg <- paste0("File already cached: {.file ", guess_path, "}.")
      make_msg("success", verbose, msg)
      data_sf <- read_geo_file_sf(guess_path)
      data_sf$geo <- data_sf$NUTS_ID

      return(data_sf)
    }

    # Now check online
    db_path <- paste0(
      "https://gisco-services.ec.europa.eu/distribution/",
      "v2/nuts/nuts-",
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
      "distribution/v2/nuts/distribution/"
    )
    url <- file.path(api_entry, single_unit)

    if (!cache) {
      msg <- paste0("{.url ", url, "}.")
      make_msg("info", verbose, "Reading from", msg)

      data_sf <- read_geo_file_sf(url)
      data_sf$geo <- data_sf$NUTS_ID
      return(data_sf)
    }

    file_local <- download_url(
      url,
      cache_dir = cache_dir,
      subdir = "nuts/units",
      verbose = verbose,
      update_cache = update_cache
    )
    data_sf <- read_geo_file_sf(file_local)
    data_sf$geo <- data_sf$NUTS_ID
    data_sf
  })
  alldata <- rbind_fill(alldata)
  if (is.null(alldata)) {
    return(NULL)
  }
  alldata <- sanitize_sf(alldata)
  alldata
}
