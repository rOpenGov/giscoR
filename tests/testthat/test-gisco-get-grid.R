test_that("Grid validates inputs", {
  expect_error(gisco_get_grid(resolution = 24))
  expect_error(gisco_get_grid(spatialtype = "9999"))
})

test_that("Grids use the grid dataset reader", {
  local_mocked_bindings(
    read_gisco_dataset = function(url,
                                  name,
                                  cache_dir = NULL,
                                  subdir,
                                  update_cache = FALSE,
                                  verbose = FALSE,
                                  ...) {
      expect_match(url, "grid_100km_surf[.]gpkg$")
      expect_identical(name, "grid_100km_surf.gpkg")
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "grid")
      expect_true(update_cache)
      expect_true(verbose)
      data.frame(id = "grid")
    }
  )

  grid <- gisco_get_grid(
    100,
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(grid$id, "grid")
})

test_that("Grids select point files", {
  local_mocked_bindings(
    read_gisco_dataset = function(url, name, ...) {
      expect_match(url, "grid_100km_point[.]gpkg$")
      expect_identical(name, "grid_100km_point.gpkg")
      data.frame(id = "point")
    }
  )

  grid <- gisco_get_grid(100, spatialtype = "POINT")
  expect_identical(grid$id, "point")
})

test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(n <- gisco_get_grid(update_cache = TRUE), "Error")
  expect_null(n)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})
