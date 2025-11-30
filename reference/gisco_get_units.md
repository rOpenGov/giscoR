# Get geospatial units data from GISCO API

**\[deprecated\]**

This function is deprecated. Use:

- [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/reference/gisco_get_metadata.md)
  (equivalent to `mode = "df"`)

- TODO

Download individual shapefiles of units. Unlike
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md)
or
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md),
that downloads a full dataset and applies filters, `gisco_get_units()`
downloads a single shapefile for each unit.

## Usage

``` r
gisco_get_units(
  id_giscoR = c("nuts", "countries", "urban_audit"),
  unit = "ES4",
  mode = c("sf", "df"),
  year = "2016",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = "20",
  spatialtype = "RG"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

## Arguments

- id_giscoR:

  Select the `unit` type to be downloaded. Accepted values are `"nuts"`,
  `"countries"` or `"urban_audit"`.

- unit:

  Unit ID to be downloaded. See **Details**.

- mode:

  Controls the output of the function. Possible values are `"sf"` or
  `"df"`. See **Value** and **Details**.

- year:

  character string or number. Release year of the file. One of `"2024"`,
  `"2020"`, `"2016"`, `"2013"`, `"2010"`, `"2006"`, `"2001"` .

- epsg:

  character string or number. Projection of the map: 4-digit [EPSG
  code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326)

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035)

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857)

- cache:

  logical. Whether to do caching. Default is `TRUE`. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- verbose:

  logical. If `TRUE` displays informational messages.

- resolution:

  character string or number. Resolution of the geospatial data. One of:

  - `"60"`: 1:60million

  - `"20"`: 1:20million

  - `"10"`: 1:10million

  - `"03"`: 1:3million

  - `"01"`: 1:1million

- spatialtype:

  Type of geometry to be returned: `"RG"`, for `POLYGON` and `"LB"` for
  `POINT`.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object on
`mode = "sf"` or a data frame on `mode = "df"`.

## Details

The function can return a data frame on `mode = "df"` or a
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object on
`mode = "sf"`.

In order to see the available `unit` ids with the required combination
of `spatialtype, year`, first run the function on `"df"` mode. Once that
you get the data frame you can select the required ids on the `unit`
parameter.

On `mode = "df"` the only relevant parameters are `spatialtype, year`.

## Note

Country-level files would be renamed on your `cache_dir` to avoid naming
conflicts with NUTS-0 datasets.

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

## See also

[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md)

Other political:
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md)

## Author

dieghernan, <https://github.com/dieghernan/>

## Examples

``` r
# \donttest{
cities <- gisco_get_units(
  id_giscoR = "urban_audit",
  mode = "df",
  year = "2020"
)
#> Warning: `gisco_get_units()` was deprecated in giscoR 1.0.0.
#> ℹ Please use `gisco_get_metadata()` instead.
VAL <- cities[grep("Valencia", cities$URAU_NAME), ]
#   Order from big to small
VAL <- VAL[order(as.double(VAL$AREA_SQM), decreasing = TRUE), ]

VAL.sf <- gisco_get_units(
  id_giscoR = "urban_audit",
  year = "2020",
  unit = VAL$URAU_CODE
)
# Provincia
Provincia <-
  gisco_get_units(
    id_giscoR = "nuts",
    unit = c("ES523"),
    resolution = "01"
  )

# Reorder
VAL.sf$URAU_CATG <- factor(VAL.sf$URAU_CATG, levels = c("F", "K", "C"))

# Plot
library(ggplot2)

ggplot(Provincia) +
  geom_sf(fill = "gray1") +
  geom_sf(data = VAL.sf, aes(fill = URAU_CATG)) +
  scale_fill_viridis_d() +
  labs(
    title = "Valencia",
    subtitle = "Urban Audit",
    fill = "Urban Audit\ncategory"
  )

# }
```
