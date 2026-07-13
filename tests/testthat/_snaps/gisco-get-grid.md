# Grid validates inputs

    Code
      gisco_get_grid(resolution = 24)
    Condition
      Error:
      ! `resolution` must be "100", "50", "20", "10", "5", "2", or "1", not "24".

---

    Code
      gisco_get_grid(spatialtype = "9999")
    Condition
      Error:
      ! `spatialtype` must be "REGION" or "POINT", not "9999".

# Grids return NULL for 404 responses

    Code
      n <- gisco_get_grid(update_cache = TRUE)
    Message
      x Error 404 (Not Found): <https://gisco-services.ec.europa.eu/grid/grid_100km_surf.gpkg>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

