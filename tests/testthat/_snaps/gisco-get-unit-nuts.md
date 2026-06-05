# unit_nuts: Validate inputs

    Code
      gisco_get_unit_nuts(year = -1989)
    Condition
      Error:
      ! `year` must be "2024", "2021", "2016", "2013", "2010", "2006", or "2003", not "-1989".

---

    Code
      gisco_get_unit_nuts(epsg = -1989)
    Condition
      Error:
      ! `epsg` must be "4326", "3857", or "3035", not "-1989".

---

    Code
      gisco_get_unit_nuts(resolution = -1989)
    Condition
      Error:
      ! `resolution` must be "1", "3", "10", "20", or "60", not "-1989".

---

    Code
      gisco_get_unit_nuts(spatialtype = "foo")
    Condition
      Error:
      ! `spatialtype` must be "RG" or "LB", not "foo".

