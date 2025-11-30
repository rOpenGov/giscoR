# World coastal lines `POLYGON` object

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object as
provided by GISCO (2016 version).

## Format

A `POLYGON` [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object (resolution: 1:20million, EPSG:4326) with 3 variables:

- COAS_ID:

  Coast ID.

- FID:

  FID.

- geometry:

  geometry field.

## Source

[COAS_RG_20M_2016_4326.geojson](https://gisco-services.ec.europa.eu/distribution/v2/coas/geojson/)
file.

## See also

[`gisco_get_coastallines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastallines.md)

Other dataset:
[`gisco_countries`](https://ropengov.github.io/giscoR/reference/gisco_countries.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md),
[`gisco_nuts`](https://ropengov.github.io/giscoR/reference/gisco_nuts.md)

## Examples

``` r
data("gisco_coastallines")
head(gisco_coastallines)
#> Simple feature collection with 6 features and 1 field
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -180 ymin: -89 xmax: 179.9949 ymax: 83.65187
#> Geodetic CRS:  WGS 84
#> # A tibble: 6 × 2
#>   COAS_ID                                                               geometry
#>     <dbl>                                                          <POLYGON [°]>
#> 1       1 ((113.6473 22.70988, 113.7385 22.70698, 114.0376 22.5037, 113.8981 22…
#> 2       2 ((-58.83353 -63.55264, -59.49395 -63.83298, -59.87452 -63.83559, -60.…
#> 3       3 ((-94.64807 74.07687, -95.03269 73.98793, -95.11147 73.94852, -95.215…
#> 4       4 ((143.5061 -12.96175, 143.3915 -12.80046, 143.337 -12.54796, 143.133 …
#> 5       6 ((-76.4565 83.10617, -76.88173 82.97603, -76.404 82.69248, -77.3879 8…
#> 6       5 ((-34.8436 83.57385, -35.705 83.61014, -37.22521 83.55804, -37.75604 …
```
