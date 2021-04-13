#' Get geospatial data from GISCO API
#'
#' @concept political
#'
#' @name gisco_get
#'
#' @description
#' Loads a simple feature (`sf`) object from GISCO API entry point or your
#' local library.
#'
#' @param year Release year. See **Release years available** on [`gisco_get`].
#'
#' @param epsg projection of the map: 4-digit [EPSG code](https://epsg.io/).
#'  One of:
#'  * "4258": ETRS89
#'  * "4326": WGS84
#'  * "3035": ETRS89 / ETRS-LAEA
#'  * "3857": Pseudo-Mercator
#'
#' @param cache A logical whether to do caching. Default is `TRUE`.
#'
#' @param update_cache A logical whether to update cache. Default is `FALSE`.
#'  When set to `TRUE` it would force a fresh download of the source
#'  `.geojson` file.
#'
#' @param cache_dir A path to a cache directory. See Details on [`gisco_get`].
#'
#' @param verbose Display information. Useful for debugging,
#'  default is `FALSE`.
#'
#' @param resolution Resolution of the geospatial data. One of
#' * "60": 1:60million
#' * "20": 1:20million
#' * "10": 1:10million
#' * "03": 1:3million
#' * "01": 1:1million
#'
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @details
#' `country` only available on specific datasets. Some `spatialtype` options
#' (as "BN", "COASTL", "INLAND") may not include country-level identifiers.
#'
#' `country` could be either a vector of country names, a vector of ISO3
#' country codes or a vector of Eurostat country codes. Mixed types
#' (as `c("Turkey","US","FRA")`) would not work.
#'
#' Sometimes cached files may be corrupt. On that case, try re-downloading
#' the data setting `update_cache = TRUE`.
#'
#' Set `cache_dir = "path/to/dir"` or `options(gisco_cache_dir = "path/to/dir)`.
#' If you experience any problem on download, try to download
#' the corresponding `.geojson` file by any other method and save it on
#' your `cache_dir`.
#'
#' For a complete list of files available check [`gisco_db`].
#'
#' # About world regions
#'
#' Regions are defined as per the geographic regions defined by the
#' UN (see <https://unstats.un.org/unsd/methodology/m49/>.
#' Under this scheme Cyprus is assigned to Asia. You may use
#' `region = "EU"` to get the EU members (reference date: 2021).
#'
#' # Release years available
#'
#' * **`gisco_get_coastallines`**: one of "2006", "2010", "2013" or "2016".
#' * **`gisco_get_communes`**: one of "2001", "2004", "2006", "2008", "2010",
#' "2013" or "2016".
#' * **`gisco_get_countries`**: one of "2001", "2006", "2010", "2013", "2016"
#' or "2020".
#' * **`gisco_get_lau`**: one of "2016", "2017", "2018" or "2019"
#'
#' @return A `sf` object specified by `spatialtype`.
#'
#' @note
#' Please check the download and usage provisions on [gisco_attributions()].
#'
#' @examples
#'
#' library(sf)
#'
#' ##################################
#' # Example - gisco_get_coastallines
#' ##################################
#'
#' coastlines <- gisco_get_coastallines()
#' plot(st_geometry(coastlines), col = "palegreen", border = "lightblue3")
#' title(
#'   main = "Coastal Lines",
#'   sub = gisco_attributions(),
#'   line = 1
#' )
#' @seealso [`gisco_db`], [gisco_attributions()], [`gisco_coastallines`]
#'
#' @export
gisco_get_coastallines <- function(year = "2016",
                                   epsg = "4326",
                                   cache = TRUE,
                                   update_cache = FALSE,
                                   cache_dir = NULL,
                                   verbose = FALSE,
                                   resolution = "20") {
  ext <- "geojson"

  geturl <- gsc_api_url(
    id_giscoR = "coastallines",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = NULL,
    ext = ext,
    nuts_level = NULL,
    level = NULL,
    verbose = verbose
  )

  # Check if data is already available
  checkdata <- grep("COAS_RG_20M_2016_4326", geturl$namefile)
  if (isFALSE(update_cache) & length(checkdata)) {
    dwnload <- FALSE
    data_sf <- giscoR::gisco_coastallines
    if (verbose) {
      message(
        "Loaded from gisco_coastallines dataset. Use update_cache = TRUE",
        " to load the shapefile from the .geojson file"
      )
    }
  } else {
    dwnload <- TRUE
  }
  if (dwnload) {
    if (cache) {
      # Guess source to load
      namefileload <-
        gsc_api_cache(
          geturl$api_url,
          geturl$namefile,
          cache_dir,
          update_cache,
          verbose
        )
    } else {
      namefileload <- geturl$api_url
    }

    # Load - geojson only so far
    data_sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }
  return(data_sf)
}

