test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_get_countries(
      update_cache = TRUE,
      resolution = 60
    ),
    "Error"
  )
  expect_null(n)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Cached dataset vs updated", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testcountry")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )
  expect_snapshot(db_cached <- gisco_get_countries(verbose = TRUE))

  # Force download

  db_cached2 <- gisco_get_countries(
    update_cache = TRUE,
    cache_dir = cdir
  )

  expect_s3_class(db_cached, "sf")
  expect_s3_class(db_cached, "tbl_df")

  expect_identical(
    list.files(cdir, recursive = TRUE),
    "countries/CNTR_RG_20M_2024_4326.gpkg"
  )

  # Cleanup
  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Cache vs non-cached", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testcountry")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )
  expect_message(
    db_online <- gisco_get_countries(
      resolution = "60",
      cache = FALSE,
      verbose = TRUE,
      cache_dir = cdir
    ),
    "Reading from"
  )

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  # vs cache TRUE
  expect_silent(
    db_cached <- gisco_get_countries(
      resolution = "60",
      cache = TRUE,
      cache_dir = cdir
    )
  )

  expect_identical(db_online, db_cached)
  expect_s3_class(db_online, "sf")
  expect_s3_class(db_online, "tbl_df")
  expect_identical(
    list.files(cdir, recursive = TRUE),
    "countries/CNTR_RG_60M_2024_4326.gpkg"
  )

  # shp is always cached
  expect_length(list.files(cdir, recursive = TRUE, pattern = "shp"), 0)

  f <- gisco_get_countries(
    resolution = 60,
    cache_dir = cdir,
    ext = "shp",
    cache = FALSE
  )
  expect_length(list.files(cdir, recursive = TRUE, pattern = "shp"), 1)

  # Cleanup
  unlink(cdir, recursive = TRUE, force = TRUE)
})
test_that("Filter countries", {
  skip_on_cran()
  skip_if_gisco_offline()

  db_cached <- gisco_get_countries(region = "Africa")
  db_cached2 <- gisco_get_countries(update_cache = TRUE, region = "Africa")
  expect_lt(nrow(db_cached), 70)
  expect_s3_class(db_cached, "sf")
  expect_s3_class(db_cached, "tbl_df")

  # See EU
  db_cached_eu <- gisco_get_countries(update_cache = TRUE, region = "EU")
  expect_identical(nrow(db_cached_eu), 27L)

  # Combine
  db_cached_full <- gisco_get_countries(
    resolution = "60",
    region = c("EU", "Africa")
  )
  expect_identical(nrow(db_cached) + nrow(db_cached_eu), nrow(db_cached_full))

  # Combine with cnt
  db_cached_full <- gisco_get_countries(
    resolution = "60",
    country = c("Spain", "Angola", "Japan"),
    region = c("EU", "Africa")
  )
  expect_identical(nrow(db_cached_full), 2L)
  expect_identical(
    db_cached_full$ISO3_CODE,
    convert_country_code(c("Angola", "Spain"), "iso3c")
  )

  db_cnts <- gisco_get_countries(
    resolution = "60",
    verbose = TRUE,
    country = c("Spain", "Angola", "Japan")
  )
  expect_identical(nrow(db_cnts), 3L)
  expect_identical(
    sort(db_cnts$CNTR_ID),
    sort(convert_country_code(c("Angola", "Spain", "Japan")))
  )
})

