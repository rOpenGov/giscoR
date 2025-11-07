# Set your [giscoR](https://CRAN.R-project.org/package=giscoR) cache dir

This function will store your `cache_dir` path on your local machine and
would load it for future sessions. Type `Sys.getenv("GISCO_CACHE_DIR")`
to find your cached path or use `gisco_detect_cache_dir()`.

Alternatively, you can store the `cache_dir` manually with the following
options:

- Run `Sys.setenv(GISCO_CACHE_DIR = "cache_dir")`. You would need to run
  this command on each session (Similar to `install = FALSE`).

- Write this line on your `.Renviron` file:
  `GISCO_CACHE_DIR = "value_for_cache_dir"` (same behavior than
  `install = TRUE`). This would store your `cache_dir` permanently. See
  also
  [`usethis::edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html).

## Usage

``` r
gisco_set_cache_dir(
  cache_dir,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
)

gisco_detect_cache_dir(...)
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

- ...:

  Ignored

## Value

`gisco_set_cache_dir()` returns an (invisible) character with the path
to your `cache_dir`, but it is mainly called for its side effect.

`gisco_detect_cache_dir()` returns the path to the `cache_dir` used in
this session.

## See also

[`rappdirs::user_config_dir()`](https://rappdirs.r-lib.org/reference/user_data_dir.html)

Other cache utilities:
[`gisco_clear_cache()`](https://ropengov.github.io/giscoR/reference/gisco_clear_cache.md)

## Examples

``` r
# Don't run this! It would modify your current state
# \dontrun{
gisco_set_cache_dir(verbose = TRUE)
#> Using a temporary cache dir.  Set 'cache_dir' to a value for store permanently
#> giscoR cache dir is:  C:\Users\RUNNER~1\AppData\Local\Temp\RtmpKY0xVG/giscoR
# }

Sys.getenv("GISCO_CACHE_DIR")
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpKY0xVG/giscoR"

gisco_detect_cache_dir()
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpKY0xVG/giscoR"
```
