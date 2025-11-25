# Get GISCO world country [`sf`](https://r-spatial.github.io/sf/reference/sf.html) polygons, points and lines

Returns world country polygons, lines and points at a specified scale,
as provided by GISCO. Also, specific areas as Gibraltar or Antarctica
are presented separately. The definition of country used on GISCO
correspond roughly with territories with an official
[ISO-3166](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
code.

## Usage

``` r
gisco_get_countries(
  year = "2016",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = "20",
  spatialtype = "RG",
  country = NULL,
  region = NULL
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

## Arguments

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

  Type of geometry to be returned:

  - `"BN"`: Boundaries - `LINESTRING` object.

  - `"COASTL"`: coastlines - `LINESTRING` object.

  - `"INLAND"`: inland boundaries - `LINESTRING` object.

  - `"LB"`: Labels - `POINT` object.

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  **Note that** parameters `country` and `region` would be only applied
  when `spatialtype` is `"BN"` or `"RG"`.

- country:

  Optional. A character vector of country codes. It could be either a
  vector of country names, a vector of ISO3 country codes or a vector of
  Eurostat country codes. Mixed types (as `c("Italy","ES","FRA")`) would
  not work. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- region:

  Optional. A character vector of UN M49 region codes or European Union
  membership. Possible values are `"Africa"`, `"Americas"`, `"Asia"`,
  `"Europe"`, `"Oceania"` or `"EU"` for countries belonging to the
  European Union (as per 2021). See **About world regions** and
  [gisco_countrycode](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md).

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
specified by `spatialtype`.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

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

## World Regions

Regions are defined as per the geographic regions defined by the UN (see
<https://unstats.un.org/unsd/methodology/m49/>. Under this scheme Cyprus
is assigned to Asia. You may use `region = "EU"` to get the EU members
(reference date: 2021).

## See also

[`gisco_countrycode()`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md),
[gisco_countries](https://ropengov.github.io/giscoR/reference/gisco_countries.md),
[`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html)

Other political:
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md),
[`gisco_get_coastallines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastallines.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md),
[`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/reference/gisco_get_postalcodes.md),
[`gisco_get_units()`](https://ropengov.github.io/giscoR/reference/gisco_get_units.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md)

## Examples

``` r
cntries <- gisco_get_countries()

library(ggplot2)
ggplot(cntries) +
  geom_sf()


# Get a region

africa <- gisco_get_countries(region = "Africa")
ggplot(africa) +
  geom_sf(fill = "#078930", col = "white") +
  theme_minimal()

```
