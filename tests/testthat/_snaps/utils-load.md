# No conexion

    Code
      fend <- api_cache(url, cache_dir = cdir, subdir = "fixme", update_cache = FALSE,
        verbose = FALSE)
    Message
      x Offline
      > Returning "NULL"

# Get urls

    Code
      get_url_db("communes", "9999", fn = "gisco_get_communes")
    Condition
      Error in `get_url_db()`:
      ! Years available for `giscoR::giscoR::gisco_get_communes()` are "2001", "2004", "2006", "2008", "2010", "2013", and "2016".

---

    Code
      get_url_db("communes", "2016", epsg = "1111", ext = "csv", fn = "gisco_get_communes")
    Condition
      Error in `get_url_db()`:
      ! No results for `giscoR::gisco_get_communes()` with params:
      * `year` = "2016"
      * `epsg` = "1111"
      * `ext` = "csv"
      i Check available combinations in `giscoR::gisco_get_latest_db()`.

---

    Code
      ss <- get_url_db("communes", "2016", fn = "gisco_get_communes")
    Message
      ! `giscoR::gisco_get_communes()` has 25 results with params:
      * `year` = "2016"
      * `epsg` = "4326"
      > Returning first value:
      * `id_giscoR` = "communes"
      * `year` = "2016"
      * `epsg` = "4326"
      * `resolution` = "01"
      * `spatialtype` = "BN"
      * `nuts_level` = "NA"
      * `level` = "NA"
      * `ext` = "csv"
      * `api_file` = "csv/COMM_BN_01M_2016_4326.csv"
      * `api_entry` = "https://gisco-services.ec.europa.eu/distribution/v2/communes"

