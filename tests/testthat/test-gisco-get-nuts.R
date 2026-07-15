test_that("NUTS return NULL when offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_test_cached_db("nuts-db-")

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })
  cdir <- local_test_cache_dir("testnuts-offline-")
  expect_snapshot(
    n <- gisco_get_nuts(update_cache = TRUE, cache_dir = cdir, resolution = 60)
  )
  expect_null(n)
})
test_that("NUTS return NULL for 404 responses", {
  skip_on_cran()
  skip_if_gisco_offline()
  local_test_cached_db("nuts-db-")

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_snapshot(n <- gisco_get_nuts(update_cache = TRUE, resolution = 60))
  expect_null(n)
})

test_that("NUTS use resolved GISCO files", {
  local_mocked_bindings(
    resolve_gisco_file = function(...) {
      list(
        url = "https://example.com/NUTS_RG_60M_2024_4326.gpkg",
        name = "NUTS_RG_60M_2024_4326.gpkg"
      )
    },
    read_gisco_dataset = function(url,
                                  name,
                                  cache = TRUE,
                                  cache_dir = NULL,
                                  subdir,
                                  update_cache = FALSE,
                                  verbose = FALSE,
                                  filters = NULL,
                                  post_process = NULL,
                                  ...) {
      expect_match(url, "NUTS_RG_60M_2024_4326[.]gpkg$")
      expect_identical(name, "NUTS_RG_60M_2024_4326.gpkg")
      expect_false(cache)
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "nuts")
      expect_true(update_cache)
      expect_true(verbose)
      expect_true(is.function(filters))
      expect_true(is.function(post_process))
      data.frame(
        CNTR_CODE = c("ES", "FR"),
        NUTS_ID = c("ES51", "FR1"),
        LEVL_CODE = c(2, 1)
      )
    }
  )

  nuts <- gisco_get_nuts(
    resolution = 60,
    cache = FALSE,
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(nuts$NUTS_ID, c("ES51", "FR1"))
})

test_that("NUTS validate extensions and level inputs", {
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
  expect_identical(nrow(all[all$LEVL_CODE == 1, ]), nrow(l1))

  expect_identical(nrow(all[all$LEVL_CODE == 2, ]), nrow(l2))

  expect_identical(nrow(all[all$LEVL_CODE == 3, ]), nrow(l3))
})

test_that("NUTS can refresh an existing cached dataset", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("testnuts-")

  expect_identical(list.files(cdir, recursive = TRUE), character(0))
  expect_snapshot(db_cached <- gisco_get_nuts(verbose = TRUE, nuts_id = "ES51"))

  # In some levels should also filter from cache
  db_cached_l1 <- gisco_get_nuts(nuts_level = 1)
  db_cached_l2 <- gisco_get_nuts(nuts_level = 2)
  db_cached_l3 <- gisco_get_nuts(nuts_level = 3)
  expect_true(all(db_cached_l1$LEVL_CODE == 1))
  expect_true(all(db_cached_l2$LEVL_CODE == 2))

  expect_true(all(db_cached_l3$LEVL_CODE == 3))
  expect_identical(list.files(cdir, recursive = TRUE), character(0))
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
})

test_that("NUTS return matching data with and without cache", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("testnuts-")

  expect_identical(list.files(cdir, recursive = TRUE), character(0))
  expect_message(
    db_online <- gisco_get_nuts(
      resolution = "60",
      cache = FALSE,
      verbose = TRUE,
      cache_dir = cdir
    ),
    "Reading from"
  )

  expect_identical(list.files(cdir, recursive = TRUE), character(0))

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
})

test_that("NUTS can be filtered by country and level", {
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
  expect_identical(db_cached_full$NUTS_ID, "ES511")
})

test_that("NUTS filters also work without cache", {
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
test_that("NUTS support boundary and label spatial types", {
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

test_that("NUTS support GeoJSON and zipped shapefile downloads", {
  skip_on_cran()
  skip_if_gisco_offline()

  cdir <- local_test_cache_dir("testnuts-")

  expect_identical(list.files(cdir, recursive = TRUE), character(0))

  db_geojson <- gisco_get_nuts(
    resolution = "60",
    cache_dir = cdir,
    nuts_level = 0,
    ext = "geojson"
  )
  expect_s3_class(db_geojson, "sf")
  expect_s3_class(db_geojson, "tbl_df")

  expect_length(list.files(cdir, recursive = TRUE, pattern = "geojson"), 1)

  db_zip <- gisco_get_nuts(
    resolution = "60",
    nuts_level = 0,
    cache_dir = cdir,
    verbose = TRUE,
    ext = "shp"
  )

  expect_s3_class(db_zip, "sf")
  expect_s3_class(db_zip, "tbl_df")

  expect_length(list.files(cdir, recursive = TRUE, pattern = "shp.zip"), 1)
})
