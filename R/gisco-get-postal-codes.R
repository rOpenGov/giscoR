#' Postal codes dataset
#'
#' @description
#' The postal code point dataset shows the location of postal codes, NUTS codes
#' and the Degree of Urbanisation classification across the EU, EFTA and
#' candidate countries from a variety of sources. Its primary purpose is to
#' create correspondence tables for the NUTS classification (EC) 1059/2003 as
#' part of the Tercet Regulation (EU) 2017/2391.
#'
#' @rdname gisco_get_postal_codes
#' @family admin
#' @inheritParams gisco_get_countries
#' @inherit gisco_get_countries source return
#' @inheritSection gisco_get_countries Note
#' @export
#'
#' @seealso
#' See [gisco_bulk_download()] to perform a bulk download of datasets.
#'
#' @param year character string or number. Release year of the file. One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("postal_codes",
#'   "year",TRUE)}.
#' @param ext character. Extension of the file (default `"gpkg"`). One of
#'   \Sexpr[stage=render,results=rd]{giscoR:::for_docs("postal_codes",
#'   "ext",TRUE)}.
#' @inheritParams gisco_get_countries
#' @inherit gisco_get_countries source return note
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
#'       caption = paste("(c) European Union - GISCO, 2024,",
#'         "postal code point dataset",
#'         "Licence CC-BY-SA 4.0",
#'         sep = "\n"
#'       )
#'     )
#' }
#' }
gisco_get_postal_codes <- function(
  year = 2024,
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  ext = "gpkg"
) {
  valid_ext <- for_docs("countries", "ext", formatted = FALSE)
  ext <- match_arg_pretty(ext, valid_ext)

  url <- get_url_db(
    "postal_codes",
    year = year,
    ext = ext,
    fn = "gisco_get_postal_codes"
  )
  filename <- basename(url)

  file_local <- download_url(
    url = url,
    name = filename,
    cache_dir = cache_dir,
    subdir = "postal_codes",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun

  filter_col <- get_col_name(file_local)
  if (all(!is.null(country), !is.null(filter_col))) {
    make_msg("info", verbose, "Speed up using {.pkg sf} query")
    country <- get_country_code(country)

    # Get layer name
    layer <- get_sf_layer_name(file_local)

    # Construct query
    q <- paste0(
      "SELECT * from \"",
      layer,
      "\" WHERE ",
      filter_col,
      " IN (",
      paste0("'", country, "'", collapse = ", "),
      ")"
    )

    msg <- paste0("{.code ", q, "}")
    make_msg("info", verbose, "Using query:\n   ", msg)
    data_sf <- read_geo_file_sf(file_local, q = q)
    return(data_sf)
  }

  # If not read the whole file
  data_sf <- read_geo_file_sf(file_local)

  data_sf
}

# Export alias ----

#' @export
#' @rdname gisco_get_postal_codes
#' @usage NULL
gisco_get_postalcodes <- gisco_get_postal_codes
