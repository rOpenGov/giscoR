# Airports dataset

This dataset includes the location of over 11,800 Pan European airports
and heliports. The airports are identified using the International Civil
Aviation Organisation (ICAO) airport codes.

## Usage

``` r
gisco_get_airports(
  year = c(2013, 2006),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
)
```

## Source

<https://ec.europa.eu/eurostat/web/gisco/geodata/transport-networks>

Copyright: <https://ec.europa.eu/eurostat/web/gisco/geodata>

## Arguments

- year:

  character string or number. Release year of the file. One of `2013`,
  `2006`.

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

## See also

Other transport networks datasets:
[`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md)

## Examples

``` r
library(sf)

greece <- gisco_get_countries(country = "EL", resolution = 3)
airp_gc <- gisco_get_airports(2013, country = "EL")

library(ggplot2)

if (inherits(airp_gc, "sf")) {
  ggplot(greece) +
    geom_sf(fill = "grey80") +
    geom_sf(data = airp_gc, color = "blue") +
    labs(
      title = "Airports on Greece",
      shape = NULL,
      color = NULL,
      caption = gisco_attributions()
    )
}
```
