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
    make_msg("info", verbose, msg)

    return(file_local)
  }

  if (fileoncache) {
    make_msg("info", verbose, "Updating cached file")
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

  # Response
  resp <- httr2::req_perform(req, path = file_local)

  # Testing
  test_offline <- getOption("giscoR_test_offline", NULL)
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
  file_local
}


load_shp <- function(
  url,
  cache_dir = NULL,
  subdir,
  verbose,
  update_cache
) {
  cache_dir <- gsc_helper_cachedir(cache_dir)
  basename <- basename(url)

  # Download file
  file_local <- api_cache(
    url,
    basename,
    cache_dir,
    subdir,
    update_cache = update_cache,
    verbose = verbose
  )
  if (is.null(file_local)) {
    return(NULL) # nocov
  }

  shp_zip <- unzip(file_local, list = TRUE)
  shp_zip <- shp_zip$Name
  shp_zip <- shp_zip[grepl("shp$", shp_zip)]
  shp_end <- shp_zip[1]

  # Read with vszip
  shp_read <- file.path("/vsizip/", file_local, shp_end)
  shp_read <- gsub("//", "/", shp_read)
  data_sf <- sf::read_sf(shp_read, quiet = !verbose)

  data_sf <- gsc_helper_utf8(data_sf)

  data_sf
}
