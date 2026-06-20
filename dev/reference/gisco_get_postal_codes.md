# Postal codes dataset

The postal code point dataset shows the location of postal codes, NUTS
codes and the degree of urbanisation classification across the EU, EFTA
and candidate countries. Its primary purpose is to create correspondence
tables for the NUTS classification established by Regulation (EC) No
1059/2003 as part of the Tercet Regulation (EU) 2017/2391.

## Usage

``` r
gisco_get_postal_codes(
  year = 2025,
  epsg = 4326,
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  ext = "gpkg"
)
```

## Source

GISCO administrative units:
<https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.

GISCO postal code distribution API:
<https://gisco-services.ec.europa.eu/distribution/v2/pcode/>.

## Arguments

- year:

  A character string or numeric value with the release year of the file.
  One of `"2025"`, `"2024"`, `"2020"` .

- epsg:

  A character string or numeric value with the coordinate reference
  system as a 4-digit [EPSG code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

- country:

  A character vector of country codes. It can be either a vector of
  country names, a vector of ISO 3166-1 alpha-3 country codes or a
  vector of Eurostat country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

- cache_dir:

  A character string with a path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  A logical value indicating whether to refresh the cached file.
  Defaults to `FALSE`. When set to `TRUE`, it forces a new download.

- verbose:

  A logical value indicating whether to display informational messages.

- ext:

  A character value with the extension of the file (default `"gpkg"`).
  One of `"shp"`, `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

The GISCO distribution API provides postal code releases for 2025, 2024
and 2020. The 2025 release has a reference date of 1 January 2025.

## Copyright

The dataset is released under the CC-BY-SA-4.0 license. Although the
distribution API provides a 2025 release, the official GISCO licensing
page currently requires the following attribution: © European Union -
GISCO, 2024, postal code point dataset, Licence CC-BY-SA 4.0.

## Note

This dataset is not covered by
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).
Use the attribution specified above until GISCO publishes revised
licensing text.

Non-geographical postal codes, such as post boxes and codes used by
large organizations, are not included. The dataset may omit or
incorrectly locate postal codes because the source data vary
considerably among countries.

## See also

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

Administrative unit datasets:
[`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md),
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)

## Examples

``` r

# Large download.
# \dontrun{

pc_bel <- gisco_get_postal_codes(year = 2025, country = "BE")
#> ! The file to download is "200.4 Mb".

if (!is.null(pc_bel)) {
  library(ggplot2)

  ggplot(pc_bel) +
    geom_sf(color = "gold") +
    theme_bw() +
    labs(
      title = "Postcodes of Belgium",
      subtitle = "2025",
      caption = paste("\u00a9 European Union - GISCO, 2024,",
        "postal code point dataset",
        "Licence CC-BY-SA 4.0",
        sep = "\n"
      )
    )
}

# }
```
