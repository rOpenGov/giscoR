gisco_get_latest_db <- function(update_cache = FALSE) {
  cdir <- tempdir()
  cdir_db <- gsc_helper_cachedir(file.path(cdir, "giscor", "cache_db"))

  cached_db <- file.path(cdir_db, "gisco_cached_db.rds")

  if (file.exists(cached_db) && isFALSE(update_cache)) {
    # Read the db, not update
    db <- readRDS(cached_db)
    return(db)
  }

  get_db_data <- function(entry_point) {
    url_api <- "https://gisco-services.ec.europa.eu/distribution/v2/"

    # Compose url
    req <- httr2::request(url_api)
    req <- httr2::req_url_path_append(req, entry_point)
    api_entry <- httr2::req_get_url(req)
    req <- httr2::req_url_path_append(req, "datasets.json")
    req <- httr2::req_cache(req, cdir_db)
    req <- httr2::req_error(req, is_error = function(x) {
      FALSE
    })

    test_off <- getOption("gisco_test_off", FALSE)

    if (any(!httr2::is_online(), test_off)) {
      return(NULL)
    }

    # Testing
    test_offline <- getOption("gisco_test_err", FALSE)
    if (test_offline) {
      # Modify to redirect to fake url
      req <- httr2::req_url(
        req,
        "https://gisco-services.ec.europa.eu/distribution/v2/fake"
      )
    }

    resp <- httr2::req_perform(req)

    if (httr2::resp_is_error(resp)) {
      return(NULL)
    }

    master <- httr2::resp_body_json(resp)
    years <- gsub("[^.0-9]", "", names(master))
    iter <- seq_along(master)

    all_data <- lapply(iter, function(i) {
      req <- httr2::request(url_api)
      req <- httr2::req_url_path_append(req, entry_point)
      req <- httr2::req_url_path_append(req, master[[i]]$files)
      req <- httr2::req_cache(req, cdir_db)
      req <- httr2::req_error(req, is_error = function(x) {
        FALSE
      })
      resp <- httr2::req_perform(req)
      # nocov start
      if (httr2::resp_is_error(resp)) {
        return(NULL)
      }
      # nocov end

      child <- httr2::resp_body_json(resp)
      tibble::tibble(
        id_giscor = entry_point,
        year = years[i],
        api_file = unlist(child),
        api_entry = api_entry
      )
    })

    all_data <- do.call(rbind, all_data)
  }

  final_db <- lapply(
    c("coas", "communes", "countries", "lau", "nuts", "urau", "pcode"),
    get_db_data
  )

  final_db <- do.call(rbind, final_db)
  if (is.null(final_db)) {
    url_api <- "https://gisco-services.ec.europa.eu/distribution/v2/" # nolint

    cli::cli_alert_warning(
      c(
        "Can't access {.url {url_api}}. ",
        "If you think this is a bug please consider opening an issue on ",
        "{.url https://github.com/ropengov/giscoR/issues}"
      )
    )
    cli::cli_alert("Returning {.val NULL}")
    return(NULL)
  }
  final_db <- tibble::as_tibble(final_db)

  # Remove non-useful extensions
  final_db <- final_db[
    !grepl(
      "cpg$|dbf$|shp$|prj$|svg$|svg.zip$",
      final_db$api_file
    ),
  ]

  # EPSG
  final_db$epsg <- NA
  final_db[grep("3857", final_db$api_file), ]$epsg <- "3857"
  final_db[grep("4326", final_db$api_file), ]$epsg <- "4326"
  final_db[grep("3035", final_db$api_file), ]$epsg <- "3035"

  # Resolution--
  final_db$resolution <- NA
  final_db[grep("01M", final_db$api_file), ]$resolution <- "01"
  final_db[grep("03M", final_db$api_file), ]$resolution <- "03"
  final_db[grep("10M", final_db$api_file), ]$resolution <- "10"
  final_db[grep("20M", final_db$api_file), ]$resolution <- "20"
  final_db[grep("60M", final_db$api_file), ]$resolution <- "60"
  final_db[grep("100K", final_db$api_file), ]$resolution <- "100"

  # spatialtype - Order matters
  avspatialtype <- c("BN", "RG", "LB", "COASTL", "INLAND")
  final_db$spatialtype <- NA
  for (i in seq_along(avspatialtype)) {
    char <- avspatialtype[i]
    r <- as.integer(grep(char, final_db$api_file))
    if (length(r) > 0) {
      final_db[grep(char, final_db$api_file), ]$spatialtype <- char
    }
  }

  # nuts_level: Different for NUTS and URBAN AUDIT
  final_db$nuts_level <- NA
  final_db$level <- NA
  clean <- final_db[!final_db$id_giscor %in% c("nuts", "urau"), ]
  nuts <- final_db[final_db$id_giscor == "nuts", ]
  urau <- final_db[final_db$id_giscor == "urau", ]

  # NUTS
  nuts$nuts_level <- "all"

  avnutslev <- c("LEVL_0", "LEVL_1", "LEVL_2", "LEVL_3")

  for (i in seq_along(avnutslev)) {
    char <- avnutslev[i]
    num <- gsub("[^.0-9]", "", char)
    r <- grep(char, nuts$api_file)
    if (length(r) > 0) {
      nuts[grep(char, nuts$api_file), ]$nuts_level <- num
    }
  }

  # URAU

  urau$level <- "all"
  uraulev <- c("CITIES", "GREATER_CITIES", "FUA", "CITY", "KERN", "LUZ")
  for (i in seq_along(uraulev)) {
    char <- uraulev[i]
    r <- grep(char, urau$api_file)
    if (length(r) > 0) {
      urau[grep(char, urau$api_file), ]$level <- char
    }
  }

  # Almost there: regenerate and add file extension
  final_db_2 <- rbind(clean, urau, nuts)

  # Recode
  id_giscor <- final_db_2$id_giscor
  id_giscor[id_giscor == "coas"] <- "coastal_lines"
  id_giscor[id_giscor == "urau"] <- "urban_audit"
  id_giscor[id_giscor == "pcode"] <- "postal_codes"
  final_db_2$id_giscor <- id_giscor

  # get extensions
  extension <- final_db_2$api_file
  # remove ending zip
  extension <- gsub(".zip$", "", extension)
  ext_end <- tools::file_ext(extension)
  final_db_2$ext <- ext_end

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

  final_db_2 <- final_db_2[, ordernames]

  final_db_2 <- final_db_2[do.call(order, final_db_2), ]
  final_db_2$last_updated <- Sys.Date()

  # Write in temp

  saveRDS(final_db_2, cached_db)

  final_db_2
}

# Get db
get_db <- function() {
  db <- gisco_get_latest_db()
  if (is.null(db)) {
    db <- giscoR::gisco_db

    cdir <- tempdir()
    cdir_db <- gsc_helper_cachedir(file.path(cdir, "giscor", "cache_db"))

    cached_db <- file.path(cdir_db, "gisco_cached_db.rds")
    saveRDS(db, cached_db)

    # Msg
    url_api <- "https://gisco-services.ec.europa.eu/distribution/v2/" # nolint

    cli::cli_alert_warning(
      c(
        "Can't get the latest database from {.url {url_api}}.\n",
        "Try later with {.fn giscoR::gisco_get_latest_db} option",
        "{.arg update_cache = TRUE}"
      )
    )
    cli::cli_alert_info(
      c(
        "Using cached {.help [{.value gisco_db}](giscoR::gisco_db)} ",
        "information (may be outdated)"
      )
    )
  }
  db
}
