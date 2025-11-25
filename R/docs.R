# For docs
for_docs <- function(id, field, decreasing = FALSE) {
  db <- get_db()

  df <- db[db$id_giscoR == id, field]
  x <- sort(unique(df[[field]]), decreasing = decreasing)
  x <- paste0('"', x, '"')
  ftext <- paste0("\\code{", x, "}")
  paste0(ftext, collapse = ", ")
}
