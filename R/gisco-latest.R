#' Metadata utils (TODO)
#'
#' Get the latest information available in the current database.
#'
#' @family databases
#' @rdname gisco_get_db
#' @export
#' @param id_giscoR Unit types available. Accepted values are
#'   `r for_docs(gisco_get_db_idgisco())`.
gisco_get_db_years <- function(
  id_giscoR = c(
    "coastallines",
    "communes",
    "countries",
    "lau",
    "nuts",
    "postalcodes",
    "urban_audit"
  )
) {
  id_giscor <- match.arg(id_giscoR)
  db <- gisco_get_latest_db()
  db_y <- db[db$id_giscoR == id_giscor, ]
  x <- unique(sort(db_y$year))
  x
}
#' @rdname gisco_latest
#' @export
gisco_get_db_idgisco <- function() {
  db <- gisco_get_latest_db()
  sort(unique(db$id_giscoR))
}

# For docs
for_docs <- function(x) {
  ftext <- paste0('`"', x, '"`')
  lt <- length(ftext)
  paste0(paste0(ftext[-lt], collapse = ", "), " or ", ftext[lt])
}
