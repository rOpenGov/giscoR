# Urban audit validates inputs before remote access

    Code
      gisco_get_urban_audit(year = "1999")
    Condition
      Error:
      ! Years available for `giscoR::gisco_get_urban_audit()` are 2001, 2004, 2014, 2018, 2020, 2021, and 2024.

---

    Code
      gisco_get_urban_audit(epsg = "9999")
    Condition
      Error:
      ! No results for `giscoR::gisco_get_urban_audit()` with these parameters:
      * `year` = "2024"
      * `epsg` = "9999"
      * `spatialtype` = "RG"
      * `level` = "all"
      * `ext` = "gpkg"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

---

    Code
      gisco_get_urban_audit(level = "9999")
    Condition
      Error:
      ! `level` must be "all", "CITIES", "FUA", "GREATER_CITIES", "CITY", "KERN", or "LUZ", not "9999".

---

    Code
      gisco_get_urban_audit(spatialtype = "BN")
    Condition
      Error:
      ! `spatialtype` must be "RG" or "LB", not "BN".

---

    Code
      gisco_get_urban_audit(year = 2001)
    Condition
      Error:
      ! No results for `giscoR::gisco_get_urban_audit()` with these parameters:
      * `year` = "2001"
      * `epsg` = "4326"
      * `spatialtype` = "RG"
      * `level` = "all"
      * `ext` = "gpkg"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

# Urban audit returns NULL for 404 responses

    Code
      n <- gisco_get_urban_audit(update_cache = TRUE)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/urau/gpkg/URAU_RG_100K_2024_4326.gpkg>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# Urban audit validates extensions and level inputs

    Code
      gisco_get_urban_audit(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

---

    Code
      gisco_get_urban_audit(level = "docx")
    Condition
      Error:
      ! `level` must be "all", "CITIES", "FUA", "GREATER_CITIES", "CITY", "KERN", or "LUZ", not "docx".

