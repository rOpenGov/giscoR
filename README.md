
<!-- README.md is generated from README.Rmd. Please edit that file -->

# giscoR <img src="man/figures/logo.png" align="right" width="120"/>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/giscoR)](https://CRAN.R-project.org/package=giscoR)
[![CRAN
results](https://cranchecks.info/badges/worst/giscoR)](https://cran.r-project.org/web/checks/check_results_giscoR.html)
[![r-universe](https://dieghernan.r-universe.dev/badges/giscoR)](https://dieghernan.r-universe.dev/)
[![R build
status](https://github.com/dieghernan/giscoR/workflows/R-CMD-check/badge.svg)](https://github.com/dieghernan/giscoR/actions)
[![codecov](https://codecov.io/gh/dieghernan/giscoR/branch/master/graph/badge.svg)](https://codecov.io/gh/dieghernan/giscoR)
![](https://cranlogs.r-pkg.org/badges/giscoR) [![Project Status: Active
– The project has reached a stable, usable state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![DOI](https://img.shields.io/badge/DOI-10.5281/zenodo.4317946-blue)](https://doi.org/10.5281/zenodo.4317946)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/giscor/badge)](https://www.codefactor.io/repository/github/dieghernan/giscor)

<!-- badges: end -->

[giscoR](https://dieghernan.github.io/giscoR/) is an API package that
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
<https://dieghernan.github.io/giscoR/>

## Installation

Install `giscoR` from
[**CRAN**](https://CRAN.R-project.org/package=giscoR):

``` r
install.packages("giscoR")
```

You can install the developing version of `giscoR` with:

``` r
library(remotes)
install_github("dieghernan/giscoR")
```

Alternatively, you can install `giscoR` using the
[r-universe](https://dieghernan.r-universe.dev/ui#builds):

``` r
# Enable this universe
options(repos = c(
  dieghernan = "https://dieghernan.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))


install.packages("giscoR")
```

## Usage

This script highlights some features of `giscoR`:

``` r

library(giscoR)
library(sf)

# Different resolutions
DNK_res60 <- gisco_get_countries(resolution = "60", country = "DNK")
DNK_res20 <-
  gisco_get_countries(resolution = "20", country = "DNK")
DNK_res10 <-
  gisco_get_countries(resolution = "10", country = "DNK")
DNK_res03 <-
  gisco_get_countries(resolution = "03", country = "DNK")


# Plot tmap

library(tmap)

plot60 <- qtm(DNK_res60, fill = "tomato", main.title = "60M")
plot20 <- qtm(DNK_res20, fill = "tomato", main.title = "20M")
plot10 <- qtm(DNK_res10, fill = "tomato", main.title = "10M")
plot03 <- qtm(DNK_res03, fill = "tomato", main.title = "03M")

tmap_arrange(plot60, plot20, plot10, plot03)
```

<img src="https://raw.githubusercontent.com/dieghernan/giscoR/master/img/README-example-1.svg" width="100%" />

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


tm_shape(coast, bbox = labs) +
  tm_lines("deepskyblue4") +
  tm_shape(labs) +
  tm_dots(
    col = "springgreen4",
    border.col = "darkgoldenrod1",
    shape = 21,
    border.lwd = 1,
    size = 1
  )
```

<img src="https://raw.githubusercontent.com/dieghernan/giscoR/master/img/README-example-2.svg" width="100%" />

## Labels

An example of a labeled map using `tmap`:

``` r

ITA <- gisco_get_nuts(country = "Italy", nuts_level = 1)


tm_shape(ITA, point.per = "feature") +
  tm_polygons() +
  tm_text("NAME_LATN")
```

<img src="https://raw.githubusercontent.com/dieghernan/giscoR/master/img/README-labels-1.svg" width="100%" />

## Thematic maps

An example of a thematic map plotted with the `tmap` package. The
information is extracted via the `eurostat` package:

``` r

nuts3 <- gisco_get_nuts(
  year = "2016",
  epsg = "3035",
  resolution = "3",
  nuts_level = "3"
)

# Countries
countries <-
  gisco_get_countries(
    year = "2016",
    epsg = "3035",
    resolution = "3"
  )

# Use eurostat
library(eurostat)

popdens <- get_eurostat("demo_r_d3dens")
popdens <- popdens[popdens$time == "2018-01-01", ]



nuts3.sf <- merge(nuts3,
  popdens,
  by.x = "NUTS_ID",
  by.y = "geo",
  all.x = TRUE
)

br <- c(0, 25, 50, 100, 200, 500, 1000, 2500, 5000, 10000, 30000)

# Plot
tm_shape(countries, bbox = c(23, 14, 74, 55) * 10e4) +
  tm_fill("#E0E0E0") +
  tm_shape(nuts3.sf) +
  tm_fill(
    "values",
    breaks = br,
    palette = "-inferno",
    alpha = .7,
    title = "Population density (km2)\nNUTS3 (2018)"
  ) +
  tm_shape(countries) +
  tm_borders(lwd = .25) +
  tm_credits(gisco_attributions(),
    position = c("left", "bottom")
  ) +
  tm_layout(
    bg.color = "#daf3ff",
    outer.bg.color = "white",
    legend.bg.color = "white",
    legend.frame = "black",
    legend.title.size = 0.8,
    inner.margins = c(0, 0, 0, 0),
    outer.margins = c(0, 0, 0, 0),
    frame = TRUE,
    frame.lwd = 0,
    attr.outside = TRUE
  )
```

<img src="https://raw.githubusercontent.com/dieghernan/giscoR/master/img/README-thematic-1.svg" width="100%" />

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

  - `eurostat` package (<https://ropengov.github.io/eurostat/>). This is
    an API package that provides access to open data from Eurostat.

### Plotting `sf` objects

Some packages recommended for visualization are:

  - [`tmap`](https://mtennekes.github.io/tmap/)
  - [`ggplot2`](https://github.com/tidyverse/ggplot2) +
    [`ggspatial`](https://github.com/paleolimbot/ggspatial)
  - [`mapsf`](https://riatelab.github.io/mapsf/)
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
