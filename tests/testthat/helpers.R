skip_if_gisco_offline <- function() {
  if (gisco_check_access()) {
    return(invisible(TRUE))
  }

  testthat::skip("GISCO API not reachable")

  invisible()
}
