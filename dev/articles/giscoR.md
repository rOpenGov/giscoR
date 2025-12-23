# Get started with giscoR

## Introduction

*Full site with more examples and vignettes on
<https://ropengov.github.io/giscoR/>*

[**giscoR**](https://ropengov.github.io/giscoR/) is a package designed
to provide a simple interface to the [GISCO
API](https://gisco-services.ec.europa.eu/distribution/v2/).

Within Eurostat, GISCO meets the European Commission’s geographical
information needs at three levels: the European Union, its member
countries, and its regions. GISCO provides shapefiles in different
formats, focusing especially on the European Union but also offering
some worldwide datasets such as country polygons, labels, borders, and
coastlines.

GISCO supplies data at multiple resolutions: high-detail datasets for
small areas (01M, 03M) and lightweight datasets for larger areas (10M,
20M, 60M). Datasets are available in three projections:
[EPSG:4326](https://epsg.io/4326), [EPSG:3035](https://epsg.io/3035),
and [EPSG:3857](https://epsg.io/3857).

**giscoR** returns
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) objects; see
<https://r-spatial.github.io/sf/> for details.

## Caching

**giscoR** supports caching of downloaded datasets. Set the cache
directory with:

``` r
gisco_set_cache_dir("./path/to/location")
```

If a file is not available locally, it will be downloaded to that
directory so subsequent requests for the same data will load from the
local cache.

If you experience any problems downloading, you can also manually
download the file from the [GISCO API
website](https://gisco-services.ec.europa.eu/distribution/v2/) and store
it in your local cache directory.

## Downloading data

Please note the following attribution and licensing requirements when
using GISCO data:

> [Eurostat’s general copyright notice and licence
> policy](https://ec.europa.eu/eurostat/web/main/help/copyright-notice)
> applies. Moreover, there are specific rules that apply to some of the
> following datasets available for downloading. The download and use of
> these data are subject to these rules being accepted. See our
> [administrative
> units](https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units)
> and [statistical
> units](https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units)
> for more details.
>
> Source: <https://ec.europa.eu/eurostat/web/gisco/geodata>

There is a function,
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md),
that provides guidance on this topic and returns attributions in several
languages.

``` r
library(giscoR)
c(
  gisco_attributions(lang = "en"),
  gisco_attributions(lang = "fr"),
  gisco_attributions(lang = "de")
) |> cat(sep = "\n\n")
#> © EuroGeographics for the administrative boundaries
#> 
#> © EuroGeographics pour les limites administratives
#> 
#> © EuroGeographics bezüglich der Verwaltungsgrenzen
```

## Basic example

Examples of downloading data: EU member states and candidate countries
as of 2024:

``` r
library(dplyr)
library(ggplot2)
world <- gisco_get_countries(resolution = 3, epsg = 3035)


world <- world |>
  mutate(
    status = case_when(
      EU_STAT == "T" ~ "Current members",
      CC_STAT == "T" ~ "Candidate countries",
      TRUE ~ NA
    ),
    # As levels
    status = factor(status, levels = c("Current members", "Candidate countries"))
  )

ggplot(world) +
  geom_sf(fill = "#c1c1c1") +
  geom_sf(aes(fill = status), color = "white") +
  guides(fill = guide_legend(direction = "horizontal")) +
  # Center in Europe: EPSG 3035
  coord_sf(
    xlim = c(2377294, 7453440),
    ylim = c(1313597, 5628510)
  ) +
  scale_fill_manual(
    values = c("#039", "#2782bb"), na.value = "#c1c1c1",
    na.translate = FALSE
  ) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "grey90", color = NA),
    axis.line = element_blank(),
    axis.text = element_blank(),
    panel.grid = element_blank(),
    legend.position = "bottom"
  ) +
  labs(
    title = "EU Member states and Candidate countries (2024)",
    caption = gisco_attributions(),
    fill = ""
  )
```

![EU Member states and Candidate countries (2024)](country-1.png)

EU Member states and Candidate countries (2024)

You can select specific countries by name (in any language), ISO3 codes,
or Eurostat codes. However, you cannot mix these identifier types in a
single call.

You can also combine different datasets — set `resolution` and `epsg`
(and optionally `year`) to the same value:

``` r
cntr <- c("Morocco", "Algeria", "Tunisia", "Libya", "Egypt")

africa_north <- gisco_get_countries(
  country = cntr,
  resolution = "03",
  epsg = "4326", year = "2024"
)

# For ordering the plot

africa_north$NAME_ENGL <- factor(africa_north$NAME_ENGL, levels = cntr)
# Coastlines

coast <- gisco_get_coastal_lines(
  resolution = "03",
  epsg = "4326",
  year = "2016"
)

# Plot
ggplot(coast) +
  geom_sf(color = "#B9B9B9") +
  geom_sf(data = africa_north, fill = "#346733", color = "#335033") +
  coord_sf(xlim = c(-13, 37), ylim = c(18.5, 40)) +
  facet_wrap(vars(NAME_ENGL), ncol = 2) +
  labs(caption = gisco_attributions("fr"))
```

![Political map of North Africa](africa-1.png)

Political map of North Africa

## Thematic maps with **giscoR**

This example shows how **giscoR** can be used together with Eurostat
data. For plotting we use **ggplot2**; however, any package that
supports `sf` objects (e.g., **tmap**, **mapsf**, **leaflet**) can be
used.

``` r
# EU members
library(giscoR)
library(dplyr)
library(eurostat)
library(ggplot2)

nuts2 <- gisco_get_nuts(
  year = "2021", epsg = "3035", resolution = "10",
  nuts_level = "2"
)
# Borders from countries
borders <- gisco_get_countries(epsg = "3035", year = "2020", resolution = "3")

eu_bord <- borders |>
  filter(CNTR_ID %in% nuts2$CNTR_CODE)

# Eurostat data - Disposable income
pps <- get_eurostat("tgs00026") |>
  filter(TIME_PERIOD == "2022-01-01")

nuts2_sf <- nuts2 |>
  left_join(pps, by = "geo") |>
  mutate(
    values_th = values / 1000,
    categ = cut(values_th, c(0, 15, 30, 60, 90, 120, Inf))
  )


# Adjust the labels
labs <- levels(nuts2_sf$categ)
labs[1] <- "< 15"
labs[6] <- "> 120"
levels(nuts2_sf$categ) <- labs


# Finally the plot
ggplot(nuts2_sf) +
  # Background
  geom_sf(data = borders, fill = "#e1e1e1", color = NA) +
  geom_sf(aes(fill = categ), color = "grey20", linewidth = .1) +
  geom_sf(data = eu_bord, fill = NA, color = "black", linewidth = .15) +
  # Center in Europe: EPSG 3035
  coord_sf(xlim = c(2377294, 6500000), ylim = c(1413597, 5228510)) +
  # Legends and color
  scale_fill_manual(
    values = hcl.colors(length(labs), "Geyser", rev = TRUE),
    # Label NA
    labels = function(x) {
      ifelse(is.na(x), "No Data", x)
    },
    na.value = "#e1e1e1"
  ) +
  guides(fill = guide_legend(nrow = 1)) +
  theme_void() +
  theme(
    text = element_text(colour = "grey0"),
    panel.background = element_rect(fill = "#97dbf2"),
    panel.border = element_rect(fill = NA, color = "grey10"),
    plot.title = element_text(hjust = 0.5, vjust = -1, size = 12),
    plot.subtitle = element_text(
      hjust = 0.5, vjust = -2, face = "bold",
      margin = margin(b = 10, t = 5), size = 12
    ),
    plot.caption = element_text(
      size = 8, hjust = 0, margin =
        margin(b = 4, t = 8)
    ),
    legend.text = element_text(size = 7, ),
    legend.title = element_text(size = 7),
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.text.position = "bottom",
    legend.title.position = "top",
    legend.key.height = rel(0.5),
    legend.key.width = unit(.1, "npc")
  ) +
  # Annotate and labels
  labs(
    title = "Disposable income of private households (2022)",
    subtitle = "NUTS-2 level",
    fill = "euros (thousands)",
    caption = paste0(
      "Source: Eurostat, ", gisco_attributions()
    )
  )
```

![Disposable income of private households by NUTS 2 regions
(2022)](giscoR-1.png)

Disposable income of private households by NUTS 2 regions (2022)
