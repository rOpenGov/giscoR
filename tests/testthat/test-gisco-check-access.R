test_that("Access checks report GISCO availability", {
  withr::local_envvar(NOT_CRAN = "true")
  withr::local_options(gisco_timeout = 300)
  local_mocked_bindings(gisco_req_perform = function(req, ...) {
    expect_equal(req$options$timeout_ms, 10000)
    httr2::response(200, url = httr2::req_get_url(req))
  })

  expect_true(gisco_check_access())
})

test_that("Access checks report GISCO connection failures", {
  withr::local_envvar(NOT_CRAN = "true")
  local_mocked_bindings(gisco_req_perform = mock_connection_failure)

  expect_false(gisco_check_access())
})

test_that("CRAN environment is detected from NOT_CRAN", {
  withr::local_envvar(NOT_CRAN = NA)

  expect_equal(on_cran(), !interactive())

  withr::local_envvar(NOT_CRAN = "false")

  expect_true(on_cran())
  expect_false(gisco_check_access())

  withr::local_envvar(NOT_CRAN = "true")

  expect_false(on_cran())
})
