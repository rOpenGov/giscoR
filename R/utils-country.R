#' Convert country names or codes to desired code
#'
#' @param names vector of names or codes
#'
#' @param out out code
#'
#' @return a vector of names
#'
#' @noRd
convert_country_code <- function(names, out = "eurostat") {
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
    cli::cli_alert_warning(
      "Some country/codes were not matched unambiguously: {.str {ff}}"
    )
    cli::cli_alert_info("Review the names/codes or switch to ISO3 codes.")
  }

  outnames2
}

#' Get country codes from country names and/or region names
#'
#' @param country character vector of country codes or names
#' @param region character vector of region codes or names
#' @param code desired output code, default is "eurostat"
#' @return character vector of country codes
#'
#' @noRd
get_countrycodes_region <- function(
  country = NULL,
  region = NULL,
  code = "eurostat"
) {
  store <- NULL
  if (!is.null(country)) {
    country <- convert_country_code(country, code)
    store <- c(store, country)
  }

  if (!is.null(region)) {
    region_df <- giscoR::gisco_countrycode
    cntryregion <- region_df[region_df$un.region.name %in% region, ]

    if ("EU" %in% region) {
      eu <- region_df[region_df$eu, ]
      cntryregion <- unique(rbind(cntryregion, eu))
    }
    cnt_region <- sort(unique(cntryregion$CNTR_CODE))
    cnt_region <- cnt_region[!is.na(cnt_region)]
    cnt_region <- convert_country_code(cnt_region, code)

    # Condition in both country and region is AND
    # so we intersect
    if (!is.null(store)) {
      store <- sort(unique(intersect(store, cnt_region)))
    } else {
      store <- sort(cnt_region)
    }
  }

  store
}
