#' Helper function to convert country names to codes
#'
#' Convert country codes
#'
#' @param names vector of names or codes
#'
#' @param out out code
#'
#' @return a vector of names
#'
#' @noRd
gsc_helper_countrynames <- function(names, out = "eurostat") {
  names <- as.character(names[!is.na(names)])
  maxname <- max(nchar(names))
  if (maxname > 3) {
    outnames <- countrycode::countryname(names, out)
  } else if (maxname == 3) {
    outnames <- countrycode::countrycode(names, "iso3c", out)
  } else if (maxname == 2) {
    outnames <- countrycode::countrycode(names, "eurostat", out)
  } else {
    stop(paste0(
      "Invalid country names. Try a vector of names,",
      " ISO3 codes or Eurostat codes"
    ))
  }
  linit <- length(outnames)
  outnames2 <- outnames[!is.na(outnames)]
  lend <- length(outnames2)
  if (linit != lend) {
    f <- paste(names[is.na(outnames)], sep = ",", collapse = ",")
    warning(
      paste(
        "Countries ommited: ",
        f,
        ". Review the names of switch to ISO3 or Eurostat codes.",
        sep = " "
      )
    )
  }
  outnames2
}


#' Helper for docs
#' @noRd
gsc_helper_year_docs <- function(x) {
  # nocov start
  db <- giscoR::gisco_db
  db <- as.data.frame(db)
  y <- db[db$id_giscoR %in% x, "year"]

  y_all <- sort(unique(unlist(strsplit(y, ","))))
  ftext <- paste0('`"', y_all, '"`')
  lt <- length(ftext)
  paste0(paste0(ftext[-lt], collapse = ", "), " or ", ftext[lt])
  # nocov end
}
