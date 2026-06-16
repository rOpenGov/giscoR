#' Check access to the GISCO geodata distribution
#'
#' @description
#' Check if \R has access to resources at
#' <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' @keywords internal
#' @encoding UTF-8
#' @return A logical.
#'
#' @examples
#'
#' gisco_check_access()
#' @export
gisco_check_access <- function() {
  if (!is_online_fun()) {
    return(FALSE)
  }
  if (on_cran()) {
    return(FALSE)
  }

  req <- gisco_request(
    gisco_distribution_url(),
    cache = FALSE,
    retry = FALSE
  )
  req <- httr2::req_url_path_append(req, "themes.json")
  resp <- gisco_perform_request(
    req,
    httr2::req_get_url(req),
    error_verbose = FALSE,
    offline_verbose = FALSE,
    check_online = FALSE,
    fake_404 = FALSE
  )

  !is.null(resp)
}

#' Check whether the current session is running on CRAN
#'
#' @return A logical.
#' @noRd
on_cran <- function() {
  env <- Sys.getenv("NOT_CRAN")
  if (identical(env, "")) {
    !interactive()
  } else {
    !isTRUE(as.logical(env))
  }
}
