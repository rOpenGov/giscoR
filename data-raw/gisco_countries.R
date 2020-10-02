## code to prepare `gisco_countries` dataset goes here
library(giscoR)
library(sf)
gisco_countries <- gisco_get_countries(
  resolution = "20",
  year = "2016",
  epsg = "4326",
  update_cache = TRUE,
  cache_dir = NULL,
  spatialtype = "RG",
  country = NULL,
  region = NULL
)

gisco_countries <- st_transform(gisco_countries_20M_2016, 4326)


usethis::use_data(gisco_countries,
                  overwrite = TRUE,
                  compress = "xz")

