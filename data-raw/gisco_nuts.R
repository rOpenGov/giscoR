## code to prepare `gisco_nuts` dataset goes here
# Fix - encoding name values

# library(giscoR)
library(sf)
# gisco_nuts <- gisco_get_nuts(
#   resolution = "20",
#   year = "2016",
#   epsg = "4326",
#   update_cache = TRUE,
#   cache_dir = NULL,
#   spatialtype = "RG"
# )


gisco_nuts <- st_read("https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/NUTS_RG_20M_2016_4326.geojson",
                      stringsAsFactors = FALSE)

gisco_nuts <- st_make_valid(gisco_nuts)


usethis::use_data(gisco_nuts,
                  overwrite = TRUE,
                  compress = "xz")
