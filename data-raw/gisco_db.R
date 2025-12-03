## code to prepare `gisco_db` dataset goes here
library(giscoR)
gisco_db <- gisco_get_latest_db(update_cache = TRUE)

usethis::use_data(gisco_db, overwrite = TRUE, compress = "xz")
