#' Retrieve and update the GISCO database used by \CRANpkg{giscoR}
#'
#' Returns or optionally updates the cached database with endpoints from the
#' GISCO geodata distribution.
#'
#' @family database
#' @encoding UTF-8
#' @param update_cache A logical value. If `TRUE`, rebuild the cached database
#'   with the most recent information from the GISCO geodata distribution.
#'
#' @inherit gisco_get_metadata return
#'
#' @details
#' The cached database is stored in the \CRANpkg{giscoR} cache path. See
#' [gisco_set_cache_dir()] for details. The cached database is used in
#' subsequent \R sessions.
#'
#' On new GISCO data releases, you can access the updated data by refreshing
#' the cached database without waiting for a new version of
#' \CRANpkg{giscoR}.
#'
#' A static database [gisco_db] is shipped with the package. This database is
#' used if there is any problem during the update.
#'
#' @inherit gisco_get_metadata source
#' @examplesIf gisco_check_access()
#'
#' gisco_get_cached_db() |>
#'   dplyr::glimpse()
#'
#' @export
gisco_get_cached_db <- function(update_cache = FALSE) {
  cdir <- create_cache_dir()
  cached_db <- cached_db_file(cdir)

  # On CRAN, do not download.
  if (all(on_cran(), !file.exists(cached_db))) {
    db <- giscoR::gisco_db
    saveRDS(db, cached_db)

    return(db)
  }

  if (file.exists(cached_db) && isFALSE(update_cache)) {
    # Read the database without updating.
    db <- readRDS(cached_db)
    return(db)
  }

  final_db <- scrape_distribution_db()
  if (is.null(final_db)) {
    url_api <- gisco_distribution_url() # nolint

    cli::cli_alert_warning(c(
      "Could not access {.url {url_api}}. ",
      "If this looks like a bug, please open an issue at ",
      "{.url https://github.com/ropengov/giscoR/issues}."
    ))
    cli::cli_alert("Returning {.val NULL}.")
    return(NULL)
  }
  final_db_2 <- normalize_distribution_db(final_db)

  # Write to the cache.
  saveRDS(final_db_2, cached_db)

  final_db_2
}

#' Get the cached database file path
#'
#' @param cache_dir A base cache directory.
#'
#' @return A character string with the cached database file path.
#' @noRd
cached_db_file <- function(cache_dir = detect_cache_dir_muted()) {
  cdir_db <- create_cache_dir(file.path(cache_dir, "cache_db"))
  file.path(cdir_db, "gisco_cached_db.rds")
}

#' Scrape all GISCO distribution database entry points
#'
#' @param entry_points A character vector with distribution entry points.
#'
#' @return A data frame, or `NULL` when all requests fail.
#' @noRd
scrape_distribution_db <- function(
  entry_points = c(
    "coas",
    "communes",
    "countries",
    "lau",
    "nuts",
    "urau",
    "pcode"
  )
) {
  final_db <- lapply(entry_points, scrap_api_data)
  rbind_fill(final_db)
}

#' Normalize a scraped GISCO distribution database
#'
#' @param db A scraped GISCO distribution database.
#'
#' @return A tibble ready to cache.
#' @noRd
normalize_distribution_db <- function(db) {
  db <- tibble::as_tibble(db)

  db <- db[!grepl("cpg$|dbf$|shp$|prj$|svg$|svg.zip$", db$api_file), ]
  db$year <- as.numeric(db$year)
  db <- add_distribution_db_tags(db)
  db <- add_distribution_db_levels(db)
  db <- recode_distribution_db_ids(db)
  db$ext <- tools::file_ext(gsub(".zip$", "", db$api_file))

  ordernames <- c(
    "id_giscor",
    "year",
    "epsg",
    "resolution",
    "spatialtype",
    "nuts_level",
    "level",
    "ext",
    "api_file",
    "api_entry"
  )
  db <- db[, ordernames]
  db <- db[do.call(order, db), ]
  db$last_updated <- Sys.Date()
  db
}

#' Add EPSG, resolution and spatial type tags
#'
#' @param db A GISCO distribution database.
#'
#' @return The database with tag columns.
#' @noRd
add_distribution_db_tags <- function(db) {
  db$epsg <- NA
  db[grep("3857", db$api_file), ]$epsg <- 3857
  db[grep("4326", db$api_file), ]$epsg <- 4326
  db[grep("3035", db$api_file), ]$epsg <- 3035

  db$resolution <- NA
  db[grep("01M", db$api_file), ]$resolution <- 1
  db[grep("03M", db$api_file), ]$resolution <- 3
  db[grep("10M", db$api_file), ]$resolution <- 10
  db[grep("20M", db$api_file), ]$resolution <- 20
  db[grep("60M", db$api_file), ]$resolution <- 60
  db[grep("100K", db$api_file), ]$resolution <- 100

  db$spatialtype <- NA
  avspatialtype <- c("BN", "RG", "LB", "COASTL", "INLAND")
  for (i in seq_along(avspatialtype)) {
    char <- avspatialtype[i]
    rows <- grep(char, db$api_file)
    if (length(rows) > 0) {
      db[rows, ]$spatialtype <- char
    }
  }
  db
}

