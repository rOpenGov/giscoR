# Postal codes dataset

The postal code point dataset shows the location of postal codes, NUTS
codes and the Degree of Urbanisation classification across the EU, EFTA
and candidate countries from a variety of sources. Its primary purpose
is to create correspondence tables for the NUTS classification (EC)
1059/2003 as part of the Tercet Regulation (EU) 2017/2391.

## Usage

``` r
gisco_get_postal_codes(
  year = 2024,
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  ext = "gpkg"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>.

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.

## Arguments

- year:

  character string or number. Release year of the file. One of `"2024"`,
  `"2020"` .

- country:

  character vector of country codes. It could be either a vector of
  country names, a vector of ISO3 country codes or a vector of Eurostat
  country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed? Default is `FALSE`. When
  set to `TRUE` it would force a new download.

- verbose:

  logical. If `TRUE` displays informational messages.

- ext:

  character. Extension of the file (default `"gpkg"`). One of `"shp"`,
  `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Copyright

The dataset is released under the CC-BY-SA-4.0 licence and requires the
following attribution whenever used:

© European Union - GISCO, 2024, postal code point dataset, Licence
CC-BY-SA 4.0.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

Other administrative units datasets:
[`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md),
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)

## Examples

``` r
# Heavy-weight download!
# \dontrun{

pc_bel <- gisco_get_postal_codes(country = "BE")
#> ! The file to be downloaded has size 138.6 Mb.

if (!is.null(pc_bel)) {
  library(ggplot2)

  ggplot(pc_bel) +
    geom_sf(color = "gold") +
    theme_bw() +
    labs(
      title = "Postcodes of Belgium",
      subtitle = "2024",
      caption = paste("\u00a9 European Union - GISCO, 2024,",
        "postal code point dataset",
        "Licence CC-BY-SA 4.0",
        sep = "\n"
      )
    )
}

# }
```
