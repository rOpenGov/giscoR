# Deprecations

    Code
      s <- gisco_get_lau(year = 2024, cache = TRUE, gisco_id = "ES_12016")
    Condition
      Warning:
      The `cache` argument of `gisco_get_lau()` is deprecated as of giscoR 1.0.0.
      i Results are always cached. To avoid persistent cache files, use `cache_dir = tempdir()`.

# Extensions

    Code
      gisco_get_lau(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

