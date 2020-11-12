#' @title Check access to GISCO API
#' @description Check if R has access to resources at \url{https://gisco-services.ec.europa.eu/distribution/v2/}.
#' @return a logical.
#' @examples
#' gisco_check_access()
#' @export
gisco_check_access <- function() {
  url <-
    "https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/NUTS_LB_2016_4326_LEVL_0.geojson"
  access <-
    tryCatch(
      download.file(url, destfile = tempfile(), quiet = TRUE),
      warning = function(e) {
        return(FALSE)
      }
    )
  # nocov start
  if (isFALSE(access)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
  # nocov end
}


#' @name gsc_helper_cachedir
#' @noRd
gsc_helper_cachedir <- function(cache_dir = NULL) {
  # Check cache dir from options if not set
  if (is.null(cache_dir)) {
    cache_dir <- getOption("gisco_cache_dir", NULL)
  }
  # Reevaluate
  if (is.null(cache_dir)) {
    cache_dir <- file.path(tempdir(), "gisco")
  }

  #Create cache dir if needed
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir)
  }
  return(cache_dir)
}
#' @name gsc_api_url
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
  av.years <- paste(db$year, collapse = ",")
  av.years  <- sort(unique(unlist(strsplit(av.years , ","))))

  if (!(year %in% av.years))
    stop("Year ",
         year,
         " not available. Try ",
         paste0("'", av.years, "'", collapse = ","))

  db <- db[grep(year, db$year),]


  rm(av.years)

  # Available epsg
  av.epsg <- paste(db$epsg, collapse = ",")
  av.epsg  <- sort(unique(unlist(strsplit(av.epsg , ","))))


  if (!(epsg %in% av.epsg))
    stop("EPSG ",
         epsg,
         " not available. Try ",
         paste0("'", av.epsg, "'", collapse = ","))


  db <- db[grep(epsg, db$epsg),]
  rm(av.epsg)

  # Available ext
  # nocov start
  av.ext <- paste(db$ext, collapse = ",")
  av.ext  <- sort(unique(unlist(strsplit(av.ext , ","))))
  # nocov end


  if (!(ext %in% av.ext))
    stop("\n",
         ext,
         " format not available. Try one of ",
         paste0("'", av.ext, "'", collapse = ","))


  db <- db[grep(ext, db$ext),]
  rm(av.ext)


  # Available spatialtype
  av.sptype <- paste(db$spatialtype, collapse = ",")
  av.sptype  <- sort(unique(unlist(strsplit(av.sptype , ","))))

  if (length(av.sptype) == 1) {
    if (verbose)
      message("[Auto] Selecting spatialtype = '", av.sptype, "'\n")
    spatialtype <- av.sptype
  } else {
    if (!(spatialtype %in% av.sptype))
      stop(
        "spatialtype '",
        spatialtype,
        "' not available. Try ",
        paste0("'", av.sptype, "'", collapse = ","),
        "\n"
      )
    db <- db[grep(spatialtype, db$spatialtype), ]
  }

  rm(av.sptype)

  # Available resolution
  av.res <- paste(db$resolution, collapse = ",")
  av.res  <- sort(unique(unlist(strsplit(av.res , ","))))

  if (length(av.res) == 1) {
    if (verbose)
      message("[Auto] Selecting resolution = '", av.res, "'\n")
    resolution <- av.res
  } else {
    if (!(resolution %in% av.res))
      stop(
        "resolution '",
        resolution,
        "' not available for year ",
        year,
        ". Try ",
        paste0("'", av.res, "'", collapse = ","),
        "\n"
      )
    db <- db[grep(resolution, db$resolution), ]
  }
  rm(av.res)

  # NUTS LEVEL
  if (id_giscoR == "nuts") {
    av.nuts <- paste(db$nuts_level, collapse = ",")
    av.nuts  <- sort(unique(unlist(strsplit(av.nuts , ","))))

    if (is.null((nuts_level)))
      nuts_level <- "error"


    if (!(nuts_level %in% av.nuts))
      stop("Select one nuts level of ",
           paste0("'", av.nuts, "'", collapse = ","))
    db <- db[grep(nuts_level, db$nuts_level), ]
  }

  # Urban Audit Level
  if (id_giscoR == "urban_audit") {
    av.ualevel <- paste(db$level, collapse = ",")
    av.ualevel  <- sort(unique(unlist(strsplit(av.ualevel , ","))))

    if (is.null((level)))
      level <- "all"


    if (!(level %in% av.ualevel))
      stop("Select one level of ",
           paste0("'", av.ualevel, "'", collapse = ","))
    db <- db[grep(level, db$level), ]
  }


  # Sanity check
  # nocov start
  if (nrow(db) > 1) {
    message(
      "Several options selected. ",
      "On gisco_db, rows: ",
      paste0(rownames(db), collapse = ","),
      " matches your selection. ",
      "Selecting row ",
      rownames(db[1,])
    )
    message("\n Consider opening an issue.")
    db <- db[1,]
  }
  # nocov end


  gisco.path <- db$api_file
  # Create api call
  params <-
    c("year",
      "epsg",
      "resolution",
      "spatialtype",
      "nuts_level",
      "level",
      "ext")


  for (i in seq_len(length(params))) {
    patt <- paste0("\\{", params[i], "\\}")
    repl <- eval(parse(text = params[i]))
    if (is.null(repl))
      repl <- "ERR"
    gisco.path <- gsub(patt, repl, x = gisco.path)
  }

  # TopoJson has .json extension
  if (ext == "topojson") {
    gisco.path <-
      gsub(paste0(".", ext), ".json", gisco.path, fixed = TRUE)
  }

  # Shp are zips
  if (ext %in% c("shp", "svg")) {
    gisco.path <- paste0(gisco.path, ".zip")
  }
  namefile <- gsub(paste0(ext, "/"), "", gisco.path)
  api.url <- file.path(db$api_entry, gisco.path)

  output <- list(api.url = api.url,
                 namefile = namefile)

  return(output)
}