#' Add NUTS and Urban Audit level columns
#'
#' @param db A GISCO distribution database.
#'
#' @return The database with level columns.
#' @noRd
add_distribution_db_levels <- function(db) {
  db$nuts_level <- NA
  db$level <- NA
  clean <- db[!db$id_giscor %in% c("nuts", "urau"), ]
  nuts <- db[db$id_giscor == "nuts", ]
  urau <- db[db$id_giscor == "urau", ]

  nuts$nuts_level <- "all"
  avnutslev <- c("LEVL_0", "LEVL_1", "LEVL_2", "LEVL_3")
  for (i in seq_along(avnutslev)) {
    char <- avnutslev[i]
    rows <- grep(char, nuts$api_file)
    if (length(rows) > 0) {
      nuts[rows, ]$nuts_level <- gsub("[^.0-9]", "", char)
    }
  }

  urau$level <- "all"
  uraulev <- c("CITIES", "GREATER_CITIES", "FUA", "CITY", "KERN", "LUZ")
  for (i in seq_along(uraulev)) {
    char <- uraulev[i]
    rows <- grep(char, urau$api_file)
    if (length(rows) > 0) {
      urau[rows, ]$level <- char
    }
  }

  rbind(clean, urau, nuts)
}

#' Recode raw GISCO database identifiers
#'
#' @param db A GISCO distribution database.
#'
#' @return The database with public giscoR identifiers.
#' @noRd
recode_distribution_db_ids <- function(db) {
  id_giscor <- db$id_giscor
  id_giscor[id_giscor == "coas"] <- "coastal_lines"
  id_giscor[id_giscor == "urau"] <- "urban_audit"
  id_giscor[id_giscor == "pcode"] <- "postal_codes"
  db$id_giscor <- id_giscor
  db
}

#' Get data from a GISCO geodata distribution entry point
#'
#' @param entry_point A character value with the GISCO geodata distribution
#'   entry point.
#' @return A tibble with the data from the API.
#' @noRd
scrap_api_data <- function(entry_point) {
  url_api <- gisco_distribution_url()

  # Compose the URL.
  req <- gisco_request(url_api, retry = FALSE)
  req <- httr2::req_url_path_append(req, entry_point)
  api_entry <- httr2::req_get_url(req)
  req <- httr2::req_url_path_append(req, "datasets.json")

  resp <- gisco_perform_request(
    req,
    httr2::req_get_url(req),
    error_verbose = FALSE,
    offline_verbose = FALSE
  )
  if (is.null(resp)) {
    return(NULL)
  }

  master <- httr2::resp_body_json(resp)
  years <- gsub("[^.0-9]", "", names(master))
  iter <- seq_along(master)

  all_data <- lapply(iter, function(i) {
    req <- gisco_request(url_api, retry = FALSE)
    req <- httr2::req_url_path_append(req, entry_point)
    req <- httr2::req_url_path_append(req, master[[i]]$files)
    resp <- gisco_perform_request(
      req,
      httr2::req_get_url(req),
      error_verbose = FALSE,
      offline_verbose = FALSE,
      fake_404 = FALSE
    )
    # nocov start
    if (is.null(resp)) {
      return(NULL)
    }
    # nocov end

    child <- httr2::resp_body_json(resp)
    tibble::tibble(
      id_giscor = entry_point,
      year = years[i],
      api_file = unname(unlist(child)),
      api_entry = unname(api_entry)
    )
  })

  all_data <- rbind_fill(all_data)
  all_data
}

#' Internal function to get the GISCO database, with fallback to static
#'
#' @return A tibble with the GISCO database.
#'
#' @noRd
get_db <- function() {
  cdir <- detect_cache_dir_muted()
  cached_db <- cached_db_file(cdir)

  if (file.exists(cached_db)) {
    db <- readRDS(cached_db)
    return(db)
  }

  db <- gisco_get_cached_db()
  if (is.null(db)) {
    db <- giscoR::gisco_db

    cdir <- create_cache_dir()
    cached_db <- cached_db_file(cdir)
    saveRDS(db, cached_db)

    # Warn that the static fallback is being used.
    url_api <- gisco_distribution_url() # nolint

    cli::cli_alert_warning(c(
      "Could not retrieve the latest database from {.url {url_api}}.\n",
      "Try again later with {.fn giscoR::gisco_get_cached_db} ",
      "and {.arg update_cache} = {.val {TRUE}}."
    ))

    date <- unique(db$last_updated)

    cli::cli_alert_info(c(
      "Using cached ",
      "{.help [{.val gisco_db}](giscoR::gisco_db)} ",
      paste0("information as of {.val ", date, "}. It may be outdated.")
    ))
  }
  db
}
