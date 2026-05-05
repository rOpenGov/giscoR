# Census dataset

This dataset shows pan-European communal boundaries depicting the
situation at the corresponding Census.

## Usage

``` r
gisco_get_census(
  year = 2011,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  spatialtype = c("RG", "PT")
)
```

## Source

<https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units/census>.

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>.

## Arguments

- year:

  character string or number. Release year of the file. Currently only
  `"2011"` is provided.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed? Default is `FALSE`. When
  set to `TRUE` it forces a new download.

- verbose:

  logical. If `TRUE` displays informational messages.

- spatialtype:

  Type of geometry to be returned:

  - `"PT"`: Points - `POINT` object.

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## See also

See
[`gisco_id_api_census_grid()`](https://ropengov.github.io/giscoR/reference/gisco_id_api.md)
to download via GISCO ID service API.

Other statistical units datasets:
[`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastal_lines.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md)

## Examples

``` r
if (FALSE) { # gisco_check_access()
# \donttest{
library(sf)

pts <- gisco_get_census(spatialtype = "PT")

pts
# }
}
```
