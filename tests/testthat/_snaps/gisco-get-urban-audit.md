# Test inputs

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

