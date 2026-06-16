# Errors

    Code
      gisco_get_coastal_lines(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

# Cached dataset vs updated

    Code
      db_cached <- gisco_get_coastal_lines(verbose = TRUE)
    Message
      i Loaded from `?giscoR::gisco_coastal_lines()` dataset. Use `update_cache` = TRUE to reload from file.

