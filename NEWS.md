# giscoR (development version)

In this major release, we have completely overhauled the code and test suite.
The package now uses **httr2** for API requests, and the preferred file format
for downloading data is now GeoPackage (`"gpkg"`) when available, instead of
GeoJSON. Additionally, cached files are now organized into subfolders based on
the data topic, making them easier to manage and locate.

These changes imply that previous caches will not be compatible with this
version of **giscoR** and will need to be re-downloaded.

The package has also been updated for compatibility with **R 4.1** and above.
Several dependencies have been added or removed to improve performance. The
package always returns tidy objects (either **tibbles** or **sf** objects whose
attached data frame is a tibble).

Another major change is that dataset subsetting is now performed during reading
(see `sf::read_sf()`) using GDAL's query capabilities. This improves function
performance and, combined with the switch to GeoPackage as the preferred format,
significantly reduces the size of downloaded files. Additionally, the
**geojsonsf** package (initially added to improve performance) is no longer
needed and has been removed as a dependency.

We have added new functions, introduced new arguments to existing functions,
renamed some functions, and partially deprecated others to streamline the user
experience. The only function that has been fully deprecated is
`gisco_get_units()`, as its functionality has been integrated into other
functions. The datasets shipped with the package have also been updated to the
latest available versions.

Most changes will not affect the user experience, but we recommend reviewing the
documentation at <https://ropengov.github.io/giscoR/> to ensure a smooth
transition to the new version.

## Major Changes

-   Complete code and test overhaul for improved stability and maintainability.
-   API requests now use **httr2** for better performance and reliability.
-   Preferred download format switched to GeoPackage (`"gpkg"`) when available,
    replacing GeoJSON.
-   Cache structure reorganized into topic-based subfolders for easier
    management.

> **Note:** Previous caches are not compatible with this version and must be
> re-downloaded.

### Compatibility and Performance

-   Updated for **R ≥ 4.1**.
-   Dependencies revised: added **cli**, **httr2**, **lifecycle**, **tibble**;
    removed **geojsonsf**.
-   Functions now return **tidy objects** (tibbles or `sf` objects with tibble
    data frames).
-   **Subsetting performed on read** using GDAL query via `sf::read_sf()`,
    improving speed and reducing file size.

## New functions:

-   `gisco_get_census()`: Access GISCO Census data.
-   `gisco_get_unit_country()`, `gisco_get_unit_nuts()`,
    `gisco_get_unit_urban_audit()`: Access individual unit files.
-   `gisco_get_latest_db()`: Retrieve and store the latest `gisco_db` dataset.
-   `gisco_get_metadata()`: Retrieve dataset metadata.

## Renamed Functions

-   `gisco_addressapi_*` → `gisco_address_api_*`
-   `gisco_get_coastallines()` → `gisco_get_coastal_lines()`
-   `gisco_get_postalcodes()` → `gisco_get_postal_codes()`

> Previous names remain as aliases for backward compatibility.

## Arguments

-   New `ext` argument for specifying file format (e.g., `"gpkg"`, `"shp"`,
    `"geojson"`).
