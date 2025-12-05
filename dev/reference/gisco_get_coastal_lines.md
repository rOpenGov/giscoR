# Coastal lines dataset

Downloads worldwide coastlines.

## Usage

``` r
gisco_get_coastal_lines(
  year = 2016,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = 20,
  ext = "gpkg"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>.

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>.

## Arguments

- year:

  character string or number. Release year of the file. One of `"2016"`,
  `"2013"`, `"2010"`, `"2006"` .

- epsg:

  character string or number. Projection of the map: 4-digit [EPSG
  code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

- cache:

  logical. Whether to do caching. Default is `TRUE`. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- verbose:

  logical. If `TRUE` displays informational messages.

- resolution:

  character string or number. Resolution of the geospatial data. One of:

  - `"60"`: 1:60 million.

  - `"20"`: 1:20 million.

  - `"10"`: 1:10 million.

  - `"03"`: 1:3 million.

  - `"01"`: 1:1 million.

- ext:

  character. Extension of the file (default `"gpkg"`). One of `"shp"`,
  `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

[gisco_coastal_lines](https://ropengov.github.io/giscoR/dev/reference/gisco_coastal_lines.md).

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

Other statistical units datasets:
[`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)

## Examples

``` r
coast <- gisco_get_coastal_lines()

library(ggplot2)

ggplot(coast) +
  geom_sf(color = "#1278AB", fill = "#FDFBEA") +
  # Zoom on Mediterranean Sea
  coord_sf(
    xlim = c(-4, 35),
    ylim = c(31, 45)
  ) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "#C7E7FB", color = NA),
    panel.border = element_rect(colour = "black", fill = NA)
  )
```
