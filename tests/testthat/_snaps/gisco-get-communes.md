# Communes return NULL for 404 responses

    Code
      n <- gisco_get_communes(update_cache = TRUE, spatialtype = "LB")
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/communes/shp/COMM_LB_2016_4326.shp.zip>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# Communes validate year, EPSG and spatial type

    Code
      gisco_get_communes(year = "2007")
    Condition
      Error:
      ! Years available for `giscoR::gisco_get_communes()` are 2001, 2004, 2006, 2008, 2010, 2013, and 2016.

---

    Code
      gisco_get_communes(epsg = "9999")
    Condition
      Error:
      ! No results for `giscoR::gisco_get_communes()` with these parameters:
      * `year` = "2016"
      * `epsg` = "9999"
      * `spatialtype` = "RG"
      * `ext` = "shp"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

---

    Code
      gisco_get_communes(year = "2004", spatialtype = "COASTL")
    Condition
      Error:
      ! No results for `giscoR::gisco_get_communes()` with these parameters:
      * `year` = "2004"
      * `epsg` = "4326"
      * `spatialtype` = "COASTL"
      * `ext` = "shp"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

---

    Code
      gisco_get_communes(year = "2004", spatialtype = "INLAND")
    Condition
      Error:
      ! No results for `giscoR::gisco_get_communes()` with these parameters:
      * `year` = "2004"
      * `epsg` = "4326"
      * `spatialtype` = "INLAND"
      * `ext` = "shp"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

---

    Code
      gisco_get_communes(spatialtype = "ERR")
    Condition
      Error:
      ! No results for `giscoR::gisco_get_communes()` with these parameters:
      * `year` = "2016"
      * `epsg` = "4326"
      * `spatialtype` = "ERR"
      * `ext` = "shp"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

# Communes report deprecated cache usage

    Code
      s <- gisco_get_communes(cache = FALSE, spatialtype = "LB")
    Condition
      Warning:
      The `cache` argument of `gisco_get_communes()` is deprecated as of giscoR 1.0.0.
      i Results are always cached. To avoid persistent cache files, use `cache_dir = tempdir()`.

# Communes reject unsupported extensions and read GeoJSON

    Code
      gisco_get_communes(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

