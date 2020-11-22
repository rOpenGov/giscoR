#' @title Attribution when publishing GISCO data
#' @description Get the legal text to be used along with the data
#' downloaded with this package
#' @param lang Language (two-letter
#' \href{https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes}{ISO_639-1}
#' code). See details.
#' @param copyright Boolean. Whether to display the copyright notice or
#' not on the console.
#' @return A string with the attribution to be used.
#' @details Current languages supported are "en" (English), "da"
#' (Danish), "de" (German),
#' "es" (Spanish), "fi" (Finish), "fr" (French), "no" (Norwegian) and
#'  "sv" (Swedish).
#'
#' Consider contributing if you spot any mistake or want to add a new language.
#'
#' @note COPYRIGHT NOTICE
#'
#' When data downloaded from
#'  \href{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units}{this page}
#' is used in any printed or electronic publication,
#' in addition to any other provisions
#' applicable to the whole Eurostat website,
#' data source will have to be acknowledged
#' in the legend of the map and
#' in the introductory page of the publication
#' with the following copyright notice:
#' \itemize{
#' 	\item EN: (C) EuroGeographics for the administrative boundaries
#' 	\item FR: (C) EuroGeographics pour les limites administratives
#' 	\item DE: (C) EuroGeographics bezüglich der Verwaltungsgrenzen
#' }
#' For publications in languages other than
#' English, French or German,
#' the translation of the copyright notice
#' in the language of the publication shall be used.
#'
#' If you intend to use the data commercially,
#' please contact EuroGeographics for
#' information regarding their licence agreements.
#' @examples
#' en <- gisco_attributions()
#' gisco_attributions(lang = "es", copyright = TRUE )
#' gisco_attributions(lang = "XXX")
#' @export
gisco_attributions <- function(lang = "en", copyright = FALSE) {
  lang <- tolower(lang)
  if (copyright) {
    message(
      "
    COPYRIGHT NOTICE

    When data downloaded from this page
    <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units>
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

  if (lang == "en") {
    attr <- "\u00a9 EuroGeographics for the administrative boundaries"
  } else if (lang == "da") {
    attr <- "\u00a9 EuroGeographics for administrative gr\u00e6nser"
  } else if (lang == "de") {
    attr <- "\u00a9 EuroGeographics bezuglich der Verwaltungsgrenzen"
  } else if (lang == "es") {
    attr <-
      "\u00a9 Eurogeographics para los l\u00edmites administrativos"
  } else if (lang == "fi") {
    attr <-
      "\u00a9 EuroGeographics Association hallinnollisille rajoille"
  } else if (lang == "fr") {
    attr <- "\u00a9 EuroGeographics pour les limites administratives"
  } else if (lang == "no") {
    attr <- "\u00a9 EuroGeographics for administrative grenser"
  } else if (lang == "sv") {
    attr <-
      "\u00a9 EuroGeographics f\u00f6r administrativa gr\u00e4nser"
  } else {
    print("Language not supported, switching to English. Consider contributing")
    attr <-
      "\u00a9 EuroGeographics for the administrative boundaries"
  }
  return(attr)
}
