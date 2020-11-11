#' @title Get geospatial data from GISCO API
#' @name gisco_get
#' @description Loads a simple feature (\code{sf}) object from GISCO API entry point or your local library.
#' @param year Release year. See Details.
#' @param epsg projection of the map: 4-digit \href{https://epsg.io/}{EPSG code}. One of:
#' \itemize{
#' \item \code{"4326"} - \href{https://epsg.io/4326}{WGS84}
#' \item \code{"3035"} - \href{https://epsg.io/3035}{ETRS89 / ETRS-LAEA}
#' \item \code{"3857"} - \href{https://epsg.io/3857}{Pseudo-Mercator}
#' }
#' @param cache a logical whether to do caching. Default is \code{TRUE}.
#' @param update_cache a logical whether to update cache. Default is \code{FALSE}. When set to \code{TRUE} it would force a fresh download of the source \code{.geojson} file.
#' @param cache_dir a path to a cache directory. The directory have to exist.  The \code{NULL} (default) uses and creates \code{/gisco} directory in the temporary directory from \code{\link{tempdir}}. The directory can also be set with \code{options(gisco_cache_dir = "path/to/dir")}.
#' @param verbose Display information. Useful for debugging, default if \code{FALSE}.
#' @param resolution Resolution of the geospatial data. One of
#' \itemize{
#'    \item \code{"60"} (1:60million),
#'    \item \code{"20"} (1:20million)
#'    \item \code{"10"} (1:10million)
#'    \item \code{"03"} (1:3million) or
#'    \item \code{"01"} (1:1million).
#'    }
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/}{GISCO API}
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @details \code{country} only available on specific datasets. Some \code{spatialtype} options (as \code{BN, COASTL, INLAND}) may not present country-level identifies.
#'
#' \code{country} could be either a vector of country names, a vector of ISO3 country codes or a vector of Eurostat country codes. Mixed types (as \code{c("Turkey","US","FRA")}) would not work.
#'
#' Sometimes cached files may be corrupt. On that case, try redownloading the data setting \code{update_cache = TRUE}.
#'
#' If you experience any problem on download, try to download the corresponding \code{.geojson} file by any other method and set \code{cache_dir = "path/to/dir"} or \code{options(gisco_cache_dir = "path/to/dir)"}.
#'
#' For a complete list of files available check
#' \link{gisco_db}.
#'
#'\strong{Release years available}
#'
#' \code{gisco_get_coastallines}: one of \code{"2006", "2010", "2013"} or \code{"2016"}.
#' @return \code{gisco_get_coastallines} returns a \code{POLYGON} object.
#' @note Please check the download and usage provisions on \link{gisco_attributions}.
#' @examples
#' library(sf)
#'
#' ##################################
#' # Example - gisco_get_coastallines
#' ##################################
#'
#' coastlines <- gisco_get_coastallines()
#' plot(st_geometry(coastlines), col = "palegreen", border = "lightblue3")
#' title(main = "Coastal Lines",
#'       sub = gisco_attributions(),
#'       line = 1)
#'
#' @seealso \link{gisco_db}, \link{gisco_attributions}, \link{gisco_coastallines}
#' @export
gisco_get_coastallines <- function(year = "2016",
                                   epsg = "4326",
                                   cache = TRUE,
                                   update_cache = FALSE,
                                   cache_dir = NULL,
                                   verbose = FALSE,
                                   resolution = "20") {
  ext <- "geojson"

  geturl <-   gsc_api_url(
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
    data.sf <- giscoR::gisco_coastallines
    if (verbose)
      message(
        "Loaded from gisco_coastallines dataset. Use update_cache = TRUE to load the shapefile from the .geojson file"
      )
  } else {
    dwnload <- TRUE
  }
  if (dwnload) {
    if (cache) {
      # Guess source to load
      namefileload <-
        gsc_api_cache(geturl$api.url,
                      geturl$namefile,
                      cache_dir,
                      update_cache,
                      verbose)
    } else {
      namefileload <- geturl$api.url
    }

    # Load - geojson only so far
    data.sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }
  return(data.sf)
}

