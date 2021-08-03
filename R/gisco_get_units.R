#' Get geospatial units data from GISCO API
#'
#' @description
#' Download individual shapefiles of units. Unlike [gisco_get_countries()],
#' [gisco_get_nuts()] or [gisco_get_urban_audit()], that downloads a full
#' dataset and applies filters, [gisco_get_units()] downloads a single
#' shapefile for each unit.
#'
#' @concept political
#'
#' @return
#' A `sf` object on `mode = "sf"` or a dataframe on `mode = "df"`.
#'
#' @param id_giscoR Select the `unit` type to be downloaded.
#' Accepted values are "nuts", "countries" or "urban_audit".
#'
#' @param unit Unit ID to be downloaded. See Details.
#'
#' @param mode Controls the output of the function. Possible values are "sf"
#' or "df". See Value and Details.
#'
#' @param spatialtype Type of geometry to be returned: "RG", for `POLYGON` and
#' "LB" for `POINT`.
#'
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#'
#' @details
#' The function can return a dataframe on `mode = "df"` or a `sf` object
#' on `mode = "sf"`.
#'
#' In order to see the available `unit` ids with the required
#' combination of `spatialtype, year`, first run the function on "df"
#' mode. Once that you get the data frame you can select the required ids
#' on the `unit` parameter.
#'
#' On `mode = "df"` the only relevant parameters are `spatialtype, year`.
#'
#' @note
#' Country-level files would be renamed on your `cache_dir`
#' to avoid naming conflicts with NUTS-0 datasets.
#'
#' Please check the download and usage provisions on [gisco_attributions()].
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>
#'
#' @seealso [gisco_get_countries()]
#'
#' @examples
#' if (gisco_check_access()) {
#'   cities <- gisco_get_units(
#'     id_giscoR = "urban_audit",
#'     mode = "df",
#'     year = "2020"
#'   )
#'   VAL <- cities[grep("Valencia", cities$URAU_NAME), ]
#'   #   Order from big to small
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
#'   # Reorder
#'   VAL.sf$URAU_CATG <- factor(VAL.sf$URAU_CATG, levels = c("F", "K", "C"))
#'
#'   # Plot
#'   library(ggplot2)
#'
#'   ggplot(Provincia) +
#'     geom_sf(fill = "gray1") +
#'     geom_sf(data = VAL.sf, aes(fill = URAU_CATG)) +
#'     scale_fill_viridis_d() +
#'     labs(
#'       title = "Valencia",
#'       subtitle = "Urban Audit",
#'       fill = "Urban Audit\ncategory"
#'     )
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
  api_entry <- unlist(strsplit(routes$api_url, "/geojson/"))[1]
  remain <- unlist(strsplit(routes$api_url, "/geojson/"))[2]




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
      df_csv <- read.csv2(
        tempf,
        sep = ",",
        stringsAsFactors = FALSE,
        encoding = "UTF-8"
      )
      if (verbose) {
        message("Load database succesfully")
      }
      return(df_csv)
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

      iter_sf <- tryCatch(
        gsc_api_load(path, epsg, "geojson", cache, verbose),
        error = function(e) {
          return(NULL)
        }
      )
      if (is.null(iter_sf)) {
        message("\n Skipping unit = ", unit[i], "\n Corrupted file")
        next()
      }


      if (exists("df_sf")) {
        df_sf <- rbind(df_sf, iter_sf)
      } else {
        df_sf <- iter_sf
      }
    }

    if (!exists("df_sf")) {
      stop("No results for ", paste0(unit, collapse = " "))
    }

    # Last check
    df_sf <- sf::st_make_valid(df_sf)
    return(df_sf)
  }
}
