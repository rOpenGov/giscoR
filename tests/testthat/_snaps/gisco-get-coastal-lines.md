# Coastal lines return NULL for 404 responses

    Code
      n <- gisco_get_coastal_lines(update_cache = TRUE, resolution = 60)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/coas/gpkg/COAS_RG_60M_2016_4326.gpkg>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

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

