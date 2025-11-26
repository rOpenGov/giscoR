#' Cached GISCO database
#'
#' Database with the list of files that the package can load.
#'
#' @family dataset
#' @family database
#'
#' @name gisco_db
#'
#' @docType data
#'
#' @format A data frame
#'
#' @details This data frame is used to check the validity of the API calls.
#'
#' @source GISCO API `datasets.json`.
#' @keywords internal
#' @examples
#'
#' data("gisco_db")
NULL

#' World countries `POLYGON` [`sf`][sf::st_sf] object
#'
#' @family dataset
#'
#' @name gisco_countries
#'
#' @description
#' A [`sf`][sf::st_sf] object including all countries as provided by
#' GISCO (2016 version).
#'
#' @format
#' A `MULTIPOLYGON` data frame (resolution: 1:20million, EPSG:4326) object
#' with `r nrow(giscoR::gisco_countries)` rows and 7 variables:
#' \describe{
#'   \item{id}{row ID.}
#'   \item{CNTR_NAME}{Official country name on local language.}
#'   \item{ISO3_CODE}{ISO 3166-1 alpha-3 code of each country, as provided by
#'   GISCO.}
#'   \item{CNTR_ID}{Country ID.}
#'   \item{NAME_ENGL}{Country name in English.}
#'   \item{FID}{FID.}
#'   \item{geometry}{geometry field.}
#' }
#' @examples
#'
#' data("gisco_countries")
#' head(gisco_countries)
#'
#' @source
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0("[CNTR_RG_20M_2016_4326.geojson]",
#'       "(https://gisco-services.ec.europa.eu/distribution/v2/",
#'       "countries/geojson/) file."))
#'
#'
#' ```
#'
#' @docType data
#'
#' @seealso [gisco_get_countries()]
#'
#' @encoding UTF-8
NULL

#' World coastal lines `POLYGON` object
#'
#' @description
#'
#' A [`sf`][sf::st_sf] object as provided by GISCO (2016 version).
#'
#' @family dataset
#'
#' @name gisco_coastallines
#'
#' @format
#' A `POLYGON` [`sf`][sf::st_sf] object (resolution: 1:20million, EPSG:4326)
#' with 3 variables:
#' \describe{
#'   \item{COAS_ID}{Coast ID.}
#'   \item{FID}{FID.}
#'   \item{geometry}{geometry field.}
#' }
#'
#' @source
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0("[COAS_RG_20M_2016_4326.geojson]",
#'       "(https://gisco-services.ec.europa.eu/distribution/v2/",
#'       "coas/geojson/) file."))
#'
#' ```
#'
#' @docType data
#'
#' @seealso [gisco_get_coastallines()]
#'
#' @examples
#' library(sf)
#' data("gisco_coastallines")
#' gisco_coastallines
#'
NULL

#' All NUTS `POLYGON` object
#'
#' A [`sf`][sf::st_sf] object including all NUTS levels as provided by GISCO
#' (2016 version).
#'
#' @family dataset
#'
#' @name gisco_nuts
#'
#' @format
#' A `POLYGON` data frame (resolution: 1:20million, EPSG:4326) object with
#' `r prettyNum(nrow(giscoR::gisco_nuts), big.mark = ",")` rows and
#' 11 variables:
#' \describe{
#'   \item{NUTS_ID}{NUTS identifier.}
#'   \item{LEVL_CODE}{NUTS level code `(0,1,2,3)`.}
#'   \item{URBN_TYPE}{Urban Type, see **Details**.}
#'   \item{CNTR_CODE}{Eurostat Country code.}
#'   \item{NAME_LATN}{NUTS name on Latin characters.}
#'   \item{NUTS_NAME}{NUTS name on local alphabet.}
#'   \item{MOUNT_TYPE}{Mount Type, see **Details**.}
#'   \item{COAST_TYPE}{Coast Type, see **Details**.}
#'   \item{FID}{FID.}
#'   \item{geo}{Same as NUTS_ID, provided for compatibility with
#'     \CRANpkg{eurostat}.}
#'   \item{geometry}{geometry field.}
#' }
#'
#' @details
#'
#' **MOUNT_TYPE**: Mountain typology:
#'  - `1`: More than 50 % of the surface is covered by topographic mountain
#'    areas.
#'  - `2`: More than 50 % of the regional population lives in topographic
#'    mountain areas.
#'  - `3`: More than 50 % of the surface is covered by topographic mountain
#'    areas and where more than 50 % of the regional population lives in these
#'    mountain areas.
#'  - `4`: Non-mountain region / other regions.
#'  - `0`: No classification provided.
#'
#' **URBN_TYPE**: Urban-rural typology:
#'  - `1`: Predominantly urban region.
#'  - `2`: Intermediate region.
#'  - `3`: Predominantly rural region.
#'  - `0`: No classification provided.
#'
#' **COAST_TYPE**: Coastal typology:
#'   - `1`: Coastal (on coast).
#'   - `2`: Coastal (less than 50% of population living within 50 km. of the
#'        coastline).
#'   - `3`: Non-coastal region.
#'   - `0`: No classification provided.
#'
#'
#' @source
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0("[NUTS_RG_20M_2016_4326.geojson]",
#'       "(https://gisco-services.ec.europa.eu/distribution/v2/",
#'       "nuts/geojson/) file."))
#'
#' ```
#'
#' @docType data
#'
#' @seealso [gisco_get_nuts()]
#'
#' @examples
#'
#' data("gisco_nuts")
#' head(gisco_nuts)
#'
#' @encoding UTF-8
NULL


#' Data frame with different country code schemes and world regions
#'
#' @name gisco_countrycode
#'
#' @family dataset
#'
#' @description
#' A data frame containing conversions between different country
#' code schemes (Eurostat/ISO2 and 3) as well as geographic regions as
#' provided by the World Bank and the UN (M49). This data set
#' is extracted from \CRANpkg{countrycode} package.
#'
#' @format
#' A data frame object with 249 rows and 13 variables:
#' \describe{
#'   \item{ISO3_CODE}{Eurostat code of each country.}
#'   \item{CNTR_CODE}{ISO 3166-1 alpha-2 code of each country.}
#'   \item{iso2c}{ISO 3166-1 alpha-3 code of each country.}
#'   \item{iso.name.en}{ISO English short name.}
#'   \item{cldr.short.en}{English short name as provided by the Unicode Common
#'     Locale Data Repository.}
#'   \item{continent}{As provided by the World Bank.}
#'   \item{un.region.code}{Numeric region code UN (M49).}
#'   \item{un.region.name}{Region name UN (M49).}
#'   \item{un.regionintermediate.code}{Numeric intermediate Region.}
#'   \item{un.regionintermediate.name}{Intermediate Region name UN (M49).}
#'   \item{un.regionsub.code}{Numeric sub-region code UN (M49).}
#'   \item{un.regionsub.name}{Sub-Region name UN (M49).}
#'   \item{eu}{Logical indicating if the country belongs to the European Union.}
#' }
#'
#' @examples
#'
#' data("gisco_countrycode")
#' dplyr::glimpse(gisco_countrycode)
#'
#' @source [countrycode::codelist] **v1.2.0**.
#'
#' @seealso
#' [gisco_get_countries()] and [countrycode::codelist], included in
#' \CRANpkg{countrycode}.
#'
#' See also the
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0(" [Unicode Common Locale Data Repository]",
#'       "(https://cldr.unicode.org/translation/displaynames/",
#'       "countryregion-territory-names)."))
#'
#' ```
#'
#' @docType data
NULL


#' World countries `POLYGON` [`sf`][sf::st_sf] object 2024
#'
#' @family dataset
#' @family admin
#'
#' @name gisco_countries_2024
#'
#' @description
#' A [`sf`][sf::st_sf] object including all countries as provided by
#' GISCO (2024 version).
#'
#' @format
#' A `MULTIPOLYGON` data frame (resolution: 1:20million, EPSG:4326) object
#' with `r nrow(giscoR::gisco_countries_2024)` rows and variables:
#' \describe{
#'   \item{CNTR_ID}{Country ID as per Eurostat.}
#'   \item{CNTR_NAME}{Official country name on local language.}
#'   \item{NAME_ENGL}{Country name in English.}
#'   \item{NAME_FREN}{Country name in French.}
#'   \item{ISO3_CODE}{ISO 3166-1 alpha-3 code of each country, as provided by
#'   GISCO.}
#'   \item{SVRG_UN}{Sovereign status as per United Nations.}
#'   \item{CAPT}{Capitol city.}
#'   \item{EU_STAT}{European Union member.}
#'   \item{EFTA_STAT}{EFTA member.}
#'   \item{CC_STAT}{EU candidate member.}
#'   \item{NAME_GERM}{Country name in German.}
#'   \item{geometry}{geometry field.}
#' }
#' @examples
#'
#' data("gisco_countries_2024")
#' head(gisco_countries_2024)
#'
#' @source
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0("[CNTR_RG_20M_2024_4326.gpkg]",
#'       "(https://gisco-services.ec.europa.eu/distribution/v2/",
#'       "countries/gpkg/) file."))
#'
#'
#' ```
#'
#' @docType data
#'
#' @seealso [gisco_get_countries()]
#'
#' @encoding UTF-8
NULL
