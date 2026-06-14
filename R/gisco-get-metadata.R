#' Get metadata
#'
#' @description
#' Get a table with names and IDs of administrative and statistical units.
#'
#' @family database
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#'
#' @param id A character string with the unit type to download. Accepted values
#'   are `"nuts"`, `"countries"` or `"urban_audit"`.
#' @param year A character string or numeric value with the release year of the
#'   metadata.
#'
#' @return
#' A [tibble][tibble::tbl_df].
#'
#' @source
#' <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' @seealso
#' [gisco_get_nuts()], [gisco_get_countries()], [gisco_get_urban_audit()].
#' @examplesIf gisco_check_access()
#' cities <- gisco_get_metadata(id = "urban_audit", year = 2020)
#'
#' cities
#' @export
gisco_get_metadata <- function(
  id = c("nuts", "countries", "urban_audit"),
  year = 2024,
  verbose = FALSE
) {
  id <- match_arg_pretty(id)
  valids <- db_values(id, "year", formatted = FALSE)
  year <- match_arg_pretty(year, valids)

  db <- get_db()
  url <- metadata_url(id, year, db)
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
  meta_df <- read_metadata_csv(file_local)
  unlink(file_local, force = TRUE)
  meta_df
}

#' Get the metadata CSV URL from the cached GISCO database
#'
#' @param id A unit type.
#' @param year A metadata year.
#' @param db A cached GISCO database.
#'
#' @return A character string with the metadata CSV URL.
#' @noRd
metadata_url <- function(id, year, db = get_db()) {
  db <- db[db$id_giscor == id, ]
  db <- db[db$year == year, ]
  db <- db[db$ext == "csv", ]
  db <- db[grepl("_AT", db$api_file, fixed = TRUE), ]

  paste0(db$api_entry, "/", db$api_file)
}

#' Read a metadata CSV file
#'
#' @param file_local Local CSV file path.
#'
#' @return A tibble.
#' @noRd
read_metadata_csv <- function(file_local) {
  meta_df <- read.csv(file_local, encoding = "UTF-8")
  tibble::as_tibble(meta_df)
}
