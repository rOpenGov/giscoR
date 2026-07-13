# Ports return NULL for 404 responses

    Code
      n <- gisco_get_ports(update_cache = TRUE)
    Message
      x Error 404 (Not Found): <https://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/PORT_2013_SH.zip>.
      ! If this looks like a bug, please open an issue at <https://github.com/ropengov/giscoR/issues>.
      > Returning "NULL".

# Ports download current and legacy point data

    Code
      gisco_get_ports(year = 2020)
    Condition
      Error:
      ! `year` must be "2013" or "2009", not "2020".

---

    Code
      gisco_get_ports(year = 2020, country = "ES")
    Condition
      Error:
      ! `year` must be "2013" or "2009", not "2020".

