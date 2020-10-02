## code to prepare `gisco_coastallines` dataset goes here

library(giscoR)
library(sf)
gisco_coastallines <- gisco_get_countries(
  resolution = "20",
  year = "2016",
  epsg = "4326",
  update_cache = TRUE,
  cache_dir = NULL,
  spatialtype = "COASTL",
  country = NULL,
  region = NULL
)

gisco_coastallines <- st_transform(gisco_coastallines, 4326)


usethis::use_data(gisco_coastallines,
                  overwrite = TRUE,
                  compress = "xz")
