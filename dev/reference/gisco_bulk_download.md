# GISCO API bulk download

Download zipped data from GISCO to the
[`cache_dir`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
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
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed? Default is `FALSE`. When
  set to `TRUE` it would force a new download.

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

  **\[deprecated\]** `recursive` is no longer supported; this function
  will never perform recursive extraction of child `.zip` files. This is
  the case of "`shp.zip` inside the top-level `.zip`, that won't be
  unzipped.

- ...:

  Ignored. The argument `id_giscoR` (**\[deprecated\]**) would be
  captured via `...` and re-directed to `id` with a
  [warning](https://lifecycle.r-lib.org/reference/deprecate_soft.html).

## Value

A (invisible) character vector with the full path of the files
extracted. See **Examples**.

## Details

Some arguments only apply to a specific value of `"id"`. For example
`"resolution"` would be ignored for values `"communes"`, `"lau"`,
`"urban_audit"` and `"postal_codes"`.

See years available in the corresponding functions:

- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md).

- [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md).

- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md).

- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md).

- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md).

- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md).

- [`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md).

The usual extensions used across
[giscoR](https://CRAN.R-project.org/package=giscoR) are `"gpkg"` and
`"shp"`, however other formats are already available on GISCO. Note that
after performing a bulk download you may need to adjust the default
`"ext"` value in the corresponding function to connect it with the
downloaded files (see **Examples**).

## See also

Additional utils for downloading datasets:
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
# Read one
library(sf)
#> Linking to GEOS 3.13.1, GDAL 3.11.4, PROJ 9.7.0; sf_use_s2() is TRUE
read_sf(dest_files[1]) |> head()
#> Simple feature collection with 6 features and 11 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 2110342 ymin: -3415366 xmax: 13761830 ymax: 2744026
#> Projected CRS: ETRS89-extended / LAEA Europe
#> # A tibble: 6 × 12
#>   CNTR_ID CNTR_NAME          NAME_ENGL NAME_FREN ISO3_CODE SVRG_UN CAPT  EU_STAT
#>   <chr>   <chr>              <chr>     <chr>     <chr>     <chr>   <chr> <chr>  
#> 1 CC      Cocos Keeling Isl… Cocos (K… Îles des… CCK       AU Ter… West… F      
#> 2 CD      République Démocr… Democrat… Républiq… COD       UN Mem… Kins… F      
#> 3 CF      République Centra… Central … Républiq… CAF       UN Mem… Bang… F      
#> 4 CG      Congo-Kongo-Kongó  Congo     Congo     COG       UN Mem… Braz… F      
#> 5 CH      Schweiz-Suisse-Sv… Switzerl… Suisse    CHE       UN Mem… Bern  F      
#> 6 CI      Côte D’Ivoire      Côte D’I… Côte d’I… CIV       UN Mem… Yamo… F      
#> # ℹ 4 more variables: EFTA_STAT <chr>, CC_STAT <chr>, NAME_GERM <chr>,
#> #   geometry <MULTIPOLYGON [m]>

# Now we can connect the function with the downloaded data like:

connect <- gisco_get_countries(
  resolution = 60,
  year = 2024, ext = "geojson",
  cache_dir = tmp, verbose = TRUE
)
#> ℹ Cache dir is C:\Users\RUNNER~1\AppData\Local\Temp\RtmpADjAsN/testexample/countries.
#> ✔ File already cached: C:\Users\RUNNER~1\AppData\Local\Temp\RtmpADjAsN/testexample/countries/CNTR_RG_60M_2024_4326.geojson.

# Message shows that file is already cached ;)
# }
# Clean
unlink(tmp, force = TRUE)
```
