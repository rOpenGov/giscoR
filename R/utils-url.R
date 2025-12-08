#' Find URL in the local cached database
#'
#' Internal function to find the correct URL from the local cached database
#'
#' @param id character string. The `id_giscor` value to filter the database.
#' @param year character string or number. Release year.
#' @param epsg numeric. EPSG code.
#' @param resolution numeric. Resolution in meters.
#' @param spatialtype character string. Spatial type.
#' @param nuts_level character string. NUTS level.
#' @param level character string. Level for Urban Audit datasets.
#' @param ext character string. File extension.
#' @param fn character string. Function name for messages.
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

  # Clean and to char
  make_params <- make_params[lengths(make_params) != 0]
  make_params <- lapply(make_params, as.character)

  if (!is.null(make_params$resolution)) {
    resolution <- as.numeric(make_params$resolution)
    make_params$resolution <- resolution
  }

  # Fun with namespace
  fn <- paste0("giscoR::", fn)

  # Initial filter
  db <- db[db$id_giscor == id, ]
  years <- sort(unique(db$year)) # nolint

  # Only inform valids in year
  if (!make_params$year %in% db$year) {
    cli::cli_abort(
      paste0(
        "Years available for {.fn ",
        fn,
        "} are ",
        "{.str {years}}."
      )
    )
  }

  # Loop and check final results
  for (n in names(make_params)) {
    check_val <- make_params[[n]]
    vec_val <- db[[n]]
    filt_db <- vec_val == check_val
    filt_db[is.na(filt_db)] <- FALSE
    db <- db[filt_db, ]
  }

  # Prepare msg
  val <- unlist(make_params)
  val <- paste0("{.arg ", names(make_params), "} = {.val ", val, "}")
  names(val) <- rep("*", length(val))

  if (nrow(db) == 0) {
    cli::cli_abort(
      c(
        "No results for {.fn {fn}} with params:",
        val,
        i = "Check available combinations in {.fn giscoR::gisco_get_cached_db}."
      )
    )
  }

  if (nrow(db) > 1) {
    cli::cli_alert_warning("{.fn {fn}} has {nrow(db)} results with params:")
    cli::cli_bullets(val)
    db_res <- db[1, setdiff(names(db), "last_updated")]
    val2 <- unlist(db_res)
    val2 <- paste0("{.arg ", names(db_res), "} = {.val ", val2, "}")
    names(val2) <- rep("*", length(val2))
    cli::cli_alert("Returning first value:")
    cli::cli_bullets(val2)
  }
  db <- db[1, ]
  url <- paste0(db$api_entry, "/", db$api_file)

  url
}


#' Internal function to download and cache a file from a URL
#'
#' @param url character string. The URL to download.
#' @param name character string. The name of the file to save.
#' @param cache_dir character string. The base cache directory.
#' @param subdir character string. The subdirectory inside the cache directory.
#' @param update_cache logical. Whether to update the cached file.
#' @param verbose logical. Whether to print messages.
#'
#' @return The local file path of the downloaded file.
#'
#' @noRd
download_url <- function(
  url = NULL,
  name = basename(url),
  cache_dir = NULL,
  subdir = "fixme",
  update_cache = FALSE,
  verbose = TRUE
) {
  cache_dir <- create_cache_dir(cache_dir)
  cache_dir <- create_cache_dir(file.path(cache_dir, subdir))

  # Create destfile and clean
  file_local <- file.path(cache_dir, name)
  file_local <- gsub("//", "/", file_local)

  msg <- paste0("Cache dir is {.path ", cache_dir, "}.")
  make_msg("info", verbose, msg)

  # Check if file already exists
  fileoncache <- file.exists(file_local)

  # If already cached return
  if (isFALSE(update_cache) && fileoncache) {
    msg <- paste0("File already cached: {.file ", file_local, "}.")
    make_msg("success", verbose, msg)

    return(file_local)
  }

  if (fileoncache) {
    make_msg("warning", verbose, "Updating cached file")
  }

  msg <- paste0("Downloading {.url ", url, "}.")
  make_msg("info", verbose, msg)

  req <- httr2::request(url)
  req <- httr2::req_error(req, is_error = function(x) {
    FALSE
  })

  # Create a folder for caching httr2 requests
  cache_httr2 <- file.path(tempdir(), "giscoR", "cache_request")
  cache_httr2 <- create_cache_dir(cache_httr2)

  req <- httr2::req_cache(
    req,
    cache_httr2,
    max_size = 1024^3 / 2,
    max_age = 3600
  )

  req <- httr2::req_timeout(req, 300)
  req <- httr2::req_retry(req, max_tries = 3)
  if (verbose) {
    req <- httr2::req_progress(req)
  }

  test_off <- getOption("gisco_test_offline", FALSE)

  if (any(!httr2::is_online(), test_off)) {
    cli::cli_alert_danger("Offline")
    cli::cli_alert("Returning {.val NULL}")
    return(NULL)
  }

  # Response

  # Check before the size to see if we need to inform with HEAD
  get_header <- httr2::req_method(req, "HEAD")
  getsize <- httr2::req_perform(get_header)

  size_dwn <- as.numeric(httr2::resp_header(getsize, "content-length", 0))
  class(size_dwn) <- class(object.size("a"))
  thr <- 50 * (1024^2)
  if (size_dwn > thr) {
    sz_dwn <- paste0(format(size_dwn, units = "auto"), ".")
    make_msg("warning", TRUE, "The file to be downloaded has size", sz_dwn)
    req <- httr2::req_progress(req)
  }

  # Testing
  test_offline <- getOption("gisco_test_404", FALSE)
  if (test_offline) {
    # Modify to redirect to fake url
    req <- httr2::req_url(
      req,
      "https://gisco-services.ec.europa.eu/distribution/v2/fake"
    )
    file_local <- tempfile(fileext = ".txt")
  }

  resp <- httr2::req_perform(req, path = file_local)

  if (httr2::resp_is_error(resp)) {
    unlink(file_local, force = TRUE)
    get_status_code <- httr2::resp_status(resp) # nolint
    get_status_desc <- httr2::resp_status_desc(resp) # nolint

    cli::cli_alert_danger(
      c(
        "{.strong Error {.num {get_status_code}}} ({get_status_desc}):",
        " {.url {url}}."
      )
    )
    cli::cli_alert_warning(
      c(
        "If you think this is a bug please consider opening an issue on ",
        "{.url https://github.com/ropengov/giscoR/issues}"
      )
    )
    cli::cli_alert("Returning {.val NULL}")
    return(NULL)
  }
  msg <- paste0("Download succesful on {.file ", file_local, "}.")
  make_msg("success", verbose, msg)

  file_local
}


