#' @title Bulk download from GISCO API
#' @description Downloads zipped data from GISCO and extract them on the
#' \code{cache_dir} folder.
#' @return Silent function.
#' @param id_giscoR Type of dataset to be downloaded. Values supported are
#' \code{"coastallines", }
#' \code{"communes", "countries", "lau", "nuts", "urban_audit"}.
#' @param year,cache_dir,update_cache,verbose,resolution See \link{gisco_get}
#' for details.
#' @param ext Extension of the file(s) to be downloaded. Available formats are
#' \code{"geojson",}\code{ "shp", "svg", "json", "gdb"}. See Details.
#' @param recursive Tries to unzip recursively the zip files (if any) included
#' in the initial bulk download (case of \code{ext = "shp"}).
#' @details The usual extension used across \pkg{giscoR} is \code{geojson},
#' however other formats are already available on GISCO.
#'
#' This function helps building a personal shape library on \code{cache_dir}
#' (or \code{options(gisco_cache_dir = "path/to/dir")}, if set by the user).
#'
#'
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/}{GISCO API}
#' @note For downloading specific files use \link{gisco_get} functions.
#' @examples
#' \dontrun{
#' # Countries 2016
#' gisco_bulk_download(id_giscoR = "countries", resolution = "60")
#'  }
#' @export
gisco_bulk_download <- function(id_giscoR = "countries",
                                year = "2016",
                                cache_dir = NULL,
                                update_cache = FALSE,
                                verbose = FALSE,
                                resolution = "10",
                                ext = "geojson",
                                recursive = TRUE) {
  valid <- c("coastallines",
             "communes",
             "countries",
             "lau",
             "nuts",
             "urban_audit")
  alias <-
    c("coastline", "communes", "countries", "lau", "nuts", "urau")

  if (!(id_giscoR %in% valid)) {
    stop("id_giscoR values should be one of ",
         paste0("'", sort(valid), "'", collapse = ","))
  }

  availext <- c("geojson", "shp", "svg", "json", "gdb")
  if (!(ext %in% availext)) {
    stop("ext should be one of ", paste0(availext, collapse = ", "))
  }

  # Standard parameters for the call
  year <- as.character(year)
  epsg <- "4326"
  spatialtype <- "RG"
  level <- "all"
  if (id_giscoR == "urban_audit" & year < "2014") {
    level <- "CITY"
  }

  routes <- gsc_api_url(
    id_giscoR,
    year,
    epsg,
    resolution,
    spatialtype,
    "geojson",
    nuts_level = "all",
    level = level,
    verbose = verbose
  )

  api_entry <- unlist(strsplit(routes$api.url, "/geojson/"))[1]
  remain <- unlist(strsplit(routes$api.url, "/geojson/"))[2]

  api_entry <- file.path(api_entry, "download")
  getalias <- alias[valid == id_giscoR]

  # Clean names
  remain2 <- gsub(spatialtype, "", remain)
  remain2 <- gsub(epsg, "", remain2)
  remain2 <- gsub(year, "", remain2)
  remain2 <- gsub(".geojson", "", remain2)
  remain2 <- gsub(level, "", remain2)
  remain2 <- (unlist(strsplit(remain2, "_")))[-1]
  remain2 <- tolower(paste0(remain2, collapse = ""))

  # Create url
  zipname <- paste0("ref-",
                    getalias,
                    "-",
                    year,
                    "-",
                    remain2,
                    ".",
                    ext,
                    ".zip")
  url <- file.path(api_entry, zipname)


  destfile <-
    gsc_api_cache(url, zipname, cache_dir, update_cache, verbose)

  # Clean cache dir name for extracting
  unzip_dir <- gsub(paste0("/", zipname), "", destfile)

  # Unzip
  gsc_unzip(destfile,
            unzip_dir, ext, recursive, verbose, update_cache)

}
