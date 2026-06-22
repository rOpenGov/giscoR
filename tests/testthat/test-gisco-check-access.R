test_that("Access", {
  skip_on_cran()
  skip_if_gisco_offline()

  expect_true(gisco_check_access())

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_false(gisco_check_access())
})

test_that("On CRAN", {
  skip_on_cran()
  skip_if_gisco_offline()

  # Automatically restored when the test exits
  withr::local_envvar(c(NOT_CRAN = "false"))

  expect_true(on_cran())
  expect_false(gisco_check_access())

  withr::local_envvar(c(NOT_CRAN = ""))

  expect_identical(!interactive(), on_cran())
})
