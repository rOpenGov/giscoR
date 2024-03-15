#' Get geospatial units data from GISCO API
#'
#' @description
#' Download individual shapefiles of units. Unlike [gisco_get_countries()],
#' [gisco_get_nuts()] or [gisco_get_urban_audit()], that downloads a full
#' dataset and applies filters, [gisco_get_units()] downloads a single
#' shapefile for each unit.
#'
#' @family political
#'
#' @return
#' A \CRANpkg{sf} object on `mode = "sf"` or a data frame on `mode = "df"`.
#'
#' @param id_giscoR Select the `unit` type to be downloaded. Accepted values are
#'  `"nuts"`, `"countries"` or `"urban_audit"`.
#'
#' @param unit Unit ID to be downloaded. See **Details**.
#'
#' @param mode Controls the output of the function. Possible values are `"sf"`
#'  or `"df"`. See **Value** and **Details**.
#'
#' @param spatialtype Type of geometry to be returned: `"RG"`, for `POLYGON` and
#'  `"LB"` for `POINT`.
#'
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#'
#' @details
#' The function can return a data frame on `mode = "df"` or a \CRANpkg{sf}
#' object on `mode = "sf"`.
#'
#' In order to see the available `unit` ids with the required
#' combination of `spatialtype, year`, first run the function on `"df"`
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
#' @examplesIf gisco_check_access()
#' \donttest{
#' cities <- gisco_get_units(
#'   id_giscoR = "urban_audit",
#'   mode = "df",
#'   year = "2020"
#' )
#' VAL <- cities[grep("Valencia", cities$URAU_NAME), ]
#' #   Order from big to small
#' VAL <- VAL[order(as.double(VAL$AREA_SQM), decreasing = TRUE), ]
#'
#' VAL.sf <- gisco_get_units(
#'   id_giscoR = "urban_audit",
#'   year = "2020",
#'   unit = VAL$URAU_CODE
#' )
#' # Provincia
#' Provincia <-
#'   gisco_get_units(
#'     id_giscoR = "nuts",
#'     unit = c("ES523"),
#'     resolution = "01"
#'   )
#'
#' # Reorder
#' VAL.sf$URAU_CATG <- factor(VAL.sf$URAU_CATG, levels = c("F", "K", "C"))
#'
#' # Plot
#' library(ggplot2)
#'
#' ggplot(Provincia) +
#'   geom_sf(fill = "gray1") +
#'   geom_sf(data = VAL.sf, aes(fill = URAU_CATG)) +
#'   scale_fill_viridis_d() +
#'   labs(
#'     title = "Valencia",
#'     subtitle = "Urban Audit",
#'     fill = "Urban Audit\ncategory"
#'   )
#' }
#' @export
gisco_get_units <- function(id_giscoR = c("nuts", "countries", "urban_audit"),
                            unit = "ES4", mode = c("sf", "df"), year = "2016",
                            epsg = "4326", cache = TRUE, update_cache = FALSE,
                            cache_dir = NULL, verbose = FALSE,
                            resolution = "20", spatialtype = "RG") {
  year <- as.character(year)

  cache_dir <- gsc_helper_cachedir(cache_dir)
  unit <- unique(unit)


  # Validations
  id_giscoR <- match.arg(id_giscoR)
  mode <- match.arg(mode)

  if (mode == "sf" && !(spatialtype %in% c("RG", "LB"))) {
    stop('spatialtype should be one of "RG","LB"')
  }

  if (is.null(unit) && mode == "sf") {
    stop("Select unit(s) to download with unit = c('unit_id1','unit_id2')")
  }

  # Convert to iso3c for countries 2001
  if (mode == "sf" && id_giscoR == "countries") {
    if (year == "2001") {
      unit <- gsc_helper_countrynames(unit, "iso3c")
    } else {
      unit <- gsc_helper_countrynames(unit, "eurostat")
    }
  }

  # Start getting urls and routes
  level <- "all"

  if (id_giscoR == "urban_audit" && year < "2014") {
    level <- "CITY"
  }


  api_entry <- gsc_api_url(id_giscoR, year, epsg, resolution,
    ext = "geojson", spatialtype, verbose = verbose,
    level = level
  )
  basename <- basename(api_entry)

  api_url <- unlist(strsplit(api_entry, "/geojson/"))[1]
  remain <- unlist(strsplit(api_entry, "/geojson/"))[2]

  # Compose depending of the mode
  if (mode == "df") {
    df <- gsc_units_df(id_giscoR, year, api_url, verbose)

    return(df)
  } else if (mode == "sf") {
    sf <- gsc_units_sf(
      id_giscoR, unit, year,
      epsg, cache, update_cache, cache_dir,
      verbose, spatialtype, api_url, remain,
      level
    )
    return(sf)
  }
}

#' Download sf for units
#' @noRd
gsc_units_sf <- function(id_giscoR,
                         unit,
                         year,
                         epsg,
                         cache,
                         update_cache,
                         cache_dir,
                         verbose,
                         spatialtype,
                         api_url,
                         remain,
                         level) {
  cache_dir <- gsc_helper_cachedir(cache_dir)

  filename <- unit

  api_url <- file.path(api_url, "distribution")

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

    if (cache) {
      path <- try(
        gsc_api_cache(
          file.path(api_url, filename[i]),
          fn,
          cache_dir,
          update_cache,
          verbose
        ),
        silent = TRUE
      )
    } else {
      path <- file.path(api_url, filename[i])
    }



    if (inherits(path, "try-error") || is.null(path)) {
      gsc_message(
        TRUE,
        "\nSkipping unit = ", unit[i], "\nNot found"
      )
      next()
    }


    iter_sf <- try(
      gsc_api_load(path, epsg, "geojson", cache, verbose),
      silent = TRUE
    )

    # nocov start
    if (inherits(iter_sf, "try-error")) {
      gsc_message(
        TRUE,
        "\nSkipping unit = ", unit[i],
        "\n Corrupted file"
      )
      next()
    }

    # nocov end

    if (exists("df_sf")) {
      df_sf <- rbind(df_sf, iter_sf)
    } else {
      df_sf <- iter_sf
    }
  }

  if (!exists("df_sf")) {
    stop("No results for c(", paste0("'", unit, "'", collapse = ", "), ")",
      call. = FALSE
    )
  }

  # Last check
  df_sf <- sf::st_make_valid(df_sf)
  return(df_sf)
}

#' Download data frame for units
#' @noRd
gsc_units_df <- function(id_giscoR, year, api_url, verbose) {
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

  url <- file.path(api_url, csv)

  file.local <- tempfile(fileext = ".csv")

  err_dwnload <- suppressWarnings(try(
    download.file(url, file.local, quiet = isFALSE(verbose), mode = "wb"),
    silent = TRUE
  ))

  # If error then try again

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

  # nocov start

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
      "not reachable.\n\nPlease download manually.",
      "If you think this is a bug please consider opening an issue on ",
      "https://github.com/ropengov/giscoR/issues"
    )
    message("Returning `NULL`")
    return(NULL)
  }

  # nocov end

  df_csv <- read.csv2(
    file.local,
    sep = ",",
    stringsAsFactors = FALSE,
    encoding = "UTF-8"
  )


  gsc_message(verbose, "Database loaded succesfully")
  return(df_csv)
}
