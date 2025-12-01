# ## code to prepare `sysdata` dataset goes here
# library(sf)
# library(dplyr)
#
#
# # Ports
# ports2013 <- st_read("./data-raw/PORT_2013_SH/Data/PORT_PT_2013.shp", stringsAsFactors = FALSE) %>%
#   st_transform(4326) %>%
#   st_make_valid()
#
# ports2009 <- st_read("./data-raw/PORT_2009_SH/shape/data/PORT_PT_2009.shp", stringsAsFactors = FALSE) %>%
#   st_transform(4326) %>%
#   st_make_valid()
#
#
# usethis::use_data(
#   ports2009,
#   ports2013,
#   overwrite = TRUE,
#   internal = TRUE,
#   compress = "xz"
# )
