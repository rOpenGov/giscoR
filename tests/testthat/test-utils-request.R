test_that("HTTP settings can be controlled with environment variables", {
  withr::local_options(gisco_timeout = NULL)
  withr::local_envvar(GISCO_TIMEOUT = "600")

  expect_equal(gisco_timeout(), 600)

  withr::local_envvar(GISCO_TIMEOUT = NA)
  expect_equal(gisco_timeout(), 300L)

  withr::local_envvar(GISCO_TIMEOUT = "invalid")
  expect_equal(gisco_timeout(), 300L)
})

test_that("HTTP options take precedence over environment variables", {
  withr::local_options(gisco_timeout = 30)
  withr::local_envvar(GISCO_TIMEOUT = "600")

  expect_equal(gisco_timeout(), 30)
})

test_that("HTTP setting environment variables are used in requests", {
  withr::local_options(gisco_timeout = NULL)
  withr::local_envvar(GISCO_TIMEOUT = "600")

  req <- gisco_request(
    "https://example.com",
    cache = FALSE,
    retry = FALSE
  )

  expect_equal(req$options$timeout_ms, 600000)
})
