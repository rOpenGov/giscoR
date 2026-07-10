skip_if_gisco_offline <- function() {
  if (gisco_check_access()) {
    return(invisible(TRUE))
  }

  testthat::skip("GISCO API not reachable")

  invisible()
}

local_test_cache_dir <- function(pattern = "gisco-test-") {
  path <- withr::local_tempdir(pattern = pattern, .local_envir = parent.frame())
  withr::defer(
    unlink(path, recursive = TRUE, force = TRUE),
    envir = parent.frame()
  )
  path
}