#' @rdname gisco_get
#' @param spatialtype Type of geometry to be returned:
#' \itemize{
#'  \item \code{"RG"}: Regions - \code{MULTIPOLYGON/POLYGON} object.
#'  \item \code{"LB"}: Labels - \code{POINT} object.
#'  \item \code{"BN"}: Boundaries - \code{LINESTRING} object.
#'  \item \code{"COASTL"}: coastlines - \code{LINESTRING} object.
#'  \item \code{"INLAND"}: inland boundaries - \code{LINESTRING} object.
#' }
#' @param country Optional. A character vector of country codes. See Details.
#' @details \code{gisco_get_communes}: one of \code{"2001", "2004", "2006", "2008", "2010", "2013"} or \code{"2016"}.
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

  geturl <-   gsc_api_url(
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
        gsc_api_cache(geturl$api.url,
                      geturl$namefile,
                      cache_dir,
                      update_cache,
                      verbose)
    } else {
      namefileload <- geturl$api.url
    }

    # Load - geojson only so far
    data.sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }

  if (!is.null(country) & "CNTR_CODE" %in% names(data.sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data.sf <- data.sf[data.sf$CNTR_CODE %in% country, ]
  }
  return(data.sf)
}

#' @rdname gisco_get
#' @param region Optional. A character vector of UN M49 region codes. Possible values are "Africa", "Americas", "Asia", "Europe", "Oceania". See Details and \link{gisco_countrycode}
#' @details \code{gisco_get_countries}: one of \code{"2001", "2006", "2010", "2013", "2016"} or \code{"2020"}.
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
#' sf_africa <- gisco_get_countries(region = 'Africa')
#' plot(st_geometry(sf_africa),
#'      col = c("springgreen4", "darkgoldenrod1", "red2"))
#' title(sub = gisco_attributions(), line = 1)
#'
#' sf_benelux <-
#'   gisco_get_countries(country = c('Belgium', 'Netherlands', 'Luxembourg'))
#' plot(st_geometry(sf_benelux),
#'      col = c("grey10", "orange", "deepskyblue2"))
#' title(sub = gisco_attributions(), line = 1)
#' @seealso \link{gisco_countrycode}, \link{gisco_countries}
#' @export
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

  geturl <-   gsc_api_url(
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
    data.sf <- giscoR::gisco_countries
    if (verbose)
      message(
        "Loaded from gisco_countries dataset. Use update_cache = TRUE to load the shapefile from the .geojson file"
      )
  } else {
    dwnload <- TRUE
  }
  if (dwnload) {
    # Speed up if requesting units
    if (!is.null(country) & spatialtype %in% c("RG", "LB")) {
      data.sf <- gisco_get_units(
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
          gsc_api_cache(geturl$api.url,
                        geturl$namefile,
                        cache_dir,
                        update_cache,
                        verbose)
      } else {
        namefileload <- geturl$api.url
      }

      # Load - geojson only so far
      data.sf <-
        gsc_api_load(namefileload, epsg, ext, cache, verbose)
    }
  }

  if (!is.null(country) & "CNTR_ID" %in% names(data.sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data.sf <- data.sf[data.sf$CNTR_ID %in% country, ]
  }
  if (!is.null(region) & "CNTR_ID" %in% names(data.sf)) {
    region.df <- giscoR::gisco_countrycode
    region.df <- region.df[region.df$un.region.name %in% region, ]
    data.sf <- data.sf[data.sf$CNTR_ID %in% region.df$CNTR_CODE, ]
  }

  return(data.sf)
}

