## code to prepare `sysdata` dataset goes here

# Downloaded on 2020-10-29
grid20km <- gisco_get_grid(resolution = 20, spatialtype = "REGION",
                           update_cache = TRUE, verbose = TRUE)

usethis::use_data(
  grid20km,
  overwrite = TRUE,
  internal = TRUE,
  compress = "xz"
)

