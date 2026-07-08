# Coastal lines validate unsupported extensions

    Code
      gisco_get_coastal_lines(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

# Coastal lines can refresh an existing cached dataset

    Code
      db_cached <- gisco_get_coastal_lines(verbose = TRUE)
    Message
      i Loaded from `?giscoR::gisco_coastal_lines()` dataset. Use `update_cache` = TRUE to reload from file.

