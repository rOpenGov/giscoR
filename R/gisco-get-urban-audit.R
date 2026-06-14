#' Urban Audit dataset
#'
#' @description
#' This dataset contains the boundaries of cities (`"CITIES"`), greater cities
#' (`"GREATER_CITIES"`) and functional urban areas (`"FUA"`) defined according
#' to the EC-OECD city definition. It is used for the Eurostat Urban Audit data
#' collection.
#'
#' Downloads data from the aggregated GISCO Urban Audit file. To download
#' single-unit Urban Audit files, use [gisco_get_unit_urban_audit()].
#'
#' @family stats
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("urban_audit",
#'   "year",TRUE)}.
#'
#' @param spatialtype A character string with the type of geometry to return.
#'   Options available are:
#' - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#' - `"LB"`: Labels - `POINT` object.
#'
#' @param level A character string with the Urban Audit level. Possible values
#'   are `"all"` (the default), which downloads the full dataset, `"CITIES"`,
#'   `"FUA"` and, for versions prior to `year = 2020`, `"GREATER_CITIES"`,
#'   `"CITY"`, `"KERN"` or `"LUZ"`.
#' @param ext A character value with the extension of the file (default
#'   `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("urban_audit",
#'   "ext",TRUE)}.
#'
#' @inherit gisco_get_nuts return
#' @details
#' For more information, see:
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(" [Eurostat - Statistics Explained]",
#' "(https://ec.europa.eu/eurostat/statistics-explained/index.php?",
#'         "title=Territorial_typologies_for_",
#'         "European_cities_and_metropolitan_regions)."))
#'
#' ```
#'
#' Cities are defined at several conceptual levels:
#' - The core city (`"CITIES"`), using an administrative definition.
#' - The Functional Urban Area/Large Urban Zone (`"FUA"`), approximating the
#'     functional urban region.
#' Coverage includes the EU, Iceland, Norway and Switzerland. The dataset
#' includes polygon features, point features and a related attribute table
#' which can be joined on the URAU code field.
#'
#' The `"URAU_CATG"` field defines the Urban Audit category:
#' - `"C"` = City.
#' - `"F"` = Functional urban area service type.
#'
#' @inheritSection gisco_get_countries Note
#' @inherit gisco_get_nuts source
#' @seealso
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' See [gisco_get_unit_urban_audit()] to download single-unit files.
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#'
#' cities <- gisco_get_urban_audit(year = 2024, level = "CITIES")
#'
#' if (!is.null(cities)) {
#'   bcn <- cities[cities$URAU_NAME == "Barcelona", ]
#'
#'   library(ggplot2)
#'   ggplot(bcn) +
#'     geom_sf()
#' }
#' }
#' @export
gisco_get_urban_audit <- function(
  year = 2024,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = c("RG", "LB"),
  country = NULL,
  level = c("all", "CITIES", "FUA", "GREATER_CITIES", "CITY", "KERN", "LUZ"),
  ext = "gpkg"
) {
  if (is.null(level)) {
    level <- "all"
  }

  valid_ext <- db_values("urban_audit", "ext", formatted = FALSE)

  ext <- match_arg_pretty(ext, valid_ext)
  level <- match_arg_pretty(level)
  spatialtype <- match_arg_pretty(spatialtype)

  file <- resolve_gisco_file(
    id = "urban_audit",
    year = year,
    epsg = epsg,
    spatialtype = spatialtype,
    ext = ext,
    level = level,
    fn = "gisco_get_urban_audit"
  )

  country <- convert_country_code_or_null(country)

  read_gisco_dataset(
    url = file$url,
    name = file$name,
    cache = cache,
    cache_dir = cache_dir,
    subdir = "urban_audit",
    update_cache = update_cache,
    verbose = verbose,
    filters = function(file_local) {
      make_sf_filter(file_local, country)
    },
    post_process = function(data_sf) {
      if (!is.null(country) && "CNTR_CODE" %in% names(data_sf)) {
        data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
      }
      data_sf
    }
  )
}
