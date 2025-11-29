#' Get grid cells covering covering Europe for various resolutions
#'
#' @description
#' These datasets contain grid cells covering the European land
#' territory, for various resolutions from 1km to 100km. Base statistics such
#' as population figures are provided for these cells.
#'
#' @family misc
#'
#' @return A `POLYGON/POINT` [`sf`][sf::st_sf] object.
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/grids>
#'
#' @param resolution Resolution of the grid cells on kms. Available values are
#' `"1"`, `"2"`, `"5"`, `"10"`, `"20"`, `"50"`, `"100"`. See **Details**.
#'
#' @param spatialtype Select one of `"REGION"` or `"POINT"`.
#'
#' @inheritParams gisco_get_countries
#'
#'
#' @details
#'
#' Files are distributed on EPSG:3035.
#'
#' The file sizes range is from 428Kb (`resolution = "100"`)
#' to 1.7Gb `resolution = "1"`. For resolutions 1km and 2km you would
#' need to confirm the download.
#'
#' @note
#' There are specific downloading provisions, please see
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/grids>
#'
#' @examplesIf gisco_check_access()
#' \donttest{
#' grid <- gisco_get_grid(resolution = 20)
#'
#' # If downloaded correctly proceed
#'
#' if (!is.null(grid)) {
#'   library(dplyr)
#'
#'   grid <- grid %>%
#'     mutate(popdens = TOT_P_2021 / 20)
#'
#'   breaks <- c(0, 0.1, 100, 500, 1000, 5000, 10000, Inf)
#'
#'   # Cut groups
#'   grid <- grid %>%
#'     mutate(popdens_cut = cut(popdens,
#'       breaks = breaks,
#'       include.lowest = TRUE
#'     ))
#'
#'   cut_labs <- prettyNum(breaks, big.mark = " ")[-1]
#'   cut_labs[1] <- "0"
#'   cut_labs[7] <- "> 10 000"
#'
#'   pal <- c("black", hcl.colors(length(breaks) - 2,
#'     palette = "Spectral",
#'     alpha = 0.9
#'   ))
#'
#'   library(ggplot2)
#'
#'   ggplot(grid) +
#'     geom_sf(aes(fill = popdens_cut), color = NA, linewidth = 0) +
#'     coord_sf(
#'       xlim = c(2500000, 7000000),
#'       ylim = c(1500000, 5200000)
#'     ) +
#'     scale_fill_manual(
#'       values = pal, na.value = "black",
#'       name = "people per sq. kilometer",
#'       labels = cut_labs,
#'       guide = guide_legend(
#'         direction = "horizontal",
#'         nrow = 1
#'       )
#'     ) +
#'     theme_void() +
#'     labs(
#'       title = "Population density in Europe (2021)",
#'       subtitle = "Grid: 20 km.",
#'       caption = gisco_attributions()
#'     ) +
#'     theme(
#'       text = element_text(colour = "white"),
#'       plot.background = element_rect(fill = "grey2"),
#'       plot.title = element_text(hjust = 0.5),
#'       plot.subtitle = element_text(hjust = 0.5, face = "bold"),
#'       plot.caption = element_text(
#'         color = "grey60", hjust = 0.5, vjust = 0,
#'         margin = margin(t = 5, b = 10)
#'       ),
#'       legend.position = "bottom",
#'       legend.title.position = "top",
#'       legend.text.position = "bottom",
#'       legend.key.height = unit(0.5, "lines"),
#'       legend.key.width = unit(1, "lines")
#'     )
#' }
#' }
#' @export
gisco_get_grid <- function(
  resolution = 20,
  spatialtype = c("REGION", "POINT"),
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
) {
  resolution <- as.numeric(resolution)
  validres <- as.character(c(1, 2, 5, 10, 20, 50, 100))

  resolution <- match_arg_pretty(resolution, validres)

  spatialtype <- match_arg_pretty(spatialtype)
  valid <- c("REGION", "POINT")

  translate <- c("surf", "point")
  ftrans <- translate[valid == spatialtype]
  filename <- paste0("grid_", resolution, "km_", ftrans, ".gpkg")
  api_entry <- "https://gisco-services.ec.europa.eu/grid"
  url <- file.path(api_entry, filename)

  file_local <- load_url(
    url,
    basename(url),
    cache_dir,
    "grid",
    update_cache,
    verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  data_sf <- read_geo_file_sf(file_local)

  data_sf
}