#' @rdname gisco_get
#'
#' @param spatialtype Type of geometry to be returned:
#' * **"RG"**: Regions - `MULTIPOLYGON/POLYGON` object.
#' * **"LB"**: Labels - `POINT` object.
#' * **"BN"**: Boundaries - `LINESTRING` object.
#' * **"COASTL"**: coastlines - `LINESTRING` object.
#' * **"INLAND"**: inland boundaries - `LINESTRING` object.
#'
#' @param country Optional. A character vector of country codes.
#' See Details on [`gisco_get`].
#'
#' @export
gisco_get_communes <- function(year = "2016",
                               epsg = "4326",
                               cache = TRUE,
                               update_cache = FALSE,
                               cache_dir = NULL,
                               verbose = FALSE,
                               spatialtype = "RG",
                               country = NULL) {
  ext <- "geojson"

  geturl <- gsc_api_url(
    id_giscoR = "communes",
    year = year,
    epsg = epsg,
    resolution = 0,
    # Not neccesary
    spatialtype = spatialtype,
    ext = ext,
    nuts_level = NULL,
    level = NULL,
    verbose = verbose
  )
  # There are not data file on this
  dwnload <- TRUE
  if (dwnload) {
    if (cache) {
      # Guess source to load
      namefileload <-
        gsc_api_cache(
          geturl$api_url,
          geturl$namefile,
          cache_dir,
          update_cache,
          verbose
        )
    } else {
      namefileload <- geturl$api_url
    }

    # Load - geojson only so far
    data_sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }

  if (!is.null(country) & "CNTR_CODE" %in% names(data_sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }
  return(data_sf)
}

#' @rdname gisco_get
#'
#' @param region Optional. A character vector of UN M49 region codes or
#' European Union membership. Possible values are "Africa", "Americas",
#' "Asia", "Europe", "Oceania" or "EU" for countries belonging to the European
#' Union (as per 2021). See **About world regions** and [`gisco_countrycode`]
#'
#' @seealso [gisco_countrycode()], [`gisco_countries`]
#'
#' @export
#'
#' @examples
#'
#' ###############################
#' # Example - gisco_get_countries
#' ###############################
#'
#' sf_world <- gisco_get_countries()
#' plot(st_geometry(sf_world), col = "seagreen2")
#' title(sub = gisco_attributions(), line = 1)
#'
#'
#' sf_africa <- gisco_get_countries(region = "Africa")
#' plot(st_geometry(sf_africa),
#'   col = c("springgreen4", "darkgoldenrod1", "red2")
#' )
#' title(sub = gisco_attributions(), line = 1)
#'
#' sf_benelux <-
#'   gisco_get_countries(country = c("Belgium", "Netherlands", "Luxembourg"))
#' plot(st_geometry(sf_benelux),
#'   col = c("grey10", "orange", "deepskyblue2")
#' )
#' title(sub = gisco_attributions(), line = 1)
gisco_get_countries <- function(year = "2016",
                                epsg = "4326",
                                cache = TRUE,
                                update_cache = FALSE,
                                cache_dir = NULL,
                                verbose = FALSE,
                                resolution = "20",
                                spatialtype = "RG",
                                country = NULL,
                                region = NULL) {
  ext <- "geojson"

  geturl <- gsc_api_url(
    id_giscoR = "countries",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = spatialtype,
    ext = ext,
    nuts_level = NULL,
    level = NULL,
    verbose = verbose
  )

  # Check if data is already available
  checkdata <- grep("CNTR_RG_20M_2016_4326", geturl$namefile)
  if (isFALSE(update_cache) & length(checkdata)) {
    dwnload <- FALSE
    data_sf <- giscoR::gisco_countries
    if (verbose) {
      message(
        "Loaded from gisco_countries dataset. Use update_cache = TRUE
    to load the shapefile from the .geojson file"
      )
    }
  } else {
    dwnload <- TRUE
  }
  if (dwnload) {
    # Speed up if requesting units
    if (!is.null(country) & spatialtype %in% c("RG", "LB")) {
      data_sf <- gisco_get_units(
        id_giscoR = "countries",
        unit = country,
        mode = "sf",
        year = year,
        epsg = epsg,
        cache = cache,
        cache_dir = cache_dir,
        update_cache = update_cache,
        verbose = verbose,
        resolution = resolution,
        spatialtype = spatialtype
      )
    } else {
      if (cache) {
        # Guess source to load
        namefileload <-
          gsc_api_cache(
            geturl$api_url,
            geturl$namefile,
            cache_dir,
            update_cache,
            verbose
          )
      } else {
        namefileload <- geturl$api_url
      }

      # Load - geojson only so far
      data_sf <-
        gsc_api_load(namefileload, epsg, ext, cache, verbose)
    }
  }

  if (!is.null(country) & "CNTR_ID" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_ID %in% country, ]
  }
  if (!is.null(region) & "CNTR_ID" %in% names(data_sf)) {
    region_df <- giscoR::gisco_countrycode
    cntryregion <- region_df[region_df$un.region.name %in% region, ]

    if ("EU" %in% region) {
      eu <- region_df[region_df$eu, ]
      cntryregion <- unique(rbind(cntryregion, eu))
    }

    data_sf <- data_sf[data_sf$CNTR_ID %in% cntryregion$CNTR_CODE, ]
  }

  return(data_sf)
}

