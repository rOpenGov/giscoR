# Get GISCO NUTS [`sf`](https://r-spatial.github.io/sf/reference/sf.html) polygons, points and lines

Returns [NUTS
regions](https://en.wikipedia.org/wiki/Nomenclature_of_Territorial_Units_for_Statistics)
polygons, lines and points at a specified scale, as provided by GISCO.

NUTS are provided at three different levels:

- `"0"`: Country level

- `"1"`: Groups of states/regions

- `"2"`: States/regions

- `"3"`: Counties/provinces/districts

Note that NUTS-level definition may vary across countries. See also
<https://ec.europa.eu/eurostat/web/gisco/geodata//statistical-units/territorial-units-statistics>.

## Usage

``` r
gisco_get_nuts(
  year = "2016",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = "20",
  spatialtype = "RG",
  country = NULL,
  nuts_id = NULL,
  nuts_level = "all"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

## Arguments

- year:

  Release year of the file. One of `"2003"`, `"2006"`, `"2010"`,
  `"2013"`, `"2016"`, `"2021"` or `"2024"`.

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

  Type of geometry to be returned:

  - `"BN"`: Boundaries - `LINESTRING` object.

  - `"LB"`: Labels - `POINT` object.

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  **Note that** parameters `country`, `nuts_level` and `nuts_id` would
  be only applied when `spatialtype` is `"BN"` or `"RG"`.

- country:

  Optional. A character vector of country codes. It could be either a
  vector of country names, a vector of ISO3 country codes or a vector of
  Eurostat country codes. Mixed types (as `c("Italy","ES","FRA")`) would
  not work. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- nuts_id:

  Optional. A character vector of NUTS IDs.

- nuts_level:

  NUTS level. One of `"0"`, `"1"`, `"2"` or `"3"`. See **Description**.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
specified by `spatialtype`. The resulting
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object would
present an additional column `geo` (equal to `NUTS_ID`) for improving
compatibility with
[eurostat](https://CRAN.R-project.org/package=eurostat) package. See
[`eurostat::get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.html)).

See also
[gisco_nuts](https://ropengov.github.io/giscoR/reference/gisco_nuts.md)
to understand the columns and values provided.

## About caching

You can set your `cache_dir` with
[`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

Sometimes cached files may be corrupt. On that case, try re-downloading
the data setting `update_cache = TRUE`.

If you experience any problem on download, try to download the
corresponding file by any other method and save it on your `cache_dir`.
Use the option `verbose = TRUE` for debugging the API query.

For a complete list of files available check
[gisco_db](https://ropengov.github.io/giscoR/reference/gisco_db.md).

## See also

[gisco_nuts](https://ropengov.github.io/giscoR/reference/gisco_nuts.md),
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get.md),
[`eurostat::get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.html)

Other political:
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md),
[`gisco_get_coastallines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastallines.md),
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md),
[`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/reference/gisco_get_postalcodes.md),
[`gisco_get_units()`](https://ropengov.github.io/giscoR/reference/gisco_get_units.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md)

## Examples

``` r
nuts2 <- gisco_get_nuts(nuts_level = 2)

library(ggplot2)

ggplot(nuts2) +
  geom_sf() +
  # ETRS89 / ETRS-LAEA
  coord_sf(
    crs = 3035, xlim = c(2377294, 7453440),
    ylim = c(1313597, 5628510)
  ) +
  labs(title = "NUTS-2 levels")

# \donttest{
# NUTS-3 for Germany
germany_nuts3 <- gisco_get_nuts(nuts_level = 3, country = "Germany")

ggplot(germany_nuts3) +
  geom_sf() +
  labs(
    title = "NUTS-3 levels",
    subtitle = "Germany",
    caption = gisco_attributions()
  )



# Select specific regions
select_nuts <- gisco_get_nuts(nuts_id = c("ES2", "FRJ", "FRL", "ITC"))

ggplot(select_nuts) +
  geom_sf(aes(fill = CNTR_CODE)) +
  scale_fill_viridis_d()

# }
```
