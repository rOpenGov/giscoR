.gisco_test_cache_dir <- withr::local_tempdir(
  pattern = "giscoR-test-cache-",
  .local_envir = testthat::teardown_env()
)
withr::local_envvar(
  GISCO_CACHE_DIR = .gisco_test_cache_dir,
  .local_envir = testthat::teardown_env()
)