-   Default `year` updated to latest available (#105).

## Datasets

-   `gisco_db`: Updated to latest available data.
-   New `gisco_countries_2024` data added, replacing `gisco_countries`
    (removed).
-   New `gisco_nuts_2024` data added, replacing `gisco_nuts` (removed).
-   New `gisco_coastal_lines` data added, replacing `gisco_coastallines`
    (removed).

## Deprecations

-   `gisco_get_units()` fully deprecated; functionality integrated into
    `gisco_get_metadata()` and `gisco_get_unit_*` family.
-   `cache` argument deprecated in heavy-download functions (`gisco_get_lau()`,
    `gisco_get_communes()`).
-   `gisco_bulk_download()`: `id_giscoR` renamed to `id`.

### Other Updates

-   Added Eurostat as copyright holder in `Authors@R`.
-   Full test suite rewritten.
-   Documentation reviewed and improved.
-   **pkgdown** site reorganized for better navigation.
-   Messages now displayed using **cli**.

# giscoR 0.6.1

-   Fix an issue when filtering source on `gisco_get_lau()`.

# giscoR 0.6.0

## Update with latest data available

-   `gisco_get_education()` and `gisco_get_healthcare()` gains a new `year`
    argument: years available now are 2020 and 2023 versions of the dataset.
-   `gisco_get_nuts()` and `gisco_get_countries()` now can download the 2024
    version of the datasets (#93 \@hannesaddec).

# giscoR 0.5.1

-   Use **CRAN** DOI: <https://doi.org/10.32614/CRAN.package.giscoR>.
-   `gisco_get_education()`: Fix API entry points.
-   Review failing examples.

# giscoR 0.5.0

-   New functions:
    -   `gisco_get_education()`.
    -   Add access to [GISCO Address
        API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home)
        through new functions. See `?gisco_addressapi` to know more (#84).
-   New dependency: **jsonlite** added to 'Imports'.
-   Update `gisco_db` with the most up-to-date released data.
-   Default year of some functions updated to the latest available data:
    -   `gisco_get_lau()` and `gisco_get_urban_audit()` default year now is
        `"2021"`.
-   Update urls in documentation.

# giscoR 0.4.2

-   Update of docs to avoid warnings on **CRAN** (#81).
-   Rebuild datasets.

# giscoR 0.4.1

-   Improve documentation, stating where the arguments `country` and `region`
    applies (#50, #75).
-   Migrate to **httr2** instead of **httr**.
-   Removed `tgs00026` dataset, use `eurostat::get_eurostat("tgs00026")`
    instead.

# giscoR 0.4.0

-   `gisco_get_nuts()`: Add an additional `geo` column (identical to `NUTS_ID`)
    for enhanced compatibility with **eurostat** package (#62).
-   Adjust examples for **CRAN**.
-   Add dependency **httr**.

# giscoR 0.3.5

-   Review examples to avoid **CRAN** errors and notes.
-   New helper function: `gisco_detect_cache_dir()`.
-   Now the functions fail gracefully with an informative message, instead of an
    error, and return `NULL`.

# giscoR 0.3.4

-   Update tests and documentation.

# giscoR 0.3.3

-   Fix broken urls on `gisco_get_healthcare()` (#51).

# giscoR 0.3.2

-   Fix HTML5 issue as requested by **CRAN**.

# giscoR 0.3.1

-   Add `Copyright` on `DESCRIPTION`.
-   Add **lwgeom** on 'Suggests'.
-   `gisco_get_airports()` and `gisco_get_ports()`:
    -   Only year available is 2013.
    -   Now information is downloaded instead of using internal data.
-   New function: `gisco_get_postalcodes()`.
-   Update `gisco_db`.

# giscoR 0.3.0

-   Now **giscoR** is part of [rOpenGov](https://ropengov.org/). Repo has been
    transferred.
-   Caching improvements: new function `gisco_set_cache_dir()` based on
    `rappdirs::user_cache_dir()`. Now the `cache_dir` path is stored and it is
    not necessary to set it up again on a new session. Also added
    `gisco_clear_cache()`.
-   Fix an error when `cache = FALSE`. Now files are loaded instead throwing an
    error.
-   New tests with **testthat**.
-   Update on docs. New examples
-   Refactor documents and codes for the previous `gisco_get` doc.
-   Add **eurostat** package to ' Suggests'.
-   **lwgeom** dependency removed.
-   Update internal grid object.
-   **tmap** package replaced by **ggplot2** on vignettes and examples.

# giscoR 0.2.4

-   New `eu` field on `giscoR::gisco_countrycode`.
-   Fix typos on documentation.
-   Include vignette on the package.
-   Move docs to **roxygen2**.
-   **lwgeom** moved to 'Imports' field.
-   **cartography** package replaced by **tmap** on vignettes.

# giscoR 0.2.3

-   Update on docs
-   Release for DOI

# giscoR 0.2.2

-   Remove vignette

# giscoR 0.2.1

-   Remove **CRAN** notes.
-   Improve docs.
-   Fix **CRAN** checks.

# giscoR 0.2.0

-   Remove **colorspace** as dependency.
-   Bump **R** minimal version to `3.6.0`.
-   Change order on arguments for `gisco_get()` functions.
-   Rewriting of internal functions and utils.
-   Add `verbose` argument to functions.
-   Rewriting of `giscoR::gisco_db`.
-   Functions added:
    -   `gisco_bulk_download()`
    -   `gisco_check_access()`
    -   `gisco_get_airports()`
    -   `gisco_get_grid()`
    -   `gisco_get_ports()`
    -   `gisco_get_units()`
-   Now `gisco_get_countries()` and `gisco_get_nuts()` uses `gisco_get_units()`
    for individual files, making the call much faster.

# giscoR 0.1.1

-   Added `giscoR::tgs00026` dataset.
-   Remove **eurostat** dependency.

# giscoR 0.1.0

-   First stable release.
