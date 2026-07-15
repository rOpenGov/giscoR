#' Build a GISCO single-unit file name
#'
#' @param unit_code Unit codes used by GISCO.
#' @param type GISCO geometry type, either `"region"` or `"label"`.
#' @param epsg A numeric EPSG code.
#' @param year A character string or numeric value with the release year.
#' @param res_txt Resolution text used by region files.
#'
#' @return A character vector with GISCO unit file names.
#' @noRd
build_unit_filenames <- function(unit_code, type, epsg, year, res_txt = NULL) {
  unit_names <- paste0(unit_code, "-", type)
  if (type == "region") {
    unit_names <- paste0(unit_names, "-", res_txt)
  }
  unit_names <- paste0(unit_names, "-", epsg)
  unit_names <- paste0(unit_names, "-", year)
  paste0(unit_names, ".geojson")
}

#' Convert spatialtype to GISCO unit file type
#'
#' @param spatialtype A character string with the type of geometry to return.
#'
#' @return A character string with GISCO's single-unit file type.
#' @noRd
unit_spatialtype_to_file_type <- function(spatialtype) {
  switch(spatialtype, "RG" = "region", "LB" = "label")
}

#' Read one GISCO single-unit file
#'
#' @param file Local file path or URL to the geospatial file.
#' @param post_process Optional function applied after reading the file.
#'
#' @return An `sf` object, or `NULL` when `file` is `NULL`.
#' @noRd
read_unit_file_sf <- function(file, post_process = NULL) {
  if (is.null(file)) {
    return(NULL)
  }

  data_sf <- read_geo_file_sf(file)
  if (!is.null(post_process)) {
    data_sf <- post_process(data_sf)
  }
  data_sf
}

#' Download or read GISCO single-unit files
#'
#' @inheritParams download_url
#' @param dataset A character string with the local dataset name.
#' @param api_id A character string with the GISCO geodata distribution path
#'   identifier.
#' @param unit_names A character vector with GISCO unit file names.
#' @param unit_labels A character vector with user-facing unit labels.
#' @param year A character string or numeric value with the release year.
#' @param post_process Optional function applied after reading each file.
#'
#' @return A sanitized `sf` object, or `NULL` when no unit can be read.
#' @noRd
get_unit_files <- function(
  dataset,
  api_id,
  unit_names,
  unit_labels,
  year,
  cache,
  update_cache,
  cache_dir,
  verbose,
  post_process = NULL
) {
  db_path <- paste0(
    gisco_distribution_url(),
    api_id,
    "/",
    api_id,
    "-",
    year,
    "-units.json"
  )
  api_entry <- paste0(gisco_distribution_url(), api_id, "/distribution/")
  cache_subdir <- file.path(dataset, "units")
  base_cache_dir <- create_cache_dir(cache_dir)
  units_db_cache <- new.env(parent = emptyenv())

  get_units_db <- function() {
    if (exists("value", envir = units_db_cache, inherits = FALSE)) {
      return(get("value", envir = units_db_cache, inherits = FALSE))
    }
    resp <- get_request_body(db_path, FALSE)
    if (is.null(resp)) {
      return(NULL)
    }
    value <- unname(unlist(httr2::resp_body_json(resp)))
    assign("value", value, envir = units_db_cache)
    value
  }

  alldata <- lapply(seq_along(unit_names), function(i) {
    single_unit <- unit_names[i]
    unit_txt <- unit_labels[i] # nolint
    make_msg(
      "info",
      verbose,
      paste0("Requested file {.file ", single_unit, "}.")
    )

    guess_path <- file.path(base_cache_dir, cache_subdir, single_unit)
    is_cached <- file.exists(guess_path)

    if (all(cache, !update_cache, is_cached)) {
      msg <- paste0("File already cached: {.file ", guess_path, "}.")
      make_msg("success", verbose, msg)
      return(read_unit_file_sf(guess_path, post_process))
    }

    units_db <- get_units_db()
    if (is.null(units_db)) {
      return(NULL)
    }

    if (!single_unit %in% units_db) {
      cli::cli_alert_warning(
        "Skipping {.arg unit} = {.str {unit_txt}} (not found online)."
      )
      return(NULL)
    }

    url <- file.path(api_entry, single_unit)

    if (!cache) {
      msg <- paste0("{.url ", url, "}.")
      make_msg("info", verbose, "Reading from", msg)
      return(read_unit_file_sf(url, post_process))
    }

    file_local <- download_url(
      url,
      cache_dir = cache_dir,
      subdir = cache_subdir,
      verbose = verbose,
      update_cache = update_cache
    )
    read_unit_file_sf(file_local, post_process)
  })

  alldata <- rbind_fill(alldata)
  if (is.null(alldata)) {
    return(NULL)
  }
  sanitize_sf(alldata)
}
