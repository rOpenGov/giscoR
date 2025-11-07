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

[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get.md)

Other dataset:
[`gisco_coastallines`](https://ropengov.github.io/giscoR/reference/gisco_coastallines.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md),
[`gisco_nuts`](https://ropengov.github.io/giscoR/reference/gisco_nuts.md)

## Examples

``` r
data("gisco_countries")
head(gisco_countries)
#> Simple feature collection with 6 features and 5 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -63.09693 ymin: 17.00297 xmax: 74.88986 ymax: 42.63545
#> Geodetic CRS:  WGS 84
#>   CNTR_ID                CNTR_NAME ISO3_CODE            NAME_ENGL FID
#> 1      AE الإمارات العربية المتحدة       ARE United Arab Emirates  AE
#> 2      AF      افغانستان-افغانستان       AFG          Afghanistan  AF
#> 3      AG      Antigua and Barbuda       ATG  Antigua and Barbuda  AG
#> 4      AI                 Anguilla       AIA             Anguilla  AI
#> 5      AL                Shqipëria       ALB              Albania  AL
#> 6      AM                 Հայաստան       ARM              Armenia  AM
#>                         geometry
#> 1 MULTIPOLYGON (((56.35462 25...
#> 2 MULTIPOLYGON (((74.7055 37....
#> 3 MULTIPOLYGON (((-61.80237 1...
#> 4 MULTIPOLYGON (((-63.05444 1...
#> 5 MULTIPOLYGON (((19.831 42.4...
#> 6 MULTIPOLYGON (((46.45984 39...
```
