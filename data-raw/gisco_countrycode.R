## code to prepare `gisco_countrycode` dataset goes here
library(countrycode)
library(igoR)
region.names <- names(codelist)[grep("un.region", names(codelist))]
cols <- c(
  "eurostat",
  "iso2c",
  "iso3c",
  "iso.name.en",
  "cldr.short.en",
  "continent",
  region.names
)
df <- codelist[, cols]

# Preserve Namibia's country code.
df$eurostat <- ifelse(df$iso3c == "NAM", "NA", df$eurostat)

# Remove records without a country code.
gisco_countrycode <- df[
  !(is.na(df$eurostat) & is.na(df$iso2c) & is.na(df$iso3c)),
]

# Use Eurostat and ISO field names to simplify joins in giscoR.

names(gisco_countrycode) <- c(
  "CNTR_CODE",
  "iso2c",
  "ISO3_CODE",
  names(gisco_countrycode)[4:length(names(gisco_countrycode))]
)

# Add European Union membership.
EU <- igo_members("EU")["ccode"]
EU$ISO3_CODE <- countrycode(EU$ccode, "cown", "iso3c")
EU$eu <- TRUE
EU <- EU[, c("ISO3_CODE", "eu")]
# Exclude the United Kingdom from European Union membership.
EU <- EU[EU$ISO3_CODE != "GBR", ]

gisco_countrycode <- merge(gisco_countrycode, EU, all.x = TRUE)
gisco_countrycode[is.na(gisco_countrycode$eu), "eu"] <- FALSE
gisco_countrycode <- tibble::as_tibble(gisco_countrycode)

usethis::use_data(gisco_countrycode, overwrite = TRUE, compress = "gzip")
