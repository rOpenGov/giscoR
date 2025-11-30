# Census data

This data set shows pan European communal boundaries depicting the
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

<https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units/census>

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>

## Arguments

- year:

  character string or number. Release year of the file. Currently only
  `"2011"` is provided.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- verbose:

  logical. If `TRUE` displays informational messages.

- spatialtype:

  Type of geometry to be returned:

  - `"PT"`: Points - `POINT` object.

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## See also

Other statistical units datasets:
[`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastal_lines.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md)

## Examples

``` r
# \donttest{
library(sf)

pts <- gisco_get_census(spatialtype = "PT")

pts
#> Simple feature collection with 115136 features and 2 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -61.7796 ymin: -21.3399 xmax: 55.75452 ymax: 71.04844
#> Geodetic CRS:  WGS 84
#> # A tibble: 115,136 × 3
#>    CENS_ID     ORIG_FID            geometry
#>  * <chr>          <int>         <POINT [°]>
#>  1 AT111_10801        1  (16.6325 47.59374)
#>  2 AT111_10802        2 (16.38657 47.49552)
#>  3 AT111_10803        3   (16.572 47.46158)
#>  4 AT111_10804        4  (16.5717 47.52752)
#>  5 AT111_10805        5 (16.56402 47.57514)
#>  6 AT111_10806        6 (16.38416 47.53657)
#>  7 AT111_10807        7 (16.37699 47.59442)
#>  8 AT111_10808        8 (16.44874 47.60538)
#>  9 AT111_10809        9 (16.40948 47.39185)
#> 10 AT111_10810       10  (16.63391 47.4686)
#> # ℹ 115,126 more rows
# }
```
