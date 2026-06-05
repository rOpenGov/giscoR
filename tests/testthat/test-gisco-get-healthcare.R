test_that("Offline", {
  local_mocked_bindings(
    is_404 = function(...) {
      TRUE
    },
    read_gisco_dataset = function(...) {
      message("Error")
      NULL
    }
  )
  expect_message(
    n <- gisco_get_healthcare(update_cache = TRUE, year = 2020),
    "Error"
  )
  expect_null(n)
})

test_that("Healthcare uses the basic service dataset", {
  local_mocked_bindings(
    read_gisco_dataset = function(url,
                                  name,
                                  cache = TRUE,
                                  cache_dir = NULL,
                                  subdir,
                                  update_cache = FALSE,
                                  verbose = FALSE,
                                  post_process = NULL,
                                  ...) {
      expect_identical(url, basic_service_url("healthcare", "2020"))
      expect_identical(name, "health_2020_EU.gpkg")
      expect_false(cache)
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "health")
      expect_true(update_cache)
      expect_true(verbose)
      expect_true(is.function(post_process))

      data <- data.frame(cntr_id = c("LU", "BE"), name = c("a", "b"))
      post_process(data)
    }
  )

  healthcare <- gisco_get_healthcare(
    year = 2020,
    country = "LU",
    cache = FALSE,
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(healthcare$cntr_id, "LU")
})

test_that("Healthcare reads, filters and caches mocked data", {
  cdir <- file.path(tempdir(), "test_health")
  unlink(cdir, force = TRUE, recursive = TRUE)
  expect_false(dir.exists(cdir))
  create_cache_dir(cdir)
  expect_true(dir.exists(cdir))

  local_mocked_bindings(
    read_gisco_dataset = function(url,
                                  name,
                                  cache = TRUE,
                                  cache_dir = NULL,
                                  subdir,
                                  verbose = FALSE,
                                  post_process = NULL,
                                  ...) {
      expect_identical(url, basic_service_url("healthcare", "2023"))
      expect_identical(name, "health_2023_EU.gpkg")
      expect_identical(subdir, "health")
      if (!is.null(cache_dir)) {
        expect_identical(cache_dir, cdir)
      }

      if (cache) {
        create_cache_dir(file.path(cache_dir, subdir))
        file.create(file.path(cache_dir, subdir, name))
      }
      if (verbose) {
        message("Mocked healthcare read.")
      }

      data <- sf::st_as_sf(tibble::tibble(
        cntr_id = c("LU", "ES", "BE", "ES"),
        geometry = sf::st_sfc(
          sf::st_point(c(1, 1)),
          sf::st_point(c(2, 2)),
          sf::st_point(c(3, 3)),
          sf::st_point(c(4, 4)),
          crs = 4326
        )
      ))
      post_process(data)
    }
  )

  # No Cache
  expect_silent(
    n <- gisco_get_healthcare(country = "LU", cache_dir = cdir, cache = FALSE)
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_true(all(n$cntr_id == "LU"))
  expect_length(list.files(cdir, recursive = TRUE), 0)

  # Cache
  expect_silent(
    n <- gisco_get_healthcare(country = "LU", cache = TRUE, cache_dir = cdir)
  )
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_true(all(n$cntr_id == "LU"))
  expect_length(list.files(cdir, recursive = TRUE), 1)

  expect_silent(n <- gisco_get_healthcare(cache_dir = cdir))
  expect_s3_class(n, "sf")
  expect_s3_class(n, "tbl_df")
  expect_silent(
    esp <- gisco_get_healthcare(country = "Spain", cache_dir = cdir)
  )
  expect_lt(nrow(esp), nrow(n))

  expect_message(gisco_get_healthcare(verbose = TRUE))
  unlink(cdir, force = TRUE, recursive = TRUE)
  expect_false(dir.exists(cdir))
})
