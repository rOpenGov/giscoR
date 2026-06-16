#' Find URL in the local cached database
#'
#' Internal function to find the correct URL from the local cached database.
#'
#' @param id A character string with the `id_giscor` value to filter the
#'   database.
#' @param year A character string or numeric value with the release year.
#' @param epsg A numeric EPSG code.
#' @param resolution A numeric value with the resolution in meters.
#' @param spatialtype A character string with the spatial type.
#' @param nuts_level A character string with the NUTS level.
#' @param level A character string with the level for Urban Audit datasets.
#' @param ext A character string with the file extension.
#' @param fn A character string with the function name for messages.
#'
#' @return A character string with the URL.
#' @noRd
get_url_db <- function(
  id,
  year,
  epsg = 4326,
  resolution = NULL,
  spatialtype = NULL,
  nuts_level = NULL,
  level = NULL,
  ext = NULL,
  fn,
  db = get_db()
) {
  if (all(!is.null(spatialtype), spatialtype %in% c("LB", "PT"))) {
    resolution <- NULL
  }

  make_params <- list(
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = spatialtype,
    nuts_level = nuts_level,
    level = level,
    ext = ext
  )

  # Clean and convert to character.
  make_params <- make_params[lengths(make_params) != 0]
  make_params <- lapply(make_params, as.character)

  if (!is.null(make_params$resolution)) {
    resolution <- as.numeric(make_params$resolution)
    make_params$resolution <- resolution
  }

  # Prefix with the package namespace.
  fn <- paste0("giscoR::", fn)

  # Apply the initial filter.
  db <- db[db$id_giscor == id, ]
  years <- sort(unique(db$year)) # nolint

  # Only report valid years.
  if (!make_params$year %in% db$year) {
    cli::cli_abort(
      paste0("Years available for {.fn ", fn, "} are ", "{.val {years}}."),
      call = NULL
    )
  }

  # Filter each parameter and check the final results.
  for (n in names(make_params)) {
    check_val <- make_params[[n]]
    vec_val <- db[[n]]
    filt_db <- vec_val == check_val
    filt_db[is.na(filt_db)] <- FALSE
    db <- db[filt_db, ]
  }

  # Prepare message.
  val <- unlist(make_params)
  val <- paste0("{.arg ", names(make_params), "} = {.val ", val, "}")
  names(val) <- rep("*", length(val))

  if (nrow(db) == 0) {
    cli::cli_abort(
      c(
        "No results for {.fn {fn}} with these parameters:",
        val,
        i = "Check available combinations in {.fn giscoR::gisco_get_cached_db}."
      ),
      call = NULL
    )
  }

  if (nrow(db) > 1) {
    cli::cli_alert_warning(
      "{.fn {fn}} returned {nrow(db)} results with these parameters:"
    )
    cli::cli_bullets(val)
    db_res <- db[1, setdiff(names(db), "last_updated")]
    val2 <- unlist(db_res)
    val2 <- paste0("{.arg ", names(db_res), "} = {.val ", val2, "}")
    names(val2) <- rep("*", length(val2))
    cli::cli_alert("Returning the first result.")
    cli::cli_bullets(val2)
  }
  db <- db[1, ]
  url <- paste0(db$api_entry, "/", db$api_file)

  url
}

#' Resolve a GISCO database URL and local file name
#'
#' @inheritParams get_url_db
#'
#' @return A list with `url` and `name`.
#' @noRd
resolve_gisco_file <- function(...) {
  url <- get_url_db(...)
  list(url = url, name = basename(url))
}

#' GISCO services base URL
#'
#' @return A character string with the GISCO services base URL.
#' @noRd
gisco_services_url <- function() {
  "https://gisco-services.ec.europa.eu"
}

#' GISCO distribution API base URL
#'
#' @return A character string with the GISCO distribution API base URL.
#' @noRd
gisco_distribution_url <- function() {
  paste0(gisco_services_url(), "/distribution/v2/")
}

#' GISCO ID service API base URL
#'
#' @return A character string with the GISCO ID service API base URL.
#' @noRd
gisco_id_url <- function() {
  paste0(gisco_services_url(), "/id/")
}

#' GISCO address API base URL
#'
#' @return A character string with the GISCO address API base URL.
#' @noRd
gisco_address_url <- function() {
  paste0(gisco_services_url(), "/addressapi/")
}

#' GISCO public database URL
#'
#' @return A character string with the GISCO public database URL.
#' @noRd
gisco_pub_url <- function() {
  paste0(gisco_services_url(), "/pub/")
}

#' Eurostat GISCO geodata files base URL
#'
#' @param filename A character string with the file name.
#'
#' @return A character string with the full geodata file URL.
#' @noRd
eurostat_gisco_geodata_url <- function(filename) {
  paste0(
    "https://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/",
    filename
  )
}

