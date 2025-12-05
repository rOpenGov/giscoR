#' Coastal lines dataset
#'
#' @description
#' Downloads worldwide coastlines.
#'
#' @rdname gisco_get_coastal_lines
#' @family stats
#' @inheritParams gisco_get_countries
#' @inheritSection gisco_get_countries Note
#' @inherit gisco_get_countries return
#' @export
#'
#' @param year character string or number. Release year of the file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("coastal_lines",
#'   "year",TRUE)}.
#' @param ext character. Extension of the file (default `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("coastal_lines",
#'   "ext",TRUE)}.
#'
#' @source
#' <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' Copyright:
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>.
#'
#'
#' @seealso
#' [gisco_coastal_lines].
#'
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' @examplesIf gisco_check_access()
#' coast <- gisco_get_coastal_lines()
#'
#' library(ggplot2)
#'
#' ggplot(coast) +
#'   geom_sf(color = "#1278AB", fill = "#FDFBEA") +
#'   # Zoom on Mediterranean Sea
#'   coord_sf(
#'     xlim = c(-4, 35),
#'     ylim = c(31, 45)
#'   ) +
#'   theme_minimal() +
#'   theme(
#'     panel.background = element_rect(fill = "#C7E7FB", color = NA),
#'     panel.border = element_rect(colour = "black", fill = NA)
#'   )
gisco_get_coastal_lines <- function(
  year = 2016,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = 20,
  ext = "gpkg"
) {
  valid_ext <- db_values("coastal_lines", "ext", formatted = FALSE)
  ext <- match_arg_pretty(ext, valid_ext)

  api_entry <- get_url_db(
    id = "coastal_lines",
    year = year,
    epsg = epsg,
    resolution = resolution,
    ext = ext,
    fn = "gisco_get_coastal_lines"
  )

  filename <- basename(api_entry)

  # Check if data is already available
  checkdata <- grepl("COAS_RG_20M_2016_4326.gpkg", filename)
  if (all(isFALSE(update_cache), checkdata)) {
    data_sf <- giscoR::gisco_coastal_lines

    make_msg(
      "info",
      verbose,
      "Loaded from {.help giscoR::gisco_coastal_lines} dataset.",
      "Use {.arg update_cache = TRUE} to re-load from file"
    )

    return(data_sf)
  }

  # Not cached are read from url
  if (all(isFALSE(cache), ext != "shp")) {
    msg <- paste0("{.url ", api_entry, "}.")
    make_msg("info", verbose, "Reading from", msg)

    data_sf <- read_geo_file_sf(api_entry)
    return(data_sf)
  }

  # Cache
  file_local <- download_url(
    api_entry,
    filename,
    cache_dir,
    "coastal",
    update_cache,
    verbose
  )
  if (is.null(file_local)) {
    return(NULL)
  }
  data_sf <- read_geo_file_sf(file_local)

  data_sf
}

# Export alias ----

#' @export
#' @rdname gisco_get_coastal_lines
#' @usage NULL
gisco_get_coastallines <- gisco_get_coastal_lines
