# Clear your [giscoR](https://CRAN.R-project.org/package=giscoR) cache directory

**Use this function with caution**. It clears your cached data and
configuration, specifically:

- Deletes the [giscoR](https://CRAN.R-project.org/package=giscoR) config
  directory (`tools::R_user_dir("giscoR", "config")`).

- Deletes the `cache_dir` directory.

- Deletes the value stored in `Sys.getenv("GISCO_CACHE_DIR")`.

## Usage

``` r
gisco_clear_cache(config = FALSE, cached_data = TRUE, verbose = FALSE)
```

## Arguments

- config:

  If `TRUE`, delete the configuration folder of
  [giscoR](https://CRAN.R-project.org/package=giscoR).

- cached_data:

  If `TRUE`, delete your `cache_dir` and all its content.

- verbose:

  A logical value indicating whether to display informational messages.

## Value

Invisible. Called for its side effects.

## Details

Fully resets your cache state as if you had never installed or used
[giscoR](https://CRAN.R-project.org/package=giscoR).

## See also

[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html)

Cache management utilities:
[`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)

## Examples

``` r

# Do not run this. It modifies your current state.
# \dontrun{
my_cache <- gisco_detect_cache_dir()
#> ℹ /tmp/Rtmp8dFve8/giscoR

# Set an example cache.
ex <- file.path(tempdir(), "example", "cache")
gisco_set_cache_dir(ex, verbose = FALSE)

# Restore the initial cache.
gisco_clear_cache(verbose = TRUE)
#> ! Deleted giscoR data: /tmp/Rtmp8dFve8/example/cache (0 bytes).

gisco_set_cache_dir(my_cache)
#> ℹ giscoR cache directory is /tmp/Rtmp8dFve8/giscoR.
#> ℹ To install your `cache_dir` path for future sessions, run this function with `install` = TRUE.
identical(my_cache, gisco_detect_cache_dir())
#> ℹ /tmp/Rtmp8dFve8/giscoR
#> [1] TRUE
# }
```
