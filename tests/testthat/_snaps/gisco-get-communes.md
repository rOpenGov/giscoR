# Deprecations

    Code
      s <- gisco_get_communes(cache = FALSE, spatialtype = "LB")
    Condition
      Warning:
      The `cache` argument of `gisco_get_lau()` is deprecated as of giscoR 1.0.0.
      i Results are always cached. To avoid persistency use `cache_dir = tempdir()`.

