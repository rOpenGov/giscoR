# Postal codes validate available years

    Code
      gisco_get_postal_codes("1991", "Years available for")
    Condition
      Error:
      ! Years available for `giscoR::gisco_get_postal_codes()` are 2020, 2024, and 2025.

# Postal codes return NULL for 404 responses

    Code
      n <- gisco_get_postal_codes(year = 2024, country = "ES", update_cache = TRUE)
    Message
      ! The file to download is "196.9 Mb".
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/pcode/gpkg/PCODE_PT_2024_4326.gpkg>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# Postal codes reject unsupported extensions and read shapefiles

    Code
      gisco_get_postal_codes(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

