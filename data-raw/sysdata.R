## code to prepare `sysdata` dataset goes here
library(giscoR)



gisco_communes_BE.sf <-
  gisco_get_communes(country = "BEL", update_cache = TRUE )

gisco_lau_BE.sf <-
  gisco_get_lau(country = "BEL", update_cache = TRUE )

gisco_urban_audit_GC.sf <- gisco_get_urban_audit(
  update_cache = TRUE,
  level = "GREATER_CITIES")

usethis::use_data(
  gisco_communes_BE.sf,
  gisco_lau_BE.sf,
  gisco_urban_audit_GC.sf,
  overwrite = TRUE,
  internal = TRUE,
  compress = "xz"
)
