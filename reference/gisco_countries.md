# World countries `POLYGON` [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
including all countries as provided by GISCO (2016 version).

## Format

A `MULTIPOLYGON` data frame (resolution: 1:20million, EPSG:4326) object
with 257 rows and 7 variables:

- id:

  row ID.

- CNTR_NAME:

  Official country name on local language.

- ISO3_CODE:

  ISO 3166-1 alpha-3 code of each country, as provided by GISCO.

- CNTR_ID:

  Country ID.

- NAME_ENGL:

  Country name in English.

- FID:

  FID.

- geometry:

  geometry field.

## Source

[CNTR_RG_20M_2016_4326.geojson](https://gisco-services.ec.europa.eu/distribution/v2/countries/geojson/)
file.

## See also

[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md)

Other dataset:
[`gisco_coastallines`](https://ropengov.github.io/giscoR/reference/gisco_coastallines.md),
[`gisco_countries_2024`](https://ropengov.github.io/giscoR/reference/gisco_countries_2024.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md),
[`gisco_nuts`](https://ropengov.github.io/giscoR/reference/gisco_nuts.md)

## Examples

``` r
data("gisco_countries")
head(gisco_countries)
#> Simple feature collection with 6 features and 4 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -63.09693 ymin: 17.00297 xmax: 74.88986 ymax: 42.63545
#> Geodetic CRS:  WGS 84
#> # A tibble: 6 × 5
#>   CNTR_ID CNTR_NAME                ISO3_CODE NAME_ENGL                  geometry
#>   <chr>   <chr>                    <chr>     <chr>            <MULTIPOLYGON [°]>
#> 1 AE      الإمارات العربية المتحدة ARE       United A… (((56.26584 25.62472, 56…
#> 2 AF      افغانستان-افغانستان      AFG       Afghanis… (((74.7055 37.38216, 74.…
#> 3 AG      Antigua and Barbuda      ATG       Antigua … (((-61.80237 17.17129, -…
#> 4 AI      Anguilla                 AIA       Anguilla  (((-63.05444 18.17551, -…
#> 5 AL      Shqipëria                ALB       Albania   (((19.73314 42.63545, 19…
#> 6 AM      Հայաստան                 ARM       Armenia   (((46.45984 39.53191, 46…
```
