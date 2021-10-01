#' Postal Codes
#'
#' Get postal codes points of the EU, EFTA and candidate countries.
#'
#' @param year Year of reference. Currently only "2020" is available.
#'
#' @inheritParams gisco_get_airports
#' @inheritSection gisco_get_countries About caching
#'
#' @family political
#'
#' @return A `POINT` object on EPSG:4326.
#'
#' @export
#'
#' @details
#' The postal code point dataset shows the location of postal codes, NUTS codes
#' and the Degree of Urbanisation classification across the EU, EFTA and
#' candidate countries from a variety of sources. Its primary purpose is to
#' create correspondence tables for the NUTS classification (EC) 1059/2003 as
#' part of the Tercet Regulation (EU) 2017/2391
#'
#' # Copyright
#'
#' The dataset is released under the CC-BY-SA-4.0 licence and requires the
#' following attribution whenever used:
#'
#' *(c) European Union - GISCO, 2021, postal code point dataset, Licence
#' CC-BY-SA 4.0 available at
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data>*
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/postal-codes>
#'
#' @examples
#'
#' # Heavy-weight download!
#' \dontrun{
#'
#' pc_bel <- gisco_get_postalcodes(country = "BE")
#'
#' library(ggplot2)
#'
#' ggplot(pc_bel) +
#'   geom_sf(color = "gold") +
#'   theme_bw() +
#'   labs(
#'     title = "Postcodes of Belgium",
#'     subtitle = "2020",
#'     caption = paste("(c) European Union - GISCO, 2021, postal code point dataset",
#'       "Licence CC-BY-SA 4.0",
#'       sep = "\n"
#'     )
#'   )
#' }
gisco_get_postalcodes <- function(year = "2020",
                                  country = NULL,
                                  cache_dir = NULL,
                                  update_cache = FALSE,
                                  verbose = FALSE) {
  year <- as.character(year)
  if (!(year %in% c("2020"))) {
    stop("Year should be 2020")
  }

  # nocov start
  if (year == "2020") {
    url <- "https://gisco-services.ec.europa.eu/tercet/Various/PC_2020_PT_SH.zip"
  }

  cache_dir <- gsc_helper_detect_cache_dir()

  name <- basename(url)

  basename <- gsc_api_cache(
    url = url, name = name, cache_dir = cache_dir,
    update_cache = update_cache, verbose = verbose
  )


  gsc_unzip(basename, cache_dir, ext = "*", verbose = verbose, update_cache = update_cache)

  destfile <- basename

  zipfiles <- unzip(destfile, list = TRUE)
  shpfile <- basename(zipfiles[grep(".shp$", zipfiles[[1]]), 1])


  data_sf <- sf::st_read(file.path(cache_dir, shpfile), quiet = !verbose)
  data_sf <- sf::st_make_valid(data_sf)

  if (!is.null(country) & "CNTR_ID" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_ID %in% country, ]
  }

  return(data_sf)
  # nocov end
}
