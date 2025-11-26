## code to prepare `gisco_countries_2024` dataset goes here
library(giscoR)
library(sf)
library(ggplot2)
url <- get_url_db(
  "countries",
  year = "2024",
  epsg = "4326",
  ext = "gpkg",
  spatialtype = "RG",
  resolution = "20",
  fn = "aa"
)

url
local <- api_cache(url, cache_dir = NULL, subdir = "countries")

gisco_countries_2024 <- sf::read_sf(local)
gisco_countries_2024 <- giscoR:::sanitize_sf(gisco_countries_2024)

colnames(giscoR::gisco_countries)
colnames(gisco_countries_2024)
dplyr::glimpse(gisco_countries_2024)

ggplot(gisco_countries_2024) +
  geom_sf()

usethis::use_data(gisco_countries_2024, overwrite = TRUE, compress = "xz")
