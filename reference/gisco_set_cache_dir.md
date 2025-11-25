# Set your [giscoR](https://CRAN.R-project.org/package=giscoR) cache dir

This function will store your `cache_dir` path on your local machine and
would load it for future sessions. Type `Sys.getenv("GISCO_CACHE_DIR")`
to find your cached path or use `gisco_detect_cache_dir()`.

## Usage

``` r
gisco_set_cache_dir(
  cache_dir,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
)

gisco_detect_cache_dir()
```

## Arguments

- cache_dir:

  A path to a cache directory. On missing value the function would store
  the cached files on a temporary dir (See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- overwrite:

  If this is set to `TRUE`, it will overwrite an existing
  `GISCO_CACHE_DIR` that you already have in local machine.

- install:

  If `TRUE`, will install the key in your local machine for use in
  future sessions. Defaults to `FALSE.` If `cache_dir` is `FALSE` this
  parameter is set to `FALSE` automatically.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

`gisco_set_cache_dir()` returns an (invisible) character with the path
to your `cache_dir`, but it is mainly called for its side effect.

`gisco_detect_cache_dir()` returns the path to the `cache_dir` used in
this session.

## Details

By default, when no cache `cache_dir` is set the package uses a folder
inside [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html) (so
files are temporary and are removed when the **R** session ends). To
persist a cache across **R** sessions, use
`gisco_set_cache_dir(cache_dir, install = TRUE)` which writes the chosen
path to a small configuration file under
`rappdirs::user_config_dir("giscoR", "R")`.

## Caching strategies

- For occasional use, rely on the default
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html)-based cache (no
  install).

- Modify the cache for a single session setting
  `gisco_set_cache_dir(cache_dir = "a/path/here)`.

- For reproducible workflows, install a persistent cache with
  `gisco_set_cache_dir(cache_dir = "a/path/here, install = TRUE)` that
  would be kept across **R** sessions.

- For caching specific files, use the `cache_dir` argument in the
  corresponding function. See example in
  [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md).

## See also

[`rappdirs::user_config_dir()`](https://rappdirs.r-lib.org/reference/user_data_dir.html)

Other cache utilities:
[`gisco_clear_cache()`](https://ropengov.github.io/giscoR/reference/gisco_clear_cache.md)

## Examples

``` r
# Don't run this! It would modify your current state
# \dontrun{
my_cache <- gisco_detect_cache_dir()
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\Rtmpayy1Is/giscoR

# Set an example cache
ex <- file.path(tempdir(), "example", "cachenew")
gisco_set_cache_dir(ex)
#> ℹ giscoR cache dir is C:\Users\RUNNER~1\AppData\Local\Temp\Rtmpayy1Is/example/cachenew.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.

gisco_detect_cache_dir()
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\Rtmpayy1Is/example/cachenew
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\Rtmpayy1Is/example/cachenew"

# Restore initial cache
gisco_set_cache_dir(my_cache)
#> ℹ giscoR cache dir is C:\Users\RUNNER~1\AppData\Local\Temp\Rtmpayy1Is/giscoR.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.
identical(my_cache, gisco_detect_cache_dir())
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\Rtmpayy1Is/giscoR
#> [1] TRUE
# }


gisco_detect_cache_dir()
#> ℹ C:\Users\RUNNER~1\AppData\Local\Temp\Rtmpayy1Is/giscoR
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\Rtmpayy1Is/giscoR"
```
