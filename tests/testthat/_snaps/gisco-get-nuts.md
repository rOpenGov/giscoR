# Valid inputs

    Code
      gisco_get_nuts(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

---

    Code
      gisco_get_nuts(nuts_level = "docx")
    Condition
      Error:
      ! `nuts_level` must be "all", "0", "1", "2", or "3", not "docx".

# Cached dataset vs updated

    Code
      db_cached <- gisco_get_nuts(verbose = TRUE, nuts_id = "ES51")
    Message
      i Loaded from `?giscoR::gisco_nuts_2024()` dataset. Use `update_cache` = TRUE to reload from file.

