# Cached GISCO database

Database with the list of files in the GISCO geodata distribution as of
2026-06-19.

## Format

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with 10,987 rows.

## Source

GISCO geodata distribution `datasets.json`.

## Details

This database is used to redirect the corresponding functions to the
correct API endpoints.

This version of the database is used if there is a problem during
update. Please use
[`gisco_get_cached_db()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_cached_db.md)
with `update_cache = TRUE` to update the corresponding API endpoints.

## See also

Included datasets:
[`gisco_coastal_lines`](https://ropengov.github.io/giscoR/dev/reference/gisco_coastal_lines.md),
[`gisco_countries_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries_2024.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md),
[`gisco_nuts_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts_2024.md)

GISCO database and metadata:
[`gisco_get_cached_db()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_cached_db.md),
[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)

## Examples

``` r
data("gisco_db")
gisco_db |>
  dplyr::glimpse()
#> Rows: 10,987
#> Columns: 11
#> $ id_giscor    <chr> "coastal_lines", "coastal_lines", "coastal_lines", "coast…
#> $ year         <dbl> 2006, 2006, 2006, 2006, 2006, 2006, 2006, 2006, 2006, 200…
#> $ epsg         <dbl> 3035, 3035, 3035, 3035, 3035, 3035, 3035, 3035, 3035, 303…
#> $ resolution   <dbl> 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 10, 10, 10, 10, 10, 1…
#> $ spatialtype  <chr> "RG", "RG", "RG", "RG", "RG", "RG", "RG", "RG", "RG", "RG…
#> $ nuts_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ level        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ ext          <chr> "csv", "geojson", "gpkg", "json", "pbf", "shp", "csv", "g…
#> $ api_file     <chr> "csv/COAS_RG_01M_2006_3035.csv", "geojson/COAS_RG_01M_200…
#> $ api_entry    <chr> "https://gisco-services.ec.europa.eu/distribution/v2/coas…
#> $ last_updated <date> 2026-06-19, 2026-06-19, 2026-06-19, 2026-06-19, 2026-06-…
```
