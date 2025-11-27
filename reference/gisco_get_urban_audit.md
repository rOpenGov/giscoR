# Get GISCO greater cities and metropolitan areas [`sf`](https://r-spatial.github.io/sf/reference/sf.html) objects

Returns polygons and points corresponding to cities, greater cities and
metropolitan areas included on the [Urban Audit
report](https://ec.europa.eu/eurostat/web/regions-and-cities) of
Eurostat.

## Usage

``` r
gisco_get_urban_audit(
  year = "2021",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = "RG",
  country = NULL,
  level = NULL
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>

## Arguments

- year:

  Release year of the file. One of `"2021"`, `"2020"`, `"2018"`,
  `"2014"`, `"2004"`, `"2001"` .

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

  .logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- verbose:

  logical. If `TRUE` displays informational messages.

- spatialtype:

  Type of geometry to be returned:

  - `"LB"`: Labels - `POINT` object.

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

- country:

  Optional. A character vector of country codes. It could be either a
  vector of country names, a vector of ISO3 country codes or a vector of
  Eurostat country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- level:

  Level of Urban Audit. Possible values are `"CITIES"`, `"FUA"`,
  `"GREATER_CITIES"` or `NULL`, that would download the full dataset.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
specified by `spatialtype`.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

## See also

[`gisco_get_communes()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md)

Other political:
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md),
[`gisco_get_units()`](https://ropengov.github.io/giscoR/reference/gisco_get_units.md)

## Examples

``` r
# \donttest{
cities <- gisco_get_urban_audit(year = "2020", level = "CITIES")

if (!is.null(cities)) {
  bcn <- cities[cities$URAU_NAME == "Barcelona", ]

  library(ggplot2)
  ggplot(bcn) +
    geom_sf()
}

# }
```
