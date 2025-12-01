## code to prepare `gisco_db` dataset goes here
devtools::load_all()

gisco_db <- gisco_get_latest_db(update_cache = TRUE)

usethis::use_data(gisco_db, overwrite = TRUE, compress = "xz")