#' @name gsc_api_cache
#' @noRd
gsc_api_cache <-
  function(url = NULL,
           name = NULL,
           cache_dir = NULL,
           update_cache = FALSE,
           verbose = TRUE) {
    cache_dir <- gsc_helper_cachedir(cache_dir)

    # Create destfile and clean
    file.local <- file.path(cache_dir, name)
    file.local <- gsub("//", "/", file.local)

    if (verbose)
      message("\nCache dir is ", cache_dir, "\n")

    # Check if file already exists
    fileoncache <- file.exists(file.local)

    if (isFALSE(update_cache) & fileoncache) {
      if (verbose)
        message("\nFile already cached\n",
                file.local)
    } else {
      if (fileoncache & verbose)
        message("\nUpdating cached file\n")

      if (verbose)
        message("Downloading from ", url, "\n")
      err_dwnload <- tryCatch(
        download.file(url, file.local, quiet = isFALSE(verbose), mode = "wb"),
        warning = function(e) {
          message(
            "\nurl \n ",
            url,
            " not reachable.\n\nPlease download manually. If you think this is a bug please consider opening an issue on https://github.com/dieghernan/giscoR/issues"
          )
          return(TRUE)
        }
      )

      if (isTRUE(err_dwnload)) {
        stop("Download failed")
      } else if (verbose) {
        message("Download succesful on \n\n", file.local, "\n\n")
      }
    }
    return(file.local)
  }


