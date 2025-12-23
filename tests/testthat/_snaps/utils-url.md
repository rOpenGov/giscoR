# Test offline

    Code
      fend <- download_url(url, cache_dir = cdir, subdir = "fixme", update_cache = FALSE,
        verbose = FALSE)
    Message
      x Offline
      > Returning "NULL"

# Get urls

    Code
      get_url_db("communes", "9999", fn = "gisco_get_communes")
    Condition
      Error:
      ! Years available for `giscoR::gisco_get_communes()` are "2001", "2004", "2006", "2008", "2010", "2013", and "2016".

---

    Code
      get_url_db("communes", "2016", epsg = "1111", ext = "csv", fn = "gisco_get_communes")
    Condition
      Error:
      ! No results for `giscoR::gisco_get_communes()` with params:
      * `year` = "2016"
      * `epsg` = "1111"
      * `ext` = "csv"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

---

    Code
      ss <- get_url_db("communes", "2016", fn = "gisco_get_communes")
    Message
      ! `giscoR::gisco_get_communes()` has 25 results with params:
      * `year` = "2016"
      * `epsg` = "4326"
      > Returning first value:
      * `id_giscor` = "communes"
      * `year` = "2016"
      * `epsg` = "4326"
      * `resolution` = "1"
      * `spatialtype` = "BN"
      * `nuts_level` = "NA"
      * `level` = "NA"
      * `ext` = "csv"
      * `api_file` = "csv/COMM_BN_01M_2016_4326.csv"
      * `api_entry` = "https://gisco-services.ec.europa.eu/distribution/v2/communes"

# No connection body

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x Offline
      > Returning "NULL"

# Error body

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/themes.json>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropengov/giscoR/issues>
      > Returning "NULL"