#' @rdname gisco_get
#'
#' @param gisco_id Optional. A character vector of GISCO_ID LAU values.
#'
#' @export
gisco_get_lau <- function(year = "2016",
                          epsg = "4326",
                          cache = TRUE,
                          update_cache = FALSE,
                          cache_dir = NULL,
                          verbose = FALSE,
                          country = NULL,
                          gisco_id = NULL) {
  ext <- "geojson"

  geturl <- gsc_api_url(
    id_giscoR = "lau",
    year = year,
    epsg = epsg,
    resolution = 0,
    # Not neccesary
    spatialtype = "RG",
    ext = ext,
    nuts_level = NULL,
    level = NULL,
    verbose = verbose
  )

  # nocov start
  # There are not data file on this
  dwnload <- TRUE
  if (dwnload) {
    if (cache) {
      # Guess source to load
      namefileload <-
        gsc_api_cache(
          geturl$api_url,
          geturl$namefile,
          cache_dir,
          update_cache,
          verbose
        )
    } else {
      namefileload <- geturl$api_url
    }

    # Load - geojson only so far
    data_sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }

  if (!is.null(country) & "CNTR_CODE" %in% names(data_sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }

  if (!is.null(country) & "CNTR_ID" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_ID %in% country, ]
  }

  if (!is.null(gisco_id) & "GISCO_ID" %in% names(data_sf)) {
    data_sf <- data_sf[data_sf$GISCO_ID %in% gisco_id, ]
  }
  return(data_sf)
  # nocov end
}

