# Urban audit unit validates year, EPSG and spatial type

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

# Urban audit unit returns NULL when offline

    Code
      n <- gisco_get_unit_urban_audit(year = 2024, update_cache = TRUE, verbose = TRUE)
    Message
      i Requested file 'ES001F-region-100k-4326-2024.geojson'.
      x No internet connection available.
      > Returning "NULL".

# Urban audit unit returns NULL for 404 responses

    Code
      n <- gisco_get_unit_urban_audit(year = 2024, update_cache = TRUE, verbose = TRUE)
    Message
      i Requested file 'ES001F-region-100k-4326-2024.geojson'.
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/urau/urau-2024-units.json>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

