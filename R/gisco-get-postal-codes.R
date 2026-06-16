#' Postal codes dataset
#'
#' @description
#' The postal code point dataset shows the location of postal codes, NUTS
#' codes and the Degree of Urbanisation classification across the EU, EFTA
#' and candidate countries from a variety of sources. Its primary purpose is
#' to create correspondence tables for the NUTS classification (EC) 1059/2003
#' as part of the Tercet Regulation (EU) 2017/2391.
#'
#' @rdname gisco_get_postal_codes
#' @family admin
#' @encoding UTF-8
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
#' # Copyright
#'
#' The dataset is released under the CC-BY-SA-4.0 license and requires the
#' following attribution whenever used:
#'
#' ```{r, echo=FALSE, results='asis'}
#' cat("")
#' cat("\u00a9 European Union - GISCO, 2024, postal code point dataset,",
#' "License CC-BY-SA 4.0.")
#'
#' ```
#'
#' @inheritSection gisco_get_countries Note
#' @inherit gisco_get_countries source
#' @seealso
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' @examplesIf gisco_check_access()
#'
#' # Large download.
#' \dontrun{
#'
#' pc_bel <- gisco_get_postal_codes(country = "BE")
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
#'       caption = paste("\u00a9 European Union - GISCO, 2024,",
#'         "postal code point dataset",
#'         "License CC-BY-SA 4.0",
#'         sep = "\n"
#'       )
#'     )
#' }
#' }
#' @export
#'
gisco_get_postal_codes <- function(
  year = 2024,
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
