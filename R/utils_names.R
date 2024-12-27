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
  return(outnames2)
}

#' Convert sf object to UTF-8
#'
#' Convert to UTF-8
#'
#' @param data_sf data_sf
#'
#' @return data_sf with UTF-8 encoding.
#'
#' @source Extracted from [`sf`][sf::st_sf] package.
#'
#' @noRd
gsc_helper_utf8 <- function(data_sf) {
  # From sf/read.R - https://github.com/r-spatial/sf/blob/master/R/read.R
  set_utf8 <- function(x) {
    n <- names(x)
    Encoding(n) <- "UTF-8"
    to_utf8 <- function(x) {
      if (is.character(x)) {
        Encoding(x) <- "UTF-8"
      }
      x
    }
    structure(lapply(x, to_utf8), names = n)
  }
  # end

  # To UTF-8
  names <- names(data_sf)
  g <- sf::st_geometry(data_sf)

  which_geom <-
    which(vapply(data_sf, function(f) {
      inherits(f, "sfc")
    }, TRUE))

  nm <- names(which_geom)

  data_utf8 <-
    as.data.frame(set_utf8(sf::st_drop_geometry(data_sf)),
      stringsAsFactors = FALSE
    )

  # Regenerate with right encoding
  data_sf <- sf::st_as_sf(data_utf8, g)

  # Rename geometry to original value
  newnames <- names(data_sf)
  newnames[newnames == "g"] <- nm
  colnames(data_sf) <- newnames
  data_sf <- sf::st_set_geometry(data_sf, nm)

  data_sf
}


#' Helper for display messages on verbose
#'
#' @noRd
gsc_message <- function(verbose, ...) {
  dots <- list(...)
  msg <- paste(dots, collapse = " ")

  if (verbose) message(msg)

  invisible()
}


#' Helper for docs
#' @noRd
gsc_helper_year_docs <- function(x) {
  # nocov start
  db <- giscoR::gisco_db
  y <- db[db$id_giscoR %in% x, "year"]

  y_all <- sort(unique(unlist(strsplit(y, ","))))
  ftext <- paste0('`"', y_all, '"`')
  lt <- length(ftext)
  paste0(paste0(ftext[-lt], collapse = ", "), " or ", ftext[lt])
  # nocov end
}
