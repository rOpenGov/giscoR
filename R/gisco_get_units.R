#' @title Get geospatial units data from GISCO API
#' @description Download individual shapefiles of units. Unlike
#' \link{gisco_get_countries}, \link{gisco_get_nuts} or
#' \link{gisco_get_urban_audit}, that downloads a full dataset
#' and applies filters, \code{gisco_get_units} downloads a single shapefiles
#' for each unit.
#' @return A \code{sf} object on \code{mode = "sf"} or a dataframe on
#' \code{mode = "df"}.
#' @param id_giscoR Select the \code{unit} type to be downloaded.
#' Accepted values are \code{'nuts','countries'} or \code{'urban_audit'}.
#' @param unit Unit ID to be downloaded. See Details.
#' @param mode Controls the output of the function. Possible values
#' are \code{"sf"} or \code{"df"}. See Value and Details.
#' @param year,epsg,cache,update_cache,cache_dir,verbose,resolution See
#'  \link{gisco_get}.
#' @param spatialtype Type of geometry to be returned: \code{"RG"}
#' for \code{POLYGON} and \code{"LB"} for \code{POINT}.
#' @details The function can return a dataframe on \code{mode = "df"}
#' or a \code{sf} object on \code{mode = "sf"}
#'
#' In order to see the available \code{unit} ids with the required
#' combination of \code{what,year}, first run the function on \code{"df"}
#' mode. Once that you get the data frame you can select the required ids
#' on the \code{unit} parameter.
#'
#' On \code{mode = "df"} the only relevant parameters are \code{what, year}.
#' @note \code{countries} file would be renamed on your \code{cache_dir}
#' to avoid naming conflicts with \code{nuts} datasets.
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/}{
#' GISCO API}
#' @seealso \link{gisco_get}
#' @examples
#' \dontrun{
#' library(sf)
#'
#' if (gisco_check_access()) {
#'   cities <- gisco_get_units(
#'     id_giscoR = "urban_audit",
#'     mode = "df",
#'     year = "2020"
#'   )
#'   VAL <- cities[grep("Valencia", cities$URAU_NAME), ]
#'   #'   Order from big to small
#'   VAL <- VAL[order(as.double(VAL$AREA_SQM), decreasing = TRUE), ]
#'
#'   VAL.sf <- gisco_get_units(
#'     id_giscoR = "urban_audit",
#'     year = "2020",
#'     unit = VAL$URAU_CODE
#'   )
#'   # Provincia
#'   Provincia <-
#'     gisco_get_units(
#'       id_giscoR = "nuts",
#'       unit = c("ES523"),
#'       resolution = "01"
#'     )
#'
#'   # Surrounding area
#'   NUTS1 <-
#'     gisco_get_units(
#'       id_giscoR = "nuts",
#'       unit = c("ES5"),
#'       resolution = "01"
#'     )
#'
#'   # Plot
#'   plot(
#'     st_geometry(Provincia),
#'     col = "gray1",
#'     border = "grey50",
#'     lwd = 3
#'   )
#'   plot(st_geometry(NUTS1),
#'     border = "grey50",
#'     lwd = 3,
#'     add = TRUE
#'   )
#'   plot(
#'     st_geometry(VAL.sf),
#'     col = c("deeppink4", "brown2", "khaki1"),
#'     add = TRUE
#'   )
#'   box()
#'   title(
#'     "Urban Audit - Valencia (ES)",
#'     sub = gisco_attributions("es"),
#'     line = 1,
#'     cex.sub = 0.7
#'   )
#' }
#' }
#' @export
gisco_get_units <- function(id_giscoR = "nuts",
                            unit = "ES4",
                            mode = "sf",
                            year = "2016",
                            epsg = "4326",
                            cache = TRUE,
                            update_cache = FALSE,
                            cache_dir = NULL,
                            verbose = FALSE,
                            resolution = "20",
                            spatialtype = "RG") {
  year <- as.character(year)

  if (!(id_giscoR %in% c("countries", "nuts", "urban_audit"))) {
    stop('id_giscoR should be one of "countries","nuts","urban_audit"')
  }

  if (!(mode %in% c("df", "sf"))) {
    stop('mode should be one of "df","sf"')
  }

  if (mode == "sf" & !(spatialtype %in% c("RG", "LB"))) {
    stop('spatialtype should be one of "RG","LB"')
  }

  if (is.null(unit) & mode == "sf") {
    stop("Select unit(s) to download with unit = c('unit_id1','unit_id2')")
  }

  # Convert to iso3c for countries 2001
  if (mode == "sf" & id_giscoR == "countries") {
    if (year == "2001") {
      unit <- gsc_helper_countrynames(unit, "iso3c")
    } else {
      unit <- gsc_helper_countrynames(unit, "eurostat")
    }
  }

  # Start getting urls and routes
  level <- "all"

  if (id_giscoR == "urban_audit" & year < "2014") {
    level <- "CITY"
  }


  routes <-
    gsc_api_url(
      id_giscoR,
      year,
      epsg,
      resolution,
      ext = "geojson",
      spatialtype,
      verbose = verbose,
      level = level
    )
  api_entry <- unlist(strsplit(routes$api.url, "/geojson/"))[1]
  remain <- unlist(strsplit(routes$api.url, "/geojson/"))[2]




  # Compose depending of the mode
  if (mode == "df") {
    if (id_giscoR == "countries") {
      if (year < "2013") {
        csv <- "csv/CNTR_AT.csv"
      } else {
        csv <- paste0("csv/CNTR_AT_", year, ".csv")
      }
    } else if (id_giscoR == "urban_audit") {
      if (year <= "2004") {
        csv <- paste0("csv/URAU_CITY_AT_", year, ".csv")
      } else if (year < "2018") {
        csv <- "csv/URAU_AT_2011_2014.csv"
      } else {
        csv <- paste0("csv/URAU_AT_", year, ".csv")
      }
    } else if (id_giscoR == "nuts") {
      csv <- paste0("csv/NUTS_AT_", year, ".csv")
    }
    url <- file.path(api_entry, csv)
    tempf <- tempfile(fileext = ".csv")
    ondwn <- tryCatch(
      download.file(url, tempf, quiet = isFALSE(verbose)),
      warning = function(e) {
        message(" url not reachable. Try again ")
        return(TRUE)
      },
      error = function(e) {
        message(" url not reachable. Try again ")
        return(TRUE)
      }
    )
    if (!isTRUE(ondwn)) {
      df.csv <- read.csv2(
        tempf,
        sep = ",",
        stringsAsFactors = FALSE,
        encoding = "UTF-8"
      )
      if (verbose) {
        message("Load database succesfully")
      }
      return(df.csv)
    }
  } else {
    unit <- unique(unit)
    filename <- unit

    api_entry <- file.path(api_entry, "distribution")

    # Slice path
    remain <- gsub(paste0("_", level), "", remain)
    filepattern <- tolower(gsub(".geojson", "", remain))
    slice <- (unlist(strsplit(filepattern, "_")))[c(-1, -2)]

    # Remove year epsg and spatial type
    slice <- slice[-grep(year, slice)]
    slice <- slice[-grep(epsg, slice)]

    if (spatialtype == "LB") {
      filepattern <-
        paste0(paste("-label", epsg, year, sep = "-"), ".geojson")
      filename <- paste0(filename, filepattern)
    } else {
      filepattern <-
        paste0(paste("-region", slice, epsg, year, sep = "-"), ".geojson")
      filepattern <- gsub("-rg", "", filepattern)
      filename <- paste0(filename, filepattern)
    }

    for (i in seq_len(length(filename))) {
      fn <- filename[i]
      if (id_giscoR == "countries") {
        # Modify name for countries
        fn <- gsub(unit[i], paste0(unit[i], "-cntry"), fn)
      }

      path <- tryCatch(
        gsc_api_cache(
          file.path(api_entry, filename[i]),
          fn,
          cache_dir,
          update_cache,
          verbose
        ),
        error = function(e) {
          return("error")
        }
      )

      if (path == "error") {
        message("\n Skipping unit = ", unit[i], "\n Not found")
        next()
      }

      iter.sf <- tryCatch(
        gsc_api_load(path, epsg, "geojson", cache, verbose),
        error = function(e) {
          return(NULL)
        }
      )
      if (is.null(iter.sf)) {
        message("\n Skipping unit = ", unit[i], "\n Corrupted file")
        next()
      }


      if (exists("df.sf")) {
        df.sf <- rbind(df.sf, iter.sf)
      } else {
        df.sf <- iter.sf
      }
    }

    if (!exists("df.sf")) {
      stop("No results for ", paste0(unit, collapse = " "))
    }

    # Last check
    df.sf <- sf::st_make_valid(df.sf)
    return(df.sf)
  }
}
