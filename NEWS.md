# giscoR (development version)

This major release introduces a full overhaul of the codebase and test suite.
Requests now use **httr2**, and **GeoPackage** (`”gpkg”`) becomes the preferred
download format when available. Cached files are reorganized into topic-based
subfolders for easier management.

> Because of internal changes, **existing caches are not compatible** with this
> release and must be rebuilt.

Database management has also been improved. Instead of relying on the static
`?gisco_db` dataset, the package now stores the database in the cache. This
cached database is used for all API calls and can be updated via
`gisco_get_cached_db(update_cache = TRUE)`. In practice, this means that when
GISCO publishes a new yearly release, you can access the new updated data simply
by refreshing the cached database without waiting for a new version of
**giscoR**.

We have transitioned from `rappdirs::user_config_dir()` to `tools::R_user_dir()`
for managing your persistent cache directory. If you are a heavy **giscoR** user
and already have a cache directory in place, you’ll receive a one-time friendly
message informing you about this migration. Consider it a warm welcome to
**giscoR** 1.0.0 😉.

The package now requires **R ≥ 4.1**, and dependency updates improve both
performance and maintainability. All functions return tidy objects (tibbles or
`sf` objects with tibble data).

Dataset subsetting is now performed at read time using GDAL’s query capabilities
(`sf::read_sf()`), improving performance and reducing file size. The
**geojsonsf** dependency is no longer required.

Several new functions and arguments have been added, some functions renamed, and
one deprecated. All bundled datasets have been updated to their latest versions.

We recommend reviewing the updated documentation at
<https://ropengov.github.io/giscoR/>.

## Major changes

-   Refactor code and test suite for improved stability.
-   Switch API requests to **httr2**.
-   Adopt GeoPackage (`”gpkg”`) as the preferred download format.
-   Reorganize cache into topic-based subfolders.

> **Note:** Previous caches must be recreated.

### Compatibility and performance

-   Require **R ≥ 4.1**.
-   Update dependencies:
    -   Add: **cli**, **httr2**, **lifecycle**, **tibble**
    -   Remove: **geojsonsf**
-   Return tidy objects consistently.
-   Perform dataset subsetting at read time using GDAL queries via
    `sf::read_sf()`.

## New functions

-   Metadata and database utilities:
    -   `gisco_get_cached_db()`
    -   `gisco_get_metadata()`
-   `gisco_get_census()` for accessing census grid data.
-   New separate functions to access unit data (replacing `gisco_get_units()`):
    -   `gisco_get_unit_country()`
    -   `gisco_get_unit_nuts()`
    -   `gisco_get_unit_urban_audit()`
