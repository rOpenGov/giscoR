# Clear your [giscoR](https://CRAN.R-project.org/package=giscoR) cache dir

**Use this function with caution**. This function would clear your
cached data and configuration, specifically:

- Deletes the [giscoR](https://CRAN.R-project.org/package=giscoR) config
  directory (`tools::R_user_dir("giscoR", "config")`).

- Deletes the `cache_dir` directory.

- Deletes the values on stored on `Sys.getenv("GISCO_CACHE_DIR")`.

## Usage

``` r
gisco_clear_cache(config = FALSE, cached_data = TRUE, verbose = FALSE)
```

## Arguments

- config:

  if `TRUE`, will delete the configuration folder of
  [giscoR](https://CRAN.R-project.org/package=giscoR).

- cached_data:

  If this is set to `TRUE`, it will delete your `cache_dir` and all its
  content.

- verbose:

  logical. If `TRUE` displays informational messages.

## Value

Invisible. This function is called for its side effects.

## Details

This is an overkill function that is intended to reset your status as if
you would never have installed and/or used
[giscoR](https://CRAN.R-project.org/package=giscoR).

## See also

[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html)

Other cache utilities:
[`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)

## Examples

``` r
# Don't run this! It would modify your current state
# \dontrun{
my_cache <- gisco_detect_cache_dir()
#> ℹ /tmp/Rtmplb5Mz4/giscoR

# Set an example cache
ex <- file.path(tempdir(), "example", "cache")
gisco_set_cache_dir(ex, verbose = FALSE)

# Restore initial cache
gisco_clear_cache(verbose = TRUE)
#> ! giscoR data deleted: /tmp/Rtmplb5Mz4/example/cache (0 bytes).

gisco_set_cache_dir(my_cache)
#> ℹ giscoR cache dir is /tmp/Rtmplb5Mz4/giscoR.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.
identical(my_cache, gisco_detect_cache_dir())
#> ℹ /tmp/Rtmplb5Mz4/giscoR
#> [1] TRUE
# }
```
