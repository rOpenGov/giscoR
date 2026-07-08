# Downloads return NULL when offline

    Code
      fend <- download_url(url, cache_dir = cdir, subdir = "fixme", update_cache = FALSE,
        verbose = FALSE)
    Message
      x No internet connection available.
      > Returning "NULL".

# URL database lookup validates and returns matching entries

    Code
      get_url_db("communes", "9999", fn = "gisco_get_communes")
    Condition
      Error:
      ! Years available for `giscoR::gisco_get_communes()` are 2001, 2004, 2006, 2008, 2010, 2013, and 2016.

---

    Code
      get_url_db("communes", "2016", epsg = "1111", ext = "csv", fn = "gisco_get_communes")
    Condition
      Error:
      ! No results for `giscoR::gisco_get_communes()` with these parameters:
      * `year` = "2016"
      * `epsg` = "1111"
      * `ext` = "csv"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

# Request body returns NULL when offline

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x No internet connection available.
      > Returning "NULL".

# Request body returns NULL for 404 responses

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/themes.json>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

