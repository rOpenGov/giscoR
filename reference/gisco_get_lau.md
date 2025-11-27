# Get GISCO urban areas [`sf`](https://r-spatial.github.io/sf/reference/sf.html) polygons, points and lines

`gisco_get_communes()` and `gisco_get_lau()` download shapes of Local
Urban Areas, that correspond roughly with towns and cities.

## Usage

``` r
gisco_get_communes(
  year = "2016",
  epsg = "4326",
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = "RG",
  country = NULL
)

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

  - For `gisco_get_communes()` one of `"2016"`, `"2013"`, `"2010"`,
    `"2008"`, `"2006"`, `"2004"`, `"2001"` .

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

- spatialtype:

  character string. Type of geometry to be returned. Options available
  are:

  - `"BN"`: Boundaries - `LINESTRING` object.

  - `"COASTL"`: coastlines - `LINESTRING` object.

  - `"INLAND"`: inland boundaries - `LINESTRING` object.

  - `"LB"`: Labels - `POINT` object.

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

- country:

  Optional. A character vector of country codes. It could be either a
  vector of country names, a vector of ISO3 country codes or a vector of
  Eurostat country codes. See also
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

Other administrative units datasets:
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md),
[`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/reference/gisco_get_postalcodes.md)

## Examples

``` r
# \donttest{

ire_lau <- gisco_get_communes(spatialtype = "LB", country = "Ireland")

if (!is.null(ire_lau)) {
  library(ggplot2)

  ggplot(ire_lau) +
    geom_sf(shape = 21, col = "#009A44", size = 0.5) +
    labs(
      title = "Communes in Ireland",
      subtitle = "Year 2016",
      caption = gisco_attributions()
    ) +
    theme_void() +
    theme(text = element_text(
      colour = "#009A44",
      family = "serif", face = "bold"
    ))
}

# }
```
