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

#' Helper function to get available years for GISCO ID endpoints
#'
#' @param endpoint character string. The GISCO ID endpoint to query.
#' @returns
#' A character string with the available years for the specified endpoint.
#' @noRd
docs_id_years <- function(endpoint) {
  apiurl <- paste0(
    "https://gisco-services.ec.europa.eu/id/",
    endpoint,
    "?year=9999"
  )

  req <- httr2::request(apiurl)
  req <- httr2::req_error(req, is_error = function(x) {
    FALSE
  })
  resp <- httr2::req_perform(req)
  get_years <- httr2::resp_body_json(resp, simplifyVector = TRUE)
  get_years <- get_years$details
  available_years <- gsub("[^0-9]", " ", get_years)
  available_years <- unique(unlist(strsplit(available_years, " ")))
  available_years <- sort(as.numeric(available_years), decreasing = TRUE)

  x <- paste0('"', available_years, '"')
  ftext <- paste0("\\code{", x, "}")
  ftext <- paste0(ftext, collapse = ", ")
  if (length(available_years) == 1) {
    ftext <- paste0("is ", ftext)
  } else {
    ftext <- paste0("are ", ftext)
  }
  ftext
}