#' @name gsc_api_load
#' @noRd
gsc_api_load <- function(file = NULL,
                         epsg = NULL,
                         ext = "geojson",
                         cache = FALSE,
                         verbose = TRUE) {
  epsg <- as.character(epsg)
  num <- sf::st_crs(as.integer(epsg))

  # Currently only supported this ext
  if (ext %in% c("geojson", "gpkg")) {
    if (verbose & isTRUE(cache)) {
      message("Reading from local file ", file)
      size <- file.size(file)
      class(size) <- 'object_size'
      message(format(size, units = "auto"))
    } else{
      if (verbose)
        message("Reading from url ", file)
    }
    if (ext == "geojson") {
      err_onload <- tryCatch(
        data.sf <- geojsonsf::geojson_sf(file,
                                         input = num$input,
                                         wkt = num$wkt),
        warning = function(e) {
          message("\n\nFile couldn't be loaded from \n\n",
                  file,
                  "\n\n Please try cache = TRUE")
          return(TRUE)
        },
        error = function(e) {
          message(
            "File :\n",
            file,
            "\nmay be corrupt. Please try again using cache = TRUE and update_cache = TRUE"
          )
          return(TRUE)
        }
      )
    } else {
      # nocov start
      err_onload <- tryCatch(
        data.sf <-
          sf::st_read(
            file,
            stringsAsFactors = FALSE,
            quiet = !verbose
          ),
        warning = function(e) {
          message("\n\nFile couldn't be loaded from \n\n",
                  file,
                  "\n\n Please try cache = TRUE")
          return(TRUE)
        },
        error = function(e) {
          message(
            "File :\n",
            file,
            "\nmay be corrupt. Please try again using cache = TRUE and update_cache = TRUE"
          )
          return(TRUE)
        }
      )
      # nocov end
    }

    if (isTRUE(err_onload)) {
      loaded <- FALSE
    } else {
      loaded <- TRUE
      if (verbose)
        message("File loaded")
    }

    if (loaded) {
      if (verbose)
        message("Encoding characters")
      # To UTF-8
      data.sf <- gsc_helper_utf8(data.sf)
      data.sf <- sf::st_make_valid(data.sf)
      return(data.sf)
    } else {
      stop("\nExecution halted")
    }
  } else {
    # nocov start
    stop("\nExtension ", ext, " not supported yet")
    # nocov end
  }
}

#' @name gsc_unzip
#' @noRd
gsc_unzip <-
  function(destfile,
           cache_dir,
           ext,
           recursive = TRUE,
           verbose = TRUE,
           update_cache = TRUE) {
    infiles <- tryCatch(
      unzip(destfile, list = TRUE),
      warning = function(e) {
        message(
          "It was an error extracting the files. Try unzipping the file yourself \n",
          destfile,
          "\n"
        )
        return(TRUE)
      },
      error = function(e) {
        message(
          "It was an error extracting the files. Try unzipping the file yourself \n",
          destfile,
          "\n"
        )
        return(TRUE)
      }
    )

    continue <- !isTRUE(infiles)



    #Extract files
    if (continue) {
      outfiles <- infiles[grep(ext, infiles$Name), ]$Name

      if (verbose)
        message("Extracting files: ", paste0(outfiles, collapse = "\n"), "\n")
      tryCatch(
        unzip(
          destfile,
          files = outfiles,
          exdir = cache_dir,
          overwrite = update_cache
        ),
        warning = function(e) {
          message(
            "Some files of ",
            destfile,
            " may have not been extracted. Please check folder ",
            cache_dir,
            "\n"
          )
        },
        error = function(e) {
          message(
            "It was an error unzipping the file,",
            "try downloading manually. \n\n File on",
            cache_dir,
            "\n"
          )
        }
      )
    }
    continue <- !isTRUE(infiles)

    # Evaluate if recursive selected and needed
    rec <- recursive
    if (rec) {
      loopzip <- outfiles[grep("zip", outfiles)]
      rec <- (length(loopzip) > 0)
    }
    if (rec) {
      if (verbose)
        message("Extracting recursively files ",
                paste0(loopzip, collapse = "\n"),
                "\n")
      for (i in seq_len(length(loopzip))) {
        fpath <- file.path(cache_dir, loopzip[i])
        tryCatch(
          unzip(fpath,
                exdir = cache_dir,
                overwrite = update_cache),
          warning = function(e) {
            message(
              "\nSome files of ",
              loopzip[i],
              " may have not been extracted. Please check folder ",
              cache_dir,
              "\n"
            )
          },
          error = function(e) {
            message(
              "\nIt was an error unzipping the file, ",
              loopzip[i],
              "try downloading manually. \n\n File on",
              cache_dir,
              "\n"
            )
          }
        )
      }
    }
  }
