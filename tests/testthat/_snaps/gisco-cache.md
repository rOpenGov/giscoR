# Persistent cache config can be installed and overwritten

    Code
      gisco_set_cache_dir(cache_dir2, install = TRUE, verbose = FALSE)
    Condition
      Error in `gisco_set_cache_dir()`:
      ! A `cache_dir` path already exists.
      You can overwrite it with `overwrite` = TRUE.

# Legacy cache configuration migrates to the current location

    Code
      migrate_cache(old = old, new = new)
    Message
      v giscoR >= 1.0.0: cache configuration migrated. See Note in `giscoR::gisco_set_cache_dir()` for details.
      i This is a one-time message and will not be displayed again.

