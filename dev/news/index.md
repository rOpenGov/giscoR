# Changelog

## giscoR (development version)

This major release introduces a full overhaul of the codebase and test
suite. Requests now use **httr2**, and **GeoPackage** (`”gpkg”`) becomes
the preferred download format when available. Cached files are
reorganized into topic-based subfolders for easier management.

Because of internal changes, **existing caches are not compatible** with
this release and must be rebuilt.

The package now requires **R ≥ 4.1**, and dependency updates improve
both performance and maintainability. All functions return tidy objects
(tibbles or `sf` objects with tibble data).

Dataset subsetting is now performed at read time using GDAL’s query
capabilities
([`sf::read_sf()`](https://r-spatial.github.io/sf/reference/st_read.html)),
improving performance and reducing file size. The **geojsonsf**
dependency is no longer required.

Several new functions and arguments have been added, some functions
renamed, and one deprecated. All bundled datasets have been updated to
their latest versions.

We recommend reviewing the updated documentation at
<https://ropengov.github.io/giscoR/>.

### Major changes

- Refactor code and test suite for improved stability.  
- Switch API requests to **httr2**.  
- Adopt GeoPackage (`”gpkg”`) as the preferred download format.  
- Reorganize cache into topic-based subfolders.

> **Note:** Previous caches must be recreated.

#### Compatibility and performance

- Require **R ≥ 4.1**.  
- Update dependencies:
  - Add: **cli**, **httr2**, **lifecycle**, **tibble**  
  - Remove: **geojsonsf**  
- Return tidy objects consistently.  
- Perform dataset subsetting at read time using GDAL queries via
  [`sf::read_sf()`](https://r-spatial.github.io/sf/reference/st_read.html).

### New functions

- [`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md)  
- [`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)  
- [`gisco_get_unit_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)  
- [`gisco_get_unit_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)  
- [`gisco_get_latest_db()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_latest_db.md)  
- [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)

### Renamed functions

- `gisco_addressapi_*` → `gisco_address_api_*`  
- [`gisco_get_coastallines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md)
  →
  [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md)  
- [`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)
  →
  [`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)

> Old names remain available as aliases.

### Argument updates

- Add `ext` argument to control file format (`”gpkg”`, `”shp”`,
  `”geojson”`).  
- Update default `year` to the latest release
  ([\#105](https://github.com/rOpenGov/giscoR/issues/105)).

### Dataset updates

- Update `gisco_db` to the newest data.  
- Add `gisco_countries_2024` (replace `gisco_countries`).  
- Add `gisco_nuts_2024` (replace `gisco_nuts`).  
- Add `gisco_coastal_lines` (replace `gisco_coastallines`).

### Deprecations

- Deprecate
  [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md).
  - Functionality is now available through
    [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)
    and the `gisco_get_unit_*` family.  
- Deprecate `cache` argument in heavy-download functions
  ([`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md),
  [`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md)).  
- In
  [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md),
  rename `id_giscoR` → `id`.

### Other updates

- Add Eurostat as copyright holder.  
- Rewrite the full test suite.  
- Review and improve documentation.  
- Reorganize **pkgdown** site.  
- Use **cli** for all messages.

## giscoR 0.6.1

CRAN release: 2025-01-27

- Fix source filtering in
  [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md).

## giscoR 0.6.0

CRAN release: 2024-08-28

### Data updates

- Add `year` argument to
  [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md)
  and
  [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md);
  support 2020 and 2023 data.  
- Add support for 2024 datasets in
  [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  and
  [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  ([\#93](https://github.com/rOpenGov/giscoR/issues/93),
  [@hannesaddec](https://github.com/hannesaddec)).

## giscoR 0.5.1

CRAN release: 2024-07-06

- Use CRAN DOI.  
- Fix API entry points in
  [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md).  
- Review failing examples.

## giscoR 0.5.0

CRAN release: 2024-05-29

- Add
  [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md).  
- Add support for the GISCO Address API (see `?gisco_addressapi`).  
- Add **jsonlite** to Imports.  
- Update `gisco_db`.  
- Update defaults:
  - [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md)
    → `”2021”`  
  - [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)
    → `”2021”`  
- Update documentation URLs.

## giscoR 0.4.2

CRAN release: 2024-03-27

- Update documentation to avoid CRAN warnings
  ([\#81](https://github.com/rOpenGov/giscoR/issues/81)).  
- Rebuild datasets.

## giscoR 0.4.1

CRAN release: 2024-03-15

- Clarify where `country` and `region` arguments apply
  ([\#50](https://github.com/rOpenGov/giscoR/issues/50),
  [\#75](https://github.com/rOpenGov/giscoR/issues/75)).  
- Migrate from **httr** to **httr2**.  
- Remove `tgs00026` dataset.

## giscoR 0.4.0

CRAN release: 2023-10-30

- Add `geo` column to
  [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  ([\#62](https://github.com/rOpenGov/giscoR/issues/62)).  
- Update CRAN examples.  
- Add **httr** dependency.

## giscoR 0.3.5

CRAN release: 2023-06-30

- Review examples for CRAN issues.  
- Add
  [`gisco_detect_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).  
- Improve error handling: return informative message and `NULL`.

## giscoR 0.3.4

CRAN release: 2023-05-26

- Update tests and documentation.

## giscoR 0.3.3

CRAN release: 2023-02-16

- Fix URLs in
  [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md)
  ([\#51](https://github.com/rOpenGov/giscoR/issues/51)).

## giscoR 0.3.2

CRAN release: 2022-08-13

- Fix CRAN-requested HTML5 issue.

## giscoR 0.3.1

CRAN release: 2021-10-06

- Add copyright section.  
- Add **lwgeom** to Suggests.  
- Update behavior of
  [`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md)
  and
  [`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md):
  - Only year available: 2013  
  - Always download fresh data  
- Add
  [`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md).  
- Update `gisco_db`.

## giscoR 0.3.0

CRAN release: 2021-09-27

- Transfer package to **rOpenGov**.  
- Improve caching:
  - Add
    [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)  
  - Persist cache directory across sessions  
  - Add
    [`gisco_clear_cache()`](https://ropengov.github.io/giscoR/dev/reference/gisco_clear_cache.md)  
- Fix `cache = FALSE` behavior.  
- Add new tests.  
- Update documentation and examples.  
- Refactor `gisco_get` documentation.  
- Add **eurostat** to Suggests.  
- Remove **lwgeom**.  
- Update internal grid.  
- Replace **tmap** with **ggplot2**.

## giscoR 0.2.4

CRAN release: 2021-04-13

- Add `eu` field to `gisco_countrycode`.  
- Fix documentation typos.  
- Add vignette.  
- Move to **roxygen2**.  
- Move **lwgeom** to Imports.  
- Replace **cartography** with **tmap**.

## giscoR 0.2.3

- Update documentation.  
- Release DOI.

## giscoR 0.2.2

CRAN release: 2020-11-23

- Remove vignette.

## giscoR 0.2.1

- Remove CRAN notes.  
- Improve documentation.  
- Fix CRAN checks.

## giscoR 0.2.0

CRAN release: 2020-11-12

- Remove **colorspace**.  
- Require **R ≥ 3.6.0**.  
- Reorder arguments in
  [`gisco_get()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  functions.  
- Rewrite internal utilities.  
- Add `verbose` argument.  
- Rewrite `gisco_db`.  
- Add:
  - [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)  
  - [`gisco_check_access()`](https://ropengov.github.io/giscoR/dev/reference/gisco_check_access.md)  
  - [`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md)  
  - [`gisco_get_grid()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_grid.md)  
  - [`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md)  
  - [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)  
- Update
  [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  and
  [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  for faster downloads.

## giscoR 0.1.1

CRAN release: 2020-10-28

- Add `tgs00026` dataset.  
- Remove **eurostat** dependency.

## giscoR 0.1.0

CRAN release: 2020-10-13

- First stable release.
