# giscoR 1.1.1

- Refactor internal helpers, documentation and tests, including clearer
  user-facing messages, more consistent roxygen2 documentation, reused
  documentation blocks and faster mocked tests for selected download-heavy
  paths.

# giscoR 1.1.0

- Adapt vignettes to Quarto.
- Bump the minimum **httr2** version to **1.2.0** (#126).
- Query timeout can now be controlled with `options(gisco_timeout)` using
  `httr2::req_timeout()`. The default value is
  `httr2::req_timeout(..., seconds = 300)` (5 minutes) (#123).
- Use `testthat::local_mocked_bindings()` for API error testing.

# giscoR 1.0.1

- Fix a bug that overwrote the bundled GISCO database with the cached version in
  a new session. The cache now persists.
- Update `?gisco_db`.
- `gisco_get_unit_urban_audit()` and `gisco_get_urban_audit()` now default to
  the latest available year, 2024.

# giscoR 1.0.0

This major release introduces a full overhaul of the codebase and test suite.
Requests now use **httr2**, and GeoPackage (`"gpkg"`) is the preferred download
format when available. Cached files are reorganized into topic-based subfolders
for easier management.

> Because of internal changes, **existing caches are not compatible** with this
> release and must be rebuilt.

Database management has also been improved. Instead of relying on the static
`?gisco_db` dataset, the package now stores the GISCO database in the cache.
This cached database is used for all API calls and can be updated via
`gisco_get_cached_db(update_cache = TRUE)`. In practice, when GISCO publishes a
new release, you can access updated data by refreshing the cached database
without waiting for a new version of **giscoR**.

The package now uses `tools::R_user_dir()` instead of
`rappdirs::user_config_dir()` to manage the persistent cache directory. If you
already have a cache directory in place, you will see a one-time message about
this migration.

The package now requires **R ≥ 4.1**, and dependency updates improve both
performance and maintainability. All functions return tidy objects (tibbles or
`sf` objects with tibble data).

Dataset subsetting is now performed at read time with GDAL query capabilities
(`sf::read_sf()`), improving performance and reducing file size. The
**geojsonsf** dependency is no longer required.

Several new functions and arguments have been added, some functions have been
renamed and one function has been deprecated. All bundled datasets have been
updated to their latest versions.

We recommend reviewing the updated documentation at
<https://ropengov.github.io/giscoR/>.

## Major changes

- Adopt GeoPackage (`"gpkg"`) as the preferred download format.
- Refactor the codebase and test suite for improved stability.
- Reorganize the cache into topic-based subfolders.
- Switch API requests to **httr2**.

> **Note:** Previous caches must be recreated.

## Compatibility and performance

- Add **cli**, **httr2**, **lifecycle** and **tibble**.
- Perform dataset subsetting at read time using GDAL queries via
  `sf::read_sf()`.
- Remove **geojsonsf**.
- Require **R ≥ 4.1**.
- Return tidy objects consistently.

## New functions

- `gisco_get_cached_db()` provides access to the cached GISCO database.
- `gisco_get_census()` provides access to census grid data.
- `gisco_get_metadata()` provides access to GISCO metadata.
- `gisco_get_unit_country()` provides access to country unit data and replaces
  the corresponding `gisco_get_units()` workflow.
- `gisco_get_unit_nuts()` provides access to NUTS unit data and replaces the
  corresponding `gisco_get_units()` workflow.
- `gisco_get_unit_urban_audit()` provides access to Urban Audit unit data and
  replaces the corresponding `gisco_get_units()` workflow.
- `gisco_id_api_biogeo_region()` provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- `gisco_id_api_census_grid()` provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- `gisco_id_api_country()` provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- `gisco_id_api_geonames()` provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- `gisco_id_api_lau()` provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- `gisco_id_api_nuts()` provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).
- `gisco_id_api_river_basin()` provides access to the [GISCO ID service
  API](https://gisco-services.ec.europa.eu/id/api-docs/).

## Renamed functions

- `gisco_address_api()` replaces `gisco_addressapi()`. The old name remains
  available as an alias.
- `gisco_get_coastal_lines()` replaces `gisco_get_coastallines()`. The old name
  remains available as an alias.
- `gisco_get_postal_codes()` replaces `gisco_get_postalcodes()`. The old name
  remains available as an alias.

## Argument updates

- `ext` adds control over the file format (`"gpkg"`, `"shp"` or `"geojson"`).
- `year` defaults are updated to the latest release (#105).

## Dataset updates

- `?gisco_coastal_lines` is added and replaces `gisco_coastallines`.
- `?gisco_countries_2024` is added and replaces `gisco_countries`.
- `?gisco_db` is updated to the newest data.
- `?gisco_nuts_2024` is added and replaces `gisco_nuts`.

> The datasets `gisco_countries`, `gisco_nuts` and `gisco_coastallines` are no
> longer available. Any code that accessed them directly (for example,
> `giscoR::gisco_countries`) will now fail.
>
> Use the updated datasets or, preferably, retrieve them with the corresponding
> functions such as `gisco_get_countries()` with default arguments.

## Deprecations

- `gisco_bulk_download()` renames the `id_giscoR` argument to `id`.
- `gisco_get_communes()` and `gisco_get_lau()` deprecate the `cache` argument in
  heavy-download functions.
- `gisco_get_units()` is deprecated. Equivalent functionality is now available
  through `gisco_get_metadata()` and the `?gisco_get_unit` family.

## Other updates

- Add Eurostat as copyright holder.
- Reorganize the **pkgdown** site.
- Review and improve documentation.
- Rewrite the full test suite.
- Use **cli** for all messages.

# giscoR 0.6.1

- `gisco_get_lau()` fixes source filtering.

# giscoR 0.6.0

## Data updates

- `gisco_get_countries()` and `gisco_get_nuts()` add support for 2024 datasets
  (#93, @hannesaddec).
- `gisco_get_education()` and `gisco_get_healthcare()` add the `year` argument
  and support 2020 and 2023 data.

# giscoR 0.5.1

- Review failing examples.
- Update `?gisco_db`.
- Use CRAN DOI.
- `gisco_get_education()` fixes API entry points.

# giscoR 0.5.0

- Add **jsonlite** to Imports.
- Update documentation URLs.
- `?gisco_addressapi` adds support for the GISCO Address API.
- `?gisco_db` is updated.
- `gisco_get_education()` is added.
- `gisco_get_lau()` updates its default year to `"2021"`.
- `gisco_get_urban_audit()` updates its default year to `"2021"`.

# giscoR 0.4.2

- Rebuild datasets.
- Update documentation to avoid CRAN warnings (#81).

# giscoR 0.4.1

- Clarify where the `country` and `region` arguments apply (#50, #75).
- Migrate from **httr** to **httr2**.
- Remove the `tgs00026` dataset.

# giscoR 0.4.0

- Update CRAN examples.
- Add **httr** dependency.
- `gisco_get_nuts()` adds the `geo` column (#62).

# giscoR 0.3.5

- Improve error handling so functions return an informative message and `NULL`.
- Review examples for CRAN issues.
- `gisco_detect_cache_dir()` is added.

# giscoR 0.3.4

- Update tests and documentation.

# giscoR 0.3.3

- `gisco_get_healthcare()` fixes URLs (#51).

# giscoR 0.3.2

- Fix CRAN-requested HTML5 issues.

# giscoR 0.3.1

- Add copyright section.
- Add **lwgeom** to Suggests.
- Remove the `tgs00026` dataset.
- Update `?gisco_db`.
- `gisco_get_airports()` and `gisco_get_ports()` now always download fresh 2013
  data.
- `gisco_get_postalcodes()` is added.

# giscoR 0.3.0

- Add new tests.
- Fix `cache = FALSE` behavior.
- Improve caching with `gisco_set_cache_dir()`, persistent cache directories and
  `gisco_clear_cache()`.
- Remove **lwgeom**.
- Replace **tmap** with **ggplot2**.
- Transfer the package to **rOpenGov**.
- Update documentation and examples.
- Update the internal grid.
- `?gisco_get` documentation is refactored.

# giscoR 0.2.4

- Add a vignette.
- Move to **roxygen2**.
- Move **lwgeom** to Imports.
- Replace **cartography** with **tmap**.
- `?gisco_countrycode` adds the `eu` field.

# giscoR 0.2.3

- Release DOI.
- Update documentation.

# giscoR 0.2.2

- Remove the vignette.

# giscoR 0.2.1

- Fix CRAN checks.
- Improve documentation.
- Remove CRAN notes.

# giscoR 0.2.0

- Add the `verbose` argument.
- Remove **colorspace**.
- Require **R ≥ 3.6.0**.
- Rewrite internal utilities.
- Rewrite `?gisco_db`.
- `gisco_bulk_download()` is added.
- `gisco_check_access()` is added.
- `gisco_get_airports()` is added.
- `gisco_get_countries()` and `gisco_get_nuts()` get faster downloads.
- `gisco_get_grid()` is added.
- `gisco_get_ports()` is added.
- `gisco_get_units()` is added.
- `?gisco_get` functions reorder arguments.

# giscoR 0.1.1

- Add the `tgs00026` dataset.
- Remove the **eurostat** dependency.

# giscoR 0.1.0

- First stable release.
