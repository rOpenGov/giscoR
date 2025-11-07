# Package index

## Political

These functions return
[sf](https://r-spatial.github.io/sf/reference/sf.html) objects with
political boundaries

- [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md)
  : Bulk download from GISCO API

- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get.md)
  :

  Get GISCO world country
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) polygons,
  points and lines

- [`gisco_get_coastallines()`](https://ropengov.github.io/giscoR/reference/gisco_get_coastallines.md)
  :

  Get GISCO coastlines
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) polygons

- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md)
  [`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md)
  :

  Get GISCO urban areas
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) polygons,
  points and lines

- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md)
  :

  Get GISCO NUTS
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) polygons,
  points and lines

- [`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/reference/gisco_get_postalcodes.md)
  : Get postal code points from GISCO

- [`gisco_get_units()`](https://ropengov.github.io/giscoR/reference/gisco_get_units.md)
  : Get geospatial units data from GISCO API

- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md)
  :

  Get GISCO greater cities and metropolitan areas
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) objects

## Infrastructures

These functions return
[sf](https://r-spatial.github.io/sf/reference/sf.html) objects with
man-made features

- [`gisco_get_airports()`](https://ropengov.github.io/giscoR/reference/gisco_get_airports.md)
  [`gisco_get_ports()`](https://ropengov.github.io/giscoR/reference/gisco_get_airports.md)
  : Get location of airports and ports from GISCO API
- [`gisco_get_education()`](https://ropengov.github.io/giscoR/reference/gisco_get_education.md)
  : Get locations of education services in Europe
- [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/reference/gisco_get_healthcare.md)
  : Get locations of healthcare services in Europe

## Tools

Access to other GISCO tools

- [`gisco_addressapi_search()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  [`gisco_addressapi_reverse()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  [`gisco_addressapi_bbox()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  [`gisco_addressapi_countries()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  [`gisco_addressapi_provinces()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  [`gisco_addressapi_cities()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  [`gisco_addressapi_roads()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  [`gisco_addressapi_housenumbers()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  [`gisco_addressapi_postcodes()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  [`gisco_addressapi_copyright()`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
  : GISCO Address API

## Misc

These functions return other
[sf](https://r-spatial.github.io/sf/reference/sf.html) objects

- [`gisco_get_grid()`](https://ropengov.github.io/giscoR/reference/gisco_get_grid.md)
  : Get grid cells covering covering Europe for various resolutions

## Cache management

- [`gisco_clear_cache()`](https://ropengov.github.io/giscoR/reference/gisco_clear_cache.md)
  :

  Clear your [giscoR](https://CRAN.R-project.org/package=giscoR) cache
  dir

- [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md)
  [`gisco_detect_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md)
  :

  Set your [giscoR](https://CRAN.R-project.org/package=giscoR) cache dir

## Helpers

A collection of helper functions

- [`gisco_attributions()`](https://ropengov.github.io/giscoR/reference/gisco_attributions.md)
  : Attribution when publishing GISCO data
- [`gisco_check_access()`](https://ropengov.github.io/giscoR/reference/gisco_check_access.md)
  : Check access to GISCO API

## Datasets

Datasets included with
[giscoR](https://CRAN.R-project.org/package=giscoR)

- [`gisco_coastallines`](https://ropengov.github.io/giscoR/reference/gisco_coastallines.md)
  :

  World coastal lines `POLYGON` object

- [`gisco_countries`](https://ropengov.github.io/giscoR/reference/gisco_countries.md)
  :

  World countries `POLYGON`
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object

- [`gisco_countrycode`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md)
  : Data frame with different country code schemes and world regions

- [`gisco_nuts`](https://ropengov.github.io/giscoR/reference/gisco_nuts.md)
  :

  All NUTS `POLYGON` object

## About the package

- [`giscoR`](https://ropengov.github.io/giscoR/reference/giscoR-package.md)
  [`giscoR-package`](https://ropengov.github.io/giscoR/reference/giscoR-package.md)
  : giscoR: Download Map Data from GISCO API - Eurostat
