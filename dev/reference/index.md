# Package index

## GISCO Geodata

Download datasets from the [GISCO Geodata
distribution](https://ec.europa.eu/eurostat/web/gisco/geodata). These
functions return [sf](https://r-spatial.github.io/sf/reference/sf.html)
objects.

### Administrative units

On using administrative data for statistical purposes, administrative
units are the units for which administrative data are recorded. These
units may or may not be the same as those required for the statistical
purposes (referred to as statistical units). See [copyright
information](https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units).

- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md)
  : Communes dataset
- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  : Country dataset
- [`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)
  : Postal codes dataset

### Statistical units

A statistical unit is the unit of observation or measurement for which
data are collected or derived. See [copyright
information](https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units).

- [`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md)
  : Census dataset
- [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md)
  : Coastal lines dataset
- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md)
  : Local Administrative Units (LAU) dataset
- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  : Territorial units for statistics (NUTS) dataset
- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)
  : Urban Audit dataset

### Grids

These datasets contain grid cells covering the land territory of the EU,
in various resolutions from 1 km to 100 km. Base statistics such as
population figures are provided for these cells.

- [`gisco_get_grid()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_grid.md)
  : Grid dataset

### Transport networks

- [`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md)
  : Airports dataset
- [`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md)
  : Ports dataset

### Basic services

- [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md)
  : Education services in Europe
- [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md)
  : Healthcare services in Europe

### Additional helpers

Additional functions for downloading GISCO API datasets.

- [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
  : GISCO API bulk download
- [`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  [`gisco_get_unit_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  : GISCO API single download

## GISCO Address API

Query the [GISCO Addres
API](https://gisco-services.ec.europa.eu/address_api/), which allows
developers to carry out both geocoding and reverse geocoding using a
pan-european address database.

- [`gisco_address_api_search()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  [`gisco_address_api_reverse()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  [`gisco_address_api_bbox()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  [`gisco_address_api_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  [`gisco_address_api_provinces()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  [`gisco_address_api_cities()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  [`gisco_address_api_roads()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  [`gisco_address_api_housenumbers()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  [`gisco_address_api_postcodes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  [`gisco_address_api_copyright()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  : GISCO Address API

## Misc

These functions return other
[sf](https://r-spatial.github.io/sf/reference/sf.html) objects

- [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)
  : Get metadata

## Cache management

- [`gisco_clear_cache()`](https://ropengov.github.io/giscoR/dev/reference/gisco_clear_cache.md)
  :

  Clear your [giscoR](https://CRAN.R-project.org/package=giscoR) cache
  dir

- [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
  [`gisco_detect_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
  :

  Set your [giscoR](https://CRAN.R-project.org/package=giscoR) cache dir

## Helpers

A collection of helper functions

- [`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md)
  : Attribution when publishing GISCO data

## Datasets

Datasets included with
[giscoR](https://CRAN.R-project.org/package=giscoR)

- [`gisco_coastallines`](https://ropengov.github.io/giscoR/dev/reference/gisco_coastallines.md)
  :

  World coastal lines `POLYGON` object

- [`gisco_countries`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries.md)
  :

  World countries `POLYGON`
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object

- [`gisco_countries_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries_2024.md)
  :

  World countries `POLYGON`
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object 2024

- [`gisco_countrycode`](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md)
  : Data frame with different country code schemes and world regions

- [`gisco_nuts`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts.md)
  :

  All NUTS `POLYGON` object

- [`gisco_nuts_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts_2024.md)
  :

  All NUTS `POLYGON` object

## About the package

- [`giscoR`](https://ropengov.github.io/giscoR/dev/reference/giscoR-package.md)
  [`giscoR-package`](https://ropengov.github.io/giscoR/dev/reference/giscoR-package.md)
  : giscoR: Download Map Data from GISCO API - Eurostat
