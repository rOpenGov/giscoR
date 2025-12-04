rm(list = ls())
# options(gisco_cache_dir = "~/R/mapslib/GISCO/")

library(giscoR)
library(sf)
library(countrycode)
library(dplyr)
library(ggplot2)

# sysfonts::font_add_google("Noto Serif")
# sysfonts::font_families_google()

map <- gisco_get_nuts(
  year = "2016",
  nuts_level = "3",
  resolution = "10",
  epsg = "3035"
)

f <-
  codelist |>
  select(eurostat, eu28) |>
  filter(!is.na(eu28), eurostat != "UK")

map <- inner_join(map, f, by = c("CNTR_CODE" = "eurostat"))

wrld <- gisco_get_countries(
  year = "2016",
  resolution = "10",
  epsg = "3035"
)

wrld <- wrld[!wrld$CNTR_ID %in% unique(map$CNTR_CODE), ]

a <- ggplot(map) +
  geom_sf(
    fill = "yellow1",
    colour = "yellow3",
    size = 0.05
  ) +
  geom_sf(
    data = wrld,
    colour = "yellow3",
    fill = NA,
    size = 0.1
  ) +
  theme_void() +
  theme(
    panel.grid.major = element_line(
      color = "yellow3",
      size = 0.1
    ),
    rect = element_rect(
      colour = "yellow3",
      fill = NA,
      size = 2
    )
  ) +
  coord_sf(
    xlim = c(1400000, 7650000),
    ylim = c(-1500000, 5500000),
    expand = TRUE
  )

a

library(hexSticker)

# fontinit <- as.character(windowsFonts("serif"))
# windowsFonts(serif = windowsFont("Noto Serif"))

sticker(
  a,
  package = "giscoR",
  s_width = 10,
  s_height = 2,
  s_x = 1,
  s_y = 0.6,
  filename = "man/figures/logoraw.png",
  h_color = "yellow3",
  h_fill = "deepskyblue4",
  p_y = 1.74,
  p_family = "Noto Serif",
  p_color = "yellow3",
  white_around_sticker = TRUE,
  p_size = 15,
  # p_family = "serif",
  # p_size = 30,
  # dpi = 600
)

# windowsFonts(serif = fontinit)
# windowsFonts("serif")
