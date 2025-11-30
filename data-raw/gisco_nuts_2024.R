## code to prepare `gisco_nuts_2024` dataset goes here
library(giscoR)
library(sf)
gisco_nuts_2024 <- gisco_get_nuts(
  resolution = "20",
  year = "2024",
  epsg = "4326",
  update_cache = TRUE,
  cache_dir = NULL,
  spatialtype = "RG",
  country = NULL,
  verbose = TRUE,
  nuts_id = NULL,
  nuts_level = "all",
  ext = "gpkg"
)
dplyr::glimpse(gisco_nuts_2024)
usethis::use_data(gisco_nuts_2024, overwrite = TRUE, compress = "xz")
