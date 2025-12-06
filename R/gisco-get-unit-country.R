#' GISCO API single download
#'
#' @description
#' Download datasets of single spatial units from GISCO to the
#' [`cache_dir`][gisco_set_cache_dir()].
#'
#' Unlike [gisco_get_countries()], [gisco_get_nuts()] or
#' [gisco_get_urban_audit()] (that downloads a full dataset and applies
#' filters), these functions download a single per unit, reducing the time
#' of downloading and reading into your **R** session.
#'
#' @rdname gisco_get_unit
#' @name gisco_get_unit
#' @family extra
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @inherit gisco_get_countries return
#' @inheritSection gisco_get_countries Note
#' @export
#'
#' @seealso
#' [gisco_get_metadata()], [gisco_get_countries()],
#' [gisco_get_nuts()], [gisco_get_urban_audit()].
#'
#' See [`gisco_id_api`][giscoR::gisco_id_api] to download via GISCO ID service
#' API.
#'
#' @param unit character vector of unit ids to be downloaded. See **Details**.
#' @param year character string or number. Release year of the file.
#' @param spatialtype character string. Type of geometry to be returned.
#'   Options available are:
#'   * `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#'   * `"LB"`: Labels - `POINT` object.
#'
#' @source
#' <https://gisco-services.ec.europa.eu/distribution/v2/>
#'
#' All the source files are `.geojson` files.
#'
#' @details
#' Check the available `unit` ids with the required
#' combination of arguments with [gisco_get_metadata()].
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

  use_code <- switch(year,
    "2001" = "iso3c",
    "2006" = "iso2c",
    "eurostat"
  )
  unit_code <- convert_country_code(unit, use_code)

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
      "countries",
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
      "v2/countries/countries-",
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
      "distribution/v2/countries/distribution/"
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
      subdir = "countries/units",
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
