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
airp <- gisco_get_airports(year = 2013)
coast <- giscoR::gisco_coastal_lines

if (!is.null(airp)) {
  library(ggplot2)

  ggplot(coast) +
    geom_sf(fill = "grey10", color = "grey20") +
    geom_sf(
      data = airp, color = "#00F0FF",
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
      title = "Airports in Europe", subtitle = "Year 2013",
      caption = "Source: Eurostat, Airports 2013 dataset."
    ) +
    # Center in Europe: EPSG 3035
    coord_sf(
      crs = 3035,
      xlim = c(2377294, 7453440),
      ylim = c(1313597, 5628510)
    )
}
```
