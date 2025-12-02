# Get geospatial units data from GISCO API

**\[deprecated\]**

This function is deprecated. Use:

- [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)
  (equivalent to `mode = "df"`).

- [`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  and friends (equivalent to `mode = "sf"`)

Download individual shapefiles of units. Unlike
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
or
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md),
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
argument.

On `mode = "df"` the only relevant arguments are `spatialtype, year`.

## Note

Country-level files would be renamed on your `cache_dir` to avoid naming
conflicts with NUTS-0 datasets.

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## Examples

``` r
# \donttest{
# Get metadata
cities <- gisco_get_metadata("urban_audit", 2020)


# Valencia, Spain
valencia <- cities[grep("Valencia", cities$URAU_NAME), ]
valencia
#> # A tibble: 3 × 10
#>   URAU_CODE URAU_CATG CNTR_CODE URAU_NAME CITY_CPTL CITY_KERN FUA_CODE 
#>   <chr>     <chr>     <chr>     <chr>     <chr>     <chr>     <chr>    
#> 1 ES003L3   F         ES        Valencia  ""        ""        ""       
#> 2 ES003C1   C         ES        Valencia  ""        "ES003K1" "ES003L3"
#> 3 ES003K1   K         ES        Valencia  ""        ""        ""       
#> # ℹ 3 more variables: NUTS3_2016 <chr>, AREA_SQM <dbl>, NUTS3_2021 <chr>
library(dplyr)
# Now get the shapes and order by AREA_SQM
valencia_sf <- gisco_get_unit_urban_audit(
  unit = valencia$URAU_CODE,
  year = "2020",
) |>
  arrange(desc(AREA_SQM))
# Plot
library(ggplot2)

ggplot(valencia_sf) +
  geom_sf(aes(fill = URAU_CATG)) +
  scale_fill_viridis_d() +
  labs(
    title = "Valencia",
    subtitle = "Urban Audit 2020",
    fill = "Category"
  )

# }
```
