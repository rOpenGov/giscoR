# Test only in dev version - i.e. PKG version with 4 digits

home <- length(unclass(packageVersion("giscoR"))[[1]]) == 4

if (home) {
  expect_silent(gisco_bulk_download(resolution = 60))
  expect_message(gisco_bulk_download(resolution = 60, verbose = TRUE))
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    ext = "json"
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    ext = "shp"
  ))
  expect_message(gisco_bulk_download(
    resolution = 60,
    verbose = TRUE,
    ext = "shp"
  ))
  expect_silent(gisco_bulk_download(resolution = 60, update_cache = TRUE))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    ext = "shp",
    recursive = TRUE
  ))
  expect_silent(gisco_bulk_download(
    resolution = 60,
    ext = "shp",
    recursive = FALSE
  ))
  expect_silent(gisco_bulk_download(
    id_giscoR = "countries",
    verbose = TRUE,
    resolution = 60
  ))

  expect_silent(gisco_get_coastallines(resolution = "60"))
  expect_silent(gisco_get_coastallines(resolution = 3))
  expect_message(gisco_get_coastallines(resolution = "60", verbose = TRUE))
  expect_silent(gisco_get_coastallines(
    resolution = "60",
    verbose = TRUE,
    update_cache = TRUE
  ))
  cachetest <- paste0(tempdir(), "/coast")
  expect_silent(gisco_get_coastallines(
    resolution = "60",
    cache_dir = cachetest
  ))

  a <- gisco_get_coastallines(resolution = "60", epsg = "3035")
  b <- gisco_get_coastallines(resolution = "60", epsg = "3857")
  c <- gisco_get_coastallines(resolution = "60", epsg = "4326")

  epsg3035 <- sf::st_crs(3035)
  epsg3857 <- sf::st_crs(3857)
  epsg4326 <- sf::st_crs(4326)

  expect_equal(epsg3035, sf::st_crs(a))
  expect_equal(epsg3857, sf::st_crs(b))
  expect_equal(epsg4326, sf::st_crs(c))

  expect_silent(gisco_get_communes(spatialtype = "COASTL"))
  expect_silent(gisco_get_communes(spatialtype = "LB", country = "LU"))
  expect_silent(gisco_get_communes(spatialtype = "COASTL"))


  expect_silent(gisco_get_countries(
    spatialtype = "LB",
    country = c("Spain", "Italia")
  ))

  expect_silent(gisco_get_countries(
    spatialtype = "COASTL",
    country = c("ESP", "ITA")
  ))

  expect_silent(gisco_get_countries(
    resolution = "10",
    country = c("ESP", "ITA")
  ))

  expect_silent(gisco_get_countries(resolution = 60, country = c("ES", "IT")))
  expect_silent(gisco_get_countries(spatialtype = "COASTL", resolution = "60"))

  expect_silent(gisco_get_countries(resolution = "60", country = "DNK"))

  expect_silent(gisco_get_countries(spatialtype = "COASTL", resolution = 3))
  expect_silent(gisco_get_countries(
    spatialtype = "COASTL",
    resolution = "60",
    update_cache = TRUE
  ))


  expect_silent(gisco_get_countries(
    year = "2013",
    resolution = "60",
    spatialtype = "RG"
  ))

  expect_silent(gisco_get_grid(100))
  expect_silent(gisco_get_grid(100, verbose = TRUE))
  expect_message(gisco_get_grid(100, spatialtype = "POINT", verbose = TRUE))

  expect_silent(gisco_get_healthcare())
  expect_message(gisco_get_healthcare(verbose = TRUE))


  expect_silent(gisco_get_nuts(spatialtype = "LB"))
  expect_silent(gisco_get_nuts(resolution = "60", nuts_level = "0"))
  expect_silent(
    gisco_get_nuts(
      resolution = "60",
      nuts_level = "0",
      update_cache = TRUE,
      verbose = TRUE
    )
  )
  expect_silent(gisco_get_nuts(
    resolution = "60",
    nuts_level = "0",
    nuts_id = "ES5"
  ))

  expect_silent(gisco_get_nuts(
    resolution = "60",
    nuts_id = "ES5",
    spatialtype = "LB"
  ))

  expect_silent(gisco_get_nuts(
    resolution = "60",
    nuts_id = "ES5",
    spatialtype = "BN"
  ))
  expect_silent(gisco_get_nuts(resolution = "60", country = c("ITA", "POL")))

  a <- gisco_get_nuts(resolution = "60", epsg = "3035")
  b <- gisco_get_nuts(resolution = "60", epsg = "3857")
  c <- gisco_get_nuts(resolution = "60", epsg = "4326")

  epsg3035 <- sf::st_crs(3035)
  epsg3857 <- sf::st_crs(3857)
  epsg4326 <- sf::st_crs(4326)

  expect_equal(epsg3035, sf::st_crs(a))
  expect_equal(epsg3857, sf::st_crs(b))
  expect_equal(epsg4326, sf::st_crs(c))

  expect_silent(gisco_get_units(
    year = "2001",
    id_giscoR = "countries",
    unit = "ES"
  ))
  expect_silent(gisco_get_units(
    id_giscoR = "countries",
    unit = "Spain",
    spatialtype = "LB"
  ))

  expect_silent(gisco_get_units(
    id_giscoR = "countries",
    unit = "ESP"
  ))

  expect_silent(
    gisco_get_units(
      year = "2001",
      id_giscoR = "countries",
      mode = "df",
      unit = "ES",
      spatialtype = "LB"
    )
  )
  expect_error(
    gisco_get_units(
      year = "2001",
      id_giscoR = "countries",
      unit = "Spain",
      resolution = "60"
    )
  )
  expect_silent(gisco_get_units(id_giscoR = "nuts", unit = "ES"))
  expect_silent(gisco_get_units(
    id_giscoR = "nuts",
    year = 2016,
    unit = "PT",
    update_cache = TRUE
  ))
  r <-
    gisco_get_units(
      id_giscoR = "nuts",
      unit = c("FR", "ES", "xt", "PT")
    )
  expect_true(nrow(r) == 3)
  expect_message(gisco_get_units(
    id_giscoR = "nuts",
    unit = c("FR", "ES", "xt", "PT")
  ))
  expect_message(gisco_get_units(verbose = TRUE))
  df <- gisco_get_units(mode = "df")
  expect_true(class(df) == "data.frame")
  sf <-
    gisco_get_units(
      id_giscoR = "urban_audit",
      year = "2020",
      unit = "ES002L2"
    )
  expect_true(class(sf)[1] == "sf")
  expect_silent(gisco_get_units(unit = c("ES1", "ES345", "FFRE3")))
  expect_silent(gisco_get_units(
    id_giscoR = "urban_audit",
    year = "2004",
    mode = "df"
  ))
  expect_silent(gisco_get_units(
    id_giscoR = "urban_audit",
    year = "2014",
    mode = "df",
    verbose = TRUE
  ))
  expect_silent(gisco_get_units(
    id_giscoR = "countries",
    year = "2001",
    mode = "df"
  ))

  expect_silent(gisco_get_units(
    id_giscoR = "nuts",
    year = "2016",
    update_cache = TRUE,
    unit = "ES"
  ))

  expect_silent(gisco_get_units(
    id_giscoR = "countries",
    year = "2016",
    verbose = TRUE,
    unit = c("DK", "ES")
  ))

  expect_error(gisco_get_units(
    id_giscoR = "nuts",
    year = "2016",
    verbose = TRUE,
    unit = c("XXXXX")
  ))

  expect_silent(gisco_get_units(
    id_giscoR = "countries",
    year = 2016,
    mode = "df"
  ))
  expect_silent(gisco_get_units(
    id_giscoR = "urban_audit",
    year = 2018,
    mode = "df"
  ))

  expect_silent(gisco_get_urban_audit(level = "GREATER_CITIES"))
  expect_silent(gisco_get_urban_audit(
    spatialtype = "LB",
    level = "GREATER_CITIES"
  ))

  expect_silent(
    gisco_get_urban_audit(
      level = "GREATER_CITIES",
      spatialtype = "LB",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )

  expect_silent(
    gisco_get_urban_audit(
      year = 2014,
      spatialtype = "LB",
      level = "GREATER_CITIES",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )

  expect_silent(gisco_get_urban_audit(
    year = 2018,
    epsg = 3857,
    level = "GREATER_CITIES",
    country = c("ITA", "POL")
  ))

  expect_silent(
    gisco_get_urban_audit(
      year = 2018,
      spatialtype = "LB",
      epsg = 3857,
      country = c("ITA", "POL"),
      verbose = TRUE
    )
  )

  expect_silent(
    gisco_get_urban_audit(
      year = 2020,
      spatialtype = "LB",
      level = "GREATER_CITIES",
      epsg = 3857,
      country = c("ITA", "POL")
    )
  )
}
