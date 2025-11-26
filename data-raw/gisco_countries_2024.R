## code to prepare `gisco_countries_2024` dataset goes here
library(giscoR)
library(sf)
library(ggplot2)

gisco_countries_2024 <- gisco_get_countries(
  verbose = TRUE,
  year = 2024,
  resolution = 20,
  epsg = 4326,
  spatialtype = "RG",
  update_cache = TRUE
)

ggplot(gisco_countries_2024) +
  geom_sf()

usethis::use_data(gisco_countries_2024, overwrite = TRUE, compress = "xz")
