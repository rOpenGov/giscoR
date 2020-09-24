# import stuffs
#' @importFrom utils download.file
NULL


#' @name gsc_helper_communes_url
#' @title Helper function communes_url
#' @description Get url for communes
#' @param year year
#' @param crs crs
#' @param spatialtype spatialtype
#' @return a string
#' @noRd
gsc_helper_communes_url <- function(year, crs, spatialtype) {
  # nocov start
  y <- as.integer(year)
  if (y >= 2010) {
    if (spatialtype %in% c("COASTL", "INLAND")) {
      filename <-
        paste0("COMM_BN_01M_",
               year,
               "_",
               crs,
               "_",
               spatialtype,
               ".geojson")

    } else if (spatialtype == "LB") {
      (filename <-
         paste0("COMM_LB_",
                year,
                "_",
                crs,
                ".geojson"))

    } else {
      filename <-
        paste0("COMM_",
               spatialtype,
               "_01M_",
               year,
               "_",
               crs,
               ".geojson")
    }
  } else if (y >= 2006) {
    if (spatialtype %in% c("COASTL", "INLAND")) {
      filename <-
        paste0("COMM_BN_",
               year,
               "_",
               crs,
               "_",
               spatialtype,
               ".geojson")
    } else {
      filename <-
        paste0("COMM_",
               spatialtype,
               "_",
               year,
               "_",
               crs,
               ".geojson")
    }
  } else if (y == 2004) {
    if (spatialtype %in% c("COASTL", "INLAND")) {
      stop(
        paste0(
          "Communes ",
          year,
          " is not provided for ",
          spatialtype,
          ". Try spatialtype = BN."
        )
      )
    } else {
      filename <-
        paste0("COMM_",
               spatialtype,
               "_",
               year,
               "_",
               crs,
               ".geojson")
    }
  } else {
    if (spatialtype %in% c("COASTL", "INLAND")) {
      stop(
        paste0(
          "Communes ",
          year,
          " is not provided for ",
          spatialtype,
          ". Try spatialtype = BN."
        )
      )
    } else {
      if (spatialtype == "LB") {
        (filename <-
           paste0("COMM_LB_",
                  year,
                  "_",
                  crs,
                  ".geojson"))

      } else {
        filename <-
          paste0("COMM_",
                 spatialtype,
                 "_01M_",
                 year,
                 "_",
                 crs,
                 ".geojson")
      }
    }
  }
  return(filename)
  # nocov end
}

#' @name gsc_helper_urau_url
#' @title Helper function urau_url
#' @description Get url for communes
#' @param year year
#' @param crs crs
#' @param spatialtype spatialtype
#' @param level level
#' @return a string
#' @noRd
gsc_helper_urau_url <- function(year, crs, spatialtype, level) {
  if (spatialtype == "LB") {
    if (level == "") {
      filename <-
        paste0("URAU_LB_",
               year,
               "_",
               crs,
               ".geojson")
    } else {
      filename <-
        paste0("URAU_LB_",
               year,
               "_",
               crs,
               "_",
               level,
               ".geojson")
    }
  } else {
    if (year == "2018") {
      text <- "01M"
    } else {
      text <- "100K"
    }
    # nocov start
    if (level == "") {
      filename <-
        paste0("URAU_RG_",
               text,
               "_",
               year,
               "_",
               crs,
               ".geojson")
      # nocov end
    } else {
      filename <-
        paste0("URAU_RG_",
               text,
               "_",
               year,
               "_",
               crs,
               "_",
               level,
               ".geojson")
    }
  }
  return(filename)
}


#' @name gsc_helper_dwnl_nocaching
#' @title Helper function download with no caching
#' @description Download
#' @param cache cache
#' @param cache_dir cache_dir
#' @param update_cache update_cache
#' @param filename filename
#' @param url url
#' @return an sf object
#' @noRd
gsc_helper_dwnl_nocaching <-
  function(cache,
           cache_dir,
           update_cache,
           filename,
           url) {
    if (cache) {
      if (is.null(cache_dir)) {
        cache_dir <- getOption("gisco_cache_dir", NULL)
        if (is.null(cache_dir)) {
          cache_dir <- file.path(tempdir(), "gisco")
        }
      }

      if (isFALSE(dir.exists(cache_dir))) {
        dir.create(cache_dir)
      }

      filepath <- paste0(cache_dir, "/", filename)

      if (update_cache | isFALSE(file.exists(filepath))) {
        if (update_cache) {
          print("Updating cache")
        }
        download.file(url, filepath, quiet = TRUE)

      }
      data.sf <- sf::st_read(filepath,   stringsAsFactors = FALSE,
                             quiet = TRUE)
    } else {
      data.sf <- sf::st_read(url,   stringsAsFactors = FALSE,
                             quiet = TRUE)
    }
  }

#' @name gsc_helper_dwnl_caching
#' @title Helper function download always catching
#' @description Download
#' @param cache_dir cache_dir
#' @param update_cache update_cache
#' @param filename filename
#' @param url url
#' @return an sf object
#' @noRd
gsc_helper_dwnl_caching <- function(cache_dir,
                                    update_cache,
                                    filename,
                                    url) {
  # Always cache on this function given the large size of the files
  if (is.null(cache_dir)) {
    cache_dir <- getOption("gisco_cache_dir", NULL)
    if (is.null(cache_dir)) {
      cache_dir <- file.path(tempdir(), "gisco")
    }
  }
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir)
  }

  filepath <- paste0(cache_dir, "/", filename)
  if (update_cache | isFALSE(file.exists(filepath))) {
    if (update_cache) {
      print("Updating cache")
    }
    message(paste0("Starting download from url:\n\n",
                   print(url)))
    download.file(url, filepath)
  }
  size <- file.size(filepath)
  class(size) <- 'object_size'


  print(paste0("Loading from cache dir: ", cache_dir))
  print(size, units = "auto")

  data.sf <- sf::st_read(filepath,
                         stringsAsFactors = FALSE,
                         quiet = TRUE)

}
