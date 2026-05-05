# Get metadata

Get a table with the names and IDs of administrative and statistical
units.

## Usage

``` r
gisco_get_metadata(
  id = c("nuts", "countries", "urban_audit"),
  year = 2024,
  verbose = FALSE
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>.

## Arguments

- id:

  character string. Select the unit type to be downloaded. Accepted
  values are `"nuts"`, `"countries"` or `"urban_audit"`.

- year:

  character string or number. Release year of the metadata.

- verbose:

  logical. If `TRUE` displays informational messages.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).

## See also

[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md),
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md).

Other database utils:
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md),
[`gisco_get_cached_db()`](https://ropengov.github.io/giscoR/reference/gisco_get_cached_db.md)

## Examples

``` r
if (FALSE) { # gisco_check_access()
cities <- gisco_get_metadata(id = "urban_audit", year = 2020)

cities
}
```
