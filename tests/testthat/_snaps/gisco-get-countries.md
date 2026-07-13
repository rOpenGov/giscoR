# Countries can refresh an existing cached dataset

    Code
      db_cached <- gisco_get_countries(verbose = TRUE)
    Message
      i Loaded from `?giscoR::gisco_countries_2024()` dataset. Use `update_cache` = TRUE to reload from file.

# Countries support GeoJSON and zipped shapefile downloads

    Code
      gisco_get_countries(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

# Countries return NULL for 404 responses

    Code
      n <- gisco_get_countries(update_cache = TRUE, resolution = 60)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/countries/gpkg/CNTR_RG_60M_2024_4326.gpkg>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

