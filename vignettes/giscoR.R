## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE,
  out.width = "100%"
)

library(sf)
library(ggplot2) # Use ggplot for plotting

## ---- eval=FALSE--------------------------------------------------------------
#  gisco_set_cache_dir("./path/to/location")

## ---- message=TRUE------------------------------------------------------------
library(giscoR)
gisco_attributions(copyright = TRUE)

## ----country------------------------------------------------------------------

library(sf)
library(ggplot2) # Use ggplot for plotting


Asia <- gisco_get_countries(region = "Asia")


ggplot(Asia) +
  geom_sf(fill = "cornsilk", color = "#887e6a") +
  theme(
    panel.background = element_rect(fill = "#fffff3"),
    panel.border = element_rect(
      colour = "#887e6a",
      fill = NA,
      size = 1.5
    ),
    axis.text = element_text(
      family = "serif",
      colour = "#887e6a",
      face = "bold"
    )
  )

## ----africa-------------------------------------------------------------------

africa_north <-
  gisco_get_countries(
    country = c("Morocco", "Argelia", "Libia", "Tunisia", "Egypt"),
    resolution = "20",
    epsg = "4326",
    year = "2016"
  )

# Coastal lines

coast <- gisco_get_coastallines(
  resolution = "20",
  epsg = "4326",
  year = "2016"
)

# Plot

ggplot(coast) +
  geom_sf(color = "grey80") +
  geom_sf(data = africa_north, fill = "grey30", color = "white") +
  coord_sf(
    xlim = c(-13, 37),
    ylim = c(18.5, 40)
  ) +
  theme(
    axis.ticks = element_blank(),
    axis.text = element_blank()
  ) +
  facet_wrap(vars(NAME_ENGL), ncol = 2)

## ----giscoR, eval=FALSE-------------------------------------------------------
#
#  # EU members plus UK
#
#  eu2016 <- c("UK", gisco_countrycode[gisco_countrycode$eu, ]$CNTR_CODE)
#
#  nuts2 <- gisco_get_nuts(
#    year = "2016",
#    epsg = "3035",
#    resolution = "3",
#    nuts_level = "2",
#    country = eu2016
#  )
#
#  # Borders
#  borders <- gisco_get_countries(
#    epsg = "3035",
#    year = "2016",
#    resolution = "3",
#    country = eu2016
#  )
#
#  # Eurostat data - Purchase parity power
#  pps <- giscoR::tgs00026
#  pps <- pps[pps$time == 2016, ]
#
#  # Breaks
#  br <- c(0, seq(10, 25, 2.5), 1000) * 1000
#
#  nuts2.sf <- merge(nuts2,
#    pps,
#    by.x = "NUTS_ID",
#    by.y = "geo",
#    all.x = TRUE
#  )
#
#  # Cut
#  nuts2.sf$values_groups <- cut(nuts2.sf$values, breaks = br)
#
#  # Labels
#  labels <- paste0(br / 1000, "k")[-1]
#  labels[1] <- "<10k"
#  labels[8] <- ">25k"
#
#  # Plot
#  pal <- hcl.colors(8, "Spectral", alpha = 0.8)
#
#  ggplot(nuts2.sf) +
#    geom_sf(aes(fill = values_groups), color = NA, alpha = 0.9) +
#    geom_sf(data = borders, fill = NA, size = 0.1, col = "grey30") +
#    # Center in Europe: EPSG 3035
#    coord_sf(
#      xlim = c(2377294, 6500000),
#      ylim = c(1413597, 5228510)
#    ) +
#    labs(
#      title = "Disposable Incoming Households (2016)",
#      subtitle = "NUTS-2 level",
#      caption = paste0(
#        "Source: Eurostat\n ", gisco_attributions()
#      )
#    ) +
#    scale_fill_manual(
#      name = "euros",
#      values = pal,
#      drop = FALSE,
#      na.value = "black",
#      labels = labels,
#      guide = guide_legend(
#        direction = "horizontal",
#        keyheight = 0.5,
#        keywidth = 2,
#        title.position = "top",
#        title.hjust = 0,
#        label.hjust = .5,
#        nrow = 1,
#        byrow = TRUE,
#        reverse = FALSE,
#        label.position = "bottom"
#      )
#    ) +
#    theme_void() +
#    # Theme
#    theme(
#      plot.background = element_rect(fill = "black"),
#      plot.title = element_text(
#        color = "grey90",
#        hjust = 0.5,
#        vjust = -1,
#      ),
#      plot.subtitle = element_text(
#        color = "grey90",
#        hjust = 0.5,
#        vjust = -2,
#        face = "bold"
#      ),
#      plot.caption = element_text(
#        color = "grey90",
#        size = 6,
#        hjust = 0.5,
#        margin = margin(b = 2, t = 13)
#      ),
#      legend.text = element_text(
#        size = 7,
#        color = "grey90"
#      ),
#      legend.title = element_text(
#        size = 7,
#        color = "grey90"
#      ),
#      legend.position = c(0.5, 0.02)
#    )

## ----include_png3, echo=FALSE, out.width="100%"-------------------------------

# For better quality, including cache png
# From cache
knitr::include_graphics("choro.png")
