#' Create the httr2 request cache directory
#'
#' @return A character string with the request cache directory.
#' @noRd
gisco_request_cache_dir <- function() {
  create_cache_dir(file.path(tempdir(), "giscoR", "cache_request"))
}

#' Build a GISCO httr2 request with common options
#'
#' @param url A character string with the request URL.
#' @param verbose A logical value indicating whether to show progress.
#' @param cache A logical value indicating whether to cache the request.
#' @param retry A logical value indicating whether to retry the request.
#' @param progress A logical value indicating whether to show progress.
#'
#' @return An `httr2_request` object.
#' @noRd
gisco_request <- function(
  url,
  verbose = FALSE,
  cache = TRUE,
  retry = TRUE,
  progress = verbose
) {
  req <- httr2::request(url)
  req <- httr2::req_error(req, is_error = function(x) {
    FALSE
  })
  req <- httr2::req_timeout(req, getOption("gisco_timeout", 300L))

  if (cache) {
    req <- httr2::req_cache(
      req,
      gisco_request_cache_dir(),
      max_size = 1024^3 / 2,
      max_age = 3600
    )
  }
  if (retry) {
    req <- httr2::req_retry(req, max_tries = 3)
  }
  if (progress) {
    req <- httr2::req_progress(req)
  }

  req
}

#' Apply the test 404 redirect to a request
#'
#' @param req An `httr2_request` object.
#'
#' @return An `httr2_request` object.
#' @noRd
gisco_request_fake_404 <- function(req) {
  if (!is_404()) {
    return(req)
  }

  httr2::req_url(
    req,
    paste0(gisco_distribution_url(), "fake")
  )
}

#' Handle an HTTP error response
#'
#' @param resp An `httr2_response` object.
#' @param url A character string with the request URL.
#' @param file_local Optional path to remove after a failed download.
#' @param verbose A logical value indicating whether to print messages.
#'
#' @return `TRUE` when `resp` is an error, otherwise `FALSE`.
#' @noRd
gisco_response_is_error <- function(
  resp,
  url,
  file_local = NULL,
  verbose = TRUE
) {
  if (!httr2::resp_is_error(resp)) {
    return(FALSE)
  }

  if (!is.null(file_local)) {
    unlink(file_local, force = TRUE)
  }
  if (!verbose) {
    return(TRUE)
  }

  get_status_code <- httr2::resp_status(resp) # nolint
  get_status_desc <- httr2::resp_status_desc(resp) # nolint

  cli::cli_alert_danger(c(
    "{.strong Error {get_status_code}} ({get_status_desc}): ",
    "{.url {url}}."
  ))
  cli::cli_alert_warning(c(
    "If this looks like a bug, please open an issue at ",
    "{.url https://github.com/ropengov/giscoR/issues}."
  ))
  cli::cli_alert("Returning {.val NULL}.")
  TRUE
}

#' Perform a GISCO request
#'
#' @param req An `httr2_request` object.
#' @param url A character string with the original request URL.
#' @param path Optional file path for downloads.
#' @param error_file Optional file path to remove after a failed download.
#' @param error_verbose A logical value indicating whether to print HTTP error
#'   messages.
#' @param offline_verbose A logical value indicating whether to print offline
#'   messages.
#' @param check_online A logical value indicating whether to check network
#'   availability before performing the request.
#' @param fake_404 A logical value indicating whether to apply the test 404
#'   redirect.
#' @param check_error A logical value indicating whether HTTP error responses
#'   should return `NULL`.
#'
#' @return An `httr2_response` object, or `NULL` for offline or error
#'   responses.
#' @noRd
gisco_perform_request <- function(
  req,
  url,
  path = NULL,
  error_file = path,
  error_verbose = TRUE,
  offline_verbose = TRUE,
  check_online = TRUE,
  fake_404 = TRUE,
  check_error = TRUE
) {
  if (check_online && !is_online_fun()) {
    if (offline_verbose) {
      cli::cli_alert_danger("No internet connection available.")
      cli::cli_alert("Returning {.val NULL}.")
    }
    return(NULL)
  }

  if (fake_404) {
    req <- gisco_request_fake_404(req)
  }

  if (is.null(path)) {
    resp <- httr2::req_perform(req)
  } else {
    resp <- httr2::req_perform(req, path = path)
  }

  if (
    check_error &&
      gisco_response_is_error(resp, url, error_file, verbose = error_verbose)
  ) {
    return(NULL)
  }
  resp
}

#' Call a GISCO JSON API endpoint
#'
#' @param custom_query A named list with query arguments.
#' @param apiurl The API endpoint URL.
#' @param result_field A character string with the JSON field to extract.
#' @param verbose A logical value indicating whether to print verbose output.
#'
#' @return A tibble, or `NULL` when the endpoint cannot be reached.
#' @noRd
call_gisco_json_api <- function(
  custom_query,
  apiurl,
  result_field,
  verbose = FALSE
) {
  clean_q <- unlist(custom_query)
  url <- httr2::url_modify(apiurl, query = as.list(clean_q))

  resp <- get_request_body(url, verbose)
  if (is.null(resp)) {
    return(NULL)
  }

  resp_json <- httr2::resp_body_json(resp, simplifyVector = TRUE)
  tibble::as_tibble(resp_json[[result_field]])
}
