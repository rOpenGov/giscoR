# Address API returns NULL when offline

    Code
      fend <- gisco_address_api_bbox()
    Message
      x No internet connection available.
      > Returning "NULL".
      ! No results found. Returning "NULL".

# Address API returns NULL for 404 responses

    Code
      n <- gisco_address_api_bbox()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/bbox>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".
      ! No results found. Returning "NULL".

---

    Code
      n <- gisco_address_api_cities()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/cities>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_address_api_copyright()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/copyright>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_address_api_housenumbers()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/housenumbers>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_address_api_postcodes()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/postcodes>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_address_api_provinces()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/provinces>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_address_api_reverse(x = 0, y = 0)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/reverse?x=0&y=0>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_address_api_roads()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/roads>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_address_api_search()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/search>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_address_api_countries()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/countries>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

---

    Code
      n <- gisco_address_api_copyright()
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/addressapi/copyright>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

