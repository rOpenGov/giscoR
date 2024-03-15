#' Get GISCO urban areas \CRANpkg{sf} polygons, points and lines
#'
#' @description
#' [gisco_get_communes()] and [gisco_get_lau()] download shapes of Local
#' Urban Areas, that correspond roughly with towns and cities.
#'
#' @order 2
#'
#' @note
#' Please check the download and usage provisions on [gisco_attributions()].
#' @family political
#'
#' @return A \CRANpkg{sf} object specified by `spatialtype`. In the case of
#'   [gisco_get_lau()], a `POLYGON` object.
#'
#' @param year Release year of the file:
#'   - For `gisco_get_communes()` one of `r gsc_helper_year_docs("communes")`.
#'   - For `gisco_get_lau()` one of `r gsc_helper_year_docs("lau")`.
#'
#' @param gisco_id Optional. A character vector of GISCO_ID LAU values.
#'
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#'
#'
#' @export
gisco_get_lau <- function(year = "2016", epsg = "4326", cache = TRUE,
                          update_cache = FALSE, cache_dir = NULL,
                          verbose = FALSE, country = NULL, gisco_id = NULL) {
  ext <- "geojson"

  api_entry <- gsc_api_url(
    id_giscoR = "lau", year = year, epsg = epsg,
    resolution = 0, spatialtype = "RG", ext = ext, nuts_level = NULL,
    level = NULL, verbose = verbose
  )

  filename <- basename(api_entry)
  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun


  if ((!is.null(country) || !is.null(gisco_id)) && cache) {
    gsc_message(verbose, "Speed up using sf query")
    if (!is.null(country)) {
      country <- gsc_helper_countrynames(country, "eurostat")
    }

    namefileload <- gsc_api_cache(
      api_entry, filename, cache_dir, update_cache,
      verbose
    )

    if (is.null(namefileload)) {
      return(NULL)
    }

    # Get layer name
    layer <- tools::file_path_sans_ext(basename(namefileload))

    # Construct query
    q <- paste0("SELECT * from \"", layer, "\" WHERE")

    where <- NULL

    if (!is.null(country)) {
      where <- c(where, paste0(
        "CNTR_CODE IN (",
        paste0("'", country, "'", collapse = ", "),
        ")"
      ))
    }

    if (!is.null(gisco_id)) {
      where <- c(where, paste0(
        "GISCO_ID IN (",
        paste0("'", gisco_id, "'", collapse = ", "),
        ")"
      ))
    }

    where <- paste(where, collapse = " OR ")
    q <- paste(q, where)

    gsc_message(verbose, "Using query:\n   ", q)


    data_sf <- try(
      suppressWarnings(sf::st_read(namefileload,
        quiet = !verbose, query = q
      )),
      silent = TRUE
    )

    # If everything was fine then output
    if (!inherits(data_sf, "try-error")) {
      data_sf <- sf::st_make_valid(data_sf)
      return(data_sf)
    }

    # If not don't update cache (was already updated) and continue
    update_cache <- FALSE
    rm(data_sf)
    gsc_message(
      TRUE,
      "\n\nIt was a problem with the query.",
      "Retrying without country filters\n\n"
    )
  }

  if (cache) {
    # Guess source to load
    namefileload <- gsc_api_cache(
      api_entry, filename, cache_dir,
      update_cache, verbose
    )
  } else {
    namefileload <- api_entry
  }

  if (is.null(namefileload)) {
    return(NULL)
  }

  # Load - geojson only so far
  data_sf <- gsc_api_load(namefileload, epsg, ext, cache, verbose)

  if (!is.null(country) && "CNTR_CODE" %in% names(data_sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }

  if (!is.null(country) && "CNTR_ID" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_ID %in% country, ]
  }

  if (!is.null(gisco_id) && "GISCO_ID" %in% names(data_sf)) {
    data_sf <- data_sf[data_sf$GISCO_ID %in% gisco_id, ]
  }
  return(data_sf)
}


#' @rdname gisco_get_lau
#' @name gisco_get_lau
#'
#' @order 1
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#'
#' ire_lau <- gisco_get_communes(spatialtype = "LB", country = "Ireland")
#'
#' if (!is.null(ire_lau)) {
#'   library(ggplot2)
#'
#'   ggplot(ire_lau) +
#'     geom_sf(shape = 21, col = "#009A44", size = 0.5) +
#'     labs(
#'       title = "Communes in Ireland",
#'       subtitle = "Year 2016",
#'       caption = gisco_attributions()
#'     ) +
#'     theme_void() +
#'     theme(text = element_text(
#'       colour = "#009A44",
#'       family = "serif", face = "bold"
#'     ))
#' }
#' }
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

  api_entry <- gsc_api_url(
    id_giscoR = "communes", year = year,
    epsg = epsg, resolution = 0,
    # Not needed
    spatialtype = spatialtype, ext = ext, nuts_level = NULL,
    level = NULL, verbose = verbose
  )


  filename <- basename(api_entry)

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun

  if (cache && !is.null(country)) {
    gsc_message(verbose, "Speed up using sf query")
    country <- gsc_helper_countrynames(country, "eurostat")
    namefileload <- gsc_api_cache(
      api_entry, filename,
      cache_dir, update_cache, verbose
    )

    if (is.null(namefileload)) {
      return(NULL)
    }

    # Get layer name
    layer <- tools::file_path_sans_ext(basename(namefileload))

    # Construct query
    q <- paste0(
      "SELECT * from \"", layer, "\" WHERE CNTR_CODE IN (",
      paste0("'", country, "'", collapse = ", "), ")"
    )

    gsc_message(verbose, "Using query:\n   ", q)


    data_sf <- try(
      suppressWarnings(
        sf::st_read(namefileload, quiet = !verbose, query = q)
      ),
      silent = TRUE
    )

    # If everything was fine then output
    if (!inherits(data_sf, "try-error")) {
      data_sf <- sf::st_make_valid(data_sf)
      return(data_sf)
    }

    # If not don't update cache (was already updated) and continue
    update_cache <- FALSE
    rm(data_sf)
    gsc_message(
      TRUE,
      "\n\nIt was a problem with the query.",
      "Retrying without country filters\n\n"
    )
  }




  if (cache) {
    # Guess source to load
    namefileload <- gsc_api_cache(
      api_entry, filename,
      cache_dir, update_cache, verbose
    )
  } else {
    namefileload <- api_entry
  }

  if (is.null(namefileload)) {
    return(NULL)
  }

  # Load - geojson only so far
  data_sf <- gsc_api_load(namefileload, epsg, ext, cache, verbose)


  return(data_sf)
}
