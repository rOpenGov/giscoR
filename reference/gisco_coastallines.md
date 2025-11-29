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

[`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastal_lines.md)

Other dataset:
[`gisco_countries`](https://ropengov.github.io/giscoR/reference/gisco_countries.md),
[`gisco_countries_2024`](https://ropengov.github.io/giscoR/reference/gisco_countries_2024.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md),
[`gisco_nuts`](https://ropengov.github.io/giscoR/reference/gisco_nuts.md)

## Examples

``` r
library(sf)
#> Linking to GEOS 3.13.1, GDAL 3.11.0, PROJ 9.6.0; sf_use_s2() is TRUE
data("gisco_coastallines")
gisco_coastallines
#> Simple feature collection with 2129 features and 1 field
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -180 ymin: -89 xmax: 180 ymax: 83.65187
#> Geodetic CRS:  WGS 84
#> # A tibble: 2,129 × 2
#>    COAS_ID                                                              geometry
#>  *   <int>                                                         <POLYGON [°]>
#>  1       1 ((113.6473 22.70988, 113.7385 22.70698, 114.0376 22.5037, 113.8981 2…
#>  2       2 ((-58.83353 -63.55264, -59.49395 -63.83298, -59.87452 -63.83559, -60…
#>  3       3 ((-94.64807 74.07687, -95.03269 73.98793, -95.11147 73.94852, -95.21…
#>  4       4 ((143.5061 -12.96175, 143.3915 -12.80046, 143.337 -12.54796, 143.133…
#>  5       6 ((-76.4565 83.10617, -76.88173 82.97603, -76.404 82.69248, -77.3879 …
#>  6       5 ((-34.8436 83.57385, -35.705 83.61014, -37.22521 83.55804, -37.75604…
#>  7      19 ((16.06003 80.01951, 15.97761 79.96032, 15.97309 79.87954, 15.70064 …
#>  8      21 ((172.7781 -40.77023, 172.688 -40.56407, 172.5863 -40.57173, 172.170…
#>  9       7 ((133.9832 -0.7584836, 133.4405 -0.7163446, 132.8097 -0.4098242, 132…
#> 10       8 ((116.7862 6.879588, 116.6918 6.875269, 115.8821 5.684854, 115.4644 …
#> # ℹ 2,119 more rows
```