test_that("Filter countries no cached", {
  skip_on_cran()
  skip_if_gisco_offline()

  db_cached <- gisco_get_countries(region = "Africa")
  db_no_cache <- gisco_get_countries(
    region = "Africa",
    cache = FALSE
  )
  expect_lt(nrow(db_cached), 70)
  expect_s3_class(db_cached, "sf")
  expect_s3_class(db_cached, "tbl_df")

  # See EU
  db_cached_eu <- gisco_get_countries(
    region = "EU",
    cache = FALSE
  )
  expect_identical(nrow(db_cached_eu), 27L)

  # Combine
  db_cached_full <- gisco_get_countries(
    resolution = "60",
    cache = FALSE,
    region = c("EU", "Africa")
  )
  expect_identical(nrow(db_cached) + nrow(db_cached_eu), nrow(db_cached_full))

  # Combine with cnt
  db_cached_full <- gisco_get_countries(
    resolution = "60",
    country = c("Spain", "Angola", "Japan"),
    region = c("EU", "Africa"),
    cache = FALSE
  )
  expect_identical(nrow(db_cached_full), 2L)
  expect_identical(
    db_cached_full$ISO3_CODE,
    convert_country_code(c("Angola", "Spain"), "iso3c")
  )

  db_cnts <- gisco_get_countries(
    resolution = "60",
    cache = FALSE,
    country = c("Spain", "Angola", "Japan")
  )
  expect_identical(nrow(db_cnts), 3L)
  expect_identical(
    sort(db_cnts$CNTR_ID),
    sort(convert_country_code(c("Angola", "Spain", "Japan")))
  )

  # No filters
  bn <- gisco_get_countries(spatialtype = "COASTL", resolution = "60")
  bn_nocach <- gisco_get_countries(
    spatialtype = "COASTL",
    cache = FALSE,
    country = "AN ERROR",
    resolution = "60"
  )

  expect_identical(nrow(bn), nrow(bn_nocach))
})


test_that("Spatial types", {
  skip_on_cran()
  skip_if_gisco_offline()

  # LB
  lb <- gisco_get_countries(spatialtype = "LB")
  expect_true(unique(sf::st_geometry_type(lb)) == "POINT") # Can filter
  expect_true("CNTR_ID" %in% names(lb))
  lb_filter <- gisco_get_countries(spatialtype = "LB", country = "ESP")
  expect_identical(lb_filter$CNTR_ID, "ES")

  # BN
  bn <- gisco_get_countries(spatialtype = "BN", resolution = "60")
  expect_true(unique(sf::st_geometry_type(bn)) == "MULTILINESTRING")
  # No filter
  expect_false("CNTR_ID" %in% names(bn))
  expect_identical(
    bn,
    gisco_get_countries(spatialtype = "BN", resolution = "60", country = "ES")
  )

  # COASTL
  bn <- gisco_get_countries(spatialtype = "COASTL", resolution = "60")
  expect_true(unique(sf::st_geometry_type(bn)) == "MULTILINESTRING")
  # No filter
  expect_false("CNTR_ID" %in% names(bn))
  expect_identical(
    bn,
    gisco_get_countries(
      spatialtype = "COASTL",
      resolution = "60",
      country = "ES"
    )
  )
  # INLAND
  bn <- gisco_get_countries(spatialtype = "INLAND", resolution = "60")
  expect_true(unique(sf::st_geometry_type(bn)) == "MULTILINESTRING")
  # No filter
  expect_false("CNTR_ID" %in% names(bn))
  expect_identical(
    bn,
    gisco_get_countries(
      spatialtype = "INLAND",
      resolution = "60",
      country = "ES"
    )
  )
})

test_that("Extensions", {
  skip_on_cran()
  skip_if_gisco_offline()

  # Error
  expect_snapshot(
    gisco_get_countries(ext = "docx"),
    error = TRUE
  )

  cdir <- file.path(tempdir(), "testcountry")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  db_geojson <- gisco_get_countries(
    resolution = "60",
    cache_dir = cdir,
    ext = "geojson"
  )
  expect_s3_class(db_geojson, "sf")
  expect_s3_class(db_geojson, "tbl_df")

  expect_length(
    list.files(cdir, recursive = TRUE, pattern = "geojson"),
    1
  )

  db_zip <- gisco_get_countries(
    resolution = "60",
    cache_dir = cdir,
    verbose = TRUE,
    ext = "shp"
  )

  expect_s3_class(db_zip, "sf")
  expect_s3_class(db_zip, "tbl_df")

  expect_length(
    list.files(cdir, recursive = TRUE, pattern = "shp.zip"),
    1
  )

  # Cleanup
  unlink(cdir, recursive = TRUE, force = TRUE)
})
