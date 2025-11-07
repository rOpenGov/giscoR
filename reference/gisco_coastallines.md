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
#> Simple feature collection with 6 features and 2 fields
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -180 ymin: -89 xmax: 179.9948 ymax: 83.65187
#> Geodetic CRS:  WGS 84
#>   COAS_ID FID                       geometry
#> 1       1   1 POLYGON ((113.6472 22.70988...
#> 2       2   2 POLYGON ((-58.83353 -63.552...
#> 3       3   3 POLYGON ((-94.64807 74.0768...
#> 4       4   4 POLYGON ((143.5061 -12.9617...
#> 5       6   6 POLYGON ((-76.4565 83.10617...
#> 6       5   5 POLYGON ((-34.8436 83.57385...
```
