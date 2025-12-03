# Changelog

## giscoR (development version)

In this major release, we have completely overhauled the code and test
suite. The package now uses **httr2** for API requests, and the
preferred file format for downloading data is now GeoPackage (`"gpkg"`)
when available, instead of GeoJSON. Additionally, cached files are now
organized into subfolders based on the data topic, making them easier to
manage and locate.

These changes imply that previous caches will not be compatible with
this version of **giscoR** and will need to be re-downloaded.

The package has also been updated for compatibility with **R 4.1** and
above. Several dependencies have been added or removed to improve
performance. The package always returns tidy objects (either **tibbles**
or **sf** objects whose attached data frame is a tibble).

Another major change is that dataset subsetting is now performed during
reading (see
[`sf::read_sf()`](https://r-spatial.github.io/sf/reference/st_read.html))
using GDAL’s query capabilities. This improves function performance and,
combined with the switch to GeoPackage as the preferred format,
significantly reduces the size of downloaded files. Additionally, the
**geojsonsf** package (initially added to improve performance) is no
longer needed and has been removed as a dependency.

We have added new functions, introduced new arguments to existing
functions, renamed some functions, and partially deprecated others to
streamline the user experience. The only function that has been fully
deprecated is
[`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md),
as its functionality has been integrated into other functions. The
datasets shipped with the package have also been updated to the latest
available versions.

Most changes will not affect the user experience, but we recommend
reviewing the documentation at <https://ropengov.github.io/giscoR/> to
ensure a smooth transition to the new version.

### Major Changes

- Complete code and test overhaul for improved stability and
  maintainability.
- API requests now use **httr2** for better performance and reliability.
- Preferred download format switched to GeoPackage (`"gpkg"`) when
  available, replacing GeoJSON.
- Cache structure reorganized into topic-based subfolders for easier
  management.

> **Note:** Previous caches are not compatible with this version and
> must be re-downloaded.

#### Compatibility and Performance

- Updated for **R ≥ 4.1**.
- Dependencies revised: added **cli**, **httr2**, **lifecycle**,
  **tibble**; removed **geojsonsf**.
- Functions now return **tidy objects** (tibbles or `sf` objects with
  tibble data frames).
- **Subsetting performed on read** using GDAL query via
  [`sf::read_sf()`](https://r-spatial.github.io/sf/reference/st_read.html),
  improving speed and reducing file size.

### New functions:

- [`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md):
  Access GISCO Census data.
- [`gisco_get_unit_country()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md),
  [`gisco_get_unit_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md),
  [`gisco_get_unit_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_unit.md):
  Access individual unit files.
- [`gisco_get_latest_db()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_latest_db.md):
  Retrieve and store the latest `gisco_db` dataset.
- [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md):
  Retrieve dataset metadata.

### Renamed Functions

- `gisco_addressapi_*` → `gisco_address_api_*`
- [`gisco_get_coastallines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md)
  →
  [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md)
- [`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)
  →
  [`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)

> Previous names remain as aliases for backward compatibility.

### Arguments

- New `ext` argument for specifying file format (e.g., `"gpkg"`,
  `"shp"`, `"geojson"`).
- Default `year` updated to latest available
  ([\#105](https://github.com/rOpenGov/giscoR/issues/105)).

### Datasets

- `gisco_db`: Updated to latest available data.
- New `gisco_countries_2024` data added, replacing `gisco_countries`
  (removed).
- New `gisco_nuts_2024` data added, replacing `gisco_nuts` (removed).
- New `gisco_coastal_lines` data added, replacing `gisco_coastallines`
  (removed).

### Deprecations

- [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)
  fully deprecated; functionality integrated into
  [`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md)
  and `gisco_get_unit_*` family.
- `cache` argument deprecated in heavy-download functions
  ([`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md),
  [`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md)).
- [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md):
  `id_giscoR` renamed to `id`.

#### Other Updates

- Added Eurostat as copyright holder in `Authors@R`.
- Full test suite rewritten.
- Documentation reviewed and improved.
- **pkgdown** site reorganized for better navigation.
- Messages now displayed using **cli**.

## giscoR 0.6.1

CRAN release: 2025-01-27

- Fix an issue when filtering source on
  [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md).

## giscoR 0.6.0

CRAN release: 2024-08-28

### Update with latest data available

- [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md)
  and
  [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md)
  gains a new `year` argument: years available now are 2020 and 2023
  versions of the dataset.
- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  and
  [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  now can download the 2024 version of the datasets
  ([\#93](https://github.com/rOpenGov/giscoR/issues/93)
  [@hannesaddec](https://github.com/hannesaddec)).

## giscoR 0.5.1

CRAN release: 2024-07-06

- Use **CRAN** DOI: <https://doi.org/10.32614/CRAN.package.giscoR>.
- [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md):
  Fix API entry points.
- Review failing examples.

## giscoR 0.5.0

CRAN release: 2024-05-29

- New functions:
  - [`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md).
  - Add access to [GISCO Address
    API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home)
    through new functions. See `?gisco_addressapi` to know more
    ([\#84](https://github.com/rOpenGov/giscoR/issues/84)).
- New dependency: **jsonlite** added to ‘Imports’.
- Update `gisco_db` with the most up-to-date released data.
- Default year of some functions updated to the latest available data:
  - [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md)
    and
    [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)
    default year now is `"2021"`.
- Update urls in documentation.

## giscoR 0.4.2

CRAN release: 2024-03-27

- Update of docs to avoid warnings on **CRAN**
  ([\#81](https://github.com/rOpenGov/giscoR/issues/81)).
- Rebuild datasets.

## giscoR 0.4.1

CRAN release: 2024-03-15

- Improve documentation, stating where the arguments `country` and
  `region` applies
  ([\#50](https://github.com/rOpenGov/giscoR/issues/50),
  [\#75](https://github.com/rOpenGov/giscoR/issues/75)).
- Migrate to **httr2** instead of **httr**.
- Removed `tgs00026` dataset, use `eurostat::get_eurostat("tgs00026")`
  instead.

## giscoR 0.4.0

CRAN release: 2023-10-30

- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md):
  Add an additional `geo` column (identical to `NUTS_ID`) for enhanced
  compatibility with **eurostat** package
  ([\#62](https://github.com/rOpenGov/giscoR/issues/62)).
- Adjust examples for **CRAN**.
- Add dependency **httr**.

## giscoR 0.3.5

CRAN release: 2023-06-30

- Review examples to avoid **CRAN** errors and notes.
- New helper function:
  [`gisco_detect_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).
- Now the functions fail gracefully with an informative message, instead
  of an error, and return `NULL`.

## giscoR 0.3.4

CRAN release: 2023-05-26

- Update tests and documentation.

## giscoR 0.3.3

CRAN release: 2023-02-16

- Fix broken urls on
  [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md)
  ([\#51](https://github.com/rOpenGov/giscoR/issues/51)).

## giscoR 0.3.2

CRAN release: 2022-08-13

- Fix HTML5 issue as requested by **CRAN**.

## giscoR 0.3.1

CRAN release: 2021-10-06

- Add `Copyright` on `DESCRIPTION`.
- Add **lwgeom** on ‘Suggests’.
- [`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md)
  and
  [`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md):
  - Only year available is 2013.
  - Now information is downloaded instead of using internal data.
- New function:
  [`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md).
- Update `gisco_db`.

## giscoR 0.3.0

CRAN release: 2021-09-27

- Now **giscoR** is part of [rOpenGov](https://ropengov.org/). Repo has
  been transferred.
- Caching improvements: new function
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md)
  based on
  [`rappdirs::user_cache_dir()`](https://rappdirs.r-lib.org/reference/user_cache_dir.html).
  Now the `cache_dir` path is stored and it is not necessary to set it
  up again on a new session. Also added
  [`gisco_clear_cache()`](https://ropengov.github.io/giscoR/dev/reference/gisco_clear_cache.md).
- Fix an error when `cache = FALSE`. Now files are loaded instead
  throwing an error.
- New tests with **testthat**.
- Update on docs. New examples
- Refactor documents and codes for the previous `gisco_get` doc.
- Add **eurostat** package to ’ Suggests’.
- **lwgeom** dependency removed.
- Update internal grid object.
- **tmap** package replaced by **ggplot2** on vignettes and examples.

## giscoR 0.2.4

CRAN release: 2021-04-13

- New `eu` field on
  [`giscoR::gisco_countrycode`](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md).
- Fix typos on documentation.
- Include vignette on the package.
- Move docs to **roxygen2**.
- **lwgeom** moved to ‘Imports’ field.
- **cartography** package replaced by **tmap** on vignettes.

## giscoR 0.2.3

- Update on docs
- Release for DOI

## giscoR 0.2.2

CRAN release: 2020-11-23

- Remove vignette

## giscoR 0.2.1

- Remove **CRAN** notes.
- Improve docs.
- Fix **CRAN** checks.

## giscoR 0.2.0

CRAN release: 2020-11-12

- Remove **colorspace** as dependency.
- Bump **R** minimal version to `3.6.0`.
- Change order on arguments for
  [`gisco_get()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  functions.
- Rewriting of internal functions and utils.
- Add `verbose` argument to functions.
- Rewriting of
  [`giscoR::gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md).
- Functions added:
  - [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)
  - [`gisco_check_access()`](https://ropengov.github.io/giscoR/dev/reference/gisco_check_access.md)
  - [`gisco_get_airports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_airports.md)
  - [`gisco_get_grid()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_grid.md)
  - [`gisco_get_ports()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_ports.md)
  - [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)
- Now
  [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
  and
  [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
  uses
  [`gisco_get_units()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_units.md)
  for individual files, making the call much faster.

## giscoR 0.1.1

CRAN release: 2020-10-28

- Added
  [`giscoR::tgs00026`](https://ropengov.github.io/eurostat/reference/tgs00026.html)
  dataset.
- Remove **eurostat** dependency.

## giscoR 0.1.0

CRAN release: 2020-10-13

- First stable release.
