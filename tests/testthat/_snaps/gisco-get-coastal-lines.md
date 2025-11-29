# Errors

    Code
      gisco_get_coastal_lines(ext = "docx")
    Condition
      Error:
      ! `ext` should be one of "geojson", "gpkg" or "shp", not "docx".

# Cached dataset vs updated

    Code
      db_cached <- gisco_get_coastal_lines(verbose = TRUE)
    Message
      i Loaded from `?giscoR::gisco_coastallines()` dataset. Use `update_cache = TRUE` to re-load from file

