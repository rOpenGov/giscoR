# Territorial units for statistics (NUTS) dataset

The GISCO statistical unit dataset represents the NUTS (nomenclature of
territorial units for statistics) and statistical regions by means of
multipart polygon, polyline and point topology. The NUTS geographical
information is completed by attribute tables and a set of cartographic
help lines to better visualise multipart polygonal regions.

The NUTS are a hierarchical system divided into 3 levels:

- NUTS 1: major socio-economic regions

- NUTS 2: basic regions for the application of regional policies

- NUTS 3: small regions for specific diagnoses.

Also, there is a NUTS 0 level, which usually corresponds to the national
boundaries.

## Usage

``` r
gisco_get_nuts(
  year = 2024,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = 20,
  spatialtype = "RG",
  country = NULL,
  nuts_id = NULL,
  nuts_level = c("all", "0", "1", "2", "3"),
  ext = "gpkg"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>.

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.

## Arguments

- year:

  character string or number. Release year of the file. One of `"2024"`,
  `"2021"`, `"2016"`, `"2013"`, `"2010"`, `"2006"`, `"2003"` .

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

  - `"BN"`: Boundaries - `LINESTRING` object.

  **Note that** arguments `country`, `nuts_level` and `nuts_id` would be
  only applied when `spatialtype` is `"RG"` or `"LB"`.

- country:

  character vector of country codes. It could be either a vector of
  country names, a vector of ISO3 country codes or a vector of Eurostat
  country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- nuts_id:

  Optional. A character vector of NUTS IDs.

- nuts_level:

  character string. NUTS level. One of `0`, `1`, `2`, `3` or `all` for
  all levels.

- ext:

  character. Extension of the file (default `"gpkg"`). One of `"shp"`,
  `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

The NUTS nomenclature is a hierarchical classification of statistical
regions and subdivides the EU economic territory into regions of three
different levels (NUTS 1, 2 and 3, moving respectively from larger to
smaller territorial units). NUTS 1 is the most aggregated level. An
additional Country level (NUTS 0) is also available for countries where
the nation at statistical level does not coincide with the
administrative boundaries.

The NUTS classification has been officially established through
Commission Delegated Regulation 2019/1755. A non-official NUTS-like
classification has been defined for the EFTA countries, candidate
countries and potential candidates based on a bilateral agreement
between Eurostat and the respective statistical agencies.

An introduction to the NUTS classification is available here:
<https://ec.europa.eu/eurostat/web/nuts/overview>.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

[gisco_nuts_2024](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts_2024.md),
[`eurostat::get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.html).

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

See
[`gisco_get_unit_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
to download single files.

Other statistical units datasets:
[`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md),
[`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)

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
```