#' @rdname gisco_get
#'
#' @param nuts_level NUTS level. One of "0" (Country-level), "1", "2" or "3".
#' See <https://ec.europa.eu/eurostat/web/nuts/background>.
#'
#' @param nuts_id Optional. A character vector of NUTS IDs.
#'
#' @details
#' # Release years available
#'
#' * **`gisco_get_nuts`**: one of "2003", "2006", "2010", "2013", "2016"
#' or "2021".
#'
#' @seealso [`gisco_nuts`]
#'
#' @export
#'
#' @examples
#'
#' ##########################
#' # Example - gisco_get_nuts
#' ##########################
#'
#' nuts1 <- gisco_get_nuts(
#'   resolution = "20",
#'   year = "2016",
#'   epsg = "4326",
#'   nuts_level = "1",
#'   country = "ITA"
#' )
#' nuts2 <- gisco_get_nuts(
#'   resolution = "20",
#'   year = "2016",
#'   epsg = "4326",
#'   nuts_level = "2",
#'   country = "ITA"
#' )
#' nuts3 <- gisco_get_nuts(
#'   resolution = "20",
#'   year = "2016",
#'   epsg = "4326",
#'   nuts_level = "3",
#'   country = "ITA"
#' )
#'
#' plot(st_geometry(nuts3),
#'   border = "grey60",
#'   lty = 3
#' )
#'
#' plot(st_geometry(nuts2),
#'   lwd = 2,
#'   border = "red2",
#'   add = TRUE
#' )
#'
#' plot(st_geometry(nuts1),
#'   lwd = 3,
#'   border = "springgreen4",
#'   add = TRUE
#' )
#'
#' box()
#' title(
#'   main = "NUTS Levels on Italy",
#'   sub = gisco_attributions(),
#'   cex.sub = 0.7,
#'   line = 1
#' )
#' legend(
#'   "topright",
#'   legend = c("NUTS 1", "NUTS 2", "NUTS 3"),
#'   col = c("springgreen4", "red2", "grey60"),
#'   lty = c(1, 1, 3),
#'   lwd = c(3, 2, 1),
#'   bty = "n",
#'   y.intersp = 2
#' )
gisco_get_nuts <- function(year = "2016",
                           epsg = "4326",
                           cache = TRUE,
                           update_cache = FALSE,
                           cache_dir = NULL,
                           verbose = FALSE,
                           resolution = "20",
                           spatialtype = "RG",
                           country = NULL,
                           nuts_id = NULL,
                           nuts_level = "all") {
  ext <- "geojson"

  nuts_level <- as.character(nuts_level)

  geturl <- gsc_api_url(
    id_giscoR = "nuts",
    year = year,
    epsg = epsg,
    resolution = resolution,
    spatialtype = spatialtype,
    ext = ext,
    nuts_level = nuts_level,
    level = NULL,
    verbose = verbose
  )

  # Check if data is already available
  checkdata <- grep("NUTS_RG_20M_2016_4326", geturl$namefile)
  if (isFALSE(update_cache) & length(checkdata)) {
    dwnload <- FALSE
    data_sf <- giscoR::gisco_nuts
    if (verbose) {
      message(
        "Loaded from gisco_nuts dataset. Use update_cache = TRUE to load",
        " the shapefile from the .geojson file"
      )
    }
    if (nuts_level %in% c("0", "1", "2", "3")) {
      data_sf <- data_sf[data_sf$LEVL_CODE == nuts_level, ]
    }
  } else {
    dwnload <- TRUE
  }
  if (dwnload) {
    # Speed up if requesting units
    if (!is.null(nuts_id) & spatialtype %in% c("RG", "LB")) {
      data_sf <- gisco_get_units(
        id_giscoR = "nuts",
        unit = nuts_id,
        mode = "sf",
        year = year,
        epsg = epsg,
        cache = cache,
        cache_dir = cache_dir,
        update_cache = update_cache,
        verbose = verbose,
        resolution = resolution,
        spatialtype = spatialtype
      )
    } else {
      if (cache) {
        # Guess source to load
        namefileload <-
          gsc_api_cache(
            geturl$api_url,
            geturl$namefile,
            cache_dir,
            update_cache,
            verbose
          )
      } else {
        namefileload <- geturl$api_url
      }

      # Load - geojson only so far
      data_sf <-
        gsc_api_load(namefileload, epsg, ext, cache, verbose)
    }
  }
  if (!is.null(country) & "CNTR_CODE" %in% names(data_sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }

  if (!is.null(nuts_id) & "NUTS_ID" %in% names(data_sf)) {
    data_sf <- data_sf[data_sf$NUTS_ID %in% nuts_id, ]
  }
  return(data_sf)
}

#' @rdname gisco_get
#'
#' @param level Level of Urban Audit. Possible values are "CITIES", "FUA",
#' "GREATER_CITIES" or `NULL`, that would download the full dataset.
#'
#' @details
#'
#' # Release years available
#'
#' * **`gisco_get_urban_audit`**: one of "2001", "2004", "2014", "2018"
#' or "2020".
#'
#' @export
gisco_get_urban_audit <- function(year = "2020",
                                  epsg = "4326",
                                  cache = TRUE,
                                  update_cache = FALSE,
                                  cache_dir = NULL,
                                  verbose = FALSE,
                                  spatialtype = "RG",
                                  country = NULL,
                                  level = NULL) {
  ext <- "geojson"

  geturl <- gsc_api_url(
    id_giscoR = "urban_audit",
    year = year,
    epsg = epsg,
    resolution = 0,
    # Not neccesary
    spatialtype = spatialtype,
    ext = ext,
    nuts_level = NULL,
    level = level,
    verbose = verbose
  )
  # There are not data file on this
  dwnload <- TRUE
  if (dwnload) {
    if (cache) {
      # Guess source to load
      namefileload <-
        gsc_api_cache(
          geturl$api_url,
          geturl$namefile,
          cache_dir,
          update_cache,
          verbose
        )
    } else {
      namefileload <- geturl$api_url
    }

    # Load - geojson only so far
    data_sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }

  if (!is.null(country) & "CNTR_CODE" %in% names(data_sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }
  return(data_sf)
}
