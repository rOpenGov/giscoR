#' Check access to GISCO API
#'
#' @family helper
#'
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

  req <- httr2::request("https://gisco-services.ec.europa.eu/distribution/v2/")
  req <- httr2::req_url_path_append(
    req,
    "nuts/geojson/NUTS_LB_2016_4326_LEVL_0.geojson"
  )
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
