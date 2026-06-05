# Deprecations

    Code
      s <- gisco_get_communes(cache = FALSE, spatialtype = "LB")
    Condition
      Warning:
      The `cache` argument of `gisco_get_communes()` is deprecated as of giscoR 1.0.0.
      i Results are always cached. To avoid persistent cache files, use `cache_dir = tempdir()`.

# Extensions

    Code
      gisco_get_communes(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

