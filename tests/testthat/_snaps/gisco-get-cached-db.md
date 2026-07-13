# Cached database returns NULL when offline

    Code
      fend <- gisco_get_cached_db(update_cache = TRUE)
    Message
      ! Could not access <https://gisco-services.ec.europa.eu/distribution/v2/>. If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# Cached database returns NULL for 404 responses

    Code
      n <- gisco_get_cached_db(update_cache = TRUE)
    Message
      ! Could not access <https://gisco-services.ec.europa.eu/distribution/v2/>. If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# Cached database stores fallback data when remote access fails

    Code
      n <- get_db()
    Message
      ! Could not access <https://gisco-services.ec.europa.eu/distribution/v2/>. If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".
      ! Could not retrieve the latest database from <https://gisco-services.ec.europa.eu/distribution/v2/>.
      Try again later with `giscoR::gisco_get_cached_db()` and `update_cache` = TRUE.
      i Using cached "gisco_db" (`?giscoR::gisco_db()`) information as of "2026-06-19". It may be outdated.

# Cached database refreshes from the remote metadata

    Code
      unique(new_db$id_giscor)
    Output
      [1] "coastal_lines" "communes"      "countries"     "lau"          
      [5] "nuts"          "postal_codes"  "urban_audit"  

---

    Code
      unique(new_db$ext)
    Output
      [1] "csv"     "geojson" "gpkg"    "json"    "pbf"     "shp"     "parquet"

---

    Code
      unique(new_db$epsg)
    Output
      [1] 3035 3857 4326   NA

---

    Code
      unique(new_db$nuts_level)
    Output
      [1] NA    "0"   "1"   "2"   "3"   "all"

---

    Code
      unique(new_db$resolution)
    Output
      [1]   1   3  10  20  60  NA 100

---

    Code
      unique(new_db$spatialtype)
    Output
      [1] "RG"     "BN"     "LB"     NA       "COASTL" "INLAND"

---

    Code
      unique(new_db$level)
    Output
      [1] NA               "CITY"           "KERN"           "LUZ"           
      [5] "CITIES"         "FUA"            "GREATER_CITIES" "all"           

---

    Code
      sort(unique(new_db$year))
    Output
       [1] 2001 2003 2004 2006 2008 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
      [16] 2020 2021 2022 2023 2024 2025

