test_that("Offline", {
  skip_on_cran()
  skip_if_gisco_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  expect_message(
    n <- gisco_get_education(country = "LU", update_cache = TRUE),
    "Error"
  )
  expect_null(n)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Education uses basic service URLs", {
  urls <- character()
  local_mocked_bindings(
    read_gisco_dataset = function(url,
                                  name,
                                  cache = TRUE,
                                  cache_dir = NULL,
                                  subdir,
                                  update_cache = FALSE,
                                  verbose = FALSE,
                                  ...) {
      urls <<- c(urls, url)
      expect_match(name, "^edu_2023_")
      expect_false(cache)
      expect_identical(cache_dir, "cache")
      expect_identical(subdir, "education")
      expect_true(update_cache)
      expect_true(verbose)
      data.frame(cntr_id = basename(tools::file_path_sans_ext(url)))
    }
  )

  education <- gisco_get_education(
    country = c("LU", "BE"),
    cache = FALSE,
    cache_dir = "cache",
    update_cache = TRUE,
    verbose = TRUE
  )
  expect_identical(
    urls,
    basic_service_url("education", "2023", c("LU", "BE"))
  )
  expect_identical(education$cntr_id, c("LU", "BE"))
})

test_that("Basic service helpers build URLs and file names", {
  url <- basic_service_url("healthcare", "2020")
  expect_identical(
    url,
    paste0(gisco_pub_url(), "healthcare/2020/gpkg/EU.gpkg")
  )
  expect_identical(
    basic_service_filename("health", "2020", url),
    "health_2020_EU.gpkg"
  )
})

test_that("Education online", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_education(country = "LU", cache = FALSE))
  expect_silent(gisco_get_education(country = "Denmark"))
  expect_message(gisco_get_education(verbose = TRUE, country = "BE"))

  # Several countries
  nn <- gisco_get_education(country = c("LU", "DK", "BE"))

  expect_length(unique(nn$cntr_id), 3)
  expect_s3_class(nn, "sf")
  expect_s3_class(nn, "tbl_df")

  # Full
  eufull <- gisco_get_education()
  expect_s3_class(eufull, "sf")
  expect_s3_class(eufull, "tbl_df")

  expect_gt(length(unique(eufull$cntr_id)), 10)
})

test_that("Education online 2020", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_silent(gisco_get_education(country = "LU", cache = FALSE, year = 2020))
  expect_silent(gisco_get_education(country = "Denmark", year = 2020))
  expect_message(gisco_get_education(
    verbose = TRUE,
    country = "BE",
    year = 2020
  ))

  # Several countries
  nn <- gisco_get_education(country = c("LU", "DK", "BE"), year = 2020)

  expect_length(unique(nn$cntr_id), 3)
  expect_s3_class(nn, "sf")
  expect_s3_class(nn, "tbl_df")
})