-   Functions to access the [GISCO ID service
    API](https://gisco-services.ec.europa.eu/id/api-docs/)
    -   `gisco_id_api_geonames()`
    -   `gisco_id_api_nuts()`
    -   `gisco_id_api_lau()`
    -   `gisco_id_api_country()`
    -   `gisco_id_api_river_basin()`
    -   `gisco_id_api_biogeo_region()`
    -   `gisco_id_api_census_grid()`

## Renamed functions

We renamed several functions to improve clarity and consistency:

-   `?gisco_addressapi` → `?gisco_address_api`
-   `gisco_get_coastallines()` → `gisco_get_coastal_lines()`
-   `gisco_get_postalcodes()` → `gisco_get_postal_codes()`

> Old names remain available as aliases.

## Argument updates

-   Add `ext` argument to control file format (`”gpkg”`, `”shp”`, `”geojson”`).
-   Update default `year` to the latest release (#105).

## Dataset updates

We updated all bundled datasets to their latest versions and added new ones:

-   Update `?gisco_db` to the newest data.
-   Add `?gisco_countries_2024` (replaces `gisco_countries`).
-   Add `?gisco_nuts_2024` (replaces `gisco_nuts`).
-   Add `?gisco_coastal_lines` (replaced `gisco_coastallines`).

> The datasets `gisco_countries`, `gisco_nuts`, and `gisco_coastallines` are no
> longer available. Any code that accessed them directly (e.g.,
> `giscoR::gisco_countries`) will now fail.\
>
> Please use the updated datasets or, preferably, retrieve them via the
> corresponding functions such as `gisco_get_countries()` with default
> parameters.

## Deprecations

-   Deprecate `gisco_get_units()`.
    -   Functionality is now available through `gisco_get_metadata()` and the
        `?gisco_get_unit` family.
-   Deprecate `cache` argument in heavy-download functions (`gisco_get_lau()`,
    `gisco_get_communes()`).
-   In `gisco_bulk_download()`, rename `id_giscoR` → `id`.

## Other updates

-   Add Eurostat as copyright holder.
-   Rewrite the full test suite.
-   Review and improve documentation.
-   Reorganize **pkgdown** site.
-   Use **cli** for all messages.

# giscoR 0.6.1

-   Fix source filtering in `gisco_get_lau()`.

# giscoR 0.6.0

## Data updates

-   Add `year` argument to `gisco_get_education()` and `gisco_get_healthcare()`;
    support 2020 and 2023 data.
-   Add support for 2024 datasets in `gisco_get_nuts()` and
    `gisco_get_countries()` (#93, @hannesaddec).

# giscoR 0.5.1

-   Use CRAN DOI.
-   Fix API entry points in `gisco_get_education()`.
-   Review failing examples.

# giscoR 0.5.0

-   Add `gisco_get_education()`.
-   Add support for the GISCO Address API (see `?gisco_addressapi`).
-   Add **jsonlite** to Imports.
-   Update `?gisco_db`.
-   Update defaults:
    -   `gisco_get_lau()` → `”2021”`
    -   `gisco_get_urban_audit()` → `”2021”`
-   Update documentation URLs.

# giscoR 0.4.2

-   Update documentation to avoid CRAN warnings (#81).
-   Rebuild datasets.

# giscoR 0.4.1

-   Clarify where `country` and `region` arguments apply (#50, #75).
-   Migrate from **httr** to **httr2**.
-   Remove `tgs00026` dataset.

# giscoR 0.4.0

-   Add `geo` column to `gisco_get_nuts()` (#62).
-   Update CRAN examples.
-   Add **httr** dependency.

# giscoR 0.3.5

-   Review examples for CRAN issues.
-   Add `gisco_detect_cache_dir()`.
-   Improve error handling: return informative message and `NULL`.

# giscoR 0.3.4

-   Update tests and documentation.

# giscoR 0.3.3

-   Fix URLs in `gisco_get_healthcare()` (#51).

# giscoR 0.3.2

-   Fix CRAN-requested HTML5 issue.

# giscoR 0.3.1

-   Add copyright section.
-   Add **lwgeom** to Suggests.
-   Update behavior of `gisco_get_airports()` and `gisco_get_ports()`:
    -   Only year available: 2013
    -   Always download fresh data
-   Add `gisco_get_postalcodes()`.
-   Update `?gisco_db`.

# giscoR 0.3.0

-   Transfer package to **rOpenGov**.
-   Improve caching:
    -   Add `gisco_set_cache_dir()`
    -   Persist cache directory across sessions
    -   Add `gisco_clear_cache()`
-   Fix `cache = FALSE` behavior.
-   Add new tests.
-   Update documentation and examples.
-   Refactor `?gisco_get` documentation.
-   Add **eurostat** to Suggests.
-   Remove **lwgeom**.
-   Update internal grid.
-   Replace **tmap** with **ggplot2**.

# giscoR 0.2.4

-   Add `eu` field to `?gisco_countrycode`.
-   Fix documentation typos.
-   Add vignette.
-   Move to **roxygen2**.
-   Move **lwgeom** to Imports.
-   Replace **cartography** with **tmap**.

# giscoR 0.2.3

-   Update documentation.
-   Release DOI.

# giscoR 0.2.2

-   Remove vignette.

# giscoR 0.2.1

-   Remove CRAN notes.
-   Improve documentation.
-   Fix CRAN checks.

# giscoR 0.2.0

-   Remove **colorspace**.
-   Require **R ≥ 3.6.0**.
-   Reorder arguments in `?gisco_get` functions.
-   Rewrite internal utilities.
-   Add `verbose` argument.
-   Rewrite `?gisco_db`.
-   Add:
    -   `gisco_bulk_download()`
    -   `gisco_check_access()`
    -   `gisco_get_airports()`
    -   `gisco_get_grid()`
    -   `gisco_get_ports()`
    -   `gisco_get_units()`
-   Update `gisco_get_countries()` and `gisco_get_nuts()` for faster downloads.

# giscoR 0.1.1

-   Add `tgs00026` dataset.
-   Remove **eurostat** dependency.

# giscoR 0.1.0

-   First stable release.
