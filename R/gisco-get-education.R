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
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/basic-services>.
#'
#' There are no specific download rules for the datasets shown below. However,
#' please refer to [the general copyright
#' notice](https://ec.europa.eu/eurostat/web/gisco/geodata) and licence
#' provisions, which must be complied with. Permission to download and use
#' these data are subject to these rules being accepted.
#'
#' The data are extracted from official national registers. They may contain
#' inconsistencies, inaccuracies and gaps, due to the heterogeneity of the
#' input national data.
#'
#'
#' @details
#' Files are distributed on [EPSG:4326](https://epsg.io/4326).
#'
#' ```{r child = "man/chunks/education_meta.Rmd"}
#' ```
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#' edu_austria <- gisco_get_education(country = "Austria", year = 2023)
#'
#' # Plot if downloaded
#' if (!is.null(edu_austria)) {
#'   austria_nuts3 <- gisco_get_nuts(country = "Austria", nuts_level = 3)
#'
#'   library(ggplot2)
#'   ggplot(austria_nuts3) +
#'     geom_sf(fill = "grey10", color = "grey60") +
#'     geom_sf(
#'       data = edu_austria, aes(color = rev(public_private)),
#'       alpha = 0.25
#'     ) +
#'     theme_void() +
#'     theme(
#'       plot.background = element_rect(fill = "black"),
#'       text = element_text(color = "white"),
#'       panel.grid = element_blank(),
#'       plot.title = element_text(face = "bold", hjust = 0.5),
#'       plot.subtitle = element_text(face = "italic", hjust = 0.5)
#'     ) +
#'     labs(
#'       title = "Education", subtitle = "Austria (2023)",
#'       caption = "Source: Eurostat, Education 2023 dataset.",
#'       color = "Type"
#'     ) +
#'     coord_sf(crs = 3035)
#' }
#' }
#'
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
    country_get <- convert_country_code(country)
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
