# Bulk download returns NULL when offline

    Code
      n <- gisco_bulk_download(update_cache = TRUE)
    Message
      x No internet connection available.
      > Returning "NULL".

# Bulk download returns NULL for 404 responses

    Code
      n <- gisco_bulk_download(update_cache = TRUE)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/countries/download/ref-countries-2016-10m.shp.zip>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# Bulk download reports deprecated arguments

    Code
      s <- gisco_bulk_download(id_giscoR = "coastal_lines", resolution = 60,
        cache_dir = cdir)
    Condition
      Warning:
      The `id_giscoR` argument of `gisco_bulk_download()` is deprecated as of giscoR 1.0.0.
      i Please use the `id` argument instead.

---

    Code
      gisco_bulk_download("nuts", resolution = 60, recursive = TRUE, cache_dir = cdir)
    Condition
      Warning:
      The `recursive` argument of `gisco_bulk_download()` is deprecated as of giscoR 1.0.0.
      i Child `.zip` files inside the top-level `.zip` will not be unzipped.

# Bulk download validates user inputs

    Code
      gisco_bulk_download(year = "2000")
    Condition
      Error:
      ! Years available for `giscoR::gisco_bulk_download()` are 2001, 2006, 2010, 2013, 2016, 2020, and 2024.

---

    Code
      gisco_bulk_download(resolution = "35")
    Condition
      Error:
      ! No results for `giscoR::gisco_bulk_download()` with these parameters:
      * `year` = "2016"
      * `epsg` = "4326"
      * `resolution` = "35"
      * `spatialtype` = "RG"
      * `ext` = "shp"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

---

    Code
      gisco_bulk_download(id_giscoR = "nutes")
    Condition
      Warning:
      The `id_giscoR` argument of `gisco_bulk_download()` is deprecated as of giscoR 1.0.0.
      i Please use the `id` argument instead.
      Error:
      ! `id` must be "countries", "coastal_lines", "communes", "lau", "nuts", "urban_audit", or "postal_codes", not "nutes".

---

    Code
      gisco_bulk_download(ext = "aa")
    Condition
      Error:
      ! `ext` must be "shp", "geojson", "svg", "json", or "gdb", not "aa".

