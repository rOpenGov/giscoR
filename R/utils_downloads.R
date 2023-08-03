#' Extract downloading path
#' @noRd
gsc_api_url <- function(id_giscoR = "nuts",
                        year = "2016",
                        epsg = "4326",
                        resolution = "60",
                        spatialtype = "BN",
                        ext = "geojson",
                        nuts_level = "all",
                        level = NULL,
                        verbose = TRUE) {
  year <- as.character(year)
  epsg <- as.character(epsg)
  resolution <- as.character(resolution)
  if (nchar(resolution) == 1) {
    resolution <- paste0("0", resolution)
  }
  db <- giscoR::gisco_db
  db <- db[db$id_giscoR == id_giscoR, ]

  # Available years
  av_years <- paste(db$year, collapse = ",")
  av_years <- sort(unique(unlist(strsplit(av_years, ","))))

  if (!(year %in% av_years)) {
    stop(
      "Year ",
      year,
      " not available. Try ",
      paste0("'", av_years, "'", collapse = ",")
    )
  }

  db <- db[grep(year, db$year), ]


  rm(av_years)

  # Available epsg
  av_epsg <- paste(db$epsg, collapse = ",")
  av_epsg <- sort(unique(unlist(strsplit(av_epsg, ","))))


  if (!(epsg %in% av_epsg)) {
    stop(
      "EPSG ",
      epsg,
      " not available. Try ",
      paste0("'", av_epsg, "'", collapse = ",")
    )
  }


  db <- db[grep(epsg, db$epsg), ]
  rm(av_epsg)

  # Available ext

  av_ext <- paste(db$ext, collapse = ",")
  av_ext <- sort(unique(unlist(strsplit(av_ext, ","))))



  if (!(ext %in% av_ext)) {
    stop(
      "\n",
      ext,
      " format not available. Try one of ",
      paste0("'", av_ext, "'", collapse = ",")
    )
  }

  db <- db[grep(ext, db$ext), ]
  rm(av_ext)


  # Available spatialtype
  av_sptype <- paste(db$spatialtype, collapse = ",")
  av_sptype <- sort(unique(unlist(strsplit(av_sptype, ","))))

  if (length(av_sptype) == 1) {
    gsc_message(
      verbose, "[Auto] Selecting spatialtype = '",
      av_sptype, "'\n"
    )


    spatialtype <- av_sptype
  } else {
    if (!(spatialtype %in% av_sptype)) {
      stop(
        "spatialtype '",
        spatialtype,
        "' not available. Try ",
        paste0("'", av_sptype, "'", collapse = ","),
        "\n"
      )
    }
    db <- db[grep(spatialtype, db$spatialtype), ]
  }

  rm(av_sptype)

  # Available resolution
  av_res <- paste(db$resolution, collapse = ",")
  av_res <- sort(unique(unlist(strsplit(av_res, ","))))

  if (length(av_res) == 1) {
    gsc_message(
      verbose,
      "[Auto] Selecting resolution = '", av_res, "'\n"
    )

    resolution <- av_res
  } else {
    if (!(resolution %in% av_res)) {
      stop(
        "resolution '",
        resolution,
        "' not available for year ",
        year,
        ". Try ",
        paste0("'", av_res, "'", collapse = ","),
        "\n"
      )
    }
    db <- db[grep(resolution, db$resolution), ]
  }
  rm(av_res)

  # NUTS LEVEL
  if (id_giscoR == "nuts") {
    av_nuts <- paste(db$nuts_level, collapse = ",")
    av_nuts <- sort(unique(unlist(strsplit(av_nuts, ","))))

    if (is.null((nuts_level))) {
      nuts_level <- "error"
    }


    if (!(nuts_level %in% av_nuts)) {
      stop(
        "Select one nuts level of ",
        paste0("'", av_nuts, "'", collapse = ",")
      )
    }
    db <- db[grep(nuts_level, db$nuts_level), ]
  }

  # Urban Audit Level
  if (id_giscoR == "urban_audit") {
    av_ualevel <- paste(db$level, collapse = ",")
    av_ualevel <- sort(unique(unlist(strsplit(av_ualevel, ","))))

    if (is.null((level))) {
      level <- "all"
    }


    if (!(level %in% av_ualevel)) {
      stop(
        "Select one level of ",
        paste0("'", av_ualevel, "'", collapse = ",")
      )
    }
    if (level == "CITIES") {
      db <- db[db$level == "CITIES", ]
    } else {
      db <- db[grep(level, db$level), ]
    }
  }

  # Sanity check
  # nocov start
  if (nrow(db) > 1) {
    gsc_message(
      TRUE,
      "Several options selected. ",
      "On gisco_db, rows: ",
      paste0(rownames(db), collapse = ","),
      " matches your selection. ",
      "Selecting row ",
      rownames(db[1, ]),
      "\n Consider opening an issue."
    )
    db <- db[1, ]
  }
  # nocov end


  gisco_path <- db$api_file
  # Create api call
  params <-
    c(
      "year",
      "epsg",
      "resolution",
      "spatialtype",
      "nuts_level",
      "level",
      "ext"
    )


  for (i in seq_len(length(params))) {
    patt <- paste0("\\{", params[i], "\\}")
    repl <- eval(parse(text = params[i]))
    if (is.null(repl)) {
      repl <- "ERR"
    }
    gisco_path <- gsub(patt, repl, x = gisco_path)
  }

  # TopoJson has .json extension
  if (ext == "topojson") {
    gisco_path <-
      gsub(paste0(".", ext), ".json", gisco_path, fixed = TRUE)
  }

  # Shp are zips
  if (ext %in% c("shp", "svg")) {
    gisco_path <- paste0(gisco_path, ".zip")
  }

  api_url <- file.path(db$api_entry, gisco_path)

  return(api_url)
}

