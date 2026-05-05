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

  logical. On `TRUE` the cached database is rebuilt with the most
  updated information of the GISCO API.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).

## Details

The cached database is stored in the
[giscoR](https://CRAN.R-project.org/package=giscoR) cache path, see
[`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md)
for details. The cached database is used in subsequent **R** sessions.

On new GISCO data releases, you can access the new updated data simply
by refreshing the cached database without waiting for a new version of
[giscoR](https://CRAN.R-project.org/package=giscoR).

A static database
[gisco_db](https://ropengov.github.io/giscoR/reference/gisco_db.md) is
shipped with the package. This database is used in case there is any
problem on update.

## See also

Other database utils:
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md),
[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/reference/gisco_get_metadata.md)

## Examples

``` r
if (FALSE) { # gisco_check_access()

gisco_get_cached_db() |>
  dplyr::glimpse()
}
```
