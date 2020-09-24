#' @title World countries \code{POLYGON} object
#' @name gisco_countries_60M_2016
#' @description A \code{sf} object including all
#' countries as provided by GISCO (2016 version).
#' @format A \code{MULTIPOLYGON} data frame (resolution: 1:60million, EPSG:4326) object with 257 rows and 7 variables:
#' \describe{
#'   \item{id}{row ID}
#'   \item{CNTR_NAME}{Official country name on local language}
#'   \item{ISO3_CODE}{\href{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3}{ISO 3166-1 alpha-3 code} of each country, as provided by GISCO}
#'   \item{CNTR_ID}{Country ID}
#'   \item{NAME_ENGL}{Country name in English}
#'   \item{FID}{FID}
#'   \item{geometry}{geometry field}
#' }
#' @source \url{https://gisco-services.ec.europa.eu/distribution/v2/countries/geojson/CNTR_RG_60M_2016_4326.geojson}.
#' @docType data
NULL

#' @title World coastal lines \code{LINESTRING} object
#' @name gisco_coastallines_60M_2016
#' @description A \code{sf} object including the coast lines
#' as provided by GISCO (2016 version).
#' @format A \code{LINESTRING} data frame (resolution: 1:60million, EPSG:4326) object with 8 variables:
#' \describe{
#'   \item{EFTA_FLAG}{Coast belonging to EFTA countries}
#'   \item{OTHR_FLAG}{Coast belonging to other countries}
#'   \item{EU_FLAG}{Coast belonging to EU countries}
#'   \item{COAS_FLAG}{Coast flag}
#'   \item{CNTR_BN_ID}{CNTR_BN_ID}
#'   \item{CC_FLAG}{Coast belonging to EU candidate countries}
#'   \item{FID}{FID}
#'   \item{geometry}{geometry field}
#' }
#' @source \url{https://gisco-services.ec.europa.eu/distribution/v2/countries/geojson/CNTR_BN_60M_2016_4326_COASTL.geojson}.
#' @docType data
NULL

#' @title Dataframe including United Nations M49 geographic regions
#' @name M49_regions
#' @description A dataframe containing geographic regions information, as provided by the UN Standard Country or Area Codes for Statistical Use (M49).
#' @format A data frame object with 250 rows and 9 variables:
#' \describe{
#'   \item{ISO3_CODE}{\href{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3}{ISO 3166-1 alpha-3 code} of each country, as provided by GISCO}
#'   \item{NAME}{Country name}
#'   \item{REGION_CODE}{Numeric region code}
#'   \item{REGION}{Region}
#'   \item{SUBREGION_CODE}{Numeric sub-region code}
#'   \item{SUBREGION}{Sub-Region}
#'   \item{INTERREGION_CODE}{Numeric intermediate Region code}
#'   \item{INTERREGION}{Intermediate Region}
#'   \item{DEVELOPED}{Indicates wheter a country is considered "Developed" of "Developing"}
#' }
#' @source \url{https://unstats.un.org/unsd/methodology/m49/#geo-regions}
#' @note This data was extracted on 29Jan2020 using the reop \url{https://github.com/dieghernan/Country-Codes-and-International-Organizations/}
#' @docType data
NULL
