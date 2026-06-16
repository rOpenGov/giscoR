# Communes dataset

This dataset shows pan-European administrative boundaries down to
commune level. Communes are equivalent to Local Administrative Units.
See
[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md).

## Usage

``` r
gisco_get_communes(
  year = 2016,
  epsg = 4326,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = "RG",
  country = NULL,
  ext = "shp"
)
```

## Source

<https://gisco-services.ec.europa.eu/distribution/v2/>.

Copyright:
<https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.

## Arguments

- year:

  A character string or numeric value with the release year of the file.
  One of `"2016"`, `"2013"`, `"2010"`, `"2008"`, `"2006"`, `"2004"`,
  `"2001"` .

- epsg:

  A character string or numeric value with the coordinate reference
  system as a 4-digit [EPSG code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

- cache:

  **\[deprecated\]**. These functions always cache the result because of
  its size. See **Caching strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  A logical value indicating whether to refresh the cached file.
  Defaults to `FALSE`. When set to `TRUE`, it forces a new download.

- cache_dir:

  A character string with a path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- verbose:

  A logical value. If `TRUE` displays informational messages.

- spatialtype:

  A character string with the type of geometry to return. Options
  available are:

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  - `"LB"`: Labels - `POINT` object.

  - `"BN"`: Boundaries - `LINESTRING` object.

    Argument `country` is only applied when `spatialtype` is `"RG"` or
    `"LB"`.

- country:

  A character vector of country codes. It can be either a vector of
  country names, a vector of ISO 3166-1 alpha-3 country codes or a
  vector of Eurostat country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

- ext:

  A character value with the extension of the file (default `"shp"`).
  One of `"shp"`, `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

The Nomenclature of Territorial Units for Statistics (NUTS) and the LAU
nomenclature are hierarchical classifications of statistical regions
that together subdivide the EU economic territory into regions of five
different levels, moving from larger to smaller territorial units: NUTS
1, 2 and 3 and LAU.

The dataset is based on EuroBoundaryMap from
[EuroGeographics](https://eurogeographics.org/). Geographical extent
covers the European Union 28, EFTA countries and candidate countries.
The scale of the dataset is 1:100 000.

The LAU classification is not covered by any legislative act.

## Note

Check the download and usage provisions in
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

## See also

[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md).

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

Administrative unit datasets:
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md),
[`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/reference/gisco_get_postal_codes.md)

## Examples

``` r
ire_comm <- gisco_get_communes(spatialtype = "LB", country = "Ireland")

if (!is.null(ire_comm)) {
  library(ggplot2)

  ggplot(ire_comm) +
    geom_sf(shape = 21, col = "#009A44", size = 0.5) +
    labs(
      title = "Communes in Ireland",
      subtitle = "Year 2016",
      caption = gisco_attributions()
    ) +
    theme_void() +
    theme(text = element_text(
      colour = "#009A44",
      family = "serif", face = "bold"
    ))
}
```
