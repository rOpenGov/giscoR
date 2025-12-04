## code to prepare `gisco_coastal_lines` dataset goes here

library(giscoR)
library(sf)

gisco_coastal_lines <- gisco_get_coastal_lines(
  resolution = 20,
  year = "2016",
  epsg = "4326",
  update_cache = TRUE,
  cache_dir = NULL,
  verbose = TRUE
)

usethis::use_data(gisco_coastal_lines, overwrite = TRUE, compress = "xz")
