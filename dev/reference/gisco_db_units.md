# Cached GISCO database for units

Database with the list of files that the package can load in units.

## Format

A data frame

## Source

GISCO API `datasets.json`.

## Details

This data frame is used to check the validity of the API calls.

## See also

Other dataset:
[`gisco_coastallines`](https://ropengov.github.io/giscoR/dev/reference/gisco_coastallines.md),
[`gisco_countries`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries.md),
[`gisco_countries_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries_2024.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md),
[`gisco_nuts`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts.md),
[`gisco_nuts_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts_2024.md)

Other database:
[`gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md),
[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)

## Examples

``` r
data("gisco_db_units")
```
