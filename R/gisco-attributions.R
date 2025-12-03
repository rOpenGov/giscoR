#' Attribution when publishing GISCO data
#'
#' @description
#' Get the legal text to be used along with the data downloaded with this
#' package.
#'
#' @family misc
#' @encoding UTF-8
#' @export
#'
#' @param lang character. Language (two-letter ISO code). See
#'   [countrycode::codelist] and **Details**.
#' @param copyright logical `TRUE/FALSE`. Whether to display the copyright
#'   notice or not on the console.
#'
#' @return A string with the attribution to be used.
#'
#' @details
#' Current languages supported are:
#' * `"en"`: English.
#' * `"da"`: Danish.
#' * `"de"`: German.
#' * `"es"`: Spanish.
#' * `"fi"`: Finish.
#' * `"fr"`: French.
#' * `"no"`: Norwegian.
#' * `"sv"`: Swedish.
#'
#' Please consider
#' [contributing](https://github.com/rOpenGov/giscoR/issues) if you spot any
#' mistake or want to add a new language.
#'
#' @note
#'
#' COPYRIGHT NOTICE
#'
#' When data downloaded from GISCO is used in any printed or electronic
#' publication, in addition to any other provisions applicable to the whole
#' Eurostat website, data source will have to be acknowledged in the legend of
#' the map and in the introductory page of the publication with the following
#' copyright notice:
#'
#' ```{r, echo=FALSE, results='asis'}
#' cat("")
#' cat("* EN: \u00a9 EuroGeographics for the administrative boundaries.",
#' "* FR: \u00a9 EuroGeographics pour les limites administratives.",
#' "* DE: \u00a9 EuroGeographics bez\u00fcglich der Verwaltungsgrenzen.",
#' sep = "\n")
#'
#' ```
#'
#' For publications in languages other than English, French or German,
#' the translation of the copyright notice in the language of the publication
#' shall be used.
#'
#' If you intend to use the data commercially, please contact EuroGeographics
#' for information regarding their licence agreements.
#'
#' @examples
#' gisco_attributions()
#'
#' gisco_attributions(lang = "es", copyright = TRUE)
#'
#' gisco_attributions(lang = "XXX")
#'
#' # Get list of codes from countrycodes
#' library(dplyr)
#'
#' countrycode::codelist %>%
#'   select(country.name.en, iso2c)
gisco_attributions <- function(lang = "en", copyright = FALSE) {
  lang <- tolower(lang)
  if (copyright) {
    cli::cli_alert_info(
      "
    COPYRIGHT NOTICE

    When data downloaded from GISCO
    is used in any printed or electronic publication,
    in addition to any other provisions applicable to
    the whole Eurostat website, data source will have
    to be acknowledged in the legend of the map and in
    the introductory page of the publication with the
    following copyright notice:

    - EN: \u00a9 EuroGeographics for the administrative boundaries
    - FR: \u00a9 EuroGeographics pour les limites administratives
    - DE: \u00a9 EuroGeographics bez\u00fcglich der Verwaltungsgrenzen

    For publications in languages other than English,
    French or German, the translation of the copyright
    notice in the language of the publication shall be
    used.

    If you intend to use the data commercially, please
    contact EuroGeographics for information regarding
    their licence agreements.

      "
    )
  }

  # Display message
  verbose <- !lang %in% c("en", "da", "de", "es", "fi", "fr", "no", "sv")

  make_msg(
    "warning",
    verbose,
    "Language",
    lang,
    "not supported.",
    "Switching to English."
  )
  make_msg(
    "info",
    verbose,
    "Consider contributing:",
    "{.url https://github.com/rOpenGov/giscoR/issues}"
  )

  attr <- switch(lang,
    "en" = "\u00a9 EuroGeographics for the administrative boundaries",
    "da" = "\u00a9 EuroGeographics for administrative gr\u00e6nser",
    "de" = "\u00a9 EuroGeographics bez\u00fcglich der Verwaltungsgrenzen",
    "es" = "\u00a9 Eurogeographics para los l\u00edmites administrativos",
    "fi" = "\u00a9 EuroGeographics Association hallinnollisille rajoille",
    "fr" = "\u00a9 EuroGeographics pour les limites administratives",
    "no" = "\u00a9 EuroGeographics for administrative grenser",
    "sv" = "\u00a9 EuroGeographics f\u00f6r administrativa gr\u00e4nser",
    "\u00a9 EuroGeographics for the administrative boundaries"
  )
  attr
}
