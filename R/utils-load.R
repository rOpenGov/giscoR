get_url_db <- function(
  id,
  year,
  epsg = 4326,
  resolution = NULL,
  spatialtype = NULL,
  nuts_level = NULL,
  level = NULL,
  ext = NULL,
  fn
) {
  if (all(!is.null(spatialtype), spatialtype == "LB")) {
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
    resolution <- sprintf("%02d", as.numeric(make_params$resolution))
    make_params$resolution <- resolution
  }

  # Fun with namespace
  fn <- paste0("giscoR::", fn)

  db <- get_db()

  # Initial filter
  db <- db[db$id_giscoR == id, ]
  years <- sort(unique(db$year)) # nolint

  # Only inform valids in year
  if (!make_params$year %in% db$year) {
    cli::cli_abort(
      paste0(
        "Years available for {.fn giscoR::",
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
        i = "Check available combinations in {.fn giscoR::gisco_get_latest_db}."
      )
    )
  }

  if (nrow(db) > 1) {
    cli::cli_alert_warning("{.fn {fn}} has {nrow(db)} results with params:")
    cli::cli_bullets(val)
    db_res <- db[1, ]
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

api_cache <- function(
  url = NULL,
  name = basename(url),
  cache_dir = NULL,
  subdir = "fixme",
  update_cache = FALSE,
  verbose = TRUE
) {
  cache_dir <- gsc_helper_cachedir(cache_dir)
  cache_dir <- gsc_helper_cachedir(file.path(cache_dir, subdir))

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
    size <- file.size(file_local)
    class(size) <- "object_size"
    sz <- format(size, units = "auto")
    make_msg("info", verbose, "File size:", sz)
    make_msg("generic", verbose, "Start reading file...")

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
  req <- httr2::req_timeout(req, 100000)
  req <- httr2::req_retry(req, max_tries = 3)
  if (verbose) {
    req <- httr2::req_progress(req)
  }

  test_off <- getOption("gisco_test_off", NULL)

  if (any(!httr2::is_online(), test_off)) {
    cli::cli_alert_danger("Offline")
    cli::cli_alert("Returning {.val NULL}")
    return(NULL)
  }

  # Response
  resp <- httr2::req_perform(req, path = file_local)

  # Testing
  test_offline <- getOption("gisco_test_err", NULL)
  if (any(httr2::resp_is_error(resp), test_offline)) {
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
  size <- file.size(file_local)
  class(size) <- "object_size"
  sz <- format(size, units = "auto")
  make_msg("info", verbose, "File size:", sz)
  make_msg("generic", verbose, "Start reading file...")

  file_local
}
