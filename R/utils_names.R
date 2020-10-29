#' @name gsc_helper_countrynames
#' @title Helper function to convert country names to codes
#' @description Convert country codes
#' @param names vector of names or codes
#' @param out out code
#' @return a vector of names
#' @noRd
gsc_helper_countrynames <- function(names, out = "eurostat") {
  maxname <- max(nchar(names))
  if (maxname > 3) {
    outnames <- countrycode::countryname(names, out)
  } else if (maxname == 3) {
    outnames <- countrycode::countrycode(names, "iso3c", out)
  } else if (maxname == 2) {
    outnames <- countrycode::countrycode(names, "eurostat", out)
  } else {
    stop("Invalid country names. Try a vector of names, ISO3 codes or Eurostat codes")
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
  return(outnames2)
}

#' @name gsc_helper_utf8
#' @title Convert sf object to UTF-8
#' @description Convert to UTF-8
#' @param data.sf data.sf
#' @return data.sf with UTF-8 encoding.
#' @note Extracted from \code{sf}.
#' @noRd
gsc_helper_utf8 <- function(data.sf) {
  # From sf/read.R - https://github.com/r-spatial/sf/blob/master/R/read.R
  set_utf8 <- function(x) {
    n <- names(x)
    Encoding(n) <- "UTF-8"
    to_utf8 <- function(x) {
      if (is.character(x))
        Encoding(x) <- "UTF-8"
      x
    }
    structure(lapply(x, to_utf8), names = n)
  }
  # end

  # To UTF-8
  names <- names(data.sf)
  g <- sf::st_geometry(data.sf)

  which.geom <-
    which(vapply(data.sf, function(f)
      inherits(f, "sfc"), TRUE))

  nm <- names(which.geom)

  data.utf8 <-
    as.data.frame(set_utf8(sf::st_drop_geometry(data.sf)), stringsAsFactors = FALSE)

  # Regenerate with right encoding
  data.sf <- sf::st_as_sf(data.utf8, g)

  # Rename geometry to original value
  newnames <- names(data.sf)
  newnames[newnames == "g"] <- nm
  colnames(data.sf) <- newnames
  data.sf <- sf::st_set_geometry(data.sf, nm)

  return(data.sf)
}
