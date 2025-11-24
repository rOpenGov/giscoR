## code to prepare `gisco_db2` dataset goes here

rm(list = ls())

# Create gisco_db2
library(jsonlite)
library(dplyr)
library(stringr)

name <- "coastallines"
api_entry <- "https://gisco-services.ec.europa.eu/distribution/v2/coas"
clean <- "coastline-"
dataset <- "datasets.json"
ext <- "geojson"

# Function----
dwndata <- function(
    name = "coastallines",
    api_entry = "https://gisco-services.ec.europa.eu/distribution/v2/coas",
    clean = "coastline-",
    dataset = "datasets.json",
    ext = "geojson") {
  # Create temp file
  tmp <- tempfile(dataset, fileext = ".json")
  tmp <- gsub("\\", "/", tmp, fixed = TRUE)

  # Compose url
  url <- file.path(api_entry, dataset)

  # Download master file
  download.file(url, destfile = tmp)

  master <- fromJSON(tmp)
  years <- names(master) %>% str_replace_all(clean, "")
  # years <- years[1:2]

  for (i in 1:length(years)) {
    datapath <- file.path(api_entry, master[[i]]$files)
    tmp.year <- tempfile(fileext = ".json")
    tmp.year <- gsub("\\", "/", tmp.year, fixed = TRUE)
    download.file(datapath, tmp.year)
    master.year <- fromJSON(tmp.year)
    ext.year <- names(master.year)
    ext.year <- ext.year[ext.year != "csv"]
    data.year <-
      master.year[[ext]] %>%
      unlist() %>%
      as.data.frame(stringsAsFactors = FALSE)

    names(data.year) <- "api_file"
    data.year$api_file <- gsub(ext, "{ext}", data.year$api_file)
    rownames(data.year) <- c()

    data.year <- data.year %>%
      mutate(
        api_entry = api_entry,
        id_giscoR = name,
        ext = paste0(ext.year, collapse = ",")
      )
    if (exists("final.df")) {
      final.df <- bind_rows(final.df, data.year)
    } else {
      final.df <- data.year
    }
  }
  return(final.df)
}

# Get data----
coast.json <- dwndata(
  name = "coastallines",
  api_entry = "https://gisco-services.ec.europa.eu/distribution/v2/coas"
)


comm.json <- dwndata(
  name = "communes",
  api_entry = "https://gisco-services.ec.europa.eu/distribution/v2/communes"
)
countries.json <- dwndata(
  name = "countries",
  api_entry = "https://gisco-services.ec.europa.eu/distribution/v2/countries"
)
lau.json <- dwndata(
  name = "lau",
  api_entry = "https://gisco-services.ec.europa.eu/distribution/v2/lau"
)
nuts.json <- dwndata(
  name = "nuts",
  api_entry = "https://gisco-services.ec.europa.eu/distribution/v2/nuts"
)
urau.json <- dwndata(
  name = "urban_audit",
  api_entry = "https://gisco-services.ec.europa.eu/distribution/v2/urau"
)

# Join all----
df <- bind_rows(
  coast.json,
  comm.json,
  countries.json,
  lau.json,
  nuts.json,
  urau.json
)

# Assign values--

# EPSG
df$epsg <- NA
df[grep("3857", df$api_file), ]$epsg <- "3857"
df[grep("4326", df$api_file), ]$epsg <- "4326"
df[grep("3035", df$api_file), ]$epsg <- "3035"

allepsg <- unique(df$epsg)
for (i in seq_len(length(allepsg))) {
  df$api_file <- gsub(allepsg[i], "{epsg}", df$api_file)
}

df <- df %>%
  group_by(
    api_file,
    api_entry,
    id_giscoR,
    ext
  ) %>%
  summarise(epsg = paste(epsg, collapse = ","))


df <- as.data.frame(df)

# YEAR--
df$year <- NA
for (i in 2000:2024) {
  char <- as.character(i)
  r <- grep(char, df$api_file) %>% as.integer()
  if (length(r) > 0) {
    df[grep(char, df$api_file), ]$year <- char
  }
}

allyear <- sort(unique(df$year))
for (i in seq_len(length(allyear))) {
  df$api_file <- gsub(allyear[i], "{year}", df$api_file)
}


