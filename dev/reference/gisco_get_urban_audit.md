# Urban Audit dataset

This dataset contains the boundaries of cities (`"CITIES"`), greater
cities (`"GREATER_CITIES"`) and functional urban areas (`"FUA"`) defined
according to the EC-OECD city definition. It is used for the Eurostat
Urban Audit data collection.

Downloads data from the aggregated GISCO Urban Audit file. To download
single-unit Urban Audit files, use
[`gisco_get_unit_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md).

## Usage

``` r
gisco_get_urban_audit(
  year = 2024,
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

GISCO Urban Audit distribution API:
<https://gisco-services.ec.europa.eu/distribution/v2/urau/>.

## Arguments

- year:

  A character string or numeric value with the release year of the file.
  One of `"2024"`, `"2021"`, `"2020"`, `"2018"`, `"2014"`, `"2004"`,
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

- spatialtype:

  A character string with the type of geometry to return. Options
  available are:

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  - `"LB"`: Labels - `POINT` object.

- country:

  A character vector of country codes. It can be either a vector of
  country names, a vector of ISO 3166-1 alpha-3 country codes or a
  vector of Eurostat country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

- level:

  A character string with the Urban Audit level. Possible values are
  `"all"` (the default), which downloads the full dataset, `"CITIES"`,
  `"FUA"` and, for versions prior to `year = 2020`, `"GREATER_CITIES"`,
  `"CITY"`, `"KERN"` or `"LUZ"`.

- ext:

  A character value with the extension of the file (default `"gpkg"`).
  One of `"shp"`, `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

For more information, see: [Eurostat - Statistics
Explained](https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Territorial_typologies_for_European_cities_and_metropolitan_regions).

Cities are defined at several conceptual levels:

- The core city (`"CITIES"`), using an administrative definition.

- The Functional Urban Area/Large Urban Zone (`"FUA"`), approximating
  the functional urban region. Coverage includes the EU, Iceland, Norway
  and Switzerland. The dataset includes polygon features, point features
  and a related attribute table which can be joined on the URAU code
  field.

The `"URAU_CATG"` field defines the Urban Audit category:

- `"C"` = City.

- `"F"` = Functional urban area service type.

## Copyright

See the GISCO statistical unit copyright provisions:
<https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>.

## Note

Check the download and usage provisions in
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

See
[`gisco_get_unit_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
to download single-unit files.

Statistical unit datasets:
[`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md),
[`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)

## Examples

``` r
# \donttest{

cities <- gisco_get_urban_audit(year = 2024, level = "CITIES")

if (!is.null(cities)) {
  bcn <- cities[cities$URAU_NAME == "Barcelona", ]

  library(ggplot2)
  ggplot(bcn) +
    geom_sf()
}

# }
```
