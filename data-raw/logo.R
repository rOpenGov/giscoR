rm(list = ls())

library(giscoR)
library(sf)
library(countrycode)
library(dplyr)

map <- gisco_get_nuts(
  year = "2016",
  nuts_level = "0",
  resolution = "60",
  crs = "3035"
)

f <-
  codelist %>% select(eurostat, eu28) %>% filter(!is.na(eu28), eurostat != "UK")

mapend <- inner_join(map, f, by = c("CNTR_CODE" = "eurostat"))

wrld <- gisco_get_countries(
  year = "2016",
  resolution = "60",
  crs = "3035",
  spatialtype = "COASTL"
)

grat <- st_graticule(ndiscr = 500) %>% st_transform(3035)




svg(
  "a.svg",
  bg = NA,
  width = 10,
  height = 8,
  pointsize = 20
)
par(mar = c(4, 2, 0, 2))
plot(
  st_geometry(grat),
  col = "yellow1",
  xlim = c(2200000, 7150000),
  ylim = c(1380000, 5500000),
  bg = NA,
  lwd = 4
)
plot(st_geometry(mapend),
     col = "yellow3",
     border = "yellow3",
     add = TRUE)
plot(st_geometry(wrld),
     add  = TRUE,
     col = "yellow1",
     lwd = 2)
dev.off()

library(hexSticker)
fontinit <- as.character(windowsFonts("serif"))
windowsFonts(serif = windowsFont("Georgia"))

sticker(
  "a.svg",
  package = "giscoR",
  p_size = 20,
  s_x = 1,
  s_width = 0.9,
  filename = "man/figures/logo.png",
  h_color = "yellow3",
  h_fill = "deepskyblue4",
  p_y = 1.65,
  p_family = "serif",
  p_color = "yellow3",
  white_around_sticker = TRUE

)


windowsFonts(serif = fontinit)

windowsFonts("serif")

file.remove("a.svg")
