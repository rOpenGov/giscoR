#' @title Get the grid cells covering the European
#' land territory, for various resolutions.
#' @concept api
#' @description These datasets contain grid cells covering the European land
#' territory, for various resolutions from 1km to 100km. Base statistics such
#' as population figures are provided for these cells.
#' @return A \code{POLYGON/POINT} object.
#' @author dieghernan, \url{https://github.com/dieghernan/}
#' @source \href{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/grids}{GISCO API Grids}
#' @param resolution Resolution of the grid cells on kms. Available values are
#' \code{1, 2, 5, 10, 20, 50, 100}. See Details
#' @param spatialtype Select one of \code{REGION,POINT}
#' @param cache_dir,update_cache,verbose See \link{gisco_get}
#' @details Files are distributed on EPSG:3035.
#'
#'   The file sizes range is from 428K (\code{resolution = "100"})
#' to 1.7G \code{resolution = "1"}. For resolutions 1km and 2km you would
#' need to confirm the download.
#' @note There are specific downloading provisions, please see
#' \url{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/grids}
#' @examples
#' library(sf)
#'
#' grid <- gisco_get_grid(resolution = 20)
#' grid$popdens <- grid$TOT_P_2011 / 20
#'
#' breaks <-
#'   c(
#'     0,
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
#' pal <- hcl.colors(length(breaks) - 2, palette = "inferno", alpha = 0.7)
#' pal <- c("black", pal)
#'
#' opar <- par(no.readonly = TRUE)
#' par(mar = c(0, 0, 0, 0), bg = "grey2")
#' plot(
#'   grid[, "popdens"],
#'   pal = pal,
#'   key.pos = NULL,
#'   breaks = breaks,
#'   main = NA,
#'   xlim = c(2500000, 7000000),
#'   ylim = c(1500000, 5200000),
#'   border = NA
#' )
#' par(opar)
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
