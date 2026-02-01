# Retrieve and update the GISCO database in use by [giscoR](https://CRAN.R-project.org/package=giscoR)

Returns or optionally updates the cached database with the endpoints of
the GISCO API.

## Usage

``` r
gisco_get_cached_db(update_cache = FALSE)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>.

## Arguments

- update_cache:

  logical. On `TRUE` the cached database would be rebuilt with the most
  updated information of the GISCO API.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).

## Details

The cached database is stored in the
[giscoR](https://CRAN.R-project.org/package=giscoR) cache path, see
[`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md)
for details. The cached database would be used in subsequent **R**
sessions.

On new GISCO data releases, you can access the new updated data simply
by refreshing the cached database without waiting for a new version of
[giscoR](https://CRAN.R-project.org/package=giscoR).

A static database
[gisco_db](https://ropengov.github.io/giscoR/reference/gisco_db.md) is
shipped with the package. This database would be used in case there is
any problem on update.

## See also

Other database utils:
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md),
[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/reference/gisco_get_metadata.md)

## Examples

``` r
gisco_get_cached_db() |>
  dplyr::glimpse()
#> Rows: 9,714
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
#> $ last_updated <date> 2026-02-01, 2026-02-01, 2026-02-01, 2026-02-01, 2026-02-…
```
