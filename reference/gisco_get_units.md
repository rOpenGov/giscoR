# Get geospatial units data from GISCO API

**\[deprecated\]**

This function is deprecated. Use:

- [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/reference/gisco_get_metadata.md)
  (equivalent to `mode = "df"`).

- [`?gisco_get_unit`](https://ropengov.github.io/giscoR/reference/gisco_get_unit.md)
  functions (equivalent to `mode = "sf"`)

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

  A character string with the `unit` type to download. Accepted values
  are `"nuts"`, `"countries"` or `"urban_audit"`.

- unit:

  A unit ID to download.

- mode:

  A character string controlling the output of the function. Possible
  values are `"sf"` or `"df"`. See **Value**.

- year:

  A character string or numeric value with the release year of the file.

- epsg:

  A character string or numeric value with the map projection as a
  4-digit [EPSG code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

- cache:

  A logical value indicating whether to cache results. Default is
  `TRUE`. See **Caching strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  A logical value indicating whether to refresh the cached file. Default
  is `FALSE`. When set to `TRUE`, it forces a new download.

- cache_dir:

  A character string with a path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- verbose:

  A logical value. If `TRUE` displays informational messages.

- resolution:

  A character string or numeric value with the geospatial data
  resolution. One of:

  - `"60"`: 1:60 million.

  - `"20"`: 1:20 million.

  - `"10"`: 1:10 million.

  - `"03"`: 1:3 million.

  - `"01"`: 1:1 million.

- spatialtype:

  A character string with the type of geometry to return. Options
  available are:

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  - `"LB"`: Labels - `POINT` object.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object on
`mode = "sf"` or a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) on
`mode = "df"`.

## Note

Check the download and usage provisions in
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

## See also

[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/reference/gisco_get_metadata.md),
[`?gisco_get_unit`](https://ropengov.github.io/giscoR/reference/gisco_get_unit.md)
functions.

## Examples

``` r
# \donttest{
# mode df
gisco_get_units("nuts", mode = "df", year = 2016)
#> Warning: `gisco_get_units()` was deprecated in giscoR 1.0.0.
#> ℹ Please use `gisco_get_metadata()` instead.
#> # A tibble: 2,016 × 9
#>    CNTR_CODE NUTS_ID NAME_LATN          NUTS_NAME NAME_ASCI NAME_HTML MOUNT_TYPE
#>    <chr>     <chr>   <chr>              <chr>     <chr>     <chr>          <int>
#>  1 UK        UKL2    East Wales         East Wal… East Wal… East Wal…          0
#>  2 UK        UKL18   Swansea            Swansea   Swansea   Swansea            4
#>  3 UK        UKL17   Bridgend and Neat… Bridgend… Bridgend… Bridgend…          2
#>  4 UK        UKL16   Gwent Valleys      Gwent Va… Gwent Va… Gwent Va…          2
#>  5 UK        UKL15   Central Valleys    Central … Central … Central …          3
#>  6 UK        UKL14   South West Wales   South We… South We… South We…          4
#>  7 UK        UKL12   Gwynedd            Gwynedd   Gwynedd   Gwynedd            2
#>  8 UK        UKL11   Isle of Anglesey   Isle of … Isle of … Isle of …          4
#>  9 UK        UKL1    West Wales and Th… West Wal… West Wal… West Wal…          0
#> 10 UK        UKL     WALES              WALES     WALES     WALES              0
#> # ℹ 2,006 more rows
#> # ℹ 2 more variables: URBN_TYPE <int>, COAST_TYPE <int>
# ->
gisco_get_metadata("nuts", year = 2016)
#> # A tibble: 2,016 × 9
#>    CNTR_CODE NUTS_ID NAME_LATN          NUTS_NAME NAME_ASCI NAME_HTML MOUNT_TYPE
#>    <chr>     <chr>   <chr>              <chr>     <chr>     <chr>          <int>
#>  1 UK        UKL2    East Wales         East Wal… East Wal… East Wal…          0
#>  2 UK        UKL18   Swansea            Swansea   Swansea   Swansea            4
#>  3 UK        UKL17   Bridgend and Neat… Bridgend… Bridgend… Bridgend…          2
#>  4 UK        UKL16   Gwent Valleys      Gwent Va… Gwent Va… Gwent Va…          2
#>  5 UK        UKL15   Central Valleys    Central … Central … Central …          3
#>  6 UK        UKL14   South West Wales   South We… South We… South We…          4
#>  7 UK        UKL12   Gwynedd            Gwynedd   Gwynedd   Gwynedd            2
#>  8 UK        UKL11   Isle of Anglesey   Isle of … Isle of … Isle of …          4
#>  9 UK        UKL1    West Wales and Th… West Wal… West Wal… West Wal…          0
#> 10 UK        UKL     WALES              WALES     WALES     WALES              0
#> # ℹ 2,006 more rows
#> # ℹ 2 more variables: URBN_TYPE <int>, COAST_TYPE <int>

# mode sf for NUTS
gisco_get_units("nuts", unit = "ES111", mode = "sf", year = 2016)
#> Warning: `gisco_get_units()` was deprecated in giscoR 1.0.0.
#> ℹ Please use `gisco_get_unit_nuts()` instead.
#> Simple feature collection with 1 feature and 19 fields
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -9.2475 ymin: 42.56619 xmax: -7.699736 ymax: 43.73816
#> Geodetic CRS:  WGS 84
#> # A tibble: 1 × 20
#>   SVRG_UN      COAST_TYPE EU_STAT MOUNT_TYPE NAME_FREN NAME_LATN ISO3_CODE CAPT 
#> * <chr>             <int> <chr>        <int> <chr>     <chr>     <chr>     <chr>
#> 1 UN Member S…          1 T                2 Espagne   A Coruña  ESP       Madr…
#> # ℹ 12 more variables: CNTR_CODE <chr>, CC_STAT <chr>, NAME_ASCI <chr>,
#> #   NAME_GERM <chr>, NUTS_ID <chr>, EFTA_STAT <chr>, NUTS_NAME <chr>,
#> #   LEVL_CODE <int>, URBN_TYPE <int>, NAME_ENGL <chr>, geo <chr>,
#> #   geometry <POLYGON [°]>
# ->
gisco_get_unit_nuts(unit = "ES111", year = 2016)
#> Simple feature collection with 1 feature and 19 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -9.29841 ymin: 42.4636 xmax: -7.662418 ymax: 43.78793
#> Geodetic CRS:  WGS 84
#> # A tibble: 1 × 20
#>   SVRG_UN      COAST_TYPE EU_STAT MOUNT_TYPE NAME_FREN NAME_LATN ISO3_CODE CAPT 
#> * <chr>             <int> <chr>        <int> <chr>     <chr>     <chr>     <chr>
#> 1 UN Member S…          1 T                2 Espagne   A Coruña  ESP       Madr…
#> # ℹ 12 more variables: CNTR_CODE <chr>, CC_STAT <chr>, NAME_ASCI <chr>,
#> #   NAME_GERM <chr>, NUTS_ID <chr>, EFTA_STAT <chr>, NUTS_NAME <chr>,
#> #   LEVL_CODE <int>, URBN_TYPE <int>, NAME_ENGL <chr>, geo <chr>,
#> #   geometry <MULTIPOLYGON [°]>
# }
```
