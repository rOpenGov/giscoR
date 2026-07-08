# Package index

## GISCO geodata distribution

Download [`sf`
objects](https://r-spatial.github.io/sf/reference/sf.html) from the
[GISCO geodata
distribution](https://ec.europa.eu/eurostat/web/gisco/geodata).

### Administrative units

When administrative data are used for statistical purposes,
administrative units are the units for which those data are recorded.
These units may or may not match the statistical units required for
analysis. See the [copyright
information](https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units).

- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md)
  : Communes dataset
- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  : Countries dataset
- [`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)
  : Postal codes dataset

### Statistical units

A statistical unit is the unit of observation or measurement for which
data are collected or derived. See the [copyright
information](https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units).

- [`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md)
  : Census dataset
- [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md)
  : Coastal lines dataset
- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md)
  : Local Administrative Units (LAU) dataset
- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  : NUTS statistical units dataset
- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)
  : Urban Audit dataset

### Grids

Download population grids covering the EU and neighbouring countries at
resolutions from 1 km to 100 km. Grid geometries use EPSG:3035 and
population variables have year- and country-specific licensing
conditions.

- [`gisco_get_grid()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_grid.md)
  : Grid dataset

### Transport networks

Download transport network data such as airports and ports.

- [`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md)
  : Airports dataset
- [`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md)
  : Ports dataset

### Basic service locations

Download basic service locations, such as education and healthcare
services. Dataset metadata may specify licensing conditions by country
and data provider.

- [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md)
  : Education services in Europe
- [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md)
  : Healthcare services in Europe

### Bulk and single-unit downloads

Download complete archives or individual GISCO spatial units.

- [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
  : GISCO geodata bulk download
- [`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  [`gisco_get_unit_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  [`gisco_get_unit_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  : GISCO geodata single-unit download

### GISCO database and metadata

Inspect the static or cached GISCO database and query its metadata.

- [`gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md)
  : Cached GISCO database

- [`gisco_get_cached_db()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_cached_db.md)
  :

  Retrieve and update the GISCO database used by
  [giscoR](https://CRAN.R-project.org/package=giscoR)

- [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)
  : Get metadata

### Attribution and licensing

Generate attribution text and review licensing information for GISCO
data.

- [`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md)
  : Attribution for administrative and statistical GISCO data

## GISCO API tools

Query additional [GISCO APIs and
tools](https://ec.europa.eu/eurostat/web/gisco/tools), including the
GISCO ID service API and GISCO Address API.

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
- [`gisco_id_api_geonames()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  [`gisco_id_api_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  [`gisco_id_api_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  [`gisco_id_api_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  [`gisco_id_api_river_basin()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  [`gisco_id_api_biogeo_region()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  [`gisco_id_api_census_grid()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  : GISCO ID service API

## Cache management

Configure, inspect and clear the local GISCO cache.

- [`gisco_clear_cache()`](https://ropengov.github.io/giscoR/dev/reference/gisco_clear_cache.md)
  :

  Clear your [giscoR](https://CRAN.R-project.org/package=giscoR) cache
  directory

- [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
  [`gisco_detect_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
  :

  Set your [giscoR](https://CRAN.R-project.org/package=giscoR) cache
  directory

## Datasets

Use lightweight datasets included with **giscoR** without additional
downloads.

- [`gisco_coastal_lines`](https://ropengov.github.io/giscoR/dev/reference/gisco_coastal_lines.md)
  :

  Coastal lines 2016 [sf](https://CRAN.R-project.org/package=sf) object

- [`gisco_countries_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries_2024.md)
  :

  Countries 2024 [sf](https://CRAN.R-project.org/package=sf) object

- [`gisco_countrycode`](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md)
  : Database with different country code schemes and world regions

- [`gisco_nuts_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts_2024.md)
  :

  NUTS 2024 [sf](https://CRAN.R-project.org/package=sf) object

## About the package

Package overview and metadata.

- [`giscoR`](https://ropengov.github.io/giscoR/dev/reference/giscoR-package.md)
  [`giscoR-package`](https://ropengov.github.io/giscoR/dev/reference/giscoR-package.md)
  : giscoR: Download 'Eurostat' 'GISCO' Spatial Data
