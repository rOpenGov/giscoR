## code to prepare `gisco_nuts` dataset goes here

library(giscoR)
library(sf)
gisco_nuts <- gisco_get_nuts(
  resolution = "20",
  year = "2016",
  epsg = "4326",
  update_cache = TRUE,
  cache_dir = NULL,
  spatialtype = "RG",
  country = NULL,
  verbose = TRUE,
  nuts_id = NULL,
  nuts_level = "all"
)

usethis::use_data(gisco_nuts,
                  overwrite = TRUE,
                  compress = "xz")

