# Country unit validates year, EPSG, resolution and spatial type

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

# Country unit returns NULL when offline

    Code
      n <- gisco_get_unit_country(year = 2024, unit = "ES", update_cache = TRUE,
        verbose = TRUE)
    Message
      i Requested file 'ES-region-01m-4326-2024.geojson'.
      x No internet connection available.
      > Returning "NULL".

# Country unit returns NULL for 404 responses

    Code
      n <- gisco_get_unit_country(year = 2024, unit = "ES", update_cache = TRUE,
        verbose = TRUE)
    Message
      i Requested file 'ES-region-01m-4326-2024.geojson'.
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/countries/countries-2024-units.json>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

