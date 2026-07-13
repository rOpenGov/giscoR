# GISCO geodata bulk download

Download zipped data from GISCO to the
[`cache_dir`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
and extract the relevant files.

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

  A character string or numeric value with the dataset type to download,
  see **Details**. Supported values are:

  - `"countries"`.

  - `"coastal_lines"`.

  - `"communes"`.

  - `"lau"`.

  - `"nuts"`.

  - `"urban_audit"`.

  - `"postal_codes"`.

    This argument replaces the previous (deprecated) argument
    `id_giscoR`.

- year:

  A character string or numeric value with the release year of the file,
  see **Details**.

- cache_dir:

  A character string with a path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  A logical value indicating whether to refresh the cached file.
  Defaults to `FALSE`. When set to `TRUE`, it forces a new download.

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

- ext:

  The extension of the file or files to download. Available formats are
  `"shp"`, `"geojson"`, `"svg"`, `"json"` and `"gdb"`. See **Details**.

- recursive:

  **\[deprecated\]** `recursive` is no longer supported. It will never
  perform recursive extraction of child `.zip` files. This is the case
  for `shp.zip` inside the top-level `.zip`, which will not be unzipped.

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

See available years in the corresponding functions:

- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md).

- [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md).

- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md).

- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md).

- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md).

- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md).

- [`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md).

The usual extensions used across
[giscoR](https://CRAN.R-project.org/package=giscoR) are `"gpkg"` and
`"shp"`, but other formats are already available on GISCO. After a bulk
download, you may need to adjust the default `ext` value in the
corresponding function to connect it with the downloaded files (see
**Examples**).

## See also

[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)
to inspect available datasets, years and file formats before
downloading.

Bulk and single-unit downloads:
[`gisco_get_unit`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)

## Examples

``` r
tmp <- file.path(tempdir(), "testexample")
# \donttest{
dest_files <- gisco_bulk_download(
  id = "countries", resolution = 60,
  year = 2024, ext = "geojson",
  cache_dir = tmp
)
# Read one file.
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE
read_sf(dest_files[1]) |> head()
#> Simple feature collection with 6 features and 13 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 2110342 ymin: -3415366 xmax: 13761830 ymax: 2744026
#> Projected CRS: ETRS89-extended / LAEA Europe
#> # A tibble: 6 × 14
#>   CNTR_ID COUNTRY_URI CNTR_NAME      NAME_ENGL NAME_FREN ISO3_CODE SVRG_UN CAPT 
#>   <chr>   <chr>       <chr>          <chr>     <chr>     <chr>     <chr>   <chr>
#> 1 CC      CCK         Cocos Keeling… Cocos (K… Îles des… CCK       AU Ter… West…
#> 2 CD      COD         République Dé… Democrat… Républiq… COD       UN Mem… Kins…
#> 3 CF      CAF         République Ce… Central … Républiq… CAF       UN Mem… Bang…
#> 4 CG      COG         Congo-Kongo-K… Congo     Congo     COG       UN Mem… Braz…
#> 5 CH      CHE         Schweiz-Suiss… Switzerl… Suisse    CHE       UN Mem… Bern 
#> 6 CI      CIV         Côte D’Ivoire  Côte D’I… Côte d’I… CIV       UN Mem… Yamo…
#> # ℹ 6 more variables: STAT_CODE <chr>, EU_STAT <chr>, EFTA_STAT <chr>,
#> #   CC_STAT <chr>, NAME_GERM <chr>, geometry <MULTIPOLYGON [m]>

# Connect the function with the downloaded data.

connect <- gisco_get_countries(
  resolution = 60,
  year = 2024, ext = "geojson",
  cache_dir = tmp, verbose = TRUE
)
#> ℹ Cache directory is /tmp/Rtmpeevyeh/testexample/countries.
#> ✔ File already cached: /tmp/Rtmpeevyeh/testexample/countries/CNTR_RG_60M_2024_4326.geojson.

# The message shows that the file is already cached.
# }
# Clean up.
unlink(tmp, force = TRUE)
```
