#' Postal codes
#'
#' @description
#' The postal code point dataset shows the location of postal codes, NUTS codes
#' and the Degree of Urbanisation classification across the EU, EFTA and
#' candidate countries from a variety of sources. Its primary purpose is to
#' create correspondence tables for the NUTS classification (EC) 1059/2003 as
#' part of the Tercet Regulation (EU) 2017/2391.
#'
#' @family admin
#' @export
#'
#' @param year character string or number. Release year of the file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("postalcodes",
#'   "year",TRUE)}.
#'
#' @inheritParams gisco_get_countries
#' @inherit gisco_get_countries source return
#'
#' @encoding UTF-8
#'
#' @details
#' # Copyright
#'
#' The dataset is released under the CC-BY-SA-4.0 licence and requires the
#' following attribution whenever used:
#'
#'
#' ```{r, echo=FALSE, results='asis'}
#' cat("")
#' cat("\u00a9 European Union - GISCO, 2024, postal code point dataset,",
#' "Licence CC-BY-SA 4.0.")
#'
#' ```
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

  url <- get_url_db(
    "postalcodes",
    year = year,
    ext = "gpkg",
    fn = "gisco_get_postalcodes"
  )
  filename <- basename(url)

  file_local <- load_url(
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
    country <- get_country_code(country)

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
    data_sf <- read_geo_file_sf(file_local, query = q)
    return(data_sf)
  }

  # If not read the whole file
  data_sf <- read_geo_file_sf(file_local)

  data_sf
}
