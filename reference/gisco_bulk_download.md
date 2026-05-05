# GISCO API bulk download

Download zipped data from GISCO to the
[`cache_dir`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md)
and extract the relevant ones.

## Usage

``` r
gisco_bulk_download(
  id = c("countries", "coastal_lines", "communes", "lau", "nuts", "urban_audit",
    "postal_codes"),
  year = 2016,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  resolution = 10,
  ext = c("shp", "geojson", "svg", "json", "gdb"),
  recursive = deprecated(),
  ...
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>.

## Arguments

- id:

  character string or number. Type of dataset to be downloaded, see
  **Details**. Values supported are:

  - `"countries"`

  - `"coastal_lines"`

  - `"communes"`

  - `"lau"`

  - `"nuts"`

  - `"urban_audit"`

  - `"postal_codes"`

  This argument replaces the previous (deprecated) argument `id_giscoR`.

- year:

  character string or number. Release year of the file, see **Details**.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed? Default is `FALSE`. When
  set to `TRUE` it forces a new download.

- verbose:

  logical. If `TRUE` displays informational messages.

- resolution:

  character string or number. Resolution of the geospatial data. One of:

  - `"60"`: 1:60 million.

  - `"20"`: 1:20 million.

  - `"10"`: 1:10 million.

  - `"03"`: 1:3 million.

  - `"01"`: 1:1 million.

- ext:

  Extension of the file(s) to be downloaded. Formats available are
  `"shp"`, `"geojson"`, `"svg"`, `"json"`, `"gdb"`. See **Details**.

- recursive:

  **\[deprecated\]** `recursive` is no longer supported, and this
  function will never perform recursive extraction of child `.zip`
  files. This is the case of "`shp.zip` inside the top-level `.zip`,
  that won't be unzipped.

- ...:

  Ignored. The argument `id_giscoR` (**\[deprecated\]**) is captured via
  `...` and redirected to `id` with a
  [warning](https://lifecycle.r-lib.org/reference/deprecate_soft.html).

## Value

An invisible character vector with the full path of the files extracted.
See **Examples**.

## Details

Some arguments only apply to a specific value of `"id"`. For example
`"resolution"` is ignored for values `"communes"`, `"lau"`,
`"urban_audit"` and `"postal_codes"`.

See years available in the corresponding functions:

- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md).

- [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastal_lines.md).

- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/reference/gisco_get_communes.md).

- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md).

- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md).

- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md).

- [`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/reference/gisco_get_postal_codes.md).

The usual extensions used across
[giscoR](https://CRAN.R-project.org/package=giscoR) are `"gpkg"` and
`"shp"`, however other formats are already available on GISCO. Note that
after performing a bulk download you may need to adjust the default
`"ext"` value in the corresponding function to connect it with the
downloaded files (see **Examples**).

## See also

Additional utils for downloading datasets:
[`gisco_get_unit`](https://ropengov.github.io/giscoR/reference/gisco_get_unit.md)

## Examples

``` r
if (FALSE) { # gisco_check_access()
tmp <- file.path(tempdir(), "testexample")
# \donttest{
dest_files <- gisco_bulk_download(
  id = "countries", resolution = 60,
  year = 2024, ext = "geojson",
  cache_dir = tmp
)
# Read one
library(sf)
read_sf(dest_files[1]) |> head()

# Now we can connect the function with the downloaded data like:

connect <- gisco_get_countries(
  resolution = 60,
  year = 2024, ext = "geojson",
  cache_dir = tmp, verbose = TRUE
)

# Message shows that file is already cached
# }
# Clean
unlink(tmp, force = TRUE)
}
```
