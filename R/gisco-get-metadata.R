#' Get metadata
#'
#' @description
#' Get a table with the names and ids of administrative of statistical units.
#'
#' @family database
#' @seealso
#' [gisco_get_nuts()], [gisco_get_countries()], [gisco_get_urban_audit()].
#' @export
#' @inheritParams gisco_get_countries
#'
#' @source
#' <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' @param id character string. Select the unit type to be downloaded. Accepted
#'   values are `"nuts"`, `"countries"` or `"urban_audit"`.
#' @param year character string or number. Release year of the metadata.
#'
#' @returns
#' A [tibble][tibble::tbl_df].
#'
#' @examplesIf gisco_check_access()
#' cities <- gisco_get_metadata(id = "urban_audit", year = 2020)
#'
#' cities
gisco_get_metadata <- function(
  id = c("nuts", "countries", "urban_audit"),
  year = 2024,
  verbose = FALSE
) {
  id <- match_arg_pretty(id)
  valids <- for_docs(id, "year", formatted = FALSE)
  year <- match_arg_pretty(year, valids)

  db <- get_db()
  db <- db[db$id_giscoR == id, ]
  db <- db[db$year == year, ]
  db <- db[db$ext == "csv", ]
  db <- db[grepl("_AT", db$api_file), ]

  url <- paste0(db$api_entry, "/", db$api_file)

  msg <- paste0("Get {.url ", url, "}.")
  make_msg("info", verbose, msg)

  req <- httr2::request(url)
  req <- httr2::req_error(req, is_error = function(x) {
    FALSE
  })
  req <- httr2::req_cache(req, tempdir())
  req <- httr2::req_timeout(req, 300)
  req <- httr2::req_retry(req, max_tries = 3)
  if (verbose) {
    req <- httr2::req_progress(req)
  }

  test_off <- getOption("gisco_test_off", NULL)

  if (any(!httr2::is_online(), test_off)) {
    cli::cli_alert_danger("Offline")
    cli::cli_alert("Returning {.val NULL}")
    return(NULL)
  }

  file_local <- tempfile(fileext = "csv")
  # Response
  resp <- httr2::req_perform(req, path = file_local)

  # Testing
  test_offline <- getOption("gisco_test_err", NULL)
  if (any(httr2::resp_is_error(resp), test_offline)) {
    unlink(file_local, force = TRUE)
    get_status_code <- httr2::resp_status(resp) # nolint
    get_status_desc <- httr2::resp_status_desc(resp) # nolint

    cli::cli_alert_danger(
      c(
        "{.strong Error {.num {get_status_code}}} ({get_status_desc}):",
        " {.url {url}}."
      )
    )
    cli::cli_alert_warning(
      c(
        "If you think this is a bug please consider opening an issue on ",
        "{.url https://github.com/ropengov/giscoR/issues}"
      )
    )
    cli::cli_alert("Returning {.val NULL}")
    return(NULL)
  }

  meta_df <- read.csv(file_local, encoding = "UTF-8")
  meta_df <- tibble::as_tibble(meta_df)
  unlink(file_local, force = TRUE)
  meta_df
}
