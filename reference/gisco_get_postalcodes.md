# Get postal code points from GISCO

Get postal codes points of the EU, EFTA and candidate countries.

## Usage

``` r
gisco_get_postalcodes(
  year = "2024",
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>

## Arguments

- year:

  Year of reference. one of `"2024"`, `"2020"` .

- country:

  Optional. A character vector of country codes. It could be either a
  vector of country names, a vector of ISO3 country codes or a vector of
  Eurostat country codes. Mixed types (as `c("Italy","ES","FRA")`) would
  not work. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- cache_dir:

  A path to a cache directory. See **About caching**.

- update_cache:

  A logical whether to update cache. Default is `FALSE`. When set to
  `TRUE` it would force a fresh download of the source `.geojson` file.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

A `POINT` [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object on EPSG:4326.

## Details

The postal code point dataset shows the location of postal codes, NUTS
codes and the Degree of Urbanisation classification across the EU, EFTA
and candidate countries from a variety of sources. Its primary purpose
is to create correspondence tables for the NUTS classification (EC)
1059/2003 as part of the Tercet Regulation (EU) 2017/2391

## Copyright

The dataset is released under the CC-BY-SA-4.0 licence and requires the
following attribution whenever used:

*(c) European Union - GISCO, 2024, postal code point dataset, Licence
CC-BY-SA 4.0 available at
<https://ec.europa.eu/eurostat/web/gisco/geodata//administrative-units/postal-codes>*.

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

Other political:
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md),
[`gisco_get_coastallines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastallines.md),
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get.md),
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md),
[`gisco_get_units()`](https://ropengov.github.io/giscoR/reference/gisco_get_units.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md)

## Examples

``` r
# Heavy-weight download!
# \dontrun{

pc_bel <- gisco_get_postalcodes(country = "BE")

if (!is.null(pc_bel)) {
  library(ggplot2)

  ggplot(pc_bel) +
    geom_sf(color = "gold") +
    theme_bw() +
    labs(
      title = "Postcodes of Belgium",
      subtitle = "2024",
      caption = paste("(c) European Union - GISCO, 2024,",
        "postal code point dataset",
        "Licence CC-BY-SA 4.0",
        sep = "\n"
      )
    )
}

# }
```
