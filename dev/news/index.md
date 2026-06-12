# Changelog

## giscoR (development version)

- Refactor internal helpers, documentation and tests with AI assistance,
  including clearer user-facing messages, more consistent roxygen2
  documentation, reused documentation blocks and faster mocked tests for
  selected download-heavy paths.

## giscoR 1.1.0

CRAN release: 2026-03-28

- Adapt vignettes to Quarto.
- Bump the minimum **httr2** version to **1.2.0**
  ([\#126](https://github.com/rOpenGov/giscoR/issues/126)).
- Query timeout can now be controlled with `options(gisco_timeout)`
  using
  [`httr2::req_timeout()`](https://httr2.r-lib.org/reference/req_timeout.html).
  The default value is `httr2::req_timeout(..., seconds = 300)` (5
  minutes) ([\#123](https://github.com/rOpenGov/giscoR/issues/123)).
- Use
  [`testthat::local_mocked_bindings()`](https://testthat.r-lib.org/reference/local_mocked_bindings.html)
  for API error testing.

## giscoR 1.0.1

CRAN release: 2026-01-23

- Fix a bug that overwrote the bundled GISCO database with the cached
  version in a new session. The cache now persists.
- Update
  [`?gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md).
- [`gisco_get_unit_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  and
  [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)
  now default to the latest available year, 2024.

## giscoR 1.0.0

CRAN release: 2025-12-10

This major release introduces a full overhaul of the codebase and test
suite. Requests now use **httr2**, and **GeoPackage** (`"gpkg"`) is the
preferred download format when available. Cached files are reorganized
into topic-based subfolders for easier management.

> Because of internal changes, **existing caches are not compatible**
> with this release and must be rebuilt.

Database management has also been improved. Instead of relying on the
static
[`?gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md)
dataset, the package now stores the GISCO database in the cache. This
cached database is used for all API calls and can be updated via
`gisco_get_cached_db(update_cache = TRUE)`. In practice, when GISCO
publishes a new release, you can access updated data by refreshing the
cached database without waiting for a new version of **giscoR**.

The package now uses
[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) instead of
[`rappdirs::user_config_dir()`](https://rappdirs.r-lib.org/reference/user_data_dir.html)
for managing the persistent cache directory. If you already have a cache
directory in place, you will see a one-time message about this
migration.

The package now requires **R ≥ 4.1**, and dependency updates improve
both performance and maintainability. All functions return tidy objects
(tibbles or `sf` objects with tibble data).

Dataset subsetting is now performed at read time using GDAL query
capabilities
([`sf::read_sf()`](https://r-spatial.github.io/sf/reference/st_read.html)),
improving performance and reducing file size. The **geojsonsf**
dependency is no longer required.

Several new functions and arguments have been added, some functions have
been renamed and one function has been deprecated. All bundled datasets
have been updated to their latest versions.

We recommend reviewing the updated documentation at
<https://ropengov.github.io/giscoR/>.

### Major changes

- Adopt GeoPackage (`"gpkg"`) as the preferred download format.
- Refactor the codebase and test suite for improved stability.
- Reorganize the cache into topic-based subfolders.
- Switch API requests to **httr2**.

> **Note:** Previous caches must be recreated.

### Compatibility and performance

- Add **cli**, **httr2**, **lifecycle** and **tibble**.
- Perform dataset subsetting at read time using GDAL queries via
  [`sf::read_sf()`](https://r-spatial.github.io/sf/reference/st_read.html).
- Remove **geojsonsf**.
- Require **R ≥ 4.1**.
- Return tidy objects consistently.

### New functions

- [`gisco_get_cached_db()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_cached_db.md)
  provides access to the cached GISCO database.
- [`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md)
  provides access to census grid data.
- [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)
  provides access to GISCO metadata.
- [`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  provides access to country unit data and replaces the corresponding
  [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)
  workflow.
- [`gisco_get_unit_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  provides access to NUTS unit data and replaces the corresponding
  [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)
  workflow.
- [`gisco_get_unit_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  provides access to Urban Audit unit data and replaces the
  corresponding
  [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)
  workflow.
- [`gisco_id_api_biogeo_region()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- [`gisco_id_api_census_grid()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- [`gisco_id_api_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- [`gisco_id_api_geonames()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- [`gisco_id_api_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- [`gisco_id_api_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- [`gisco_id_api_river_basin()`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
  provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).

### Renamed functions

- [`gisco_address_api()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  replaces
  [`gisco_addressapi()`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md).
  The old name remains available as an alias.
- [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md)
  replaces
  [`gisco_get_coastallines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md).
  The old name remains available as an alias.
- [`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)
  replaces
  [`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md).
  The old name remains available as an alias.

### Argument updates

- `ext` adds control over the file format (`"gpkg"`, `"shp"` or
  `"geojson"`).
- `year` defaults are updated to the latest release
  ([\#105](https://github.com/rOpenGov/giscoR/issues/105)).

### Dataset updates

- [`?gisco_coastal_lines`](https://ropengov.github.io/giscoR/dev/reference/gisco_coastal_lines.md)
  is added and replaces `gisco_coastallines`.
- [`?gisco_countries_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries_2024.md)
  is added and replaces `gisco_countries`.
- [`?gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md)
  is updated to the newest data.
- [`?gisco_nuts_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts_2024.md)
  is added and replaces `gisco_nuts`.

> The datasets `gisco_countries`, `gisco_nuts` and `gisco_coastallines`
> are no longer available. Any code that accessed them directly (for
> example, `giscoR::gisco_countries`) will now fail.
>
> Use the updated datasets or, preferably, retrieve them with the
> corresponding functions such as
> [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
> with default arguments.

### Deprecations

- [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
  renames the `id_giscoR` argument to `id`.
- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md)
  and
  [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md)
  deprecate the `cache` argument in heavy-download functions.
- [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)
  is deprecated. Equivalent functionality is now available through
  [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)
  and the
  [`?gisco_get_unit`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md)
  family.

### Other updates

- Add Eurostat as copyright holder.
- Reorganize the **pkgdown** site.
- Review and improve documentation.
- Rewrite the full test suite.
- Use **cli** for all messages.

## giscoR 0.6.1

CRAN release: 2025-01-27

- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md)
  fixes source filtering.

## giscoR 0.6.0

CRAN release: 2024-08-28

### Data updates

- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  and
  [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  add support for 2024 datasets
  ([\#93](https://github.com/rOpenGov/giscoR/issues/93),
  [@hannesaddec](https://github.com/hannesaddec)).
- [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md)
  and
  [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md)
  add the `year` argument and support 2020 and 2023 data.

## giscoR 0.5.1

CRAN release: 2024-07-06

- Review failing examples.
- Update
  [`?gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md).
- Use CRAN DOI.
- [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md)
  fixes API entry points.

## giscoR 0.5.0

CRAN release: 2024-05-29

- Add **jsonlite** to Imports.
- Update documentation URLs.
- [`?gisco_addressapi`](https://ropengov.github.io/giscoR/dev/reference/gisco_address_api.md)
  adds support for the GISCO Address API.
- [`?gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md)
  is updated.
- [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md)
  is added.
- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md)
  updates its default year to `"2021"`.
- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)
  updates its default year to `"2021"`.

## giscoR 0.4.2

CRAN release: 2024-03-27

- Rebuild datasets.
- Update documentation to avoid CRAN warnings
  ([\#81](https://github.com/rOpenGov/giscoR/issues/81)).

## giscoR 0.4.1

CRAN release: 2024-03-15

- Clarify where the `country` and `region` arguments apply
  ([\#50](https://github.com/rOpenGov/giscoR/issues/50),
  [\#75](https://github.com/rOpenGov/giscoR/issues/75)).
- Migrate from **httr** to **httr2**.
- Remove the `tgs00026` dataset.

## giscoR 0.4.0

CRAN release: 2023-10-30

- Update CRAN examples.
- Add **httr** dependency.
- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  adds the `geo` column
  ([\#62](https://github.com/rOpenGov/giscoR/issues/62)).

## giscoR 0.3.5

CRAN release: 2023-06-30

- Improve error handling so functions return an informative message and
  `NULL`.
- Review examples for CRAN issues.
- [`gisco_detect_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
  is added.

## giscoR 0.3.4

CRAN release: 2023-05-26

- Update tests and documentation.

## giscoR 0.3.3

CRAN release: 2023-02-16

- [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md)
  fixes URLs ([\#51](https://github.com/rOpenGov/giscoR/issues/51)).

## giscoR 0.3.2

CRAN release: 2022-08-13

- Fix CRAN-requested HTML5 issues.

## giscoR 0.3.1

CRAN release: 2021-10-06

- Add copyright section.
- Add **lwgeom** to Suggests.
- Remove the `tgs00026` dataset.
- Update
  [`?gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md).
- [`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md)
  and
  [`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md)
  now always download fresh 2013 data.
- [`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)
  is added.

## giscoR 0.3.0

CRAN release: 2021-09-27

- Add new tests.
- Fix `cache = FALSE` behavior.
- Improve caching with
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md),
  persistent cache directories and
  [`gisco_clear_cache()`](https://ropengov.github.io/giscoR/dev/reference/gisco_clear_cache.md).
- Remove **lwgeom**.
- Replace **tmap** with **ggplot2**.
- Transfer the package to **rOpenGov**.
- Update documentation and examples.
- Update the internal grid.
- [`?gisco_get`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  documentation is refactored.

## giscoR 0.2.4

CRAN release: 2021-04-13

- Add a vignette.
- Move to **roxygen2**.
- Move **lwgeom** to Imports.
- Replace **cartography** with **tmap**.
- [`?gisco_countrycode`](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md)
  adds the `eu` field.

## giscoR 0.2.3

- Release DOI.
- Update documentation.

## giscoR 0.2.2

CRAN release: 2020-11-23

- Remove the vignette.

## giscoR 0.2.1

- Fix CRAN checks.
- Improve documentation.
- Remove CRAN notes.

## giscoR 0.2.0

CRAN release: 2020-11-12

- Add the `verbose` argument.
- Remove **colorspace**.
- Require **R ≥ 3.6.0**.
- Rewrite internal utilities.
- Rewrite
  [`?gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md).
- [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
  is added.
- [`gisco_check_access()`](https://ropengov.github.io/giscoR/dev/reference/gisco_check_access.md)
  is added.
- [`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md)
  is added.
- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  and
  [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  get faster downloads.
- [`gisco_get_grid()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_grid.md)
  is added.
- [`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md)
  is added.
- [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)
  is added.
- [`?gisco_get`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  functions reorder arguments.

## giscoR 0.1.1

CRAN release: 2020-10-28

- Add the `tgs00026` dataset.
- Remove the **eurostat** dependency.

## giscoR 0.1.0

CRAN release: 2020-10-13

- First stable release.
