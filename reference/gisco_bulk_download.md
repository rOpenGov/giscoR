# Bulk download from GISCO API

Downloads zipped data from GISCO and extract them on the
[`cache_dir`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md)
folder.

## Usage

``` r
gisco_bulk_download(
  id_giscoR = c("countries", "coastallines", "communes", "lau", "nuts", "urban_audit"),
  year = "2016",
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  resolution = "10",
  ext = c("geojson", "shp", "svg", "json", "gdb"),
  recursive = TRUE
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

## Arguments

- id_giscoR:

  Type of dataset to be downloaded. Values supported are:

  - `"coastallines"`.

  - `"communes"`.

  - `"countries"`.

  - `"lau"`.

  - `"nuts"`.

  - `"urban_audit"`.

- year:

  Release year of the file. See **Details**.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- verbose:

  logical. If `TRUE` displays informational messages.

- resolution:

  character string or number. Resolution of the geospatial data. One of:

  - `"60"`: 1:60million

  - `"20"`: 1:20million

  - `"10"`: 1:10million

  - `"03"`: 1:3million

  - `"01"`: 1:1million

- ext:

  Extension of the file(s) to be downloaded. Formats available are
  `"geojson"`, `"shp"`, `"svg"`, `"json"`, `"gdb"`. See **Details**.

- recursive:

  Tries to unzip recursively the zip files (if any) included in the
  initial bulk download (case of `ext = "shp"`).

## Value

Silent function.

## Details

See the years available in the corresponding functions:

- [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastal_lines.md).

- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/reference/gisco_get_communes.md).

- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md).

- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md).

- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md).

- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md).

The usual extension used across
[giscoR](https://CRAN.R-project.org/package=giscoR) is `"geojson"`,
however other formats are already available on GISCO.

## See also

Other political:
[`gisco_get_units()`](https://ropengov.github.io/giscoR/reference/gisco_get_units.md)

## Examples

``` r
# \dontrun{

# Countries 2016 - It would take some time
gisco_bulk_download(id_giscoR = "countries", resolution = "60")
# }
```
