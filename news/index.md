# Changelog

## giscoR (development version)

- Improve tests.
- Results displayed as tibble.

## giscoR 0.6.1

CRAN release: 2025-01-27

- Fix an issue when filtering source on
  [`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md).

## giscoR 0.6.0

CRAN release: 2024-08-28

### Update with latest data available

- [`gisco_get_education()`](https://ropengov.github.io/giscoR/reference/gisco_get_education.md)
  and
  [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/reference/gisco_get_healthcare.md)
  gains a new `year` argument: years available now are 2020 and 2023
  versions of the dataset.
- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md)
  and
  [`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md)
  now can download the 2024 version of the datasets
  ([\#93](https://github.com/rOpenGov/giscoR/issues/93)
  [@hannesaddec](https://github.com/hannesaddec)).

## giscoR 0.5.1

CRAN release: 2024-07-06

- Use **CRAN** DOI: <https://doi.org/10.32614/CRAN.package.giscoR>.
- [`gisco_get_education()`](https://ropengov.github.io/giscoR/reference/gisco_get_education.md):
  Fix API entry points.
- Review failing examples.

## giscoR 0.5.0

CRAN release: 2024-05-29

- New functions:
  - [`gisco_get_education()`](https://ropengov.github.io/giscoR/reference/gisco_get_education.md).
  - Add access to [GISCO Address
    API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home)
    through new functions. See
    [`?gisco_addressapi`](https://ropengov.github.io/giscoR/reference/gisco_addressapi.md)
    to know more ([\#84](https://github.com/rOpenGov/giscoR/issues/84)).
- New dependency: **jsonlite** added to ‘Imports’.
- Update `gisco_db` with the most up-to-date released data.
- Default year of some functions updated to the latest available data:
  - [`gisco_get_lau()`](https://ropengov.github.io/giscoR/reference/gisco_get_lau.md)
    and
    [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/reference/gisco_get_urban_audit.md)
    default year now is `"2021"`.
- Update urls in documentation.

## giscoR 0.4.2

CRAN release: 2024-03-27

- Update of docs to avoid warnings on **CRAN**
  ([\#81](https://github.com/rOpenGov/giscoR/issues/81)).
- Rebuild datasets.

## giscoR 0.4.1

CRAN release: 2024-03-15

- Improve documentation, stating where the parameters `country` and
  `region` applies
  ([\#50](https://github.com/rOpenGov/giscoR/issues/50),
  [\#75](https://github.com/rOpenGov/giscoR/issues/75)).
- Migrate to **httr2** instead of **httr**.
- Removed `tgs00026` dataset, use `eurostat::get_eurostat("tgs00026")`
  instead.

## giscoR 0.4.0

CRAN release: 2023-10-30

- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md):
  Add an additional `geo` column (identical to `NUTS_ID`) for enhanced
  compatibility with **eurostat** package
  ([\#62](https://github.com/rOpenGov/giscoR/issues/62)).
- Adjust examples for **CRAN**.
- Add dependency **httr**.

## giscoR 0.3.5

CRAN release: 2023-06-30

- Review examples to avoid **CRAN** errors and notes.
- New helper function:
  [`gisco_detect_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md).
- Now the functions fail gracefully with an informative message, instead
  of an error, and return `NULL`.

## giscoR 0.3.4

CRAN release: 2023-05-26

- Update tests and documentation.

## giscoR 0.3.3

CRAN release: 2023-02-16

- Fix broken urls on
  [`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/reference/gisco_get_healthcare.md)
  ([\#51](https://github.com/rOpenGov/giscoR/issues/51)).

## giscoR 0.3.2

CRAN release: 2022-08-13

- Fix HTML5 issue as requested by **CRAN**.

## giscoR 0.3.1

CRAN release: 2021-10-06

- Add `Copyright` on `DESCRIPTION`.
- Add **lwgeom** on ‘Suggests’.
- [`gisco_get_airports()`](https://ropengov.github.io/giscoR/reference/gisco_get_airports.md)
  and
  [`gisco_get_ports()`](https://ropengov.github.io/giscoR/reference/gisco_get_airports.md):
  - Only year available is 2013.
  - Now information is downloaded instead of using internal data.
- New function:
  [`gisco_get_postalcodes()`](https://ropengov.github.io/giscoR/reference/gisco_get_postalcodes.md).
- Update `gisco_db`.

## giscoR 0.3.0

CRAN release: 2021-09-27

- Now **giscoR** is part of [rOpenGov](https://ropengov.org/). Repo has
  been transferred.
- Caching improvements: new function
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/reference/gisco_set_cache_dir.md)
  based on
  [`rappdirs::user_cache_dir()`](https://rappdirs.r-lib.org/reference/user_cache_dir.html).
  Now the `cache_dir` path is stored and it is not necessary to set it
  up again on a new session. Also added
  [`gisco_clear_cache()`](https://ropengov.github.io/giscoR/reference/gisco_clear_cache.md).
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
  [`giscoR::gisco_countrycode`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md).
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
- Change order on parameters for
  [`gisco_get()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md)
  functions.
- Rewriting of internal functions and utils.
- Add `verbose` parameter to functions.
- Rewriting of
  [`giscoR::gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md).
- Functions added:
  - [`gisco_bulk_download()`](https://ropengov.github.io/giscoR/reference/gisco_bulk_download.md)
  - [`gisco_check_access()`](https://ropengov.github.io/giscoR/reference/gisco_check_access.md)
  - [`gisco_get_airports()`](https://ropengov.github.io/giscoR/reference/gisco_get_airports.md)
  - [`gisco_get_grid()`](https://ropengov.github.io/giscoR/reference/gisco_get_grid.md)
  - [`gisco_get_ports()`](https://ropengov.github.io/giscoR/reference/gisco_get_airports.md)
  - [`gisco_get_units()`](https://ropengov.github.io/giscoR/reference/gisco_get_units.md)
- Now
  [`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md)
  and
  [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md)
  uses
  [`gisco_get_units()`](https://ropengov.github.io/giscoR/reference/gisco_get_units.md)
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
