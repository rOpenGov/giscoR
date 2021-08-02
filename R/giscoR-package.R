#' giscoR package
#'
#' @name giscoR-package
#'
#' @aliases giscoR
#'
#' @keywords package
#'
#' @docType package
#'
#' @description \if{html}{\figure{logo.png}{options: width=120 alt="giscoR logo" align='right'}}
#'
#' giscoR is a API package that helps to retrieve data from Eurostat - GISCO
#'  (the Geographic Information System of the COmmission)
#'
#' @title Download geospatial data from GISCO API - Eurostat
#'
#' @details
#' |              |          |
#' | :---         | :--      |
#' | **Package**  | giscoR |
#' | **Type**     | Package  |
#' | **Version**  | `r packageVersion("giscoR")` |
#' | **Date**     | `r format(Sys.Date(), "%Y")`     |
#' | **License**  | GPL-3    |
#' | **LazyLoad** | yes      |
#'
#'
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @references
#' See `citation("giscoR")`
#'
#' @seealso
#'
#' Useful links:
#'  * <https://dieghernan.github.io/giscoR/>
#'  * <https://github.com/dieghernan/giscoR>
#'  * Report bugs at <https://github.com/dieghernan/giscoR/issues>
#'
#'
#'
#' @note
#' COPYRIGHT NOTICE
#'
#' When data downloaded from
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units>
#' is used in any printed or electronic publication,
#' in addition to any other provisions
#' applicable to the whole Eurostat website,
#' data source will have to be acknowledged
#' in the legend of the map and
#' in the introductory page of the publication
#' with the following copyright notice:
#'   * EN: (C) EuroGeographics for the administrative boundaries
#'   * FR: (C) EuroGeographics pour les limites administratives
#'   * DE: (C) EuroGeographics bezüglich der Verwaltungsgrenzen
#'
#' For publications in languages other than
#' English, French or German,
#' the translation of the copyright notice
#' in the language of the publication shall be used.
#'
#' If you intend to use the data commercially,
#' please contact EuroGeographics for
#' information regarding their licence agreements.
NULL

# import stuffs
#' @importFrom utils download.file unzip read.csv2 menu
NULL
