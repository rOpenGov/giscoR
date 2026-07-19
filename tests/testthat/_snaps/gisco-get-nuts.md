# NUTS return NULL when offline

    Code
      n <- gisco_get_nuts(update_cache = TRUE, cache_dir = cdir, resolution = 60)
    Message
      x No internet connection available.
      > Returning "NULL".

# NUTS return NULL for 404 responses

    Code
      n <- gisco_get_nuts(update_cache = TRUE, resolution = 60)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/nuts/gpkg/NUTS_RG_60M_2024_4326.gpkg>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# NUTS validate extensions and level inputs

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

# NUTS can refresh an existing cached dataset

    Code
      db_cached <- gisco_get_nuts(verbose = TRUE, nuts_id = "ES51")
    Message
      i Loaded from `?giscoR::gisco_nuts_2024()` dataset. Use `update_cache` = TRUE to reload from file.

