#' Get geospatial units data from GISCO API
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function is deprecated. Use:
#'
#' - [gisco_get_metadata()] (equivalent to `mode = "df"`).
#' - [gisco_get_unit_country()] and friends (equivalent to `mode = "sf"`)
#'
#' Download individual shapefiles of units. Unlike [gisco_get_countries()],
#' [gisco_get_nuts()] or [gisco_get_urban_audit()], that downloads a full
#' dataset and applies filters, [gisco_get_units()] downloads a single
#' shapefile for each unit.
#'
#' @keywords internal
#' @export
#'
#' @return
#' A [`sf`][sf::st_sf] object on `mode = "sf"` or a data frame on `mode = "df"`.
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
#'
#' @details
#' The function can return a data frame on `mode = "df"` or a [`sf`][sf::st_sf]
#' object on `mode = "sf"`.
#'
#' In order to see the available `unit` ids with the required
#' combination of `spatialtype, year`, first run the function on `"df"`
#' mode. Once that you get the data frame you can select the required ids
#' on the `unit` argument.
#'
#' On `mode = "df"` the only relevant arguments are `spatialtype, year`.
#'
#' @note
#' Country-level files would be renamed on your `cache_dir`
#' to avoid naming conflicts with NUTS-0 datasets.
#'
#' Please check the download and usage provisions on [gisco_attributions()].
#'
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>
#'
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#' # Get metadata
#' cities <- gisco_get_metadata("urban_audit", 2020)
#'
#'
#' # Valencia, Spain
#' valencia <- cities[grep("Valencia", cities$URAU_NAME), ]
#' valencia
#' library(dplyr)
#' # Now get the shapes and order by AREA_SQM
#' valencia_sf <- gisco_get_unit_urban_audit(
#'   unit = valencia$URAU_CODE,
#'   year = "2020",
#' ) |>
#'   arrange(desc(AREA_SQM))
#' # Plot
#' library(ggplot2)
#'
#' ggplot(valencia_sf) +
#'   geom_sf(aes(fill = URAU_CATG)) +
#'   scale_fill_viridis_d() +
#'   labs(
#'     title = "Valencia",
#'     subtitle = "Urban Audit 2020",
#'     fill = "Category"
#'   )
#' }
gisco_get_units <- function(
  id_giscoR = c("nuts", "countries", "urban_audit"),
  unit = "ES4",
  mode = c("sf", "df"),
  year = "2016",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = "20",
  spatialtype = "RG"
) {
  mode <- match_arg_pretty(mode)
  if (mode == "df") {
    lifecycle::deprecate_warn(
      "1.0.0",
      "gisco_get_units()",
      "giscoR::gisco_get_metadata()"
    )

    df <- gisco_get_metadata(id_giscoR, year, verbose = verbose)
    return(df)
  }
  year <- as.character(year)

  cache_dir <- create_cache_dir(cache_dir)
  unit <- unique(unit)

  # Validations
  id_giscoR <- match.arg(id_giscoR)
  mode <- match.arg(mode)

  if (!(spatialtype %in% c("RG", "LB"))) {
    stop('spatialtype should be one of "RG","LB"')
  }

  if (is.null(unit)) {
    stop("Select unit(s) to download with unit = c('unit_id1','unit_id2')")
  }

  # Convert to iso3c for countries 2001
  if (id_giscoR == "countries") {
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

  api_entry <- gsc_api_url(
    id_giscoR,
    year,
    epsg,
    resolution,
    ext = "geojson",
    spatialtype,
    verbose = verbose,
    level = level
  )
  basename <- basename(api_entry)

  api_url <- unlist(strsplit(api_entry, "/geojson/"))[1]
  remain <- unlist(strsplit(api_entry, "/geojson/"))[2]

  # Compose depending of the mode
  sf <- gsc_units_sf(
    id_giscoR,
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
    level
  )
  sf
}

#' Download sf for units
#' @noRd
gsc_units_sf <- function(
  id_giscoR,
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
  level
) {
  cache_dir <- create_cache_dir(cache_dir)

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

  for (i in seq_along(filename)) {
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
        "\nSkipping unit = ",
        unit[i],
        "\nNot found"
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
        "\nSkipping unit = ",
        unit[i],
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
    stop(
      "No results for c(",
      paste0("'", unit, "'", collapse = ", "),
      ")",
      call. = FALSE
    )
  }

  # Last check
  df_sf <- sf::st_make_valid(df_sf)
  df_sf
}