#' @name gsc_api_cache
#' @noRd
gsc_api_cache <-
  function(url = NULL,
           name = basename(url),
           cache_dir = NULL,
           update_cache = FALSE,
           verbose = TRUE) {
    cache_dir <- gsc_helper_cachedir(cache_dir)

    # Create destfile and clean
    file.local <- file.path(cache_dir, name)
    file.local <- gsub("//", "/", file.local)


    gsc_message(verbose, "\nCache dir is ", cache_dir, "\n")


    # Check if file already exists
    fileoncache <- file.exists(file.local)

    # If already cached return
    if (isFALSE(update_cache) && fileoncache) {
      gsc_message(
        verbose,
        "\nFile already cached\n",
        file.local
      )


      return(file.local)
    }

    if (fileoncache) {
      gsc_message(verbose, "\nUpdating cached file\n")
    }


    gsc_message(verbose, "Downloading from ", url, "\n")

    # Testing purposes only
    # Mock the behavior of offline
    test <- getOption("giscoR_test_offline", NULL)

    if (isTRUE(test)) {
      gsc_message(
        TRUE,
        "\nurl \n ",
        url,
        " not reachable.\n\nPlease download manually. ",
        "If you think this is a bug please consider opening an issue on ",
        "https://github.com/ropengov/giscoR/issues"
      )
      message("Returning `NULL`")
      return(NULL)
    }


    err_dwnload <- suppressWarnings(try(
      download.file(url, file.local, quiet = isFALSE(verbose), mode = "wb"),
      silent = TRUE
    ))

    # If error then try again

    if (inherits(err_dwnload, "try-error")) {
      gsc_message(verbose, "Retry query")
      Sys.sleep(1)
      err_dwnload <- suppressWarnings(try(
        download.file(url, file.local, quiet = isFALSE(verbose), mode = "wb"),
        silent = TRUE
      ))
    }

    # If not then stop
    if (inherits(err_dwnload, "try-error")) {
      gsc_message(
        TRUE,
        "\nurl \n ",
        url,
        " not reachable.\n\nPlease download manually. ",
        "If you think this is a bug please consider opening an issue on ",
        "https://github.com/ropengov/giscoR/issues"
      )
      message("Returning `NULL`")
      return(NULL)
    }

    gsc_message(verbose, "Download succesful on \n\n", file.local, "\n\n")

    return(file.local)
  }


