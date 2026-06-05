# unit_urban_audit: Validate inputs

    Code
      gisco_get_unit_urban_audit(year = -1989)
    Condition
      Error:
      ! `year` must be "2024", "2021", "2020", "2018", "2014", "2004", or "2001", not "-1989".

---

    Code
      gisco_get_unit_urban_audit(epsg = -1989)
    Condition
      Error:
      ! `epsg` must be "4326", "3857", or "3035", not "-1989".

---

    Code
      gisco_get_unit_urban_audit(spatialtype = "foo")
    Condition
      Error:
      ! `spatialtype` must be "RG" or "LB", not "foo".

