# Deprecate df mode

    Code
      df1 <- gisco_get_units("nuts", year = 2016, mode = "df")
    Condition
      Warning:
      `gisco_get_units()` was deprecated in giscoR 1.0.0.
      i Please use `gisco_get_metadata()` instead.

# Deprecate nuts

    Code
      df1 <- gisco_get_units("nuts", unit = "ES416", year = 2016, spatialtype = "LB",
        cache = FALSE)
    Condition
      Warning:
      `gisco_get_units()` was deprecated in giscoR 1.0.0.
      i Please use `gisco_get_unit_nuts()` instead.

# Deprecate country

    Code
      df1 <- gisco_get_units("countries", unit = "LU", year = 2016, spatialtype = "LB",
        cache = FALSE)
    Condition
      Warning:
      `gisco_get_units()` was deprecated in giscoR 1.0.0.
      i Please use `gisco_get_unit_country()` instead.

# Deprecate urban audit

    Code
      df1 <- gisco_get_units("urban_audit", unit = "ES001F", year = 2021,
        spatialtype = "LB", cache = FALSE)
    Condition
      Warning:
      `gisco_get_units()` was deprecated in giscoR 1.0.0.
      i Please use `gisco_get_unit_country()` instead.

