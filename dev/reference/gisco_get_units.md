# Get geospatial units data from GISCO API

**\[deprecated\]**

This function is deprecated. Use:

- [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)
  (equivalent to `mode = "df"`).

- [`?gisco_get_unit`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)functions
  (equivalent to `mode = "sf"`)

## Usage

``` r
gisco_get_units(
  id_giscoR = c("nuts", "countries", "urban_audit"),
  unit = "ES4",
  mode = c("sf", "df"),
  year = 2016,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = 20,
  spatialtype = "RG"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

All the source files are `.geojson` files.

## Arguments

- id_giscoR:

  Select the `unit` type to be downloaded. Accepted values are `"nuts"`,
  `"countries"` or `"urban_audit"`.

- unit:

  Unit ID to be downloaded.

- mode:

  Controls the output of the function. Possible values are `"sf"` or
  `"df"`. See **Value**.

- year:

  character string or number. Release year of the file.

- epsg:

  character string or number. Projection of the map: 4-digit [EPSG
  code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

- cache:

  logical. Whether to do caching. Default is `TRUE`. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- verbose:

  logical. If `TRUE` displays informational messages.

- resolution:

  character string or number. Resolution of the geospatial data. One of:

  - `"60"`: 1:60 million.

  - `"20"`: 1:20 million.

  - `"10"`: 1:10 million.

  - `"03"`: 1:3 million.

  - `"01"`: 1:1 million.

- spatialtype:

  character string. Type of geometry to be returned. Options available
  are:

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  - `"LB"`: Labels - `POINT` object.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object on
`mode = "sf"` or a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) on
`mode = "df"`.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md),
[`?gisco_get_unit`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
functions.

## Examples

``` r
# \donttest{
# mode df
gisco_get_units("nuts", mode = "df", year = 2016)
#> Warning: `gisco_get_units()` was deprecated in giscoR 1.0.0.
#> ℹ Please use `gisco_get_metadata()` instead.
#> # A tibble: 2,016 × 7
#>    CNTR_CODE NUTS_ID NAME_LATN         NUTS_NAME MOUNT_TYPE URBN_TYPE COAST_TYPE
#>    <chr>     <chr>   <chr>             <chr>          <int>     <int>      <int>
#>  1 UK        UKL2    East Wales        East Wal…          0         0          0
#>  2 UK        UKL18   Swansea           Swansea            4         1          1
#>  3 UK        UKL17   Bridgend and Nea… Bridgend…          2         1          1
#>  4 UK        UKL16   Gwent Valleys     Gwent Va…          2         1          2
#>  5 UK        UKL15   Central Valleys   Central …          3         1          2
#>  6 UK        UKL14   South West Wales  South We…          4         3          1
#>  7 UK        UKL12   Gwynedd           Gwynedd            2         3          1
#>  8 UK        UKL11   Isle of Anglesey  Isle of …          4         3          1
#>  9 UK        UKL1    West Wales and T… West Wal…          0         0          0
#> 10 UK        UKL     WALES             WALES              0         0          0
#> # ℹ 2,006 more rows
# ->
gisco_get_metadata("nuts", year = 2016)
#> # A tibble: 2,016 × 7
#>    CNTR_CODE NUTS_ID NAME_LATN         NUTS_NAME MOUNT_TYPE URBN_TYPE COAST_TYPE
#>    <chr>     <chr>   <chr>             <chr>          <int>     <int>      <int>
#>  1 UK        UKL2    East Wales        East Wal…          0         0          0
#>  2 UK        UKL18   Swansea           Swansea            4         1          1
#>  3 UK        UKL17   Bridgend and Nea… Bridgend…          2         1          1
#>  4 UK        UKL16   Gwent Valleys     Gwent Va…          2         1          2
#>  5 UK        UKL15   Central Valleys   Central …          3         1          2
#>  6 UK        UKL14   South West Wales  South We…          4         3          1
#>  7 UK        UKL12   Gwynedd           Gwynedd            2         3          1
#>  8 UK        UKL11   Isle of Anglesey  Isle of …          4         3          1
#>  9 UK        UKL1    West Wales and T… West Wal…          0         0          0
#> 10 UK        UKL     WALES             WALES              0         0          0
#> # ℹ 2,006 more rows

# mode sf for NUTS
gisco_get_units("nuts", unit = "ES111", mode = "sf", year = 2016)
#> Warning: `gisco_get_units()` was deprecated in giscoR 1.0.0.
#> ℹ Please use `gisco_get_unit_nuts()` instead.
#> Simple feature collection with 1 feature and 9 fields
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -9.2475 ymin: 42.56619 xmax: -7.699736 ymax: 43.73816
#> Geodetic CRS:  WGS 84
#> # A tibble: 1 × 10
#>   COAST_TYPE MOUNT_TYPE NAME_LATN CNTR_CODE NUTS_ID NUTS_NAME LEVL_CODE
#> *      <int>      <int> <chr>     <chr>     <chr>   <chr>         <int>
#> 1          1          2 A Coruña  ES        ES111   A Coruña          3
#> # ℹ 3 more variables: URBN_TYPE <int>, geo <chr>, geometry <POLYGON [°]>
# ->
gisco_get_unit_nuts(unit = "ES111", year = 2016)
#> Simple feature collection with 1 feature and 9 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -9.29841 ymin: 42.4636 xmax: -7.662418 ymax: 43.78793
#> Geodetic CRS:  WGS 84
#> # A tibble: 1 × 10
#>   COAST_TYPE MOUNT_TYPE NAME_LATN CNTR_CODE NUTS_ID NUTS_NAME LEVL_CODE
#> *      <int>      <int> <chr>     <chr>     <chr>   <chr>         <int>
#> 1          1          2 A Coruña  ES        ES111   A Coruña          3
#> # ℹ 3 more variables: URBN_TYPE <int>, geo <chr>, geometry <MULTIPOLYGON [°]>
# }
```
