# Deprecations

    Code
      s <- gisco_get_lau(year = 2024, cache = TRUE, gisco_id = "ES_12016")
    Condition
      Warning:
      The `cache` argument of `gisco_get_lau()` is deprecated as of giscoR 1.0.0.
      i Results are always cached. To avoid persistency use `cache_dir = tempdir()`.
    Message
      ! File size: 74.6 Mb
      i Reading file with sf. It can take a while, hold on!

