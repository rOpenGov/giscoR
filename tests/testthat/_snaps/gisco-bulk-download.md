# Deprecations

    Code
      s <- gisco_bulk_download(id_giscoR = "coastal_lines", resolution = 60,
        cache_dir = cdir)
    Condition
      Warning:
      The `id_giscoR` argument of `gisco_bulk_download()` is deprecated as of giscoR 1.0.0.
      i Please use the `id` argument instead.

---

    Code
      gisco_bulk_download("nuts", resolution = 60, recursive = TRUE, cache_dir = cdir)
    Condition
      Warning:
      The `recursive` argument of `gisco_bulk_download()` is deprecated as of giscoR 1.0.0.
      i Child `.zip` files inside the top-level `.zip` will not be unzipped.

# Errors

    Code
      gisco_bulk_download(id_giscoR = "nutes")
    Condition
      Warning:
      The `id_giscoR` argument of `gisco_bulk_download()` is deprecated as of giscoR 1.0.0.
      i Please use the `id` argument instead.
      Error:
      ! `id` must be "countries", "coastal_lines", "communes", "lau", "nuts", "urban_audit", or "postal_codes", not "nutes".

# Online mocked

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/countries/download/ref-countries-2001-20m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/countries/download/ref-countries-2024-20m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/coas/download/ref-coastline-2006-20m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/coas/download/ref-coastline-2016-20m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/communes/download/ref-communes-2001-01m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/communes/download/ref-communes-2016-01m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/lau/download/ref-lau-2011-01m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/lau/download/ref-lau-2024-01m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/nuts/download/ref-nuts-2003-20m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/nuts/download/ref-nuts-2024-20m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/urau/download/ref-urau-2001-03m.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/urau/download/ref-urau-2024-100k.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/pcode/download/ref-pcode-2020.shp.zip".

---

    Code
      s <- gisco_bulk_download(iii, year = x, resolution = 20, cache_dir = cdir, ext = "shp")
    Message
      i Mocked url is "<masked_entry>/pcode/download/ref-pcode-2025.shp.zip".

---

    Code
      gisco_bulk_download("communes", year = 2004, ext = "svg", cache_dir = cdir)
    Message
      i Mocked url is "<masked_entry>/communes/download/ref-communes-2004-01m.svg.zip".
    Output
      NULL

---

    Code
      gisco_bulk_download("countries", year = 2024, ext = "json", cache_dir = cdir,
        resolution = 60)
    Message
      i Mocked url is "<masked_entry>/countries/download/ref-countries-2024-60m.json.zip".
    Output
      NULL

---

    Code
      gisco_bulk_download("countries", year = 2024, ext = "gdb", cache_dir = cdir,
        resolution = 60)
    Message
      i Mocked url is "<masked_entry>/countries/download/ref-countries-2024-60m.gdb.zip".
    Output
      NULL

