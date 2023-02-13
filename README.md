
<!-- README.md is generated from README.Rmd. Please edit that file -->

# giscoR <a href='https://ropengov.github.io/giscoR/'><img src="man/figures/logo.png" align="right" height="139"/></a>

<!-- badges: start -->

[![rOG-badge](https://ropengov.github.io/rogtemplate/reference/figures/ropengov-badge.svg)](https://ropengov.org/)
[![CRAN
status](https://www.r-pkg.org/badges/version/giscoR)](https://CRAN.R-project.org/package=giscoR)
[![CRAN
results](https://badges.cranchecks.info/worst/giscoR.svg)](https://cran.r-project.org/web/checks/check_results_giscoR.html)
[![Downloads](https://cranlogs.r-pkg.org/badges/giscoR)](https://CRAN.R-project.org/package=giscoR)
[![r-universe](https://ropengov.r-universe.dev/badges/giscoR)](https://ropengov.r-universe.dev/)
[![R build
status](https://github.com/rOpenGov/giscoR/workflows/R-CMD-check/badge.svg)](https://github.com/rOpenGov/giscoR/actions)
[![codecov](https://codecov.io/gh/ropengov/giscoR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ropengov/giscoR)
[![DOI](https://img.shields.io/badge/DOI-10.5281/zenodo.4317946-blue)](https://doi.org/10.5281/zenodo.4317946)
[![Project Status:
Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![status](https://tinyverse.netlify.com/badge/giscoR)](https://CRAN.R-project.org/package=giscoR)

<!-- badges: end -->

[giscoR](https://ropengov.github.io/giscoR//) is an API package that
helps to retrieve data from [Eurostat - GISCO (the Geographic
Information System of the
COmmission)](https://ec.europa.eu/eurostat/web/gisco). It also provides
some lightweight data sets ready to use without downloading.

GISCO [(FAQ)](https://ec.europa.eu/eurostat/web/gisco/faq) is a
geospatial open data repository including several data sets as
countries, coastal lines, labels or [NUTS
levels](https://ec.europa.eu/eurostat/web/regions-and-cities/overview).
The data sets are usually provided at several resolution levels
(60M/20M/10M/03M/01M) and in 3 different projections (4326/3035/3857).

Note that the package does not provide metadata on the downloaded files,
the information is available on the [API
webpage](https://gisco-services.ec.europa.eu/distribution/v2/).

Full site with examples and vignettes on
<https://ropengov.github.io/giscoR/>

## Installation

Install `giscoR` from
[**CRAN**](https://CRAN.R-project.org/package=giscoR):

``` r
install.packages("giscoR")
```

You can install the developing version of `giscoR` with:

``` r
library(remotes)
install_github("rOpenGov/giscoR")
```

Alternatively, you can install `giscoR` using the
[r-universe](https://ropengov.r-universe.dev/giscoR):

``` r
# Enable this universe
options(repos = c(
  ropengov = "https://ropengov.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))


install.packages("giscoR")
```

## Usage

This script highlights some features of `giscoR`:

``` r
library(giscoR)
library(sf)
library(dplyr)

# Different resolutions
DNK_res60 <- gisco_get_countries(resolution = "60", country = "DNK") %>%
  mutate(res = "60M")
DNK_res20 <-
  gisco_get_countries(resolution = "20", country = "DNK") %>%
  mutate(res = "20M")
DNK_res10 <-
  gisco_get_countries(resolution = "10", country = "DNK") %>%
  mutate(res = "10M")
DNK_res03 <-
  gisco_get_countries(resolution = "03", country = "DNK") %>%
  mutate(res = "03M")


DNK_all <- bind_rows(DNK_res60, DNK_res20, DNK_res10, DNK_res03)

# Plot ggplot2

library(ggplot2)

ggplot(DNK_all) +
  geom_sf(fill = "tomato") +
  facet_wrap(vars(res)) +
  theme_minimal()
```

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-example-1.png" width="100%" />

``` r


# Labels and Lines available

labs <- gisco_get_countries(
  spatialtype = "LB",
  region = "Africa",
  epsg = "3857"
)

coast <- gisco_get_countries(
  spatialtype = "COASTL",
  epsg = "3857"
)

# For zooming
afr_bbox <- st_bbox(labs)

ggplot(coast) +
  geom_sf(col = "deepskyblue4", linewidth = 3) +
  geom_sf(data = labs, fill = "springgreen4", col = "darkgoldenrod1", size = 5, shape = 21) +
  coord_sf(
    xlim = afr_bbox[c("xmin", "xmax")],
    ylim = afr_bbox[c("ymin", "ymax")]
  )
```

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-example-2.png" width="100%" />

### Labels

An example of a labeled map using `ggplot2`:

``` r
ITA <- gisco_get_nuts(country = "Italy", nuts_level = 1)

ggplot(ITA) +
  geom_sf() +
  geom_sf_text(aes(label = NAME_LATN)) +
  theme(axis.title = element_blank())
```

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-labels-1.png" width="100%" />

### Thematic maps

An example of a thematic map plotted with the `ggplot2` package. The
information is extracted via the `eurostat` package. We would follow the
fantastic approach presented by [Milos
Popovic](https://twitter.com/milos_agathon) on [this
post](https://milospopovic.net/how-to-make-choropleth-map-in-r/):

``` r
# Get shapes
nuts3 <- gisco_get_nuts(
  year = "2016",
  epsg = "3035",
  resolution = "3",
  nuts_level = "3"
)

# Group by NUTS by country and convert to lines
country_lines <- nuts3 %>%
  group_by(
    CNTR_CODE
  ) %>%
  summarise(n = n()) %>%
  st_cast("MULTILINESTRING")


# Use eurostat
library(eurostat)

popdens <- get_eurostat("demo_r_d3dens")
popdens <- popdens[popdens$time == "2018-01-01", ]


# Merge data
nuts3.sf <- merge(nuts3,
  popdens,
  by.x = "NUTS_ID",
  by.y = "geo",
  all.x = TRUE
)

# Breaks and labels

br <- c(0, 25, 50, 100, 200, 500, 1000, 2500, 5000, 10000, 30000)

nuts3.sf$values_cut <- cut(nuts3.sf$values,
  breaks = br,
  dig.lab = 5
)

labs_plot <- prettyNum(br[-1], big.mark = ",")


# Palette
pal <- hcl.colors(length(br) - 1, "Lajolla")


# Plot

ggplot(nuts3.sf) +
  geom_sf(aes(fill = values_cut), linewidth = 0, color = NA, alpha = 0.9) +
  geom_sf(data = country_lines, col = "black", linewidth = 0.1) +
  # Center in Europe: EPSG 3035
  coord_sf(
    xlim = c(2377294, 7453440),
    ylim = c(1313597, 5628510)
  ) +
  labs(
    title = "Population density in 2018",
    subtitle = "NUTS-3 level",
    caption = paste0(
      "Source: Eurostat, ", gisco_attributions(),
      "\nBased on Milos Popovic: https://milospopovic.net/how-to-make-choropleth-map-in-r/"
    )
  ) +
  scale_fill_manual(
    name = "people per sq. kilometer",
    values = pal,
    labels = labs_plot,
    drop = FALSE,
    guide = guide_legend(
      direction = "horizontal",
      keyheight = 0.5,
      keywidth = 2.5,
      title.position = "top",
      title.hjust = 0.5,
      label.hjust = .5,
      nrow = 1,
      byrow = TRUE,
      reverse = FALSE,
      label.position = "bottom"
    )
  ) +
  theme_void() +
  # Theme
  theme(
    plot.title = element_text(
      size = 20, color = pal[length(pal) - 1],
      hjust = 0.5, vjust = -6
    ),
    plot.subtitle = element_text(
      size = 14,
      color = pal[length(pal) - 1],
      hjust = 0.5, vjust = -10, face = "bold"
    ),
    plot.caption = element_text(
      size = 9, color = "grey60",
      hjust = 0.5, vjust = 0,
      margin = margin(t = 5, b = 10)
    ),
    legend.text = element_text(
      size = 10,
      color = "grey20"
    ),
    legend.title = element_text(
      size = 11,
      color = "grey20"
    ),
    legend.position = "bottom"
  )
```

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-thematic-1.png" width="100%" />

## A note on caching

Some data sets (as Local Administrative Units - LAU, or high-resolution
files) may have a size larger than 50MB. You can use `giscoR` to create
your own local repository at a given local directory passing the
following function:

``` r
gisco_set_cache_dir("./path/to/location")
```

You can also download manually the files (`.geojson` format) and store
them on your local directory.

## Recommended packages

### API data packages

- `eurostat` package (<https://ropengov.github.io/eurostat/>). This is
  an API package that provides access to open data from Eurostat.

### Plotting `sf` objects

Some packages recommended for visualization are:

- [`tmap`](https://r-tmap.github.io/tmap/)
- [`ggplot2`](https://github.com/tidyverse/ggplot2) +
  [`ggspatial`](https://github.com/paleolimbot/ggspatial)
- [`mapsf`](https://riatelab.github.io/mapsf/)
- [`leaflet`](https://rstudio.github.io/leaflet/)

## Contribute

Check the GitHub page for [source
code](https://github.com/rOpenGov/giscoR/).

Contributions are very welcome:

- [Use issue tracker](https://github.com/rOpenGov/giscoR/issues) for
  feedback and bug reports.
- [Send pull requests](https://github.com/rOpenGov/giscoR/)
- [Star us on the GitHub page](https://github.com/rOpenGov/giscoR)

## Citation

To cite ‘giscoR’ in publications use:

Hernangomez D (2023). giscoR: Download Map Data from GISCO API -
Eurostat. <https://doi.org/10.5281/zenodo.4317946>,
<https://ropengov.github.io/giscoR/>

A BibTeX entry for LaTeX users is

    @Manual{R-giscoR,
      title = {{giscoR}: Download Map Data from GISCO API - Eurostat},
      doi = {10.5281/zenodo.4317946},
      author = {Diego Hernangómez},
      year = {2023},
      version = {0.3.3},
      url = {https://ropengov.github.io/giscoR/},
      abstract = {Tools to download data from the GISCO (Geographic Information System of the Commission) Eurostat database <https://ec.europa.eu/eurostat/web/gisco>. Global and European map data available. This package is in no way officially related to or endorsed by Eurostat.},
    }

## Copyright notice

*From GISCO \> Geodata \> Reference data \> Administrative Units /
Statistical Units*

> When data downloaded from this page is used in any printed or
> electronic publication, in addition to any other provisions applicable
> to the whole Eurostat website, data source will have to be
> acknowledged in the legend of the map and in the introductory page of
> the publication with the following copyright notice:
>
> EN: © EuroGeographics for the administrative boundaries
>
> FR: © EuroGeographics pour les limites administratives
>
> DE: © EuroGeographics bezüglich der Verwaltungsgrenzen
>
> For publications in languages other than English, French or German,
> the translation of the copyright notice in the language of the
> publication shall be used.

If you intend to use the data commercially, please contact
EuroGeographics for information regarding their license agreements.

## Disclaimer

This package is in no way officially related to or endorsed by Eurostat.
