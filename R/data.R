#' @title World countries \code{POLYGON} object
#' @name gisco_countries
#' @description A \code{sf} object including all
#' countries as provided by GISCO (2016 version).
#' @format A \code{MULTIPOLYGON} data frame (resolution: 1:20million, EPSG:4326) object with 257 rows and 7 variables:
#' \describe{
#'   \item{id}{row ID}
#'   \item{CNTR_NAME}{Official country name on local language}
#'   \item{ISO3_CODE}{\href{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3}{ISO 3166-1 alpha-3 code} of each country, as provided by GISCO}
#'   \item{CNTR_ID}{Country ID}
#'   \item{NAME_ENGL}{Country name in English}
#'   \item{FID}{FID}
#'   \item{geometry}{geometry field}
#' }
#' @examples
#' library(sf)
#'
#' cntry <- gisco_countries
#' GBR <- subset(cntry, ISO3_CODE == "GBR")
#'
#' plot(st_geometry(GBR), col = "red3", border = "blue4")
#' title(sub = gisco_attributions(), line = 1)
#'
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/countries/geojson/CNTR_RG_20M_2016_4326.geojson}{GISCO .geojson source}
#' @docType data
#' @seealso \link{gisco_get_countries}
NULL

#' @title World coastal lines \code{POLYGON} object
#' @name gisco_coastallines
#' @description A \code{sf} object as provided by GISCO (2016 version).
#' @format A \code{POLYGON} data frame (resolution: 1:20million, EPSG:4326) object with 8 variables:
#' \describe{
#'   \item{FID}{FID}
#'   \item{COAS_ID}{COAS_ID}
#'   \item{geometry}{geometry field}
#' }
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/coas/geojson/COAS_RG_20M_2016_4326.geojson}{GISCO .geojson source}
#' @docType data
#' @seealso \link{gisco_get_coastallines}
#' @examples
#'  library(sf)
#'
#'  coasts <- gisco_coastallines
#'
#'  plot(
#'    st_geometry(coasts),
#'    xlim = c(100, 120),
#'    ylim = c(-24, 24),
#'    col = "grey90",
#'    border = "deepskyblue4",
#'    lwd = 2
#'  )
#'  box()
#'  title(
#'    main = "Coasts on Southeastern Asia",
#'    sub = gisco_attributions(),
#'    cex.sub = 0.7,
#'    line = 1
#'  )
NULL

#' @title All NUTS \code{POLYGON} object
#' @name gisco_nuts
#' @description A \code{sf} object including all
#' NUTS levels as provided by GISCO (2016 version).
#' @format A \code{POLYGON} data frame (resolution: 1:20million, EPSG:4326) object with 11 variables:
#' \describe{
#'   \item{id}{row ID}
#'   \item{COAST_TYPE}{COAST_TYPE}
#'   \item{MOUNT_TYPE}{MOUNT_TYPE}
#'   \item{NAME_LATN}{Name on Latin characters}
#'   \item{CNTR_CODE}{Eurostat Country code}
#'   \item{FID}{FID}
#'   \item{NUTS_ID}{NUTS identifier}
#'   \item{NUTS_NAME}{NUTS name on local alphabet}
#'   \item{LEVL_CODE}{NUTS level code (0,1,2,3)}
#'   \item{URBN_TYPE}{URBN_TYPE}
#'   \item{geometry}{geometry field}
#' }
#' @source \href{https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/NUTS_RG_20M_2016_4326.geojson}{GISCO .geojson source}
#' @docType data
#' @seealso \link{gisco_get_nuts}
#' @examples
#' library(sf)
#'
#' nuts <- gisco_nuts
#'
#' italy <- subset(nuts, CNTR_CODE == "IT" & LEVL_CODE == 3)
#'
#' plot(st_geometry(italy), col = c("springgreen4", "ivory", "red2"))
#' title(
#'   sub = gisco_attributions(copyright = FALSE),
#'   cex.sub = 0.7,
#'   font.sub = 3
#' )
NULL


#' @title Dataframe including Eurostat and ISO2 and ISO3 codes for countries and world regions
#' @name gisco_countrycode
#' @description A dataframe containing conversions between different country codification systems (Eurostat/ISO2 and 3) as well as geographic regions as provided by the World Bank and the UN (M49).
#' @format A data frame object with 249 rows and 12 variables:
#' \describe{
#'   \item{CNTR_CODE}{Eurostat code of each country}
#'   \item{iso2c}{ISO 3166-1 alpha-2 code of each country}
#'   \item{ISO3_CODE}{ISO 3166-1 alpha-3 code of each country}
#'   \item{iso.name.en}{ISO English short name}
#'   \item{cldr.short.en}{English short name as provided by the \href{http://cldr.unicode.org/translation/displaynames/country-names}{Unicode Common Locale Data Repository}}
#'   \item{continent}{As provided by the World Bank}
#'   \item{un.region.code}{Numeric region code UN (M49)}
#'   \item{un.region.name}{Region name UN (M49)}
#'   \item{un.regionintermediate.code}{Numeric intermediate Region code UN (M49)}
#'   \item{un.regionintermediate.name}{Intermediate Region name UN (M49)}
#'   \item{un.regionsub.code}{Numeric sub-region code UN (M49)}
#'   \item{un.regionsub.name}{Sub-Region name UN (M49)}
#' }
#' @source \code{codelist} dataset from the \code{countrycode v1.2.0} package.
#' @seealso \link[countrycode]{codelist}
#' @docType data
NULL
