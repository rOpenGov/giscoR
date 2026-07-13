# Census returns NULL for 404 responses

    Code
      n <- gisco_get_census(update_cache = TRUE, spatialtype = "PT")
    Message
      Error

# Census reads point geometries

    Code
      gisco_get_census(year = 2020)
    Condition
      Error:
      ! `year` must be "2011", not "2020".

# Census reads polygon geometries

    Code
      all <- gisco_get_census(spatialtype = "RG")
    Message
      Mocked census polygon read.

