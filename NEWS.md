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

-   Improve documentation, stating where the parameters `country` and `region`
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
-   Change order on parameters for `gisco_get()` functions.
-   Rewriting of internal functions and utils.
-   Add `verbose` parameter to functions.
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
