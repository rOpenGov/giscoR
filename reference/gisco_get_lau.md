# Get GISCO urban areas [`sf`](https://r-spatial.github.io/sf/reference/sf.html) polygons, points and lines

[`gisco_get_communes()`](https://ropengov.github.io/giscoR/reference/gisco_get_communes.md)
and `gisco_get_lau()` download shapes of Local Urban Areas, that
correspond roughly with towns and cities.

## Usage

``` r
gisco_get_lau(
  year = "2024",
  epsg = "4326",
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL,
  gisco_id = NULL
)
```

## Arguments

- year:

  Release year of the file:

  - For
    [`gisco_get_communes()`](https://ropengov.github.io/giscoR/reference/gisco_get_communes.md)
    one of `"2016"`, `"2013"`, `"2010"`, `"2008"`, `"2006"`, `"2004"`,
    `"2001"` .

  - For `gisco_get_lau()` one of `"2024"`, `"2023"`, `"2022"`, `"2021"`,
    `"2020"`, `"2019"`, `"2018"`, `"2017"`, `"2016"`, `"2015"`,
    `"2014"`, `"2013"`, `"2012"`, `"2011"` .

- epsg:

  projection of the map: 4-digit [EPSG code](https://epsg.io/). One of:

  - `"4326"`: WGS84

  - `"3035"`: ETRS89 / ETRS-LAEA

  - `"3857"`: Pseudo-Mercator

- cache:

  **\[deprecated\]**. These functions always caches the result due to
  the size. `cache_dir` can be set to
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html), so the file
  would be deleted when the **R** session is closed.

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- verbose:

  logical. If `TRUE` displays informational messages.

- country:

  character vector of country codes. It could be either a vector of
  country names, a vector of ISO3 country codes or a vector of Eurostat
  country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- gisco_id:

  Optional. A character vector of GISCO_ID LAU values.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
specified by `spatialtype`. In the case of `gisco_get_lau()`, a
`POLYGON` object.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

## See also

Other statistical units datasets:
[`gisco_get_census()`](https://ropengov.github.io/giscoR/reference/gisco_get_census.md),
[`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastal_lines.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md)
