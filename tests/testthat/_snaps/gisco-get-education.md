# Education returns NULL for 404 responses

    Code
      n <- gisco_get_education(country = "LU", update_cache = TRUE)
    Message
      Error

# Education reads mocked 2023 service data

    Code
      gisco_get_education(verbose = TRUE, country = "BE")
    Message
      Mocked education read.
    Output
      Simple feature collection with 1 feature and 1 field
      Geometry type: POINT
      Dimension:     XY
      Bounding box:  xmin: 1 ymin: 1 xmax: 1 ymax: 1
      Geodetic CRS:  WGS 84
      # A tibble: 1 x 2
        cntr_id    geometry
      * <chr>   <POINT [°]>
      1 BE            (1 1)

# Education reads mocked 2020 service data

    Code
      gisco_get_education(verbose = TRUE, country = "BE", year = 2020)
    Message
      Mocked education 2020 read.
    Output
      Simple feature collection with 1 feature and 1 field
      Geometry type: POINT
      Dimension:     XY
      Bounding box:  xmin: 1 ymin: 1 xmax: 1 ymax: 1
      Geodetic CRS:  WGS 84
      # A tibble: 1 x 2
        cntr_id    geometry
      * <chr>   <POINT [°]>
      1 BE            (1 1)

