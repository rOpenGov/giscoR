#' Documentation helpers for \CRANpkg{giscoR}
#'
#' @description
#' Internal function to get possible values from the cached GISCO database.
#'
#' @param id A character string with the `id_giscor` value to filter the
#'   database.
#' @param field A character string with the field/column name from which to
#'   extract values.
#' @param decreasing A logical value indicating whether to sort the values in
#'   decreasing order. Defaults to `FALSE`.
#' @param formatted A logical value indicating whether to format the output
#'   values for documentation. Defaults to `TRUE`.
#'
#' @return
#' A character string with the possible values for the specified field.
#' @noRd
db_values <- function(id, field, decreasing = FALSE, formatted = TRUE) {
  db <- as.data.frame(get_db())

  df <- db[db$id_giscor == id, ]

  x <- sort(unique(df[[field]]), decreasing = decreasing)
  x <- x[!is.na(x)]
  if (field == "ext") {
    x <- x[x %in% c("shp", "geojson", "gpkg")]
  }
  if (!formatted) {
    return(as.character(x))
  }

  x <- paste0('"', x, '"')
  ftext <- paste0("\\code{", x, "}")
  paste0(ftext, collapse = ", ")
}
