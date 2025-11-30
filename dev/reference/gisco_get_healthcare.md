# Get locations of healthcare services in Europe

The dataset contains information on main healthcare services considered
to be 'hospitals' by Member States.

## Usage

``` r
gisco_get_healthcare(
  year = c(2023, 2020),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL
)
```

## Source

<https://ec.europa.eu/eurostat/web/gisco/geodata/basic-services>

## Arguments

- year:

  Release year of the file. One of `"2020"`, `"2023"` (default).

- cache:

  logical. Whether to do caching. Default is `TRUE`. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- verbose:

  logical. If `TRUE` displays informational messages.

- country:

  character vector of country codes. It could be either a vector of
  country names, a vector of ISO3 country codes or a vector of Eurostat
  country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

## Value

A `POINT` [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object.

## Details

Files are distributed on EPSG:4326. Metadata available on
<https://gisco-services.ec.europa.eu/pub/healthcare/metadata.pdf>.

## See also

[`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)

Other infrastructure:
[`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md),
[`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md)

## Author

dieghernan, <https://github.com/dieghernan/>

## Examples

``` r
# \donttest{

health_be <- gisco_get_healthcare(country = "Belgium")

# Plot if downloaded
if (inherits(health_be, "sf")) {
  library(ggplot2)
  ggplot(health_be) +
    geom_sf()
}

# }
```
