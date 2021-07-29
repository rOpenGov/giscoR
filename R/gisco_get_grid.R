#' Get the grid cells covering the European land territory
#'
#' @description
#' These datasets contain grid cells covering the European land
#' territory, for various resolutions from 1km to 100km. Base statistics such
#' as population figures are provided for these cells.
#'
#' @concept misc
#'
#' @return A `POLYGON/POINT` object.
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/grids>
#'
#' @param resolution Resolution of the grid cells on kms. Available values are
#' "1", "2", "5", "10", "20", "50", "100". See Details
#'
#' @param spatialtype Select one of `REGION,POINT`
#'
#' @inheritParams gisco_get
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
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/grids>
#'
#' @examples
#' grid <- gisco_get_grid(resolution = 20)
#' grid$popdens <- grid$TOT_P_2011 / 20
#'
#'
#' breaks <-
#'   c(
#'     0,
#'     0.1, # For capturing 0
#'     500,
#'     1000,
#'     2500,
#'     5000,
#'     10000,
#'     25000,
#'     50000,
#'     max(grid$popdens) + 1
#'   )
#'
#' # Cut groups
#'
#' grid$popdens_cut <- cut(grid$popdens, breaks = breaks, include.lowest = TRUE)
#' cut_labs <- prettyNum(breaks, big.mark = " ")[-1]
#' cut_labs[1] <- "0"
#' cut_labs[9] <- "> 50 000"
#'
#' pal <- c("black", hcl.colors(length(breaks) - 2,
#'   palette = "Spectral",
#'   alpha = 0.9
#' ))
#'
#' library(ggplot2)
#'
#' ggplot(grid) +
#'   geom_sf(aes(fill = popdens_cut), color = NA) +
#'   coord_sf(
#'     xlim = c(2500000, 7000000),
#'     ylim = c(1500000, 5200000)
#'   ) +
#'   scale_fill_manual(
#'     values = pal, na.value = "black",
#'     name = "people per sq. kilometer",
#'     labels = cut_labs,
#'     guide = guide_legend(
#'       direction = "horizontal",
#'       keyheight = 0.5,
#'       keywidth = 2,
#'       title.position = "top",
#'       title.hjust = 0.5,
#'       label.hjust = .5,
#'       nrow = 1,
#'       byrow = TRUE,
#'       reverse = FALSE,
#'       label.position = "bottom"
#'     )
#'   ) +
#'   theme_void() +
#'   labs(
#'     title = "Population density in Europe",
#'     subtitle = "Grid: 20 km.",
#'     caption = gisco_attributions()
#'   ) +
#'   theme(
#'     plot.background = element_rect(fill = "grey2"),
#'     plot.title = element_text(
#'       size = 18, color = "white",
#'       hjust = 0.5,
#'     ),
#'     plot.subtitle = element_text(
#'       size = 14,
#'       color = "white",
#'       hjust = 0.5,
#'       face = "bold"
#'     ),
#'     plot.caption = element_text(
#'       size = 9, color = "grey60",
#'       hjust = 0.5, vjust = 0,
#'       margin = margin(t = 5, b = 10)
#'     ),
#'     legend.text = element_text(
#'       size = 8,
#'       color = "white"
#'     ),
#'     legend.title = element_text(
#'       color = "white"
#'     ),
#'     legend.position = "bottom"
#'   )
#' @export
gisco_get_grid <- function(resolution = "20",
                           spatialtype = "REGION",
                           cache_dir = NULL,
                           update_cache = FALSE,
                           verbose = FALSE) {
  resolution <- as.character(resolution)
  validres <- as.character(c(1, 2, 5, 10, 20, 50, 100))

  if (!resolution %in% validres) {
    stop(
      "resolution should be one of ",
      paste0(validres, collapse = ", ")
    )
  }

  valid <- c("REGION", "POINT")
  if (!spatialtype %in% valid) {
    stop("spatialtype should be 'REGION' or 'POINT'")
  }

  dwnload <- TRUE
  if (isFALSE(update_cache)) {
    if (resolution == "20" & spatialtype == "REGION") {
      dwnload <- FALSE
      data_sf <- grid20km
    }
  }
  if (dwnload) {
    translate <- c("surf", "point")
    ftrans <- translate[valid == spatialtype]
    filename <- paste0("grid_", resolution, "km_", ftrans, ".gpkg")
    api_entry <- "https://gisco-services.ec.europa.eu/grid"
    url <- file.path(api_entry, filename)

    local <- file.path(gsc_helper_cachedir(cache_dir), filename)
    exist_local <- file.exists(local)

    if (verbose & exist_local) {
      message("File exits on local cache dir")
    }
    # nocov start
    if (resolution %in% c("1", "2") & isFALSE(exist_local)) {
      sel <-
        menu(c("Yes", "No"),
          title = "You are about to download a large file (>500M). Proceed?"
        )
      if (sel != 1) {
        stop("Execution halted")
      }
    }
    # nocov end


    localfile <-
      gsc_api_cache(url, filename, cache_dir, update_cache, verbose)

    if (verbose) {
      size <- file.size(localfile)
      class(size) <- "object_size"
      message(format(size, units = "auto"))
    }
    load <- tryCatch(
      sf::st_read(
        localfile,
        quiet = !verbose,
        stringsAsFactors = FALSE
      ),
      warning = function(e) {
        return(NULL)
      },
      error = function(e) {
        return(NULL)
      }
    )
    # nocov start
    if (is.null(load)) {
      stop(
        "\n Malformed ",
        localfile,
        "\n Try downloading from: \n",
        url,
        "\n to your cache_dir folder"
      )
    } else {
      data_sf <- load
    }
    # nocov end
  }
  return(data_sf)
}
