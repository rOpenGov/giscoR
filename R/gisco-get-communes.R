#' @rdname gisco_get_lau
#' @name gisco_get_lau
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
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = "RG",
  country = NULL
) {
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "giscoR::gisco_get_lau(cache)",
      details = paste0(
        "Results are always cached. To avoid persistency use ",
        "`cache_dir = tempdir()`."
      )
    )
  }
  year <- as.character(year)

  url <- get_url_lau(
    "communes",
    year = year,
    epsg = epsg,
    ext = "shp",
    spatialtype = spatialtype
  )

  basename <- basename(url)

  file_local <- api_cache(
    url,
    basename,
    cache_dir = cache_dir,
    subdir = "communes",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun

  if (!is.null(country)) {
    make_msg("info", verbose, "Speed up using {.pkg sf} query")

    country <- gsc_helper_countrynames(country, "eurostat")

    # Get layer name
    layer <- sf::st_layers(file_local)
    layer <- layer[which.max(layer$features), ]$name

    # Construct query
    q <- paste0(
      "SELECT * from \"",
      layer,
      "\" WHERE CNTR_ID IN (",
      paste0("'", country, "'", collapse = ", "),
      ")"
    )

    msg <- paste0("{.code ", q, "}")
    make_msg("info", verbose, "Using query:\n   ", msg)

    data_sf <- try(
      suppressWarnings(
        read_shp_zip(file_local, q)
      ),
      silent = TRUE
    )
    if (inherits(data_sf, "try-error")) {
      make_msg(
        "danger",
        TRUE,
        "Problem with the query",
        "retrying without country filters."
      )
      data_sf <- read_shp_zip(file_local)
    } else {
      data_sf <- gsc_helper_utf8(data_sf)
    }
  } else {
    data_sf <- sf::read_sf(file_local)
  }

  data_sf
}
