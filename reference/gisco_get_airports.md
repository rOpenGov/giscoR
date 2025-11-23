# Get location of airports and ports from GISCO API

Loads a [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
from GISCO API or your local library.

## Usage

``` r
gisco_get_airports(
  year = c("2006", "2013"),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
)

gisco_get_ports(
  year = c("2009", "2013"),
  country = NULL,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE
)
```

## Source

<https://ec.europa.eu/eurostat/web/gisco/geodata/transport-networks>

## Arguments

- year:

  Year of reference.

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

A `POINT` object on EPSG:4326.

## Details

`gisco_get_airports()` refer to Europe. All shapefiles provided in
[EPSG:4326](https://epsg.io/4326).

`gisco_get_ports()` adds a new field `CNTR_ISO2` to the original data
identifying the country of the port. Worldwide information available.
The port codes are aligned with UN/LOCODE standard.

## About caching

You can set your `cache_dir` with
[`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).

Sometimes cached files may be corrupt. On that case, try re-downloading
the data setting `update_cache = TRUE`.

If you experience any problem on download, try to download the
corresponding `.geojson` file by any other method and save it on your
`cache_dir`. Use the option `verbose = TRUE` for debugging the API
query.

For a complete list of files available check
[gisco_db](https://ropengov.github.io/giscoR/reference/gisco_db.md).

## See also

Other infrastructure:
[`gisco_get_education()`](https://ropengov.github.io/giscoR/reference/gisco_get_education.md),
[`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/reference/gisco_get_healthcare.md)

## Examples

``` r
# \donttest{
library(sf)

greece <- gisco_get_countries(country = "EL", resolution = 3)
airp_gc <- gisco_get_airports(2013, country = "EL")

library(ggplot2)

if (inherits(airp_gc, "sf")) {
  ggplot(greece) +
    geom_sf(fill = "grey80") +
    geom_sf(data = airp_gc, color = "blue") +
    labs(
      title = "Airports on Greece",
      shape = NULL,
      color = NULL,
      caption = gisco_attributions()
    )
}


# Plot ports

ports <- gisco_get_ports(2013)
coast <- giscoR::gisco_coastallines

# To Robinson projection :)

library(sf)
coast <- st_transform(coast, "ESRI:54030")
ports <- st_transform(ports, st_crs(coast))

if (inherits(ports, "sf")) {
  ggplot(coast) +
    geom_sf(fill = "#F6E1B9", color = "#0978AB") +
    geom_sf(data = ports, fill = "red", shape = 21) +
    theme_void() +
    theme(
      panel.background = element_rect(fill = "#C6ECFF"),
      panel.grid = element_blank(),
      plot.title = element_text(face = "bold", hjust = 0.5),
      plot.subtitle = element_text(face = "italic", hjust = 0.5)
    ) +
    labs(
      title = "Ports Worldwide", subtitle = "Year 2013",
      caption = "(c) European Union, 1995 - today"
    )
}

# }
```
