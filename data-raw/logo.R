rm(list = ls())
#options(gisco_cache_dir = "~/R/mapslib/GISCO/")

library(giscoR)
library(sf)
library(countrycode)
library(dplyr)
library(ggplot2)

sysfonts::font_add_google("Noto Serif")
#sysfonts::font_families_google()


map <- gisco_get_nuts(
  year = "2016",
  nuts_level = "3",
  resolution = "10",
  crs = "3035"
)

f <-
  codelist %>% select(eurostat, eu28) %>% filter(!is.na(eu28), eurostat != "UK")

mapend <- inner_join(map, f, by = c("CNTR_CODE" = "eurostat"))


iso3codes <-
  countrycode::countrycode(unique(mapend$CNTR_CODE),
                           origin = "eurostat",
                           destination = "iso3c")

mapbborders <- gisco_get_nuts(
  year = "2016",
  nuts_level = "0",
  resolution = "10",
  crs = "3035",
  country = iso3codes
)



wrld <- gisco_get_countries(
  year = "2016",
  resolution = "10",
  crs = "3035",
  spatialtype = "COASTL"
)


a <- ggplot(mapend) + geom_sf(fill = "yellow1",
                              colour = "yellow3",
                              size = 0.1)   +
  geom_sf(
    data = mapbborders,
    fill = NA ,
    colour = "deepskyblue4",
    size = 0.1
  ) +
  geom_sf(data = wrld,
          colour = "yellow3",
          size = 0.1) +
  coord_sf(
    xlim = c(1400000, 7650000),
    ylim = c(1100000, 5500000),
    expand = TRUE
  ) + theme_void() +
  theme(panel.grid.major = element_line(color = "yellow3", size = 0.1))

a

library(hexSticker)

# fontinit <- as.character(windowsFonts("serif"))
# windowsFonts(serif = windowsFont("Georgia"))



sticker(
  a,
  package = "giscoR",
  s_width = 6,
  s_height = 1.3,
  s_x = 1,
  s_y = 0.85,
  filename = "man/figures/logo.svg",
  h_color = "yellow3",
  h_fill = "deepskyblue4",
  p_y = 1.67,
  p_size = 6.5,
  p_family = "Noto Serif",
  p_color = "yellow3",
  white_around_sticker = TRUE,
  dpi = 100
)
# windowsFonts(serif = fontinit)
# windowsFonts("serif")
