# No conexion

    Code
      fend <- gisco_get_metadata()
    Message
      x Offline
      > Returning "NULL"

# Errors

    Code
      gisco_get_metadata("grids")
    Condition
      Error:
      ! `id` should be one of "nuts", "countries" or "urban_audit", not "grids".

---

    Code
      gisco_get_metadata("urban_audit")
    Condition
      Error:
      ! `year` should be one of "2001", "2004", "2014", "2018", "2020" or "2021", not "2024".

