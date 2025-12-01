# Deprecations

    Code
      s <- gisco_bulk_download(id_giscoR = "coastal_lines", resolution = 60,
        cache_dir = cdir)
    Condition
      Warning:
      The `id_giscoR` argument of `gisco_bulk_download()` is deprecated as of giscoR 1.0.0.
      i Please use the `id_giscor` argument instead.

---

    Code
      gisco_bulk_download("nuts", resolution = 60, recursive = TRUE, cache_dir = cdir)
    Condition
      Warning:
      The `recursive` argument of `gisco_bulk_download()` is deprecated as of giscoR 1.0.0.
      i Child `.zip` files inside the top-level `.zip` won't be unzipped.

# Errors on bulk download

    Code
      gisco_bulk_download(id_giscoR = "nutes")
    Condition
      Warning:
      The `id_giscoR` argument of `gisco_bulk_download()` is deprecated as of giscoR 1.0.0.
      i Please use the `id_giscor` argument instead.
      Error:
      ! `id_giscor` should be one of "countries", "coastal_lines", "communes", "lau", "nuts", "urban_audit" or "postal_codes", not "nutes".

