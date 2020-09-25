## code to prepare `gisco_coastallines_20M_2016` dataset goes here

library(giscoR)
library(sf)
gisco_coastallines_20M_2016 <- gisco_get_countries(
  resolution = "20",
  year = "2016",
  crs = "4326",
  update_cache = TRUE,
  cache_dir = NULL,
  spatialtype = "COASTL",
  country = NULL,
  region = NULL
)
usethis::use_data(gisco_coastallines_20M_2016,
                  overwrite = TRUE,
                  compress = "xz")
