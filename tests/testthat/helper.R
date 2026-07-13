skip_if_gisco_offline <- function() {
  if (gisco_check_access()) {
    return(invisible(TRUE))
  }

  testthat::skip("GISCO API not reachable")

  invisible()
}

local_test_cache_dir <- function(
  pattern = "gisco-test-",
  .local_envir = parent.frame()
) {
  path <- withr::local_tempdir(pattern = pattern, .local_envir = .local_envir)
  withr::defer(
    unlink(path, recursive = TRUE, force = TRUE),
    envir = .local_envir
  )
  path
}

local_test_cached_db <- function(pattern = "gisco-db-") {
  local_envir <- parent.frame()
  cache_dir <- local_test_cache_dir(pattern, .local_envir = local_envir)
  withr::local_envvar(
    GISCO_CACHE_DIR = cache_dir,
    .local_envir = local_envir
  )

  saveRDS(giscoR::gisco_db, cached_db_file(cache_dir))
  invisible(cache_dir)
}
