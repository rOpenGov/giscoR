#' Census data
#'
#' This data set shows pan European communal boundaries depicting the situation
#' at the corresponding Census.
#'
#' @family stats
#' @export
#'
#' @param year Year of reference. Currently only `"2011"` is supported
#' @param spatialtype Type of geometry to be returned:
#'  * `"PT"`: Points - `POINT` object.
#'  * `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.
#' @inheritParams gisco_get_countries
#' @inherit gisco_get_countries return
#'
#' @source
#'
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units/census>
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#' library(sf)
#'
#' pts <- gisco_get_census(spatialtype = "PT")
#'
#' pts
#' }
gisco_get_census <- function(
  year = "2011",
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  spatialtype = c("RG", "PT")
) {
  year <- as.character(year)
  year <- match.arg(year)

  spatialtype <- match.arg(spatialtype)
  if (spatialtype == "PT") {
    url <- paste0(
      "https://ec.europa.eu/eurostat/cache/GISCO/",
      "geodatafiles/CENSUS_UNITS_PT_2011_SH.zip"
    )
  } else {
    url <- paste0(
      "https://ec.europa.eu/eurostat/cache/GISCO/",
      "geodatafiles/CENSUS_UNITS_2011_RG_SH.zip"
    )
  }
  filename <- basename(url)
  namefileload <- load_url(
    url,
    filename,
    cache_dir,
    "census",
    update_cache,
    verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  data_sf <- read_shp_zip(namefileload)

  # Normalize to lonlat
  data_sf <- sf::st_transform(data_sf, 4326)
  data_sf
}
