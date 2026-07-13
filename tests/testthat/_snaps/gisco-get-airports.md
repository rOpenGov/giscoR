# Airports return NULL for 404 responses

    Code
      n <- gisco_get_airports(update_cache = TRUE)
    Message
      x Error 404 (Not Found): <https://ec.europa.eu/eurostat/documents/d/gisco/airp-pt-2024-sh>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# Airports download current and legacy point data

    Code
      gisco_get_airports(year = 2020)
    Condition
      Error:
      ! `year` must be "2024", "2013", or "2006", not "2020".

