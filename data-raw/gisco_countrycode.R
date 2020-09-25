## code to prepare `gisco_countrycode` dataset goes here
library(countrycode)
region.names <- names(codelist)[grep("un.region", names(codelist))]
cols <-
  c(
    "eurostat",
    "iso2c",
    "iso3c",
    "iso.name.en",
    "cldr.short.en",
    "continent",
    region.names
  )
df <- codelist[, cols]

# Fix Namibia
df$eurostat <- ifelse(df$iso3c == "NAM", "NA", df$eurostat)

# Delete records without id
gisco_countrycode <-
  df[!(is.na(df$eurostat) & is.na(df$iso2c) & is.na(df$iso3c)),]

# Change names to Eurostat and ISO to ease joins on giscoR

names(gisco_countrycode) <-
  c("CNTR_CODE", "iso2c", "ISO3_CODE", names(gisco_countrycode)[4:length(names(gisco_countrycode))])

usethis::use_data(gisco_countrycode, overwrite = TRUE, compress = "gzip")
