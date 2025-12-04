test_that("Test offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_offline = TRUE)
  expect_message(
    n <- gisco_get_nuts(
      update_cache = TRUE,
      cache_dir = tempdir(),
      resolution = 60
    ),
    "Offline"
  )
  expect_null(n)
  options(gisco_test_offline = FALSE)
})
test_that("Test 404", {
  skip_on_cran()
  skip_if_gisco_offline()

  options(gisco_test_404 = TRUE)
  expect_message(
    n <- gisco_get_nuts(
      update_cache = TRUE,
      resolution = 60
    ),
    "Error"
  )
  expect_null(n)
  options(gisco_test_404 = FALSE)
})

test_that("Valid inputs", {
  skip_on_cran()
  skip_if_gisco_offline()

  # validate ext
  expect_snapshot(gisco_get_nuts(ext = "docx"), error = TRUE)

  # validate level
  expect_snapshot(gisco_get_nuts(nuts_level = "docx"), error = TRUE)

  # But rest of levels should work
  all <- gisco_get_nuts(nuts_level = "all")
  l1 <- gisco_get_nuts(nuts_level = "1")
  l2 <- gisco_get_nuts(nuts_level = "2")
  l3 <- gisco_get_nuts(nuts_level = "3")
  expect_identical(
    nrow(all[all$LEVL_CODE == 1, ]),
    nrow(l1)
  )

  expect_identical(
    nrow(all[all$LEVL_CODE == 2, ]),
    nrow(l2)
  )

  expect_identical(
    nrow(all[all$LEVL_CODE == 3, ]),
    nrow(l3)
  )
})

test_that("Cached dataset vs updated", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testnuts")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )
  expect_snapshot(db_cached <- gisco_get_nuts(verbose = TRUE, nuts_id = "ES51"))

  # In some levels should also filter from cache
  db_cached_l1 <- gisco_get_nuts(nuts_level = 1)
  db_cached_l2 <- gisco_get_nuts(nuts_level = 2)
  db_cached_l3 <- gisco_get_nuts(nuts_level = 3)
  expect_true(
    all(db_cached_l1$LEVL_CODE == 1)
  )
  expect_true(
    all(db_cached_l2$LEVL_CODE == 2)
  )

  expect_true(
    all(db_cached_l3$LEVL_CODE == 3)
  )
  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )
  # Force download

  db_cached2 <- gisco_get_nuts(
    update_cache = TRUE,
    cache_dir = cdir,
    nuts_id = "ES51"
  )

  expect_s3_class(db_cached2, "sf")
  expect_s3_class(db_cached2, "tbl_df")

  expect_identical(
    list.files(cdir, recursive = TRUE),
    "nuts/NUTS_RG_20M_2024_4326.gpkg"
  )

  expect_identical(db_cached$NUTS_ID, db_cached2$NUTS_ID)
  expect_true("geo" %in% names(db_cached))
  expect_true("geo" %in% names(db_cached2))
  # Cleanup
  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Cache vs non-cached", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testnuts")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )
  expect_message(
    db_online <- gisco_get_nuts(
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
    db_cached <- gisco_get_nuts(
      resolution = "60",
      cache = TRUE,
      cache_dir = cdir
    )
  )

  expect_identical(db_online[1:10, ], db_cached[1:10, ])
  expect_s3_class(db_online, "sf")
  expect_s3_class(db_online, "tbl_df")
  expect_identical(
    list.files(cdir, recursive = TRUE),
    "nuts/NUTS_RG_60M_2024_4326.gpkg"
  )

  # shp is always cached
  expect_length(list.files(cdir, recursive = TRUE, pattern = "shp"), 0)

  f <- gisco_get_nuts(
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

  db_cached <- gisco_get_nuts(country = "Spain", nuts_level = 2)
  db_cached2 <- gisco_get_nuts(
    update_cache = TRUE,
    country = "Spain",
    nuts_level = 2
  )
  expect_equal(nrow(db_cached), 19)
  expect_s3_class(db_cached, "sf")
  expect_s3_class(db_cached, "tbl_df")

  # See with unit
  db_cached_eu <- gisco_get_nuts(
    update_cache = TRUE,
    nuts_level = 3,
    nuts_id = "ES511"
  )
  expect_equal(nrow(db_cached_eu), 1)

  # Combine
  db_cached_full <- gisco_get_nuts(
    resolution = "60",
    nuts_level = "all",
    nuts_id = "ES511"
  )
  expect_identical(nrow(db_cached_full), nrow(db_cached_eu))

  # Combine with cnt
  db_cached_full <- gisco_get_nuts(
    resolution = "60",
    country = c("Spain", "France"),
    nuts_id = "ES511"
  )
  expect_identical(nrow(db_cached_full), 1L)
  expect_identical(
    db_cached_full$NUTS_ID,
    "ES511"
  )
})

test_that("Filter countries no cached", {
  skip_on_cran()
  skip_if_gisco_offline()

  db_cached <- gisco_get_nuts(country = "NL", nuts_level = 1)
  db_no_cache <- gisco_get_nuts(
    epsg = 3035,
    resolution = "60",
    country = "NL",
    nuts_level = 1,
    cache = FALSE
  )
  expect_identical(nrow(db_cached), nrow(db_no_cache))
  expect_s3_class(db_no_cache, "sf")
  expect_s3_class(db_no_cache, "tbl_df")

  # No filters
  bn <- gisco_get_nuts(spatialtype = "BN", resolution = "60")
  bn_nocach <- gisco_get_nuts(
    spatialtype = "BN",
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
  lb <- gisco_get_nuts(spatialtype = "LB")
  expect_true(unique(sf::st_geometry_type(lb)) == "POINT") # Can filter
  expect_true("CNTR_CODE" %in% names(lb))
  lb_filter <- gisco_get_nuts(spatialtype = "LB", country = "ESP")
  expect_true(all(lb_filter$CNTR_CODE == "ES"))

  # BN
  bn <- gisco_get_nuts(spatialtype = "BN", resolution = "60")
  expect_true(unique(sf::st_geometry_type(bn)) == "MULTILINESTRING")
  # No filter
  expect_false("CNTR_CODE" %in% names(bn))
  expect_identical(
    bn,
    gisco_get_nuts(spatialtype = "BN", resolution = "60", country = "ES")
  )
})

test_that("Extensions", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- file.path(tempdir(), "testnuts")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_identical(
    list.files(cdir, recursive = TRUE),
    character(0)
  )

  db_geojson <- gisco_get_nuts(
    resolution = "60",
    cache_dir = cdir,
    nuts_level = 0,
    ext = "geojson"
  )
  expect_s3_class(db_geojson, "sf")
  expect_s3_class(db_geojson, "tbl_df")

  expect_length(
    list.files(cdir, recursive = TRUE, pattern = "geojson"),
    1
  )

  db_zip <- gisco_get_nuts(
    resolution = "60",
    nuts_level = 0,
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
