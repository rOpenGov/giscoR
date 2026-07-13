# Healthcare returns NULL for 404 responses

    Code
      n <- gisco_get_healthcare(update_cache = TRUE, year = 2020)
    Message
      Error

# Healthcare reads, filters and caches mocked data

    Code
      gisco_get_healthcare(verbose = TRUE)
    Message
      Mocked healthcare read.
    Output
      Simple feature collection with 4 features and 1 field
      Geometry type: POINT
      Dimension:     XY
      Bounding box:  xmin: 1 ymin: 1 xmax: 4 ymax: 4
      Geodetic CRS:  WGS 84
      # A tibble: 4 x 2
        cntr_id    geometry
        <chr>   <POINT [°]>
      1 LU            (1 1)
      2 ES            (2 2)
      3 BE            (3 3)
      4 ES            (4 4)