#' @rdname gisco_get
#' @param gisco_id Optional. A character vector of GISCO_ID LAU values.
#' @details \code{gisco_get_lau}: one of \code{"2016", "2017", "2018"} or \code{"2019"}.
#' @return \code{gisco_get_lau} returns a \code{POLYGON} object.
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

  geturl <-   gsc_api_url(
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
        gsc_api_cache(geturl$api.url,
                      geturl$namefile,
                      cache_dir,
                      update_cache,
                      verbose)
    } else {
      namefileload <- geturl$api.url
    }

    # Load - geojson only so far
    data.sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }

  if (!is.null(country) & "CNTR_CODE" %in% names(data.sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data.sf <- data.sf[data.sf$CNTR_CODE %in% country,]
  }
  
  if (!is.null(country) & "CNTR_ID" %in% names(data.sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data.sf <- data.sf[data.sf$CNTR_ID %in% country, ]
  }
  
  if (!is.null(gisco_id) & "GISCO_ID" %in% names(data.sf)) {
    data.sf <- data.sf[data.sf$GISCO_ID %in% gisco_id,]
  }
  return(data.sf)
  # nocov end
}

#' @rdname gisco_get
#' @param nuts_level NUTS level. One of \code{"0"} (Country-level), \code{"1", "2"} or \code{"3"}. See \url{https://ec.europa.eu/eurostat/web/nuts/background}.
#' @param nuts_id Optional. A character vector of NUTS IDs.
#' @details \code{gisco_get_nuts}: one of \code{"2003", "2006", "2010", "2013", "2016"} or \code{"2021"}.
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
#'      border = "grey60",
#'      lty = 3)
#'
#' plot(st_geometry(nuts2),
#'      lwd = 2,
#'      border = "red2",
#'      add = TRUE)
#'
#' plot(st_geometry(nuts1),
#'      lwd = 3,
#'      border = "springgreen4",
#'      add = TRUE)
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
#' @seealso \link{gisco_nuts}
#' @export
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

  geturl <-   gsc_api_url(
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
    data.sf <- giscoR::gisco_nuts
    if (verbose)
      message(
        "Loaded from gisco_nuts dataset. Use update_cache = TRUE to load the shapefile from the .geojson file"
      )
    if (nuts_level %in% c('0', '1', '2', '3')) {
      data.sf <- data.sf[data.sf$LEVL_CODE == nuts_level,]
    }
  } else {
    dwnload <- TRUE
  }
  if (dwnload) {
    # Speed up if requesting units
    if (!is.null(nuts_id) & spatialtype %in% c("RG", "LB")) {
      data.sf <- gisco_get_units(
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
          gsc_api_cache(geturl$api.url,
                        geturl$namefile,
                        cache_dir,
                        update_cache,
                        verbose)
      } else {
        namefileload <- geturl$api.url
      }

      # Load - geojson only so far
      data.sf <-
        gsc_api_load(namefileload, epsg, ext, cache, verbose)
    }
  }
  if (!is.null(country) & "CNTR_CODE" %in% names(data.sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data.sf <- data.sf[data.sf$CNTR_CODE %in% country,]
  }

  if (!is.null(nuts_id) & "NUTS_ID" %in% names(data.sf)) {
    data.sf <- data.sf[data.sf$NUTS_ID %in% nuts_id,]
  }
  return(data.sf)
}

#' @rdname gisco_get
#' @param level Level of Urban Audit. Possible values are \code{"CITIES", "FUA", "GREATER_CITIES"} or \code{NULL}. \code{NULL} would download the full dataset.
#' @details \code{gisco_get_urban_audit}: one of \code{"2001", "2004", "2014", "2018"} or \code{"2020"}.
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

  geturl <-   gsc_api_url(
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
        gsc_api_cache(geturl$api.url,
                      geturl$namefile,
                      cache_dir,
                      update_cache,
                      verbose)
    } else {
      namefileload <- geturl$api.url
    }

    # Load - geojson only so far
    data.sf <-
      gsc_api_load(namefileload, epsg, ext, cache, verbose)
  }

  if (!is.null(country) & "CNTR_CODE" %in% names(data.sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data.sf <- data.sf[data.sf$CNTR_CODE %in% country,]
  }
  return(data.sf)
}
