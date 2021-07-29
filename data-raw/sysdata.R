## code to prepare `sysdata` dataset goes here
library(sf)
library(dplyr)

# Downloaded on 2020-11-03
grid20km <- gisco_get_grid(
  resolution = 20, spatialtype = "REGION",
  update_cache = TRUE, verbose = TRUE
)



# Airports

airports2013 <- st_read("./data-raw/SHAPE/AIRP_PT_2013.shp", stringsAsFactors = FALSE) %>%
  st_transform(4326) %>%
  st_make_valid()

airports2006 <- st_read("./data-raw/AIRP_SH/shape/data/AIRP_ICAO_PT.shp", stringsAsFactors = FALSE) %>%
  st_transform(4326) %>%
  st_make_valid()

# Ports
ports2013 <- st_read("./data-raw/PORT_2013_SH/Data/PORT_PT_2013.shp", stringsAsFactors = FALSE) %>%
  st_transform(4326) %>%
  st_make_valid()

ports2009 <- st_read("./data-raw/PORT_2009_SH/shape/data/PORT_PT_2009.shp", stringsAsFactors = FALSE) %>%
  st_transform(4326) %>%
  st_make_valid()


usethis::use_data(
  grid20km,
  airports2006,
  airports2013,
  ports2009,
  ports2013,
  overwrite = TRUE,
  internal = TRUE,
  compress = "xz"
)
