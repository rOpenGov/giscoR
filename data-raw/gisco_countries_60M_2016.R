## code to prepare `gisco_countries_60M_2016` dataset goes here
library(giscoR)
library(sf)
gisco_countries_60M_2016 <- gisco_get_countries(
  resolution = "60",
  year = "2016",
  crs = "4326",
  update_cache = TRUE,
  cache_dir = NULL,
  spatialtype = "RG",
  country = NULL,
  region = NULL
)
usethis::use_data(gisco_countries_60M_2016,
                  overwrite = TRUE,
                  compress = "gzip")