#' Internal function to download and cache a file from a URL
#'
#' @param url A character string with the URL to download.
#' @param name A character string with the name of the file to save.
#' @param cache_dir A character string with the base cache directory.
#' @param subdir A character string with the subdirectory inside the cache
#'   directory.
#' @param update_cache A logical value indicating whether to update the cached
#'   file.
#' @param verbose A logical value indicating whether to print messages.
#'
#' @return The local file path of the downloaded file.
#'
#' @noRd
download_url <- function(
  url = NULL,
  name = basename(url),
  cache_dir = NULL,
  subdir = "downloads",
  update_cache = FALSE,
  verbose = TRUE
) {
  cache_dir <- create_cache_dir(cache_dir)
  cache_dir <- create_cache_dir(file.path(cache_dir, subdir))

  # Create destination file and clean path.
  file_local <- file.path(cache_dir, name)
  file_local <- gsub("//", "/", file_local, fixed = TRUE)

  msg <- paste0("Cache directory is {.path ", cache_dir, "}.")
  make_msg("info", verbose, msg)

  # Check if the file already exists.
  fileoncache <- file.exists(file_local)

  # Return if the file is already cached.
  if (isFALSE(update_cache) && fileoncache) {
    msg <- paste0("File already cached: {.file ", file_local, "}.")
    make_msg("success", verbose, msg)

    return(file_local)
  }

  if (fileoncache) {
    make_msg("warning", verbose, "Updating cached file.")
  }

  msg <- paste0("Downloading {.url ", url, "}.")
  make_msg("info", verbose, msg)

  req <- gisco_request(url, verbose = verbose)

  if (!is_online_fun()) {
    cli::cli_alert_danger("No internet connection available.")
    cli::cli_alert("Returning {.val NULL}.")
    return(NULL)
  }

  # Check the size first to see if HEAD should report it.
  get_header <- httr2::req_method(req, "HEAD")
  getsize <- httr2::req_perform(get_header)

  size_dwn <- as.numeric(httr2::resp_header(getsize, "content-length", 0))
  class(size_dwn) <- class(object.size("a"))
  thr <- 50 * (1024^2)
  if (size_dwn > thr) {
    sz_dwn <- paste0("{.val ", format(size_dwn, units = "auto"), "}.")
    make_msg("warning", TRUE, "The file to download is", sz_dwn)
    req <- httr2::req_progress(req)
  }

  # Redirect to a fake URL during tests.
  if (is_404()) {
    req <- gisco_request_fake_404(req)
    file_local <- tempfile(fileext = ".txt")
  }

  resp <- gisco_perform_request(
    req,
    url,
    path = file_local,
    check_online = FALSE,
    fake_404 = FALSE
  )
  if (is.null(resp)) {
    return(NULL)
  }
  msg <- paste0("Download completed: {.file ", file_local, "}.")
  make_msg("success", verbose, msg)

  file_local
}

#' Internal function to get the response body from a URL
#'
#' @param url A character string with the URL to download.
#' @param verbose A logical value indicating whether to print messages.
#'
#' @return The response object from httr2.
#'
#' @noRd
get_request_body <- function(url, verbose = TRUE) {
  msg <- paste0("GET {.url ", url, "}.")
  make_msg("info", verbose, msg)

  req <- gisco_request(url, verbose = verbose)

  resp <- gisco_perform_request(req, url)
  if (is.null(resp)) {
    return(NULL)
  }

  make_msg("success", verbose, "Success.")
  resp
}

#' Allow jsonlite to be listed in Imports
#'
#' The only purpose of this function is to use \CRANpkg{jsonlite} in the
#' source package code, so it is included in Imports. Otherwise, CRAN complains
#' because it is not used directly.
#'
#' We need to import \CRANpkg{jsonlite} because the package makes heavy use of
#' it under the hood with [httr2::resp_body_json()], but \CRANpkg{httr2} lists
#' it in Suggests. This helper avoids that issue.
#'
#' Never used by the package.
#'
#' @noRd
for_import_jsonlite <- function() {
  # Request JSON from the package website.
  url <- "https://ropengov.github.io/giscoR/search.json"
  resp <- get_request_body(url, verbose = FALSE)
  if (is.null(resp)) {
    return(invisible(NULL))
  }
  txt <- httr2::resp_body_string(resp)
  local <- jsonlite::parse_json(txt)
  local <- NULL
  invisible(local)
}

#' Wrapper for `is_online()` in tests
#' @noRd
is_online_fun <- function(...) {
  httr2::is_online()
}

#' Wrapper for `is_404()` in tests
#' @noRd
is_404 <- function(...) {
  FALSE
}
