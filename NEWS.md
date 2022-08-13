# giscoR 0.3.2

-   Fix HTML5 issue as requested by CRAN.

# giscoR 0.3.1

-   Add `Copyright` on DESCRIPTION.

-   Add `lwgeom` on `Suggests`.

-   `gisco_get_airports()` and `gisco_get_ports()`:

    -   Only year available is 2013.

    -   Now information is downloaded instead of using internal data.

-   New function: `gisco_get_postalcodes()`.

-   Update `gisco_db`.

# giscoR 0.3.0

-   Now **giscoR** is part of [rOpenGov](https://ropengov.org/). Repo has been transferred.
-   Caching improvements: new function `gisco_set_cache_dir()` based on `rappdirs::user_cache_dir()`. Now the `cache_dir` path is stored and it is not necessary to set it up again on a new session. Also added `gisco_clear_cache()`.
-   Fix an error when `cache = FALSE`. Now files are loaded instead throwing an error.
-   New tests with `testthat`.
-   Update on docs. New examples
-   Refactor documents and codes for the previous `gisco_get` doc.
-   Add `eurostat` package to `Suggests`.
-   `lwgeom` dependency removed.
-   Update internal grid object.
-   `tmap` package replaced by `ggplot2` on vignettes and examples.

# giscoR 0.2.4

-   New `eu` field on `giscoR::gisco_countrycode`.
-   Fix typos on documentation
-   Include vignette on the package
-   Move docs to markdown/roxygen
-   `lwgeom` moved to Import field.
-   `cartography` package replaced by `tmap` on vignettes.

# giscoR 0.2.3

-   Update on docs
-   Release for DOI

# giscoR 0.2.2

-   Remove vignette

# giscoR 0.2.1

-   Remove CRAN notes.
-   Improve docs.
-   Fix CRAN checks.

# giscoR 0.2.0

-   Remove `colorspace` as dependency.

-   Bump R minimal version to 3.6.0.

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

-   Now `gisco_get_countries()` and `gisco_get_nuts()` uses `gisco_get_units()` for individual files, making the call much faster.

# giscoR 0.1.1

-   Added `giscoR::tgs00026` dataset.
-   Remove `eurostat` dependency.

# giscoR 0.1.0

-   First stable release.
