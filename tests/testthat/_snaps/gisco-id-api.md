# Test offline

    Code
      fend <- gisco_id_api_geonames(x = 4, y = 52)
    Message
      x Offline
      > Returning "NULL"

---

    Code
      fend <- gisco_id_api_nuts(x = 4, y = 52, geometry = FALSE)
    Message
      x Offline
      > Returning "NULL"

# gisco_id_api_nuts online

    Code
      gisco_id_api_nuts(epsg = 222)
    Condition
      Error:
      ! `epsg` should be one of "4326", "4258" or "3035", not "222".

---

    Code
      n <- gisco_id_api_nuts(nuts_level = 2, epsg = 4258)
    Message
      x Error 500 (Internal Server Error): <https://gisco-services.ec.europa.eu/id/nuts?epsg=4258&year=2024&nuts_level=2&format=geojson&geometry=yes>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropengov/giscoR/issues>
      > Returning "NULL"

---

    Code
      n <- gisco_id_api_nuts(epsg = 3035, nuts_id = c("ES11", "ES12"))
    Message
      ! `nuts_id` should have length "1", not "2".
      i Using `nuts_id = "ES11"`.

# gisco_id_api_lau online

    Code
      gisco_id_api_lau(epsg = 222, x = 1, y = 1)
    Condition
      Error:
      ! `epsg` should be one of "4326", "4258" or "3035", not "222".

# gisco_id_api_country online

    Code
      gisco_id_api_country(epsg = 222, x = 1, y = 1)
    Condition
      Error:
      ! `epsg` should be one of "4326", "4258" or "3035", not "222".

