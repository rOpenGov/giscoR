
<!-- README.md is generated from README.Rmd. Please edit that file -->

# giscoR <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/giscoR)](https://CRAN.R-project.org/package=giscoR)
[![CRAN
results](https://cranchecks.info/badges/worst/giscoR)](https://cran.r-project.org/web/checks/check_results_giscoR.html)
[![R build
status](https://github.com/dieghernan/giscoR/workflows/R-CMD-check/badge.svg)](https://github.com/dieghernan/giscoR/actions)
[![codecov](https://codecov.io/gh/dieghernan/giscoR/branch/master/graph/badge.svg)](https://codecov.io/gh/dieghernan/giscoR)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
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

opar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2), mar = c(3, 0, 2, 0))
plot(st_geometry(DNK_res60), main = "60M", col = "tomato")
plot(st_geometry(DNK_res20), main = "20M", col = "tomato")
plot(st_geometry(DNK_res10), main = "10M", col = "tomato")
plot(st_geometry(DNK_res03), main = "03M", col = "tomato")
title(sub = gisco_attributions(), line = 1)
```

![](https://raw.githubusercontent.com/dieghernan/giscoR/master/README-example-1.png)<!-- -->

``` r
par(opar)

# Labels and Lines available

labs <- gisco_get_countries(spatialtype = "LB", region = "Africa", epsg = "3857")
coast <- gisco_get_countries(spatialtype = "COASTL", epsg = "3857")

opar <- par(no.readonly = TRUE)
par(mar = c(3, 0, 0, 0))
plot(st_geometry(labs),
  col = c("springgreen4", "darkgoldenrod1", "red2"), cex = 2,
  pch = 19
)
plot(st_geometry(coast), col = "deepskyblue4", lwd = 6, add = TRUE)
title(sub = gisco_attributions(), line = 1)
```

![](https://raw.githubusercontent.com/dieghernan/giscoR/master/README-example-2.png)<!-- -->

``` r
par(opar)


# A thematic map with ggplot



countries <- gisco_get_countries(epsg = "3035")

nuts2 <- gisco_get_nuts(epsg = "3035", nuts_level = "2")
```

## Thematic maps

An example of a thematic map plotted with the `cartography` package. The
information is extracted via the `eurostat` package:

``` r


nuts3 <- gisco_get_nuts(
  year = "2016",
  epsg = "3035",
  resolution = "10",
  nuts_level = "3"
)

# Countries
countries <-
  gisco_get_countries(
    year = "2016",
    epsg = "3035",
    resolution = "10"
  )

library(eurostat)
library(cartography)

popdens <- get_eurostat("demo_r_d3dens")
popdens <- popdens[popdens$time == "2018-01-01", ]



nuts3.sf <- merge(nuts3,
  popdens,
  by.x = "NUTS_ID",
  by.y = "geo",
  all.x = TRUE
)

# Prepare mapping

br <- c(0, 25, 50, 100, 200, 500, 1000, 2500, 5000, 10000, 30000)
pal <-
  hcl.colors(
    n = (length(br) - 1),
    palette = "inferno",
    alpha = 0.7,
    rev = TRUE
  )


# Plot
opar <- par(no.readonly = TRUE)
par(mar = c(0, 0, 0, 0), bg = "#C6ECFF")

plot(
  st_geometry(countries),
  col = "#E0E0E0",
  lwd = 0.1,
  bg = "#C6ECFF",
  xlim = c(2300000, 7050000),
  ylim = c(1390000, 5400000),
)

choroLayer(
  nuts3.sf,
  var = "values",
  border = NA,
  breaks = br,
  col = pal,
  legend.pos = "n",
  colNA = "#E0E0E0",
  add = TRUE
)


# Add borders
plot(st_geometry(countries),
  lwd = 0.25,
  col = NA,
  add = TRUE
)


legendChoro(
  pos = "topright",
  title.txt = "Population density (km2)\nNUTS3 (2018)",
  breaks = c("", format(br, big.mark = ",")[-c(1, length(br))], ""),
  col = pal,
  nodata = T,
  nodata.txt = "n.d.",
  nodata.col = "#E0E0E0",
  frame = TRUE
)

layoutLayer(
  title = "Population density",
  scale = 1000,
  col = pal[3],
  sources = gisco_attributions(),
  author = "dieghernan, 2020"
)
```

![](https://raw.githubusercontent.com/dieghernan/giscoR/master/README-thematic-1.svg)<!-- -->

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

`eurostat` package (<https://ropengov.github.io/eurostat/>). This is
another API package that provides access to open data from Eurostat.

`wbstats` (<https://nset-ornl.github.io/wbstats/>) is an interesting R
API packages that provides access to [The World Bank
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
