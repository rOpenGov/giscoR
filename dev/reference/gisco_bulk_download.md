# Bulk download from GISCO API

Downloads zipped data from GISCO and extract them on the
[`cache_dir`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
folder.

## Usage

``` r
gisco_bulk_download(
  id_giscor = c("countries", "coastal_lines", "communes", "lau", "nuts", "urban_audit",
    "postal_codes"),
  year = 2016,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  resolution = 10,
  ext = c("shp", "geojson"),
  recursive = deprecated(),
  ...
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

## Arguments

- id_giscor:

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
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

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

- ...:

  Ignored.

## Value

Silent function.

## Details

See the years available in the corresponding functions:

- [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md).

- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md).

- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md).

- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md).

- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md).

- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md).

The usual extension used across
[giscoR](https://CRAN.R-project.org/package=giscoR) is `"geojson"`,
however other formats are already available on GISCO.

## See also

Other political:
[`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)

## Examples

``` r
# \dontrun{

# Write on temp dir
tmp <- file.path(tempdir(), "testexample")

ss <- gisco_bulk_download(
  id_giscor = "countries", resolution = "60",
  year = 2016, ext = "geojson",
  cache_dir = tmp
)
# Read one
library(sf)
#> Linking to GEOS 3.13.1, GDAL 3.11.0, PROJ 9.6.0; sf_use_s2() is TRUE
f <- list.files(tmp, recursive = TRUE, full.names = TRUE)
f[1]
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpSKurdM/testexample/countries/CNTR_BN_60M_2016_3035.geojson"
sf::read_sf(f[1])
#> Simple feature collection with 1339 features and 9 fields
#> Geometry type: MULTILINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: -7032129 ymin: -9159740 xmax: 16931810 ymax: 15431090
#> Projected CRS: ETRS89-extended / LAEA Europe
#> # A tibble: 1,339 × 10
#>    EU_FLAG EFTA_FLAG CC_FLAG COAS_FLAG CNTR_BN_ID OTHR_FLAG POL_STAT
#>    <chr>   <chr>     <chr>   <chr>          <int> <chr>        <int>
#>  1 F       F         F       T                157 T                0
#>  2 F       F         F       T                158 T                0
#>  3 F       F         F       T                159 T                0
#>  4 F       F         F       T                160 T                0
#>  5 F       F         F       T                161 T                0
#>  6 F       F         F       T                162 T                0
#>  7 F       F         F       T                163 T                0
#>  8 F       F         F       T                164 T                0
#>  9 F       F         F       T                165 T                0
#> 10 F       F         F       T                166 T                0
#> # ℹ 1,329 more rows
#> # ℹ 3 more variables: CNTR_BN_CODE <int>, CNTR_CODE <chr>,
#> #   geometry <MULTILINESTRING [m]>

# Clean
unlink(tmp, force = TRUE)
# }
```
