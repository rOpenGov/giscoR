#' Get GISCO greater cities and metropolitan areas [`sf`][sf::st_sf] objects
#'
#' @description
#' Returns polygons and points corresponding to cities, greater cities and
#' metropolitan areas included on the
#' [Urban Audit report](https://ec.europa.eu/eurostat/web/regions-and-cities)
#' of Eurostat.
#'
#' @family political
#'
#' @return A [`sf`][sf::st_sf] object specified by `spatialtype`.
#'
#' @param year Release year of the file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("urban_audit",
#'   "year",TRUE)}`.
#'
#' @param spatialtype Type of geometry to be returned:
#'  * `"LB"`: Labels - `POINT` object.
#'  * `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#'
#' @param level Level of Urban Audit. Possible values are `"CITIES"`, `"FUA"`,
#' `"GREATER_CITIES"` or `NULL`, that would download the full dataset.
#'
#' @inheritParams gisco_get_countries
#'
#' @inheritSection gisco_get_countries About caching
#' @inherit gisco_get_countries source
#'
#'
#' @seealso [gisco_get_communes()], [gisco_get_lau()]
#'
#' @export
#'
#' @note
#' Please check the download and usage provisions on [gisco_attributions()].
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#' cities <- gisco_get_urban_audit(year = "2020", level = "CITIES")
#'
#' if (!is.null(cities)) {
#'   bcn <- cities[cities$URAU_NAME == "Barcelona", ]
#'
#'   library(ggplot2)
#'   ggplot(bcn) +
#'     geom_sf()
#' }
#' }
gisco_get_urban_audit <- function(
  year = "2021",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = "RG",
  country = NULL,
  level = NULL
) {
  if (is.null(level)) {
    level <- "all"
  }
  api_entry <- get_url_db(
    id = "urban_audit",
    year = year,
    epsg = epsg,
    spatialtype = spatialtype,
    ext = "gpkg",
    level = level,
    fn = "gisco_get_urban_audit"
  )

  if (!cache) {
    msg <- paste0("{.url ", api_entry, "}.")
    make_msg("info", verbose, "Reading from", msg)

    data_sf <- read_geo_file_sf(api_entry)
  } else {
    filename <- basename(api_entry)
    namefileload <- load_url(
      api_entry,
      filename,
      cache_dir,
      "urban_audit",
      update_cache,
      verbose
    )

    if (is.null(namefileload)) {
      return(NULL)
    }
    data_sf <- read_geo_file_sf(namefileload)
  }

  if (!is.null(country) && "CNTR_CODE" %in% names(data_sf)) {
    # Convert ISO3 to EUROSTAT thanks to Vincent Arel-Bundock (countrycode)
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }
  data_sf
}
