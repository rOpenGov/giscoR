# Test inputs

    Code
      gisco_get_urban_audit(ext = "docx")
    Condition
      Error:
      ! `ext` should be one of "geojson", "gpkg" or "shp", not "docx".

---

    Code
      gisco_get_urban_audit(level = "docx")
    Condition
      Error:
      ! `level` should be one of "all", "CITIES", "FUA", "GREATER_CITIES", "CITY", "KERN" or "LUZ", not "docx".

