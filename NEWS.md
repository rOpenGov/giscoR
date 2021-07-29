# giscoR (development version)

- Update on docs
- `lwgeom` dependency removed.
- Update internal grid object.

# giscoR 0.2.4

- New `eu` field on `giscoR::gisco_countrycode`.
- Fix typos on documentation
- Include vignette on the package
- Move docs to markdown/roxygen
- `lwgeom` moved to Import field.
- `cartography` package replaced by `tmap` on vignettes.

# giscoR 0.2.3

- Update on docs
- Release for DOI

# giscoR 0.2.2

- Remove vignette

# giscoR 0.2.1

- Remove CRAN notes.
- Improve docs.
- Fix cran checks.


# giscoR 0.2.0

- Remove `colorspace` as dependency.
- Bump R minimal version to 3.6.0.
- Change order on parameters for `gisco_get()` functions.
- Rewriting of internal functions and utils.
- Add `verbose` parameter to functions.
- Rewriting of `giscoR::gisco_db`.
- Functions added:
  - `gisco_bulk_download()`
  - `gisco_check_access()`
  - `gisco_get_airports()`
  - `gisco_get_grid()`
  - `gisco_get_ports()`
  - `gisco_get_units()`
- Now `gisco_get_countries()` and `gisco_get_nuts()` uses `gisco_get_units()` for individual files, making the call much faster.


# giscoR 0.1.1

- Added `giscoR::tgs00026` dataset.
- Remove `eurostat` dependency.


# giscoR 0.1.0

- First stable release.
