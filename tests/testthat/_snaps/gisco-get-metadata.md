# Metadata returns NULL when offline

    Code
      fend <- gisco_get_metadata()
    Message
      x No internet connection available.
      > Returning "NULL".

# Metadata returns NULL for 404 responses

    Code
      n <- gisco_get_metadata()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/nuts/csv/NUTS_AT_2024.csv>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# Metadata validates dataset and year inputs

    Code
      gisco_get_metadata("grids")
    Condition
      Error:
      ! `id` must be "nuts", "countries", or "urban_audit", not "grids".

---

    Code
      gisco_get_metadata("urban_audit", year = 1990)
    Condition
      Error:
      ! `year` must be "2001", "2004", "2014", "2018", "2020", "2021", or "2024", not "1990".

