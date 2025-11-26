make_msg <- function(type = "generic", verbose, ...) {
  if (!verbose) {
    return(invisible())
  }
  dots <- list(...)
  msg <- paste(dots, collapse = " ")

  if (type == "generic") {
    cli::cli_alert(msg)
  }
  if (type == "success") {
    cli::cli_alert_success(msg)
  }
  if (type == "warning") {
    cli::cli_alert_warning(msg)
  }
  if (type == "danger") {
    cli::cli_alert_danger(msg)
  }
  if (type == "info") {
    cli::cli_alert_info(msg)
  }
  invisible()
}

#' @param names vector of names or codes
#'
#' @param out out code
#'
#' @return a vector of names
#'
#' @noRd
get_country_code <- function(names, out = "eurostat") {
  names[tolower(names) == "antartica"] <- "Antarctica"

  # Vectorize
  outnames <- lapply(names, function(x) {
    if (
      any(grepl("kosovo", tolower(x)), "xk" == tolower(x), "xkx" == tolower(x))
    ) {
      code <- switch(out,
        "eurostat" = "XK",
        "iso3c" = "XKX"
      )
      return(code)
    }

    maxname <- max(nchar(x))
    if (maxname > 3) {
      outnames <- countrycode::countryname(x, out, warn = FALSE)
    } else if (maxname == 3) {
      outnames <- countrycode::countrycode(x, "iso3c", out, warn = FALSE)
    } else if (maxname == 2) {
      outnames <- countrycode::countrycode(x, "eurostat", out, warn = FALSE)
    } else {
      cli::cli_abort(
        paste0(
          "Invalid country name {.str {x}} ",
          "Try a vector of names or ISO3/Eurostat codes"
        )
      )
    }
    outnames
  })

  outnames <- unlist(outnames)
  linit <- length(outnames)
  outnames2 <- outnames[!is.na(outnames)]
  lend <- length(outnames2)
  if (linit != lend) {
    ff <- names[is.na(outnames)] # nolint
    cli::cli_alert_warning("Some values were not matched unambiguously: {ff}")
    cli::cli_alert_info("Review the names/codes or switch to ISO3 codes.")
  }

  outnames2
}
