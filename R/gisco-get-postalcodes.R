#' Get postal code points from GISCO
#'
#' Get postal codes points of the EU, EFTA and candidate countries.
#'
#' @param year Year of reference. one of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("postalcodes",
#'   "year",TRUE)}.
#'
#' @inheritParams gisco_get_countries
#' @inheritSection gisco_get_countries About caching
#' @inherit gisco_get_countries source
#'
#' @family political
#'
#' @return A `POINT` [`sf`][sf::st_sf] object on EPSG:4326.
#'
#' @export
#'
#' @details
#' The postal code point dataset shows the location of postal codes, NUTS codes
#' and the Degree of Urbanisation classification across the EU, EFTA and
#' candidate countries from a variety of sources. Its primary purpose is to
#' create correspondence tables for the NUTS classification (EC) 1059/2003 as
#' part of the Tercet Regulation (EU) 2017/2391
#'
#' # Copyright
#'
#' The dataset is released under the CC-BY-SA-4.0 licence and requires the
#' following attribution whenever used:
#'
#' *(c) European Union - GISCO, 2024, postal code point dataset, Licence
#' CC-BY-SA 4.0 available at
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(
#'   paste0(" <https://ec.europa.eu/eurostat/web/gisco/geodata",
#'       "//administrative-units/postal-codes>*.")
#'    )
#'
#' ```
#'
#'
#'
#' @examplesIf gisco_check_access()
#'
#' # Heavy-weight download!
#' \dontrun{
#'
#' pc_bel <- gisco_get_postalcodes(country = "BE")
#'
#' if (!is.null(pc_bel)) {
#'   library(ggplot2)
#'
#'   ggplot(pc_bel) +
#'     geom_sf(color = "gold") +
#'     theme_bw() +
#'     labs(
#'       title = "Postcodes of Belgium",
#'       subtitle = "2024",
#'       caption = paste("(c) European Union - GISCO, 2024,",
#'         "postal code point dataset",
#'         "Licence CC-BY-SA 4.0",
#'         sep = "\n"
#'       )
#'     )
#' }
#' }
gisco_get_postalcodes <- function(
  year = "2024",
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
) {
  year <- as.character(year)

  url <- get_url_postcodes(year)
  filename <- basename(url)

  file_local <- api_cache(
    url = url,
    name = filename,
    cache_dir = cache_dir,
    subdir = "postalcodes",
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
    data_sf <- sf::read_sf(file_local, query = q)
    data_sf <- gsc_helper_utf8(data_sf)
    return(data_sf)
  }

  # If not read the whole file
  data_sf <- sf::read_sf(file_local)
  data_sf <- gsc_helper_utf8(data_sf)

  data_sf
}


get_url_postcodes <- function(year = 2024, epsg = 4326, ext = "gpkg") {
  db <- gisco_get_latest_db()
  db <- db[db$id_giscoR == "postalcodes", ]
  years <- sort(unique(db$year)) # nolint

  if (!year %in% db$year) {
    cli::cli_abort(
      paste0(
        "Years available for {.fn giscoR::gisco_get_postalcodes} are ",
        "{.str {years}}."
      )
    )
  }

  db <- db[db$year == year, ]
  db <- db[db$ext == ext, ]
  db <- db[db$epsg == epsg, ]
  url <- paste0(db$api_entry, "/", db$api_file)

  url
}
