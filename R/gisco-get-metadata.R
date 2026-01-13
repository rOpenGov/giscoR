#' Get metadata
#'
#' @description
#' Get a table with the names and ids of administrative and statistical units.
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
  valids <- db_values(id, "year", formatted = FALSE)
  year <- match_arg_pretty(year, valids)

  db <- get_db()
  db <- db[db$id_giscor == id, ]
  db <- db[db$year == year, ]
  db <- db[db$ext == "csv", ]
  db <- db[grepl("_AT", db$api_file, fixed = TRUE), ]

  url <- paste0(db$api_entry, "/", db$api_file)
  tmp_file <- basename(tempfile(fileext = ".csv"))

  file_local <- download_url(
    url = url,
    name = tmp_file,
    cache_dir = tempdir(),
    subdir = "gisco_metadata",
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }
  meta_df <- read.csv(file_local, encoding = "UTF-8")
  meta_df <- tibble::as_tibble(meta_df)
  unlink(file_local, force = TRUE)
  meta_df
}
