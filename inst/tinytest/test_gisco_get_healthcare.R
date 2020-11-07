library(tinytest)


if (gisco_check_access()) {
expect_silent(gisco_get_healthcare())
expect_message(gisco_get_healthcare(verbose = TRUE))
}
