#' Education services in Europe
#'
#' @description
#' This dataset is an integration of Member States official data on the
#' location of education services. Additional information on these services is
#' included when available (see **Details**).
#'
#' @family services
#' @inherit gisco_get_countries return
#' @inheritParams gisco_get_countries
#' @encoding UTF-8
#' @export
#'
#' @param year character string or number. Release year of the file. One of
#'   `2023`, `2020`.
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/basic-services>
#'
#' There are no specific download rules for the datasets shown below. However,
#' please refer to [the general copyright
#' notice](https://ec.europa.eu/eurostat/web/gisco/geodata) and licence
#' provisions, which must be complied with. Permission to download and use
#' these data is subject to these rules being accepted.
#'
#' The data are extracted from official national registers. They may contain
#' inconsistencies, inaccuracies and gaps, due to the heterogeneity of the
#' input national data.
#'
#'
#' @details
#' Files are distributed [EPSG:4326](https://epsg.io/4326).
#'
#' ```{r child = "man/chunks/education_meta.Rmd"}
#' ```
#'
#' @examplesIf gisco_check_access()
#' edu_BEL <- gisco_get_education(country = "Belgium")
#'
#' # Plot if downloaded
#' if (nrow(edu_BEL) > 3) {
#'   library(ggplot2)
#'   ggplot(edu_BEL) +
#'     geom_sf(shape = 21, size = 0.15)
#' }
gisco_get_education <- function(
  year = c(2023, 2020),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL
) {
  # Given vars
  year <- match_arg_pretty(year)

  if (!is.null(country)) {
    country_get <- get_country_code(country)
  } else {
    country_get <- "EU"
  }

  api_entry <- paste0(
    "https://gisco-services.ec.europa.eu/pub/education/",
    year,
    "/gpkg/",
    country_get,
    ".gpkg"
  )

  n_cnt <- seq_along(api_entry)

  ress <- lapply(n_cnt, function(x) {
    api <- api_entry[x]
    filename <- paste0("edu_", year, "_", basename(api))

    if (cache) {
      # Guess source to load
      namefileload <- download_url(
        api,
        filename,
        cache_dir,
        "education",
        update_cache,
        verbose
      )
    } else {
      namefileload <- api
    }

    if (is.null(namefileload)) {
      return(NULL)
    }

    data_sf <- read_geo_file_sf(namefileload)

    data_sf
  })

  data_sf_all <- rbind_fill(ress)
  if (is.null(data_sf_all)) {
    return(NULL)
  }

  data_sf_all
}
