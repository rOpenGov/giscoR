# giscoR 0.1.2.9050

- Remove `colorspace` as dependency.
- Bump R minimal version to 3.6.0.
- Change order on parameters for `gisco_get()` functions.
- Rewriting of internal functions and utils.
- Rewriting of `giscoR::gisco_db`.
- Functions added:
  - `gisco_bulk_download()`
  - `gisco_check_access()`
  - `gisco_get_airports()`
  - `gisco_get_grid()`
  - `gisco_get_healthcare()`
  - `gisco_get_ports()`
  - `gisco_get_units()`
- Now `gisco_get_countries()` and `gisco_get_nuts()` uses `gisco_get_units()` for individual files, making the call much faster.


# giscoR 0.1.1

- Added `giscoR::tgs00026` dataset.
- Remove `eurostat` dependency.


# giscoR 0.1.0

- First stable release.
