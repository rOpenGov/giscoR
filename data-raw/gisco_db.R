## code to prepare `gisco_db` dataset goes here
library(giscoR)
gisco_db <- gisco_get_cached_db(update_cache = TRUE)
gisco_db$last_updated <- gisco_db$last_updated - 1

dplyr::glimpse(gisco_db)

usethis::use_data(gisco_db, overwrite = TRUE, compress = "xz")
