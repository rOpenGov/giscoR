test_that("offline", {
  skip_on_cran()
  skip_if_gisco_offline()
  db <- gisco_get_latest_db()

  options(giscoR_test_offline = TRUE)
  expect_message(
    n <- gisco_get_lau(update_cache = TRUE, year = 2020),
    "Error"
  )
  expect_null(n)

  options(giscoR_test_offline = FALSE)
})

test_that("LAU Errors", {
  expect_error(gisco_get_lau(year = "2001"))
  expect_error(gisco_get_lau(epsg = "9999"))
})


test_that("LAU online", {
  skip_on_cran()
  skip_if_gisco_offline()

  all <- expect_silent(gisco_get_lau(year = 2024))
  li_and_es <- expect_silent(gisco_get_lau(
    year = 2024,
    country = "LI",
    gisco_id = "ES_12016"
  ))

  expect_true(nrow(all) > 1000 * nrow(li_and_es))

  cntry <- sort(unique(li_and_es$CNTR_CODE))
  cntry <- as.character(cntry)
  expect_length(cntry, 2)
  expect_equal(cntry, c("ES", "LI"))

  expect_true(
    nrow(
      li_and_es[li_and_es$CNTR_CODE == "ES", ]
    ) ==
      1
  )

  expect_true(
    nrow(
      li_and_es[li_and_es$CNTR_CODE == "LI", ]
    ) >
      5
  )
})

test_that("Deprecations", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_snapshot(
    s <- gisco_get_lau(
      year = 2024,
      cache = TRUE,
      gisco_id = "ES_12016"
    )
  )
})
