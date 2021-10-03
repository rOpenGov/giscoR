#' Check access to GISCO API
#'
#' @concept helper
#'
#' @description
#' Check if R has access to resources at
#' <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' @return a logical.
#'
#' @examples
#'
#' gisco_check_access()
#' @export
gisco_check_access <- function() {
  url <- paste0(
    "https://gisco-services.ec.europa.eu/",
    "distribution/v2/nuts/geojson/",
    "NUTS_LB_2016_4326_LEVL_0.geojson"
  )
  # nocov start
  access <-
    tryCatch(
      download.file(url, destfile = tempfile(), quiet = TRUE),
      warning = function(e) {
        return(FALSE)
      }
    )

  if (isFALSE(access)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
  # nocov end
}


skip_if_gisco_offline <- function() {
  # nocov start
  if (gisco_check_access()) {
    return(invisible(TRUE))
  }

  if (requireNamespace("testthat", quietly = TRUE)) {
    testthat::skip("GISCO API not reachable")
  }
  return(invisible())
  # nocov end
}