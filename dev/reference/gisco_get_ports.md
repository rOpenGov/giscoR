# Ports dataset

This dataset includes the location of over 2,440 Pan European ports. The
ports are identified following the UN LOCODE list.

## Usage

``` r
gisco_get_ports(
  year = c(2013, 2009),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
)
```

## Source

<https://ec.europa.eu/eurostat/web/gisco/geodata/transport-networks>.

Copyright: <https://ec.europa.eu/eurostat/web/gisco/geodata>.

## Arguments

- year:

  character string or number. Release year of the file. One of `2013`,
  `2009`.

- country:

  character vector of country codes. It could be either a vector of
  country names, a vector of ISO3 country codes or a vector of Eurostat
  country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- verbose:

  logical. If `TRUE` displays informational messages.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

Dataset includes objects in [EPSG:4326](https://epsg.io/4326).

`gisco_get_ports()` adds a new field CNTR_ISO2 to the original data
identifying the country of the port.

## See also

Other transport networks datasets:
[`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md)

## Examples

``` r
library(sf)

ports <- gisco_get_ports(2013)
coast <- giscoR::gisco_coastal_lines

if (!is.null(ports)) {
  library(ggplot2)

  ggplot(coast) +
    geom_sf(fill = "grey10", color = "grey20") +
    geom_sf(
      data = ports, color = "#6bb857",
      size = 0.2, alpha = 0.25
    ) +
    theme_void() +
    theme(
      plot.background = element_rect(fill = "black"),
      text = element_text(color = "white"),
      panel.grid = element_blank(),
      plot.title = element_text(face = "bold", hjust = 0.5),
      plot.subtitle = element_text(face = "italic", hjust = 0.5)
    ) +
    labs(
      title = "Ports Worldwide", subtitle = "Year 2013",
      caption = "Source: Eurostat, Ports 2013 dataset."
    ) +
    coord_sf(crs = "ESRI:54030")
}
```
