# LAU returns NULL for 404 responses

    Code
      n <- gisco_get_lau(update_cache = TRUE, year = 2020)
    Message
      ! The file to download is "61.9 Mb".
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/distribution/v2/lau/gpkg/LAU_RG_01M_2020_4326.gpkg>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# LAU validates year and EPSG

    Code
      gisco_get_lau(year = "2001")
    Condition
      Error:
      ! Years available for `giscoR::gisco_get_lau()` are 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, and 2024.

---

    Code
      gisco_get_lau(epsg = "9999")
    Condition
      Error:
      ! No results for `giscoR::gisco_get_lau()` with these parameters:
      * `year` = "2024"
      * `epsg` = "9999"
      * `ext` = "gpkg"
      i Check available combinations in `giscoR::gisco_get_cached_db()`.

# LAU reports deprecated cache usage

    Code
      s <- gisco_get_lau(year = 2024, cache = TRUE, gisco_id = "ES_12016")
    Condition
      Warning:
      The `cache` argument of `gisco_get_lau()` is deprecated as of giscoR 1.0.0.
      i Results are always cached. To avoid persistent cache files, use `cache_dir = tempdir()`.

# LAU rejects unsupported extensions and reads GeoJSON

    Code
      gisco_get_lau(ext = "docx")
    Condition
      Error:
      ! `ext` must be "geojson", "gpkg", or "shp", not "docx".

