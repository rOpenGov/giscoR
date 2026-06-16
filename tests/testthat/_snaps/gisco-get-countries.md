# Cached dataset vs updated

    Code
      db_cached <- gisco_get_countries(verbose = TRUE)
    Message
      i Loaded from `?giscoR::gisco_countries_2024()` dataset. Use `update_cache` = TRUE to reload from file.

# Extensions

    Code
      gisco_get_countries(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

