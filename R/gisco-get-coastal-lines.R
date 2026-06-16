#' Coastal lines dataset
#'
#' @description
#' Download global coastal lines.
#'
#' @rdname gisco_get_coastal_lines
#' @family stats
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file.
#'   One of \Sexpr[stage=render,results=rd]{giscoR:::db_values("coastal_lines",
#'   "year",TRUE)}.
#' @param ext A character value with the extension of the file (default
#'   `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("coastal_lines",
#'   "ext",TRUE)}.
#'
#' @inherit gisco_get_countries return
#' @inheritSection gisco_get_countries Note
#' @source
#' <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' Copyright:
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>.
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
#'   # Zoom on the Mediterranean Sea.
#'   coord_sf(
#'     xlim = c(-4, 35),
#'     ylim = c(31, 45)
#'   ) +
#'   theme_minimal() +
#'   theme(
#'     panel.background = element_rect(fill = "#C7E7FB", color = NA),
#'     panel.border = element_rect(colour = "black", fill = NA)
#'   )
#' @export
#'
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

  file <- resolve_gisco_file(
    id = "coastal_lines",
    year = year,
    epsg = epsg,
    resolution = resolution,
    ext = ext,
    fn = "gisco_get_coastal_lines"
  )

  data_sf <- read_packaged_gisco_dataset(
    filename = file$name,
    pattern = "COAS_RG_20M_2016_4326.gpkg",
    data = giscoR::gisco_coastal_lines,
    data_name = "gisco_coastal_lines",
    update_cache = update_cache,
    verbose = verbose
  )
  if (!is.null(data_sf)) {
    return(data_sf)
  }

  read_gisco_dataset(
    url = file$url,
    name = file$name,
    cache = cache,
    cache_dir = cache_dir,
    subdir = "coastal",
    update_cache = update_cache,
    verbose = verbose
  )
}

# Export alias ----

#' @rdname gisco_get_coastal_lines
#' @usage NULL
#' @export
gisco_get_coastallines <- gisco_get_coastal_lines
