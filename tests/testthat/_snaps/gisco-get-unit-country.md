# unit_country: Validate inputs

    Code
      gisco_get_unit_country(year = -1989)
    Condition
      Error:
      ! `year` must be "2024", "2020", "2016", "2013", "2010", "2006", or "2001", not "-1989".

---

    Code
      gisco_get_unit_country(epsg = -1989)
    Condition
      Error:
      ! `epsg` must be "4326", "3857", or "3035", not "-1989".

---

    Code
      gisco_get_unit_country(resolution = -1989)
    Condition
      Error:
      ! `resolution` must be "1", "3", "10", "20", or "60", not "-1989".

---

    Code
      gisco_get_unit_country(spatialtype = "foo")
    Condition
      Error:
      ! `spatialtype` must be "RG" or "LB", not "foo".

