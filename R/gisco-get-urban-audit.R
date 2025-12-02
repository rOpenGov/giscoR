#' Urban Audit dataset
#'
#' @description
#' The dataset contains the boundaries of cities (`"CITIES"`), greater cities
#' (`"GREATER_CITIES"`) and functional urban areas (`"FUA"`) as defined
#' according to the EC-OECD city definition. This is used for the Eurostat Urban
#' Audit data collection.
#'
#' @family stats
#' @export
#' @inheritParams gisco_get_countries
#' @inheritSection gisco_get_countries Note
#' @inherit gisco_get_nuts source return
#'
#' @seealso
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' See [gisco_get_unit_urban_audit()] to download single files.
#'
#' @param year character string or number. Release year of the file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("urban_audit",
#'   "year",TRUE)}.
#'
#' @param spatialtype character string. Type of geometry to be returned. Options
#'   available are:
#'   * `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#'   * `"LB"`: Labels - `POINT` object.
#'
#' @param level character string. Level of Urban Audit. Possible values `"all"`
#'   (the default), that would download the full dataset or `"CITIES"`, `"FUA"`,
#'   and (for versions prior to `year = 2020`) `"GREATER_CITIES"`, `"CITY"`,
#'   `"KERN"` or `"LUZ"`.
#' @param ext character. Extension of the file (default `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("urban_audit",
#'   "ext",TRUE)}.
#'
#' @details
#' See more in
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(" [Eurostat - Statistics Explained]",
#' "(https://ec.europa.eu/eurostat/statistics-explained/index.php?",
#'         "title=Territorial_typologies_for_",
#'         "European_cities_and_metropolitan_regions)."))
#'
#' ```
#'
#' The cities are defined at several conceptual levels:
#'   - The core city (`"CITIES"`), using an administrative definition.
#'   - The Functional Urban Area/Large Urban Zone (`"FUA"`), approximating the
#'     functional urban region.
#' The coverage is the EU plus Iceland, Norway and Switzerland . The dataset
#' includes polygon features, point features and a related attribute table
#' which can be joined on the URAU code field.
#'
#' The `"URAU_CATG"` field defines the Urban Audit category:
#'   - `"C"` = City.
#'   - `"F"` = Functional Urban Area Service Type.
#'
#'
#' @examplesIf gisco_check_access()
#' cities <- gisco_get_urban_audit(year = 2021, level = "CITIES")
#'
#' if (!is.null(cities)) {
#'   bcn <- cities[cities$URAU_NAME == "Barcelona", ]
#'
#'   library(ggplot2)
#'   ggplot(bcn) +
#'     geom_sf()
#' }
gisco_get_urban_audit <- function(
  year = 2021,
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

  api_entry <- get_url_db(
    id = "urban_audit",
    year = year,
    epsg = epsg,
    spatialtype = spatialtype,
    ext = ext,
    level = level,
    fn = "gisco_get_urban_audit"
  )

  if (all(isFALSE(cache), ext != "shp")) {
    msg <- paste0("{.url ", api_entry, "}.")
    make_msg("info", verbose, "Reading from", msg)

    data_sf <- read_geo_file_sf(api_entry)
    if (!is.null(country) && "CNTR_CODE" %in% names(data_sf)) {
      country <- convert_country_code(country)
      data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
    }
    return(data_sf)
  }

  filename <- basename(api_entry)
  file_local <- download_url(
    api_entry,
    filename,
    cache_dir,
    "urban_audit",
    update_cache,
    verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun

  filter_col <- get_col_name(file_local)
  if (all(!is.null(country), !is.null(filter_col))) {
    make_msg("info", verbose, "Speed up using {.pkg sf} query")

    country <- convert_country_code(country)

    # Get layer name
    layer <- get_sf_layer_name(file_local)

    # Construct query
    q <- paste0(
      "SELECT * from \"",
      layer,
      "\" WHERE ",
      filter_col[1],
      " IN (",
      paste0("'", country, "'", collapse = ", "),
      ")"
    )

    msg <- paste0("{.code ", q, "}")
    make_msg("info", verbose, "Using query:\n   ", msg)

    data_sf <- read_geo_file_sf(file_local, q)
  } else {
    data_sf <- read_geo_file_sf(file_local)
  }

  data_sf
}
