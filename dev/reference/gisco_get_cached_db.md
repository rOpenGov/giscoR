# Retrieve and update the GISCO database used by [giscoR](https://CRAN.R-project.org/package=giscoR)

Returns or optionally updates the cached database with endpoints from
the GISCO geodata distribution.

## Usage

``` r
gisco_get_cached_db(update_cache = FALSE)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>.

## Arguments

- update_cache:

  A logical value. If `TRUE`, rebuild the cached database with the most
  recent information from the GISCO geodata distribution.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).

## Details

The cached database is stored in the
[giscoR](https://CRAN.R-project.org/package=giscoR) cache path. See
[`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
for details. The cached database is used in subsequent R sessions.

On new GISCO data releases, you can access the updated data by
refreshing the cached database without waiting for a new version of
[giscoR](https://CRAN.R-project.org/package=giscoR).

A static database
[gisco_db](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md)
is shipped with the package. This database is used if there is any
problem during the update.

## See also

GISCO database and metadata:
[`gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md),
[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)

## Examples

``` r

gisco_get_cached_db() |>
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
#> $ last_updated <date> 2026-06-20, 2026-06-20, 2026-06-20, 2026-06-20, 2026-06-…
```
