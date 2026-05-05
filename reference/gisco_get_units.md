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
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed? Default is `FALSE`. When
  set to `TRUE` it forces a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

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
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

## See also

[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/reference/gisco_get_metadata.md),
[`?gisco_get_unit`](https://ropengov.github.io/giscoR/reference/gisco_get_unit.md)
functions.

## Examples

``` r
if (FALSE) { # gisco_check_access()
# \donttest{
# mode df
gisco_get_units("nuts", mode = "df", year = 2016)
# ->
gisco_get_metadata("nuts", year = 2016)

# mode sf for NUTS
gisco_get_units("nuts", unit = "ES111", mode = "sf", year = 2016)
# ->
gisco_get_unit_nuts(unit = "ES111", year = 2016)
# }
}
```
