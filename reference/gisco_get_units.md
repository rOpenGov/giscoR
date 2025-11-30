# Get geospatial units data from GISCO API

Download individual shapefiles of units. Unlike
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get.md),
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

  Release year of the file. One of `"2001"`, `"2006"`, `"2010"`,
  `"2013"`, `"2016"`, `"2020"` or `"2024"`.

- epsg:

  projection of the map: 4-digit [EPSG code](https://epsg.io/). One of:

  - `"4258"`: ETRS89

  - `"4326"`: WGS84

  - `"3035"`: ETRS89 / ETRS-LAEA

  - `"3857"`: Pseudo-Mercator

- cache:

  A logical whether to do caching. Default is `TRUE`. See **About
  caching**.

- update_cache:

  A logical whether to update cache. Default is `FALSE`. When set to
  `TRUE` it would force a fresh download of the source `.geojson` file.

- cache_dir:

  A path to a cache directory. See **About caching**.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- resolution:

  Resolution of the geospatial data. One of

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

## About caching

You can set your `cache_dir` with
[`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

Sometimes cached files may be corrupt. On that case, try re-downloading
the data setting `update_cache = TRUE`.

If you experience any problem on download, try to download the
corresponding `.geojson` file by any other method and save it on your
`cache_dir`. Use the option `verbose = TRUE` for debugging the API
query.

For a complete list of files available check
[gisco_db](https://ropengov.github.io/giscoR/reference/gisco_db.md).

## See also

[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get.md)

Other political:
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md),
[`gisco_get_coastallines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastallines.md),
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md),
[`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/reference/gisco_get_postalcodes.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md)

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
