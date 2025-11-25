read_shp_zip <- function(file_local, q = NULL) {
  shp_zip <- unzip(file_local, list = TRUE)
  shp_zip <- shp_zip$Name
  shp_zip <- shp_zip[grepl("shp$", shp_zip)]
  shp_end <- shp_zip[1]

  # Read with vszip
  shp_read <- file.path("/vsizip/", file_local, shp_end)
  shp_read <- gsub("//", "/", shp_read)
  if (!is.null(q)) {
    data_sf <- sf::read_sf(shp_read, query = q)
  } else {
    data_sf <- sf::read_sf(shp_read)
  }

  data_sf <- gsc_helper_utf8(data_sf)

  data_sf
}