#' @name gsc_api_load
#' @noRd
gsc_api_load <- function(file = NULL,
                         epsg = NULL,
                         ext = tools::file_ext(file),
                         cache = FALSE,
                         verbose = TRUE) {
  # Currently only supported these ext
  if (!ext %in% c("geojson", "gpkg")) {
    stop("\nExtension ",
      ext,
      " not supported yet",
      call. = FALSE
    )
  }

  epsg <- as.character(epsg)
  num <- sf::st_crs(as.integer(epsg))

  if (isTRUE(cache)) {
    gsc_message(verbose, "Reading from local file ", file)
    size <- file.size(file)
    class(size) <- "object_size"
    gsc_message(verbose, format(size, units = "auto"))
  } else {
    gsc_message(verbose, "Reading from url ", file)
  }


  if (ext == "geojson") {
    data_sf <- suppressWarnings(
      try(
        geojsonsf::geojson_sf(file,
          input = num$input,
          wkt = num$wkt
        ),
        silent = TRUE
      )
    )
  } else if (ext == "gpkg") {
    data_sf <- suppressWarnings(
      try(
        sf::st_read(
          file,
          stringsAsFactors = FALSE,
          quiet = !verbose
        ),
        silent = TRUE
      )
    )
  }


  if (inherits(data_sf, "try-error")) {
    message(
      "File :\n",
      file,
      "\nmay be corrupt. ",
      "Please try again using cache = TRUE and update_cache = TRUE"
    )

    stop("\nExecution halted", call. = FALSE)
  }


  gsc_message(verbose, "File loaded", "\n", "Encoding characters")

  # To UTF-8
  data_sf <- gsc_helper_utf8(data_sf)
  data_sf <- sf::st_make_valid(data_sf)
  return(data_sf)
}


#' Load shapefile "shp" from an online resource
#' @noRd
gsc_load_shp <- function(url, cache_dir = NULL, verbose, update_cache) {
  cache_dir <- gsc_helper_cachedir(cache_dir)
  basename <- basename(url)

  # Download file
  zipfile <- gsc_api_cache(
    url, basename,
    cache_dir,
    update_cache,
    verbose
  )

  # Unzip file
  gsc_unzip(zipfile, cache_dir, "*",
    recursive = TRUE,
    verbose,
    update_cache
  )

  zippedfiles <- unzip(zipfile, list = TRUE)

  # Load shapefile
  shpfile <- basename(zippedfiles[grep(".shp$", zippedfiles[[1]]), 1])

  # Full path and load

  data_sf <- sf::st_read(file.path(cache_dir, shpfile), quiet = !verbose)

  return(data_sf)
}

#' Unzip a file
#' @noRd
gsc_unzip <-
  function(destfile,
           cache_dir,
           ext,
           # Deprecate
           recursive = TRUE,
           verbose = TRUE,
           # Deprecate
           update_cache = TRUE) {
    cache_dir <- gsc_helper_cachedir(cache_dir)

    infiles <- unzip(destfile, list = TRUE, junkpaths = TRUE)

    # Extract files
    outfiles <- infiles[grep(ext, infiles$Name), ]$Name

    gsc_message(verbose, "Extracting files:\n", 
    paste0(outfiles, collapse = "\n"), 
    "\n")


    allfiles <- list.files(cache_dir)

    basenames <- basename(outfiles)

    del <- basenames[basenames %in% allfiles]

    if (length(del) > 1) {
      s <- file.path(cache_dir, del)

      s <- file.remove(s)
    }

    result <- try(unzip(
      destfile,
      files = outfiles,
      exdir = cache_dir,
      junkpaths = TRUE,
      overwrite = update_cache
    ), silent = TRUE)


    # nocov start
    if (inherits(result, "try-error")) {
      message(
        "It was an error unzipping the file,",
        " try downloading manually. \n\n File on",
        cache_dir,
        "\n"
      )
    }
    # nocov end
  }
