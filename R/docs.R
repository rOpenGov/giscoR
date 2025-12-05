#' Help Documentation for giscor Package
#' #' @description
#' Internal function to get possible values from the cached `gisco_db` database.
#'
#' @param id character string. The `id_giscor` value to filter the database.
#' @param field character string. The field/column name from which to extract
#'   values.
#' @param decreasing logical. Whether to sort the values in decreasing order.
#'   Default is `FALSE`.
#' @param formatted logical. Whether to format the output values for
#'   documentation. Default is `TRUE`.
#'
#' @returns
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
