#' sf::read_sf wrapper
#' @noRd
read_geo_file_sf <- function(file_local, ...) {
  data_sf <- sf::read_sf(file_local, ...)
  data_sf <- sanitize_sf(data_sf)

  data_sf
}

#' Create and read 'vsizip' construct
#' @noRd
read_shp_zip <- function(file_local, q = NULL) {
  shp_zip <- unzip(file_local, list = TRUE)
  shp_zip <- shp_zip$Name
  shp_zip <- shp_zip[grepl("shp$", shp_zip)]
  shp_end <- shp_zip[1]

  # Read with vszip
  shp_read <- file.path("/vsizip/", file_local, shp_end)
  shp_read <- gsub("//", "/", shp_read)
  if (!is.null(q)) {
    data_sf <- read_geo_file_sf(shp_read, query = q)
  } else {
    data_sf <- read_geo_file_sf(shp_read)
  }

  data_sf
}


#' Convert sf object to UTF-8
#'
#' Convert to UTF-8
#'
#' @param data_sf data_sf
#'
#' @return data_sf with UTF-8 encoding.
#'
#' @source Extracted from [`sf`][sf::st_sf] package.
#'
#' @noRd
sanitize_sf <- function(data_sf) {
  # From sf/read.R - https://github.com/r-spatial/sf/blob/master/R/read.R
  set_utf8 <- function(x) {
    n <- names(x)
    Encoding(n) <- "UTF-8"
    to_utf8 <- function(x) {
      if (is.character(x)) {
        Encoding(x) <- "UTF-8"
      }
      x
    }
    structure(lapply(x, to_utf8), names = n)
  }
  # end

  # To UTF-8
  names <- names(data_sf)
  g <- sf::st_geometry(data_sf)

  nm <- "geometry"
  data_utf8 <-
    as.data.frame(
      set_utf8(sf::st_drop_geometry(data_sf)),
      stringsAsFactors = FALSE
    )

  data_utf8 <- tibble::as_tibble(data_utf8)

  # Regenerate with right encoding
  data_sf <- sf::st_as_sf(data_utf8, g)

  # Rename geometry to geometry
  newnames <- names(data_sf)
  newnames[newnames == "g"] <- nm
  colnames(data_sf) <- newnames
  data_sf <- sf::st_set_geometry(data_sf, nm)

  data_sf <- sf::st_make_valid(data_sf)

  data_sf
}
