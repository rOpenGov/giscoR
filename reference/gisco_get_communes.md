# Communes dataset

This dataset shows pan European administrative boundaries down to
commune level. Communes are equivalent to Local Administrative Units,
see
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

  character string or number. Release year of the file. One of `"2016"`,
  `"2013"`, `"2010"`, `"2008"`, `"2006"`, `"2004"`, `"2001"` .

- epsg:

  character string or number. Projection of the map: 4-digit [EPSG
  code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

- cache:

  **\[deprecated\]**. These functions always cache the result due to the
  size. See **Caching strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed? Default is `FALSE`. When
  set to `TRUE` it would force a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

- verbose:

  logical. If `TRUE` displays informational messages.

- spatialtype:

  character string. Type of geometry to be returned. Options available
  are:

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  - `"LB"`: Labels - `POINT` object.

  - `"BN"`: Boundaries - `LINESTRING` object.

  **Note that** argument `country` would be only applied when
  `spatialtype` is `"RG"` or `"LB"`.

- country:

  character vector of country codes. It could be either a vector of
  country names, a vector of ISO3 country codes or a vector of Eurostat
  country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

- ext:

  character. Extension of the file (default `"shp"`). One of `"shp"`,
  `"gpkg"`, `"geojson"` .

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

The Nomenclature of Territorial Units for Statistics (NUTS) and the LAU
nomenclature are hierarchical classifications of statistical regions
that together subdivide the EU economic territory into regions of five
different levels (NUTS 1, 2 and 3 and LAU, respectively, moving from
larger to smaller territorial units).

The dataset is based on EuroBoundaryMap from
[EuroGeographics](https://eurogeographics.org/). Geographical extent
covers the European Union 28, EFTA countries, and candidate countries.
The scale of the dataset is 1:100 000.

The LAU classification is not covered by any legislative act.

## Note

Please check the download and usage provisions on
[`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md).

## See also

[`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md).

See
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md)
to perform a bulk download of datasets.

Other administrative units datasets:
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
