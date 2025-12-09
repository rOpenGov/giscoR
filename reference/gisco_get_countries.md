# Countries dataset

This dataset contains the administrative boundaries at country level of
the world. This dataset consists of 2 feature classes (regions,
boundaries) per scale level and there are 5 different scale levels (1M,
3M, 10M, 20M and 60M).

**Please note that** this function gets data from the aggregated GISCO
country file. If you prefer to download individual country files, please
use
[`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/reference/gisco_get_unit.md).

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

<https://gisco-services.ec.europa.eu/distribution/v2/>.

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.

## Arguments

- year:

  character string or number. Release year of the file. One of `"2024"`,
  `"2020"`, `"2016"`, `"2013"`, `"2010"`, `"2006"`, `"2001"` .

- epsg:

  character string or number. Projection of the map: 4-digit [EPSG
  code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

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

  - `"COASTL"`: coastlines - `LINESTRING` object.

  - `"INLAND"`: inland boundaries - `LINESTRING` object.

  **Note that** arguments `country` and `region` would be only applied
  when `spatialtype` is `"RG"` or `"LB"`.

- country:

  character vector of country codes. It could be either a vector of
  country names, a vector of ISO3 country codes or a vector of Eurostat
  country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- region:

  Optional. A character vector of UN M49 region codes or European Union
  membership. Possible values are `"Africa"`, `"Americas"`, `"Asia"`,
  `"Europe"`, `"Oceania"` or `"EU"` for countries belonging to the
  European Union (as per 2021). See **World Regions** and
  [gisco_countrycode](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md).

- ext:

  character. Extension of the file (default `"gpkg"`). One of `"shp"`,
  `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## World Regions

Regions are defined as per the geographic regions defined by the UN (see
<https://unstats.un.org/unsd/methodology/m49/>. Under this scheme Cyprus
is assigned to Asia.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

## See also

[gisco_countrycode](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md),
[gisco_countries_2024](https://ropengov.github.io/giscoR/reference/gisco_countries_2024.md),
[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/reference/gisco_get_metadata.md),
[`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

See
[`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/reference/gisco_get_unit.md)
to download single files.

See
[`gisco_id_api_country()`](https://ropengov.github.io/giscoR/reference/gisco_id_api.md)
to download via GISCO ID service API.

Other administrative units datasets:
[`gisco_get_communes()`](https://ropengov.github.io/giscoR/reference/gisco_get_communes.md),
[`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/reference/gisco_get_postal_codes.md)

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
