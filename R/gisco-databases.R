gisco_get_latest_db <- function() {
  cached_db <- file.path(tempdir(), "gisco_cached_db.rds")

  if (file.exists(cached_db)) {
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
    req <- httr2::req_cache(req, tempdir())
    resp <- httr2::req_perform(req)
    master <- httr2::resp_body_json(resp)
    years <- gsub("[^.0-9]", "", names(master))
    iter <- seq_along(master)

    all_data <- lapply(iter, function(i) {
      req <- httr2::request(url_api)
      req <- httr2::req_url_path_append(req, entry_point)
      req <- httr2::req_url_path_append(req, master[[i]]$files)
      req <- httr2::req_cache(req, tempdir())
      resp <- httr2::req_perform(req)
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
    c("coas", "communes", "countries", "lau", "nuts", "urau"),
    get_db_data
  )

  final_db <- do.call(rbind, final_db)
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
  i <- 1
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

  # Write in temp

  saveRDS(final_db_2, cached_db)

  final_db_2
}
