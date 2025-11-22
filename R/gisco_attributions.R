#' Attribution when publishing GISCO data
#'
#' @family helper
#'
#' @description
#' Get the legal text to be used along with the data downloaded with this
#' package.
#'
#' @export
#'
#' @param lang Language (two-letter ISO code). See
#' <https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes> and **Details**.
#'
#' @param copyright Boolean `TRUE/FALSE`. Whether to display the copyright
#'   notice or not on the console.
#'
#' @return A string with the attribution to be used.
#'
#' @encoding UTF-8
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
#' * EN: (C) EuroGeographics for the administrative boundaries.
#' * FR: (C) EuroGeographics pour les limites administratives.
#' * DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen.
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
gisco_attributions <- function(lang = "en", copyright = FALSE) {
  lang <- tolower(lang)
  if (copyright) {
    message(
      "
    COPYRIGHT NOTICE

    When data downloaded from GISCO
    is used in any printed or electronic publication,
    in addition to any other provisions applicable to
    the whole Eurostat website, data source will have
    to be acknowledged in the legend of the map and in
    the introductory page of the publication with the
    following copyright notice:

    - EN: (C) EuroGeographics for the administrative boundaries
    - FR: (C) EuroGeographics pour les limites administratives
    - DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen

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

  gsc_message(
    verbose,
    "Language",
    lang,
    "not supported,",
    "switching to English.",
    "\nConsider contributing:",
    "\nhttps://github.com/rOpenGov/giscoR/issues"
  )

  attr <- switch(lang,
    "en" = "\u00a9 EuroGeographics for the administrative boundaries",
    "da" = "\u00a9 EuroGeographics for administrative gr\u00e6nser",
    "de" = "\u00a9 EuroGeographics bezuglich der Verwaltungsgrenzen",
    "es" = "\u00a9 Eurogeographics para los l\u00edmites administrativos",
    "fi" = "\u00a9 EuroGeographics Association hallinnollisille rajoille",
    "fr" = "\u00a9 EuroGeographics pour les limites administratives",
    "no" = "\u00a9 EuroGeographics for administrative grenser",
    "sv" = "\u00a9 EuroGeographics f\u00f6r administrativa gr\u00e4nser",
    "\u00a9 EuroGeographics for the administrative boundaries"
  )
  attr
}
