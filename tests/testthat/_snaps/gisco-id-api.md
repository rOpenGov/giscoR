# ID API returns NULL when offline

    Code
      fend <- gisco_id_api_geonames(x = 4, y = 52)
    Message
      x No internet connection available.
      > Returning "NULL".

---

    Code
      fend <- gisco_id_api_nuts(x = 4, y = 52, geometry = FALSE)
    Message
      x No internet connection available.
      > Returning "NULL".

# ID API returns NULL for 404 responses

    Code
      n <- gisco_id_api_geonames(x = 4, y = 52)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/id/geonames?x=4&y=52>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_id_api_nuts(x = 4, y = 52, geometry = TRUE)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/id/nuts?x=4&y=52&epsg=4326&year=2024&format=geojson&geometry=yes>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_id_api_lau(x = 4, y = 52, geometry = TRUE)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/id/lau?x=4&y=52&epsg=4326&year=2024&format=geojson&geometry=yes>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_id_api_country(x = 4, y = 52, geometry = FALSE)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/id/country?x=4&y=52&epsg=4326&year=2024&format=json&geometry=no>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# gisco_id_api_nuts online

    Code
      gisco_id_api_nuts(epsg = 222)
    Condition
      Error:
      ! `epsg` must be "4326", "4258", or "3035", not "222".

---

    Code
      n <- gisco_id_api_nuts(nuts_level = 2, epsg = 4258)
    Message
      x Error 500 (Internal Server Error): <https://gisco-services.ec.europa.eu/id/nuts?epsg=4258&year=2024&nuts_level=2&format=geojson&geometry=yes>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_id_api_nuts(epsg = 3035, nuts_id = c("ES11", "ES12"))
    Message
      ! `nuts_id` should have length 1, not 2.
      i Using `nuts_id` = "ES11".

# gisco_id_api_lau online

    Code
      gisco_id_api_lau(epsg = 222, x = 1, y = 1)
    Condition
      Error:
      ! `epsg` must be "4326", "4258", or "3035", not "222".

# gisco_id_api_country online

    Code
      gisco_id_api_country(epsg = 222, x = 1, y = 1)
    Condition
      Error:
      ! `epsg` must be "4326", "4258", or "3035", not "222".

