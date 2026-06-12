#' Convert country names or codes to the desired code
#'
#' @param names A vector of names or codes.
#'
#' @param out A character string with the output code.
#'
#' @return A character vector with country codes.
#'
#' @noRd
convert_country_code <- function(names, out = "eurostat") {
  names[tolower(names) == "antarctica"] <- "Antarctica"
  names[tolower(names) == "antartica"] <- "Antarctica"

  # Vectorize country conversion.
  outnames <- lapply(names, function(x) {
    if (
      any(
        grepl("kosovo", tolower(x), fixed = TRUE),
        "xk" == tolower(x),
        "xkx" == tolower(x)
      )
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
          "Invalid country name {.str {x}}. ",
          "Try a vector of names, ISO3 codes or Eurostat codes."
        ),
        call = NULL
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
      "Some country names or codes were not matched unambiguously: {.str {ff}}."
    )
    cli::cli_alert_info("Review the names or codes, or switch to ISO3 codes.")
  }

  outnames2
}

#' Convert country names or codes unless the input is `NULL`
#'
#' @inheritParams convert_country_code
#'
#' @return A vector of names, or `NULL` when `names` is `NULL`.
#' @noRd
convert_country_code_or_null <- function(names, out = "eurostat") {
  if (is.null(names)) {
    return(NULL)
  }

  convert_country_code(names, out)
}

#' Filter a data frame by country values in one column
#'
#' @param data A data frame or `sf` object.
#' @param country A character vector of country codes.
#' @param col A character string with the column to filter.
#'
#' @return `data`, filtered when `country` is not `NULL` and `col` exists.
#' @noRd
filter_by_country_col <- function(data, country = NULL, col = "CNTR_CODE") {
  if (is.null(country) || !col %in% names(data)) {
    return(data)
  }

  data[data[[col]] %in% country, ]
}

#' Get country codes from country names and/or region names
#'
#' @param country A character vector of country codes or names.
#' @param region A character vector of region codes or names.
#' @param code Desired output code. Default is "eurostat".
#' @return A character vector of country codes.
#'
#' @noRd
get_countrycodes_region <- function(
  country = NULL,
  region = NULL,
  code = "eurostat"
) {
  store <- NULL
  country <- convert_country_code_or_null(country, code)
  store <- c(store, country)

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

    # Intersect when both country and region are provided.
    if (!is.null(store)) {
      store <- sort(unique(intersect(store, cnt_region)))
    } else {
      store <- sort(cnt_region)
    }
  }

  store
}
