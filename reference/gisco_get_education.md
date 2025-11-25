# Get locations of education services in Europe

The dataset contains information on main education services by Member
States.

## Usage

``` r
gisco_get_education(
  year = c("2023", "2020"),
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

  A logical whether to do caching. Default is `TRUE`. See **About
  caching**.

- update_cache:

  A logical whether to update cache. Default is `FALSE`. When set to
  `TRUE` it would force a fresh download of the source `.geojson` file.

- cache_dir:

  A path to a cache directory. See **About caching**.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- country:

  Optional. A character vector of country codes. It could be either a
  vector of country names, a vector of ISO3 country codes or a vector of
  Eurostat country codes. Mixed types (as `c("Italy","ES","FRA")`) would
  not work. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

## Value

A `POINT` [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object.

## Details

Files are distributed on EPSG:4326. Metadata available on
<https://gisco-services.ec.europa.eu/pub/education/metadata.pdf>.

## About caching

You can set your `cache_dir` with
[`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

Sometimes cached files may be corrupt. On that case, try re-downloading
the data setting `update_cache = TRUE`.

If you experience any problem on download, try to download the
corresponding file by any other method and save it on your `cache_dir`.
Use the option `verbose = TRUE` for debugging the API query.

For a complete list of files available check
[gisco_db](https://ropengov.github.io/giscoR/reference/gisco_db.md).

## See also

[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get.md)

Other infrastructure:
[`gisco_get_airports()`](https://ropengov.github.io/giscoR/reference/gisco_get_airports.md),
[`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/reference/gisco_get_healthcare.md)

## Author

dieghernan, <https://github.com/dieghernan/>

## Examples

``` r
# \donttest{

edu_BEL <- gisco_get_education(country = "Belgium")

# Plot if downloaded
if (nrow(edu_BEL) > 3) {
  library(ggplot2)
  ggplot(edu_BEL) +
    geom_sf(shape = 21, size = 0.15)
}

# }
```
