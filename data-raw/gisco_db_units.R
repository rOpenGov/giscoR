## code to prepare `gisco_db_units` dataset goes here

gisco_db_units <- gisco_get_latest_db_units(update_cache = TRUE)

usethis::use_data(gisco_db_units, overwrite = TRUE, compress = "xz")
