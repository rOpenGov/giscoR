## code to prepare `gisco_internal` dataset goes here
library(giscoR)
library(sf)


gisco_communes_BE.sf <-
  gisco_get_communes(country = "BEL")

gisco_lau_BE.sf <-
  gisco_get_lau(country = "BEL")

gisco_urban_audit_GC.sf <- gisco_get_urban_audit(level = "GREATER_CITIES")

usethis::use_data(
  gisco_communes_BE.sf,
  gisco_lau_BE.sf,
  gisco_urban_audit_GC.sf,
  overwrite = TRUE,
  internal = TRUE,
  compress = "xz"
)

if("BE" == c("BE","NL")){
  print("OK")
}

country <- NULL

length(country)
