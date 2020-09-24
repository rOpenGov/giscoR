## code to prepare `M49_regions` dataset goes here
csvimport <-
  read.csv(
    "https://raw.githubusercontent.com/dieghernan/Country-Codes-and-International-Organizations/master/outputs/Countrycodes.csv",
    na.strings = "",
    encoding = "UTF-8",
    stringsAsFactors = FALSE
  )

# Cleanup
namestokeep <- c(
  "ISO_3166_3",
  "NAME.EN",
  "regioncode",
  "REGION.EN",
  "subregioncode",
  "SUBREGION.EN",
  "interregioncode",
  "INTERREGION.EN",
  "Developed"
)

M49_regions <- csvimport[!is.na(csvimport$ISO_3166_3), namestokeep]

newnames <- c(
  "ISO3_CODE",
  "NAME",
  "REGION_CODE",
  "REGION",
  "SUBREGION_CODE",
  "SUBREGION",
  "INTERREGION_CODE",
  "INTERREGION",
  "DEVELOPED"
)

names(M49_regions) <- newnames
M49_regions$DEVELOPED <- as.factor(M49_regions$DEVELOPED)
usethis::use_data(M49_regions, overwrite = TRUE, compress = "gzip")


