# For docs
for_docs <- function(id, field, decreasing = FALSE) {
  db <- get_db()

  df <- db[db$id_giscoR == id, field]
  x <- sort(unique(df[[field]]), decreasing = decreasing)
  ftext <- paste0('`"', x, '"`')
  lt <- length(ftext)
  paste0(paste0(ftext[-lt], collapse = ", "), " or ", ftext[lt])
}
