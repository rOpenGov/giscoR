# Airports dataset

This function accesses the GISCO airport and heliport datasets. Airports
are identified using International Civil Aviation Organization (ICAO)
airport codes.

## Usage

``` r
gisco_get_airports(
  year = c(2024, 2013, 2006),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
)
```

## Source

<https://ec.europa.eu/eurostat/web/gisco/geodata/transport-networks>.

## Arguments

- year:

  A character string or numeric value with the release year of the file.
  One of `2024`, `2013`, `2006`.

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

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

The returned object is transformed to [EPSG:4326](https://epsg.io/4326).

## Copyright

See the Eurostat general copyright and licence provisions:
<https://ec.europa.eu/eurostat/web/gisco/geodata>.

## See also

Transport network datasets:
[`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md)

## Examples

``` r
airp <- gisco_get_airports(year = 2024)
coast <- giscoR::gisco_get_countries(year = 2024)

if (!is.null(airp)) {
  library(ggplot2)

  ggplot(coast) +
    geom_sf(fill = "grey10", color = "grey20") +
    geom_sf(
      data = airp, color = "#00F0FF",
      size = 0.2, alpha = 0.25
    ) +
    theme_void() +
    theme(
      plot.background = element_rect(fill = "black"),
      text = element_text(color = "white"),
      panel.grid = element_blank(),
      plot.title = element_text(face = "bold", hjust = 0.5),
      plot.subtitle = element_text(face = "italic", hjust = 0.5)
    ) +
    labs(
      title = "Airports in Europe", subtitle = "Year 2024",
      caption = "Source: Eurostat, Airports 2024 dataset."
    ) +
    # Center on Europe with EPSG 3035.
    coord_sf(
      crs = 3035,
      xlim = c(2377294, 7453440),
      ylim = c(1313597, 5628510)
    )
}
```
