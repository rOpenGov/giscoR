test_that("LAU offline", {
  expect_error(gisco_get_lau(year = "2001"))
  expect_error(gisco_get_lau(epsg = "9999"))
})


test_that("LAU online", {
  skip_if_gisco_offline()
  skip_on_cran()

  all <- expect_silent(gisco_get_lau(year = 2020))
  li_and_es <- expect_silent(gisco_get_lau(
    year = 2020,
    country = "LI",
    gisco_id = "ES_12016"
  ))

  expect_true(nrow(all) > 1000 * nrow(li_and_es))

  cntry <- sort(unique(li_and_es$CNTR_CODE))
  expect_length(cntry, 2)
  expect_equal(cntry, c("ES", "LI"))

  expect_true(nrow(
    li_and_es[li_and_es$CNTR_CODE == "ES", ]
  ) == 1)

  expect_true(nrow(
    li_and_es[li_and_es$CNTR_CODE == "LI", ]
  ) > 5)
})
