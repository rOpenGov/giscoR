#' Get postal code points from GISCO
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
#' Shapefiles provided in ETRS89 ([EPSG:4258](https://epsg.io/4258)).
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/postal-codes>
#'
#' @examplesIf gisco_check_access()
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
#'     caption = paste("(c) European Union - GISCO, 2021,",
#'       "postal code point dataset",
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
  cache_dir <- gsc_helper_cachedir(cache_dir)

  if (year == "2020") {
    url <- "https://gisco-services.ec.europa.eu/tercet/Various/PC_2020_PT_SH.zip"
  }


  filename <- basename(url)

  basename <- gsc_api_cache(
    url = url, name = filename, cache_dir = cache_dir,
    update_cache = update_cache, verbose = verbose
  )

  if (is.null(basename)) {
    return(NULL)
  }

  gsc_unzip(basename, cache_dir,
    ext = "*", verbose = verbose,
    update_cache = update_cache,
    recursive = FALSE
  )

  # Capture shp layer name
  destfile <- basename

  zipfiles <- unzip(destfile, list = TRUE)
  shpfile <- basename(zipfiles[grep(".shp$", zipfiles[[1]]), 1])

  namefileload <- file.path(cache_dir, shpfile)

  # Improve speed using querys if country(es) are selected
  # We construct the query and passed it to the st_read fun

  if (!is.null(country)) {
    gsc_message(verbose, "Speed up using sf query")
    country <- gsc_helper_countrynames(country, "eurostat")

    # Get layer name
    layer <- tools::file_path_sans_ext(basename(namefileload))

    # Construct query
    q <- paste0(
      "SELECT * from \"",
      layer,
      "\" WHERE CNTR_ID IN (",
      paste0("'", country, "'", collapse = ", "),
      ")"
    )

    gsc_message(verbose, "Using query:\n   ", q)


    data_sf <- try(
      suppressWarnings(
        sf::st_read(namefileload,
          quiet = !verbose,
          query = q
        )
      ),
      silent = TRUE
    )

    # If everything was fine then output
    if (!inherits(data_sf, "try-error")) {
      data_sf <- sf::st_make_valid(data_sf)
      return(data_sf)
    }

    # nocov start

    # If not, remove and continue
    rm(data_sf)
    gsc_message(
      TRUE,
      "\n\nIt was a problem with the query.",
      "Retrying without country filters\n\n"
    )
  }

  # This is if not returning from the previous step

  data_sf <- sf::st_read(namefileload, quiet = !verbose)
  data_sf <- sf::st_make_valid(data_sf)

  return(data_sf)

  # nocov end
}
