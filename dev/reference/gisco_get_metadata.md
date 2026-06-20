# Get metadata

Get a table with names and IDs of administrative and statistical units.

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

  A character string with the unit type to download. Accepted values are
  `"nuts"`, `"countries"` or `"urban_audit"`.

- year:

  A character string or numeric value with the release year of the
  metadata.

- verbose:

  A logical value indicating whether to display informational messages.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).

## See also

[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
for bulk downloads and
[`gisco_get_unit`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
for single-unit downloads.

GISCO database and metadata:
[`gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md),
[`gisco_get_cached_db()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_cached_db.md)

## Examples

``` r
cities <- gisco_get_metadata(id = "urban_audit", year = 2020)

cities
#> # A tibble: 1,720 × 10
#>    URAU_CODE URAU_CATG CNTR_CODE URAU_NAME          CITY_CPTL CITY_KERN FUA_CODE
#>    <chr>     <chr>     <chr>     <chr>              <chr>     <chr>     <chr>   
#>  1 FR007L2   F         FR        FUA of Bordeaux    ""        ""        ""      
#>  2 FR008L2   F         FR        FUA of Nantes      ""        ""        ""      
#>  3 FR009L2   F         FR        FUA of Lille       ""        ""        ""      
#>  4 FR010L2   F         FR        FUA of Montpellier ""        ""        ""      
#>  5 FR011L2   F         FR        FUA of Saint-Étie… ""        ""        ""      
#>  6 FR012L2   F         FR        FUA of Le Havre    ""        ""        ""      
#>  7 FR013L2   F         FR        FUA of Rennes      ""        ""        ""      
#>  8 FR014L2   F         FR        FUA of Amiens      ""        ""        ""      
#>  9 FR016L2   F         FR        FUA of Nancy       ""        ""        ""      
#> 10 FR017L2   F         FR        FUA of Metz        ""        ""        ""      
#> # ℹ 1,710 more rows
#> # ℹ 3 more variables: NUTS3_2016 <chr>, AREA_SQM <dbl>, NUTS3_2021 <chr>
```
