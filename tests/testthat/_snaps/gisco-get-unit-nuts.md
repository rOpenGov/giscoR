# NUTS unit validates year, EPSG, resolution and spatial type

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

# NUTS unit returns NULL when offline

    Code
      n <- gisco_get_unit_nuts(year = 2024, update_cache = TRUE, verbose = TRUE)
    Message
      i Requested file 'ES416-region-01m-4326-2024.geojson'.
      x No internet connection available.
      > Returning "NULL".

# NUTS unit returns NULL for 404 responses

    Code
      n <- gisco_get_unit_nuts(year = 2024, update_cache = TRUE, verbose = TRUE)
    Message
      i Requested file 'ES416-region-01m-4326-2024.geojson'.
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/nuts/nuts-2024-units.json>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

