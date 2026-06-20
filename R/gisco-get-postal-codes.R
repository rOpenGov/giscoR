#' Postal codes dataset
#'
#' @description
#' The postal code point dataset shows the location of postal codes, NUTS codes
#' and the degree of urbanisation classification across the EU, EFTA and
#' candidate countries. Its primary purpose is to create correspondence tables
#' for the NUTS classification established by Regulation (EC) No 1059/2003 as
#' part of the Tercet Regulation (EU) 2017/2391.
#'
#' @rdname gisco_get_postal_codes
#' @family admin
#'
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("postal_codes",
#'   "year",TRUE)}.
#' @param ext A character value with the extension of the file (default
#'   `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::db_values("postal_codes",
#'   "ext",TRUE)}.
#' @inherit gisco_get_countries return
#' @details
#' The GISCO distribution API provides postal code releases for 2025, 2024 and
#' 2020. The 2025 release has a reference date of 1 January 2025.
#'
#' # Copyright
#'
#' The dataset is released under the CC-BY-SA-4.0 license. Although the
#' distribution API provides a 2025 release, the official GISCO licensing page
#' currently requires the following attribution:
#'
#' ```{r, echo=FALSE, results='asis'}
#' cat("")
#' cat("\u00a9 European Union - GISCO, 2024, postal code point dataset,",
#' "Licence CC-BY-SA 4.0.")
#'
#' ```
#'
#' # Note
#'
#' This dataset is not covered by [gisco_attributions()]. Use the attribution
#' specified above until GISCO publishes revised licensing text.
#'
#' Non-geographical postal codes, such as post boxes and codes used by large
#' organizations, are not included. The dataset may omit or incorrectly locate
#' postal codes because the source data vary considerably among countries.
#'
#' @source
#' GISCO administrative units:
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.
#'
#' GISCO postal code distribution API:
#' <https://gisco-services.ec.europa.eu/distribution/v2/pcode/>.
#' @seealso
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' @encoding UTF-8
#' @export
#' @examplesIf gisco_check_access()
#'
#' # Large download.
#' \dontrun{
#'
#' pc_bel <- gisco_get_postal_codes(year = 2025, country = "BE")
#'
#' if (!is.null(pc_bel)) {
#'   library(ggplot2)
#'
#'   ggplot(pc_bel) +
#'     geom_sf(color = "gold") +
#'     theme_bw() +
#'     labs(
#'       title = "Postcodes of Belgium",
#'       subtitle = "2025",
#'       caption = paste("\u00a9 European Union - GISCO, 2024,",
#'         "postal code point dataset",
#'         "Licence CC-BY-SA 4.0",
#'         sep = "\n"
#'       )
#'     )
#' }
#' }
#'
gisco_get_postal_codes <- function(
  year = 2025,
  epsg = 4326,
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  ext = "gpkg"
) {
  valid_ext <- db_values("postal_codes", "ext", formatted = FALSE)
  ext <- match_arg_pretty(ext, valid_ext)

  file <- resolve_gisco_file(
    "postal_codes",
    year = year,
    epsg = epsg,
    ext = ext,
    fn = "gisco_get_postal_codes"
  )

  country <- convert_country_code_or_null(country)

  read_gisco_dataset(
    url = file$url,
    name = file$name,
    cache = TRUE,
    cache_dir = cache_dir,
    subdir = "postal_codes",
    update_cache = update_cache,
    verbose = verbose,
    filters = function(file_local) {
      make_sf_filter(file_local, country)
    }
  )
}

# Export alias ----

#' @rdname gisco_get_postal_codes
#' @usage NULL
#' @export
gisco_get_postalcodes <- gisco_get_postal_codes
