library(tinytest)


if (gisco_check_access()) {
  expect_silent(gisco_get_healthcare())
}