df <- df %>%
  group_by(
    api_file,
    api_entry,
    id_giscoR,
    ext,
    epsg
  ) %>%
  summarise(year = paste(year, collapse = ","))

df <- as_tibble(df)
# Resolution--
df$resolution <- NA
avres <- c("01", "03", "10", "20", "60", "100")
for (i in 1:length(avres)) {
  char <- avres[i]
  r <- grep(char, df$api_file) %>% as.integer()
  if (length(r) > 0) {
    df[grep(char, df$api_file), ]$resolution <- char
  }
}


allres <- unique(df$resolution)
allres <- allres[!is.na(allres)]
allres <- sort(allres, decreasing = TRUE)

for (i in seq_len(length(allres))) {
  df$api_file <- gsub(allres[i], "{resolution}", df$api_file)
}


df <- df %>%
  group_by(api_file, api_entry, id_giscoR, ext, epsg, year) %>%
  summarise(resolution = paste(resolution, collapse = ","))

df <- as.data.frame(df)
df[df$resolution == "NA", ]$resolution <- NA

df <- as.data.frame(df)


# Order matters - spatialtype
avspatialtype <- c("BN", "RG", "LB", "COASTL", "INLAND")
df$spatialtype <- NA
for (i in 1:length(avspatialtype)) {
  char <- avspatialtype[i]
  r <- grep(char, df$api_file) %>% as.integer()
  if (length(r) > 0) {
    df[grep(char, df$api_file), ]$spatialtype <- char
  }
}

# for (i in seq_len(length(avspatialtype))) {
#   df$api_file <- gsub(avspatialtype[i], "{spatialtype}", df$api_file)
# }

df <- df %>%
  group_by(api_file, api_entry, id_giscoR, ext, epsg, year, resolution) %>%
  summarise(spatialtype = paste(spatialtype, collapse = ","))

df <- as.data.frame(df)
# Different for NUTS and URBAN AUDIT

clean <- subset(df, id_giscoR != "nuts")
nuts <- subset(df, id_giscoR == "nuts")
urau <- subset(clean, id_giscoR == "urban_audit")
clean <- subset(clean, id_giscoR != "urban_audit")

# NUTS
nuts$nuts_level <- "all"

avnutslev <- c("LEVL_0", "LEVL_1", "LEVL_2", "LEVL_3")
for (i in 1:length(avnutslev)) {
  char <- avnutslev[i]
  r <- grep(char, nuts$api_file)
  if (length(r) > 0) {
    nuts[grep(char, nuts$api_file), ]$nuts_level <- char
  }
}
nuts$nuts_level <- str_replace_all(nuts$nuts_level, "LEVL_", "")
nums <- gsub("LEVL_", "", avnutslev)


for (j in seq_len(length(nums))) {
  nuts$api_file <- gsub(nums[j], "{nuts_level}", nuts$api_file)
}

nuts <- nuts %>%
  group_by(
    api_file,
    api_entry,
    id_giscoR,
    ext,
    epsg,
    year,
    resolution,
    spatialtype
  ) %>%
  summarise(nuts_level = paste(nuts_level, collapse = ","))
nuts <- as.data.frame(nuts)

# URBAN AUDIT

urau$level <- "all"
uraulev <-
  c("CITIES", "GREATER_CITIES", "FUA", "CITY", "KERN", "LUZ")
for (i in 1:length(uraulev)) {
  char <- uraulev[i]
  r <- grep(char, urau$api_file)
  if (length(r) > 0) {
    urau[grep(char, urau$api_file), ]$level <- char
  }
}

uraulev <-
  c("GREATER_CITIES", "CITIES", "FUA", "CITY", "KERN", "LUZ")

for (j in seq_len(length(uraulev))) {
  urau$api_file <- gsub(uraulev[j], "{level}", urau$api_file)
}


# Rejoin----
gisco_db <- bind_rows(clean, nuts, urau)

gisco_db <- as.data.frame(gisco_db)

gisco_db <-
  gisco_db %>%
  select(
    id_giscoR,
    year,
    epsg,
    resolution,
    spatialtype,
    nuts_level,
    level,
    ext,
    api_file,
    api_entry
  ) %>%
  arrange(id_giscoR, year, resolution, spatialtype, api_file) %>%
  as.data.frame() |>
  as_tibble()


usethis::use_data(gisco_db, overwrite = TRUE)