#' Internal function to get the response body from a URL
#'
#' @param url character string. The URL to download.
#' @param verbose logical. Whether to print messages.
#'
#' @return The response object from httr2.
#'
#' @noRd
get_request_body <- function(url, verbose = TRUE) {
  msg <- paste0("GET {.url ", url, "}.")
  make_msg("info", verbose, msg)

  req <- httr2::request(url)
  req <- httr2::req_error(req, is_error = function(x) {
    FALSE
  })

  # Create a folder for caching httr2 requests
  cache_httr2 <- file.path(tempdir(), "giscoR", "cache_request")
  cache_httr2 <- create_cache_dir(cache_httr2)

  req <- httr2::req_cache(
    req,
    cache_httr2,
    max_size = 1024^3 / 2,
    max_age = 3600
  )

  req <- httr2::req_timeout(req, 300)
  req <- httr2::req_retry(req, max_tries = 3)
  if (verbose) {
    req <- httr2::req_progress(req)
  }

  test_off <- getOption("gisco_test_offline", FALSE)

  if (any(!httr2::is_online(), test_off)) {
    cli::cli_alert_danger("Offline")
    cli::cli_alert("Returning {.val NULL}")
    return(NULL)
  }

  # Testing
  test_offline <- getOption("gisco_test_404", FALSE)
  if (test_offline) {
    # Modify to redirect to fake url
    req <- httr2::req_url(
      req,
      "https://gisco-services.ec.europa.eu/distribution/v2/fake"
    )
  }

  resp <- httr2::req_perform(req)

  if (httr2::resp_is_error(resp)) {
    get_status_code <- httr2::resp_status(resp) # nolint
    get_status_desc <- httr2::resp_status_desc(resp) # nolint

    cli::cli_alert_danger(
      c(
        "{.strong Error {.num {get_status_code}}} ({get_status_desc}):",
        " {.url {url}}."
      )
    )
    cli::cli_alert_warning(
      c(
        "If you think this is a bug please consider opening an issue on ",
        "{.url https://github.com/ropengov/giscoR/issues}"
      )
    )
    cli::cli_alert("Returning {.val NULL}")
    return(NULL)
  }

  make_msg("success", verbose, "Success")
  resp
}

#' Allows to use jsonlite in Imports
#'
#' The only purpose of this function is to use \CRANpkg{jsonlite} in the
#' source package code, so it should be included in the Imports file. Otherwise
#' CRAN would complain as it is not directly used.
#'
#' We need to import \CRANpkg{jsonlite} because the package makes heavy use of
#' it under the hood with [httr2::resp_body_json()], but \CRANpkg{httr2} lists
#' it on Suggests. So we need to avoid this with this simple trick.
#'
#' This function is never used on the package.
#'
#' @noRd
for_import_jsonlite <- function() {
  # To json on our website
  url <- "https://ropengov.github.io/giscoR/search.json"
  resp <- get_request_body(url, verbose = FALSE)
  txt <- httr2::resp_body_string(resp)
  local <- jsonlite::parse_json(txt)
  local <- NULL
  invisible(local)
}
