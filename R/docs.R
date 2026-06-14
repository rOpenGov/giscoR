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

#' Get available years for GISCO ID endpoints
#'
#' @param endpoint A character string with the GISCO ID endpoint to query.
#' @return
#' A character string with the available years for the specified endpoint.
#' @noRd
docs_id_years <- function(endpoint) {
  apiurl <- paste0(
    gisco_id_url(),
    endpoint,
    "?year=9999"
  )

  req <- gisco_request(apiurl, cache = FALSE, retry = FALSE)
  resp <- gisco_perform_request(
    req,
    apiurl,
    fake_404 = FALSE,
    check_error = FALSE
  )
  if (is.null(resp)) {
    return("are unavailable")
  }
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
