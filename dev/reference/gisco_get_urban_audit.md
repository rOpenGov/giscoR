# Urban Audit dataset

The dataset contains the boundaries of cities (`"CITIES"`), greater
cities (`"GREATER_CITIES"`) and functional urban areas (`"FUA"`) as
defined according to the EC-OECD city definition. This is used for the
Eurostat Urban Audit data collection.

## Usage

``` r
gisco_get_urban_audit(
  year = 2021,
  epsg = 4326,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = c("RG", "LB"),
  country = NULL,
  level = c("all", "CITIES", "FUA", "GREATER_CITIES", "CITY", "KERN", "LUZ"),
  ext = "gpkg"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>

## Arguments

- year:

  character string or number. Release year of the file. One of `"2021"`,
  `"2020"`, `"2018"`, `"2014"`, `"2004"`, `"2001"` .

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

- spatialtype:

  character string. Type of geometry to be returned. Options available
  are:

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  - `"LB"`: Labels - `POINT` object.

- country:

  character vector of country codes. It could be either a vector of
  country names, a vector of ISO3 country codes or a vector of Eurostat
  country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- level:

  character string. Level of Urban Audit. Possible values `"all"` (the
  default), that would download the full dataset or `"CITIES"`, `"FUA"`,
  and (for versions prior to `year = 2020`) `"GREATER_CITIES"`,
  `"CITY"`, `"KERN"` or `"LUZ"`.

- ext:

  character. Extension of the file (default `"gpkg"`). One of `"shp"`,
  `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

See more in [Eurostat - Statistics
Explained](https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Territorial_typologies_for_European_cities_and_metropolitan_regions).

The cities are defined at several conceptual levels:

- The core city (`"CITIES"`), using an administrative definition.

- The Functional Urban Area/Large Urban Zone (`"FUA"`), approximating
  the functional urban region. The coverage is the EU plus Iceland,
  Norway and Switzerland . The dataset includes polygon features, point
  features and a related attribute table which can be joined on the URAU
  code field.

The `"URAU_CATG"` field defines the Urban Audit category:

- `"C"` = City.

- `"F"` = Functional Urban Area Service Type.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

See
[`gisco_get_unit_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
to download single files.

Other statistical units datasets:
[`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md),
[`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)

## Examples

``` r
# \donttest{

cities <- gisco_get_urban_audit(year = 2021, level = "CITIES")

if (!is.null(cities)) {
  bcn <- cities[cities$URAU_NAME == "Barcelona", ]

  library(ggplot2)
  ggplot(bcn) +
    geom_sf()
}

# }
```
