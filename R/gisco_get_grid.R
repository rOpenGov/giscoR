#' @title Get the grid cells covering the European land territory, for various resolutions.
#' @description These datasets contain grid cells covering the European land territory, for various resolutions from 1km to 100km. Base statistics such as population figures are provided for these cells.
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
#' @note There are specific downloading provisions, please see \url{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/grids}
#' @examples
#' library(sf)
#'
#' grid <- gisco_get_grid()
#' breaks <- unique(quantile(grid$TOT_P_2006, probs = seq(0, 1, 0.01)))
#'
#' # Remove coastal grids
#' grid <- grid[grid$LAND_PC > 0.2, ]
#'
#' plot(
#'         grid[, "TOT_P_2011"],
#'         pal = hcl.colors(length(breaks), "ag_Sunset"),
#'         key.pos = NULL,
#'         main = "[Grid] Population on Europe (2011)",
#'         breaks = breaks,
#'         xlim = c(2636691, 7315863),
#'         ylim = c(1422800 , 5410788),
#'         border = NA
#' )
#' @export
gisco_get_grid <- function(resolution = "20",
                           spatialtype = "REGION",
                           cache_dir = NULL,
                           update_cache = FALSE,
                           verbose = FALSE) {
  resolution <- as.character(resolution)
  validres <- as.character(c(1, 2, 5, 10, 20, 50, 100))

  if (!resolution %in% validres) {
    stop("resolution should be one of ",
         paste0(validres, collapse = ", "))
  }

  valid <- c("REGION", "POINT")
  if (!spatialtype %in% valid) {
    stop("spatialtype should be 'REGION' or 'POINT'")
  }

  dwnload <- TRUE
  if (isFALSE(update_cache)) {
    if (resolution == "20" & spatialtype == "REGION") {
      dwnload <- FALSE
      data.sf <- grid20km
    }
  }
  if (dwnload) {
    translate <- c("surf", "point")
    ftrans <- translate[valid == spatialtype]
    filename <- paste0("grid_", resolution, "km_", ftrans, ".gpkg")
    api_entry <- "https://gisco-services.ec.europa.eu/grid"
    url <- file.path(api_entry, filename)
    if (resolution %in% c("1" , "2")) {
      sel <-
        menu(c("Yes", "No"), title = "You are about to download a large file (>500M). Proceed?")
      if (sel != 1) {
        stop("Execution halted")
      }
    }


    localfile <-
      gsc_api_cache(url, filename, cache_dir, update_cache, verbose)


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
    if (is.null(load)) {
      stop(
        "\n Malformed ",
        localfile,
        "\n Try downloading from: \n",
        url,
        "\n to your cache_dir folder"
      )
    } else {
      data.sf <- load
    }
  }
  return(data.sf)
}
