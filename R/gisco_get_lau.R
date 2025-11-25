#' Get GISCO urban areas [`sf`][sf::st_sf] polygons, points and lines
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
#' @return A [`sf`][sf::st_sf] object specified by `spatialtype`. In the case of
#'   [gisco_get_lau()], a `POLYGON` object.
#'
#' @param year Release year of the file:
#'   - For `gisco_get_communes()` one of
#'     `r giscoR:::for_docs("communes", "year", decreasing = TRUE)`.
#'   - For `gisco_get_lau()` one of
#'     `r giscoR:::for_docs("lau", "year", decreasing = TRUE)`.
#'
#' @param epsg projection of the map: 4-digit [EPSG code](https://epsg.io/).
#'  One of:
#'  * `"4326"`: WGS84
#'  * `"3035"`: ETRS89 / ETRS-LAEA
#'  * `"3857"`: Pseudo-Mercator
#'
#' @param cache `r lifecycle::badge('deprecated')`. These functions always
#'   caches the result due to the size. `cache_dir` can be set to
#'  [base::tempdir()], so the file would be deleted when the **R** session is
#'  closed.
#' @param gisco_id Optional. A character vector of GISCO_ID LAU values.
#'
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#'
#'
#' @export
gisco_get_lau <- function(
  year = "2024",
  epsg = "4326",
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL,
  gisco_id = NULL
) {
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "gisco_get_lau(cache)",
      details = paste0(
        "Results are always cached. To avoid persistency use ",
        "`cache_dir = tempdir()`."
      )
    )
  }
  year <- as.character(year)

  url <- get_url_lau("lau", year, epsg, ext = "gpkg", "RG", "gisco_get_lau")

  basename <- basename(url)

  file_local <- api_cache(
    url,
    basename,
    cache_dir = cache_dir,
    subdir = "lau",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun

  if (any(!is.null(country), !is.null(gisco_id))) {
    make_msg("info", verbose, "Speed up using {.pkg sf} query")
    if (!is.null(country)) {
      country <- gsc_helper_countrynames(country, "eurostat")
    }

    # Get layer name
    layer <- sf::st_layers(file_local)
    layer <- layer[which.max(layer$features), ]$name

    # Construct query
    q <- paste0("SELECT * from \"", layer, "\" WHERE")

    where <- NULL

    if (!is.null(country)) {
      where <- c(
        where,
        paste0(
          "CNTR_CODE IN (",
          paste0("'", country, "'", collapse = ", "),
          ")"
        )
      )
    }

    if (!is.null(gisco_id)) {
      where <- c(
        where,
        paste0(
          "GISCO_ID IN (",
          paste0("'", gisco_id, "'", collapse = ", "),
          ")"
        )
      )
    }

    where <- paste(where, collapse = " OR ")
    q <- paste(q, where)

    msg <- paste0("{.code ", q, "}")
    make_msg("info", verbose, "Using query:\n   ", msg)
    data_sf <- sf::read_sf(file_local, query = q)
  } else {
    data_sf <- sf::read_sf(file_local)
  }

  data_sf <- gsc_helper_utf8(data_sf)
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
gisco_get_communes <- function(
  year = "2016",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = "RG",
  country = NULL
) {
  ext <- "geojson"

  api_entry <- gsc_api_url(
    id_giscoR = "communes",
    year = year,
    epsg = epsg,
    resolution = 0,
    # Not needed
    spatialtype = spatialtype,
    ext = ext,
    nuts_level = NULL,
    level = NULL,
    verbose = verbose
  )

  filename <- basename(api_entry)

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun

  if (cache && !is.null(country)) {
    gsc_message(verbose, "Speed up using sf query")
    country <- gsc_helper_countrynames(country, "eurostat")
    namefileload <- gsc_api_cache(
      api_entry,
      filename,
      cache_dir,
      update_cache,
      verbose
    )

    if (is.null(namefileload)) {
      return(NULL)
    }

    # Get layer name
    layer <- tools::file_path_sans_ext(basename(namefileload))

    # Construct query
    q <- paste0(
      "SELECT * from \"",
      layer,
      "\" WHERE CNTR_CODE IN (",
      paste0("'", country, "'", collapse = ", "),
      ")"
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
      data_sf <- gsc_helper_utf8(data_sf)
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
      api_entry,
      filename,
      cache_dir,
      update_cache,
      verbose
    )
  } else {
    namefileload <- api_entry
  }

  if (is.null(namefileload)) {
    return(NULL)
  }

  # Load - geojson only so far
  data_sf <- gsc_api_load(namefileload, epsg, ext, cache, verbose)
  data_sf <- gsc_helper_utf8(data_sf)

  return(data_sf)
}

get_url_lau <- function(
  id = "lau",
  year = 2024,
  epsg = 4326,
  ext = "gpkg",
  spatialtype = "RG",
  fn = "gisco_get_lau"
) {
  db <- gisco_get_latest_db()
  db <- db[db$id_giscoR == id, ]
  years <- sort(unique(db$year)) # nolint

  if (!year %in% db$year) {
    cli::cli_abort(
      paste0(
        "Years available for {.fn giscoR::",
        fn,
        "} are ",
        "{.str {years}}."
      )
    )
  }

  db <- db[db$year == year, ]
  db <- db[db$ext == ext, ]

  valid_epsg <- sort(unique(db$epsg)) # nolint

  if (!epsg %in% db$epsg) {
    cli::cli_abort(
      paste0(
        "{.arg epsg} available for {.fn giscoR::",
        fn,
        "} ",
        "are {.str {valid_epsg}}."
      )
    )
  }
  db <- db[db$epsg == epsg, ]

  valid_spatialtypes <- sort(unique(db$spatialtype)) # nolint
  lnt <- length(valid_spatialtypes) # nolint
  if (!spatialtype %in% db$spatialtype) {
    cli::cli_abort(
      paste0(
        "{.arg spatialtype} available for {.fn giscoR::",
        fn,
        "} ",
        "{qty(lnt)} {?is/are} {.str {valid_spatialtypes}}."
      )
    )
  }
  db <- db[db$spatialtype == spatialtype, ]
  if (nrow(db) == 0) {
    valid_args <- c("year", "epsg", "spatialtype") # nolint
    cli::cli_abort(
      paste0(
        "This combination of {.arg {valid_args}} ",
        "is currently not available for {.fn giscoR::",
        fn,
        "}."
      )
    )
  }

  url <- paste0(db$api_entry, "/", db$api_file)

  url
}
