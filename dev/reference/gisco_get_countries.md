# Countries dataset

This dataset contains world administrative boundaries at the country
level. It provides two feature classes, regions and boundaries, at five
scale levels: 1M, 3M, 10M, 20M and 60M.

Downloads data from the aggregated GISCO country file. To download
single-unit country files, use
[`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md).

## Usage

``` r
gisco_get_countries(
  year = 2024,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = 20,
  spatialtype = "RG",
  country = NULL,
  region = NULL,
  ext = "gpkg"
)
```

## Source

GISCO countries distribution API:
<https://gisco-services.ec.europa.eu/distribution/v2/countries/>.

## Arguments

- year:

  A character string or numeric value with the release year of the file.
  One of `"2024"`, `"2020"`, `"2016"`, `"2013"`, `"2010"`, `"2006"`,
  `"2001"` .

- epsg:

  A character string or numeric value with the coordinate reference
  system as a 4-digit [EPSG code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

- cache:

  A logical value indicating whether to cache results. Defaults to
  `TRUE`. See **Caching strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  A logical value indicating whether to refresh the cached file.
  Defaults to `FALSE`. When set to `TRUE`, it forces a new download.

- cache_dir:

  A character string with a path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- verbose:

  A logical value indicating whether to display informational messages.

- resolution:

  A character string or numeric value with the geospatial data
  resolution. One of:

  - `"60"`: 1:60 million.

  - `"20"`: 1:20 million.

  - `"10"`: 1:10 million.

  - `"03"`: 1:3 million.

  - `"01"`: 1:1 million.

- spatialtype:

  A character string with the type of geometry to return. Options
  available are:

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  - `"LB"`: Labels - `POINT` object.

  - `"BN"`: Boundaries - `LINESTRING` object.

  - `"COASTL"`: Coastal lines - `LINESTRING` object.

  - `"INLAND"`: Inland boundaries - `LINESTRING` object.

    Arguments `country` and `region` are only applied when `spatialtype`
    is `"RG"` or `"LB"`.

- country:

  A character vector of country codes. It can be either a vector of
  country names, a vector of ISO 3166-1 alpha-3 country codes or a
  vector of Eurostat country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

- region:

  An optional character vector of UN M49 region codes or European Union
  membership. Possible values are `"Africa"`, `"Americas"`, `"Asia"`,
  `"Europe"`, `"Oceania"` or `"EU"` for countries belonging to the
  European Union as of 2021. See **World regions** and
  [gisco_countrycode](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md).

- ext:

  A character value with the extension of the file (default `"gpkg"`).
  One of `"shp"`, `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## World regions

Regions follow the UN geographic regions (see
<https://unstats.un.org/unsd/methodology/m49/>). Under this scheme
Cyprus is assigned to Asia.

## Copyright

See the GISCO administrative unit copyright provisions:
<https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.

## Note

Check the download and usage provisions in
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

[gisco_countrycode](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md),
[gisco_countries_2024](https://ropengov.github.io/giscoR/dev/reference/gisco_countries_2024.md),
[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md),
[`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

See
[`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
to download single-unit files.

See
[`gisco_id_api_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
to download via GISCO ID service API.

Administrative unit datasets:
[`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md),
[`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)

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
