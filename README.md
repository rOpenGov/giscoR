
<!-- README.md is generated from README.Rmd. Please edit that file -->

# giscoR <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/dieghernan/giscoR.svg?branch=master)](https://travis-ci.com/dieghernan/giscoR)
[![R build
status](https://github.com/dieghernan/giscoR/workflows/R-CMD-check/badge.svg)](https://github.com/dieghernan/giscoR/actions)
[![License](https://img.shields.io/badge/license-GPL—3.0-blue)](https://github.com/dieghernan/giscoR/blob/master/LICENSE.md)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![codecov](https://codecov.io/gh/dieghernan/giscoR/branch/master/graph/badge.svg)](https://codecov.io/gh/dieghernan/giscoR)
<!-- badges: end -->

[giscoR](https://dieghernan.github.io/giscoR/) is a API package that
helps to retrieve data from [Eurostat - GISCO (the Geographic
Information System of the
COmmission)](https://ec.europa.eu/eurostat/web/gisco). It also provides
some lightweight data sets ready to use without downloading. Currently
only the [Administrative Units / Statistical
Units](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units)
data sets are supported.

GISCO [(FAQ)](https://ec.europa.eu/eurostat/web/gisco/faq) is a
geospatial open data repository including several data sets as
countries, coastal lines, labels or [NUTS
levels](https://ec.europa.eu/eurostat/web/regions-and-cities/overview).
The data sets are usually provided at several resolution levels
(60M/20M/10M/03M/01M) and in 3 different projections (4326/3035/3857).

Note that the package does not provide metadata on the downloaded files,
the information is available on the [API
webpage](https://gisco-services.ec.europa.eu/distribution/v2/).

## Installation

You can install the developing version of `giscoR` with:

``` r

library(remotes)
install_github("dieghernan/giscoR")
```

## Usage

This script quickly shows how the data retrieved with giscoR can be
represented with a sample of complementary packages:

``` r

library(giscoR)

countries <- gisco_get_countries(epsg = "3035")

nuts2 <- gisco_get_nuts(epsg = "3035", nuts_level = "2")

# With ggplot2

library(ggplot2)
ggplot(countries) +
  geom_sf(
    colour = "grey50",
    fill = "cornsilk",
    size = 0.1
  ) +
  geom_sf(
    data = nuts2,
    colour = "darkblue",
    fill = NA,
    size = 0.05
  ) +
  coord_sf(
    xlim = c(2200000, 7150000),
    ylim = c(1380000, 5500000),
    expand = TRUE
  ) +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("NUTS2 Regions (2016)") +
  theme(
    panel.grid.major = element_line(
      color = gray(.5),
      linetype = "dashed",
      size = 0.5
    ),
    panel.background = element_rect(fill = "aliceblue")
  ) +
  labs(caption = gisco_attributions(copyright = FALSE))
```

![](man/figures/README-example-1.png)<!-- -->

``` r


# With tmap

library(tmap)

cities <-
  gisco_get_urban_audit(
    year = "2020",
    level = "GREATER_CITIES",
    country = c("BEL", "NLD", "LUX")
  )
#> [1] "https://gisco-services.ec.europa.eu/distribution/v2/urau/geojson/URAU_RG_100K_2020_4326_GREATER_CITIES.geojson"
#> [1] "Loading from cache dir: /tmp/RtmpXqhQFh/gisco"
#> 312 Kb

countries <- gisco_get_countries(country = c("BEL", "NLD", "LUX"), resolution = "01")

tm_shape(countries) + tm_fill("black") + tm_borders("grey10") + tm_shape(cities) + tm_fill("chartreuse1") +
  tm_credits(gisco_attributions(copyright = FALSE),
    position = c("LEFT", "BOTTOM")
  ) + tm_layout(
    main.title = "Urban Audit 2020: Greater cities of Benelux",
    frame = TRUE,
    attr.outside = TRUE,
    main.title.size = 0.75,
    bg.color = "grey85"
  )
```

![](man/figures/README-example-2.png)<!-- -->

``` r


# With cartography

library(cartography)
globe <- gisco_get_countries(epsg = "3035")
globe <- merge(globe, gisco_countrycode, all.x = TRUE)
opar <- par(no.readonly = TRUE)
par(mar = c(2, 2, 2, 2))
typoLayer(globe, var = "un.region.name", legend.pos = "n")
layoutLayer(
  "Regions of the World (UN)",
  sources = gisco_attributions(copyright = FALSE),
  scale = FALSE,
  horiz = TRUE
)
```

![](man/figures/README-example-3.png)<!-- -->

``` r
par(opar)
```

### A note on caching

Some data sets (as Local Administrative Units - LAU, or high-resolution
files) may have a size larger than 50MB. You can use `giscoR` to create
your own local repository at a given local directory passing the
following option:

``` r
options(gisco_cache_dir = "./path/to/location")
```

When this option is set, `giscoR` would look for the cached file and it
will load it, speeding up the process.

You can also download manually the files (`.geojson` format) and store
them on your local directory.

## Recommended packages

### API data packages

It is recommended to install the `eurostat` package
(<https://ropengov.github.io/eurostat>), that is another API package
that queries [Eurostat](https://ec.europa.eu/eurostat/) for statistical
information.

`wbstats`(<https://nset-ornl.github.io/wbstats/>) is another interesting
R API packages that provides access to [The World Bank
Data](https://data.worldbank.org/) API.

### Plotting `sf` objects

Some packages recommended for visualization are:

  - [`tmap`](https://mtennekes.github.io/tmap/)  
  - [`cartography`](http://riatelab.github.io/cartography/docs/)
  - [`ggplot2`](https://github.com/tidyverse/ggplot2) +
    [`ggspatial`](https://github.com/paleolimbot/ggspatial)
  - [`leaflet`](https://rstudio.github.io/leaflet/)

## Contribute

Check the Github page for [source
code](https://github.com/dieghernan/giscoR/).

Contributions are very welcome:

  - [Use issue tracker](https://github.com/dieghernan/giscoR/issues) for
    feedback and bug reports.
  - [Send pull requests](https://github.com/dieghernan/giscoR/)
  - [Star us on the Github page](https://github.com/dieghernan/giscoR)

## Copyright notice

*From GISCO \> Geodata \> Reference data \> Administrative Units /
Statistical Units*

When data downloaded from this page is used in any printed or electronic
publication, in addition to any other provisions applicable to the whole
Eurostat website, data source will have to be acknowledged in the legend
of the map and in the introductory page of the publication with the
following copyright notice:

EN: © EuroGeographics for the administrative boundaries

FR: © EuroGeographics pour les limites administratives

DE: © EuroGeographics bezüglich der Verwaltungsgrenzen

For publications in languages other than English, French or German, the
translation of the copyright notice in the language of the publication
shall be used.

If you intend to use the data commercially, please contact
EuroGeographics for information regarding their licence agreements.

## Disclaimer

This package is in no way officially related to or endorsed by Eurostat.
