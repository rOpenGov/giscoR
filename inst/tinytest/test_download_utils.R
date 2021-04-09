expect_silent(gisco_check_access())

url <-
  "https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson"
# Error
expect_error(
  giscoR:::gsc_load(
    filename = "NUTS_LB_2016_4326_LEVL_10.geojson",
    api_entry = url,
    epsg = "4326"
  )
)


# Corrupt
expect_error(
  giscoR:::gsc_load(
    filename = "NUTS_LB_2016_4326_LEVL_10.geojson",
    api_entry = url,
    epsg = "4326"
  )
)

# Error
expect_error(
  giscoR:::gsc_load(
    cache = FALSE,
    verbose = TRUE,
    filename = "NUTS_LB_2016_4326_LEVL_10.geojson",
    api_entry = url,
    epsg = "4326"
  )
)

# Error
expect_error(
  giscoR:::gsc_load(
    update_cache =  TRUE,
    filename = "NUTS_LB_2016_4326_LEVL_10.geojson",
    api_entry = url,
    epsg = "4326"
  )
)
