# Local Administrative Units (LAU) dataset

This dataset shows pan-European administrative boundaries down to
commune level. Local Administrative Units are equivalent to communes.
See
[`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md).

## Usage

``` r
gisco_get_lau(
  year = 2024,
  epsg = 4326,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL,
  gisco_id = NULL,
  ext = "gpkg"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>.

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>.

## Arguments

- year:

  A character string or numeric value with the release year of the file.
  One of `"2024"`, `"2023"`, `"2022"`, `"2021"`, `"2020"`, `"2019"`,
  `"2018"`, `"2017"`, `"2016"`, `"2015"`, `"2014"`, `"2013"`, `"2012"`,
  `"2011"` .

- epsg:

  A character string or numeric value with the coordinate reference
  system as a 4-digit [EPSG code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

- cache:

  **\[deprecated\]**. Always caches the result due to its size. See
  **Caching strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  A logical value indicating whether to refresh the cached file.
  Defaults to `FALSE`. When set to `TRUE`, it forces a new download.

- cache_dir:

  A character string with a path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- verbose:

  A logical value. If `TRUE` displays informational messages.

- country:

  A character vector of country codes. It can be either a vector of
  country names, a vector of ISO 3166-1 alpha-3 country codes or a
  vector of Eurostat country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

- gisco_id:

  An optional character vector of `GISCO_ID` LAU values.

- ext:

  A character value with the extension of the file (default `"gpkg"`).
  One of `"shp"`, `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

The Nomenclature of Territorial Units for Statistics (NUTS) and the LAU
nomenclature are hierarchical classifications of statistical regions
that together subdivide the EU economic territory into regions of five
different levels, moving from larger to smaller territorial units: NUTS
1, 2 and 3 and LAU.

The LAU classification is not covered by any legislative act.
Geographical extent covers the European Union, EFTA countries and
candidate countries. The scale of the dataset is 1:100 000.

The data contain the National Statistical Agency LAU code, which can be
joined to LAU lists. They also contain a `GISCO_ID` field, which is a
unique identifier consisting of the country code and LAU code.

Total resident population figures (31 December) have also been added in
some versions based on the associated LAU lists.

## Note

Check the download and usage provisions in
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

[`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md).

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

See
[`gisco_id_api_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
to download via GISCO ID service API.

Statistical unit datasets:
[`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md),
[`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)

## Examples

``` r
# \dontrun{

lu_lau <- gisco_get_lau(year = 2024, country = "Luxembourg")
#> ! The file to download is 74.6 Mb.

if (!is.null(lu_lau)) {
  library(ggplot2)

  ggplot(lu_lau) +
    geom_sf(aes(fill = POP_DENS_2024)) +
    labs(
      title = "Population density in Luxembourg",
      subtitle = "Year 2024",
      caption = gisco_attributions()
    ) +
    scale_fill_viridis_b(
      option = "cividis",
      label = \(x) prettyNum(x, big.mark = ",")
    ) +
    theme_void() +
    labs(fill = "pop/km2")
}

# }
```
