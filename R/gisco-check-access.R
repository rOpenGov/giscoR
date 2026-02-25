#' Check access to GISCO API
#'
#' @keywords internal
#' @description
#' Check if **R** has access to resources at
#' <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' @return A logical.
#'
#' @examples
#'
#' gisco_check_access()
#' @export
gisco_check_access <- function() {
  if (!httr2::is_online()) {
    return(FALSE) # nocov
  }
  if (on_cran()) {
    return(FALSE)
  }

  req <- httr2::request("https://gisco-services.ec.europa.eu/distribution/v2/")
  req <- httr2::req_url_path_append(req, "themes.json")
  req <- httr2::req_timeout(req, getOption("gisco_timeout", 300L))
  req <- httr2::req_error(req, is_error = function(x) {
    FALSE
  })
  resp <- httr2::req_perform(req)
  if (httr2::resp_is_error(resp)) {
    FALSE # nocov
  } else {
    TRUE
  }
}

#' Skip tests if GISCO API is not reachable
#'
#' @return invisible TRUE or skips the test
#'
#' @noRd
skip_if_gisco_offline <- function() {
  # nocov start
  if (gisco_check_access()) {
    return(invisible(TRUE))
  }

  if (requireNamespace("testthat", quietly = TRUE)) {
    testthat::skip("GISCO API not reachable")
  }
  invisible()
  # nocov end
}


#' Internal function to check if we are on CRAN
#' @return logical
#' @noRd
on_cran <- function() {
  env <- Sys.getenv("NOT_CRAN")
  if (identical(env, "")) {
    !interactive() # nocov
  } else {
    !isTRUE(as.logical(env))
  }
}
