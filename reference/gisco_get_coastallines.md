# Get GISCO coastlines [`sf`](https://r-spatial.github.io/sf/reference/sf.html) polygons

Downloads worldwide coastlines

## Usage

``` r
gisco_get_coastallines(
  year = "2016",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = "20"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

## Arguments

- year:

  Release year. One of `"2006"`, `"2010"`, `"2013"` or `"2016"`.

- epsg:

  character string or number. Projection of the map: 4-digit [EPSG
  code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326)

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035)

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857)

- cache:

  logical. Whether to do caching. Default is `TRUE`. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- verbose:

  logical. If `TRUE` displays informational messages.

- resolution:

  character string or number. Resolution of the geospatial data. One of:

  - `"60"`: 1:60million

  - `"20"`: 1:20million

  - `"10"`: 1:10million

  - `"03"`: 1:3million

  - `"01"`: 1:1million

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) `POLYGON`
object.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

## See also

[gisco_coastallines](https://ropengov.github.io/giscoR/reference/gisco_coastallines.md)

Other statistical units datasets:
[`gisco_get_census()`](https://ropengov.github.io/giscoR/reference/gisco_get_census.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md)

## Examples

``` r
coast <- gisco_get_coastallines()

library(ggplot2)

ggplot(coast) +
  geom_sf(color = "#1278AB", fill = "#FDFBEA") +
  # Zoom on Caribe
  coord_sf(
    xlim = c(-99, -49),
    ylim = c(4, 30)
  ) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "#C7E7FB", color = NA),
    panel.border = element_rect(colour = "black", fill = NA)
  )
```
