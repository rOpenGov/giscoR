#' Cached GISCO database
#'
#' Database with the list of files in the GISCO API as of
#' `r unique(giscoR::gisco_db$last_updated)`.
#'
#' @docType data
#' @name gisco_db
#' @family datasets
#' @family database
#' @encoding UTF-8
#'
#' @inherit gisco_get_cached_db source
#'
#' @format
#' A [tibble][tibble::tbl_df] with
#' `r prettyNum(nrow(giscoR::gisco_db), big.mark = ",")` rows.
#'
#' @details
#' This database is used to redirect the corresponding functions to the
#' right API endpoints.
#'
#' This version of the database would be used in case there is any problem on
#' update. Please use [gisco_get_cached_db()] with `update_cache = TRUE` to
#' update the corresponding API endpoints.
#'
#' @source GISCO API `datasets.json`.
#' @examples
#' data("gisco_db")
#' gisco_db |>
#'   dplyr::glimpse()
NULL


#' Countries 2024 [`sf`][sf::st_sf] object
#'
#' @docType data
#' @name gisco_countries_2024
#' @family datasets
#' @encoding UTF-8
#'
#' @seealso [gisco_get_countries()]
#'
#' @description
#' This object contains the administrative boundaries at country level of the
#' world.
#'
#' @format
#' A [`sf`][sf::st_sf] object with `MULTIPOLYGON` geometries, resolution:
#' 1:20 million and [EPSG:4326](https://epsg.io/4326). with
#' `r nrow(giscoR::gisco_countries_2024)` rows and 12 variables:
#' \describe{
#'   \item{`CNTR_ID`}{Country ID as per Eurostat.}
#'   \item{`CNTR_NAME`}{Official country name on local language.}
#'   \item{`NAME_ENGL`}{Country name in English.}
#'   \item{`NAME_FREN`}{Country name in French.}
#'   \item{`ISO3_CODE`}{ISO 3166-1 alpha-3 code of each country, as provided by
#'   GISCO.}
#'   \item{`SVRG_UN`}{Sovereign status as per United Nations.}
#'   \item{`CAPT`}{Capitol city.}
#'   \item{`EU_STAT`}{European Union member.}
#'   \item{`EFTA_STAT`}{EFTA member.}
#'   \item{`CC_STAT`}{EU candidate member.}
#'   \item{`NAME_GERM`}{Country name in German.}
#'   \item{`geometry`}{geometry field.}
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
NULL

#' Database with different country code schemes and world regions
#'
#' @docType data
#' @name gisco_countrycode
#' @family datasets
#' @encoding UTF-8
#'
#' @inheritSection gisco_get_countries World Regions
#'
#' @description
#' A [tibble][tibble::tbl_df] containing conversions between different country
#' code schemes (Eurostat/ISO2 and 3) as well as geographic regions as
#' provided by the World Bank and the UN
#' ([M49 Standard](https://unstats.un.org/unsd/methodology/m49/)). This database
#'  has been extracted from the \CRANpkg{countrycode} package.
#'
#' @source [countrycode::codelist] **v1.6.1**.
#'
#' @seealso
#' [gisco_get_countries()], [countrycode::codelist].
#'
#' See also the
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(" [Unicode Common Locale Data Repository]",
#'       "(https://cldr.unicode.org/translation/displaynames/",
#'       "countryregion-territory-names)."))
#'
#' ```
#'
#' @format
#' A data frame object with
#' `r prettyNum(nrow(giscoR::gisco_countrycode), big.mark = ",")` rows and 13
#' variables:
#' \describe{
#'   \item{`ISO3_CODE`}{Eurostat code of each country.}
#'   \item{`CNTR_CODE`}{ISO 3166-1 alpha-2 code of each country.}
#'   \item{`iso2c`}{ISO 3166-1 alpha-3 code of each country.}
#'   \item{`iso.name.en`}{ISO English short name.}
#'   \item{`cldr.short.en`}{English short name as provided by the Unicode Common
#'     Locale Data Repository.}
#'   \item{`continent`}{As provided by the World Bank.}
#'   \item{`un.region.code`}{Numeric region code UN (M49).}
#'   \item{`un.region.name`}{Region name UN (M49).}
#'   \item{`un.regionintermediate.code`}{Numeric intermediate Region.}
#'   \item{`un.regionintermediate.name`}{Intermediate Region name UN (M49).}
#'   \item{`un.regionsub.code`}{Numeric sub-region code UN (M49).}
#'   \item{`un.regionsub.name`}{Sub-Region name UN (M49).}
#'   \item{`eu`}{Logical indicating if the country belongs to the
#'    European Union.}
#' }
#'
#' @examples
#' data("gisco_countrycode")
#' dplyr::glimpse(gisco_countrycode)
NULL


#' Coastal lines 2016 [`sf`][sf::st_sf] object
#'
#' @docType data
#' @name gisco_coastal_lines
#' @family datasets
#' @encoding UTF-8
#'
#' @seealso [gisco_get_coastal_lines()]
#'
#' @description
#' This object contains the coastal lines of the world.
#'
#' @format
#' A [`sf`][sf::st_sf] object with `POLYGON` geometries, resolution:
#' 1:20 million and [EPSG:4326](https://epsg.io/4326).
#'
#' @source
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0("[COAS_RG_20M_2016_4326.gpkg]",
#'       "(https://gisco-services.ec.europa.eu/distribution/v2/",
#'       "coas/geojson/) file."))
#'
#' ```
#'
#' @examples
#' library(sf)
#' data("gisco_coastal_lines")
#' gisco_coastal_lines
#'
NULL

#' NUTS 2024 [`sf`][sf::st_sf] object
#'
#'
#' @docType data
#' @name gisco_nuts_2024
#' @family datasets
#' @encoding UTF-8
#'
#' @seealso [gisco_get_nuts()]
#'
#' @description
#' This dataset represents the regions for levels 0, 1, 2 and 3 of the
#' Nomenclature of Territorial Units for Statistics (NUTS) for 2024.
#'
#'
#' @format
#' A [`sf`][sf::st_sf] object with `MULTIPOLYGON` geometries, resolution:
#' 1:20 million and [EPSG:4326](https://epsg.io/4326). with
#' `r nrow(giscoR::gisco_nuts_2024)` rows and 10 variables:
#' \describe{
#'   \item{`NUTS_ID`}{NUTS identifier.}
#'   \item{`LEVL_CODE`}{NUTS level code `(0,1,2,3)`.}
#'   \item{`CNTR_CODE`}{Eurostat Country code.}
#'   \item{`NAME_LATN`}{NUTS name on Latin characters.}
#'   \item{`NUTS_NAME`}{NUTS name on local alphabet.}
#'   \item{`MOUNT_TYPE`}{Mount Type, see **Details**.}
#'   \item{`URBN_TYPE`}{Urban Type, see **Details**.}
#'   \item{`COAST_TYPE`}{Coast Type, see **Details**.}
#'   \item{`geo`}{Same as `NUTS_ID`, provided for compatibility with
#'     \CRANpkg{eurostat}.}
#'   \item{`geometry`}{geometry field.}
#' }
#'
#' @details
#'
#' `MOUNT_TYPE`: Mountain typology:
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
#' `URBN_TYPE`: Urban-rural typology:
#'  - `1`: Predominantly urban region.
#'  - `2`: Intermediate region.
#'  - `3`: Predominantly rural region.
#'  - `0`: No classification provided.
#'
#' `COAST_TYPE`: Coastal typology:
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
#' cat(paste0("[NUTS_RG_20M_2024_4326.gpkg]",
#'       "(https://gisco-services.ec.europa.eu/distribution/v2/",
#'       "nuts/gpkg/) file."))
#'
#' ```
#'
#' @examples
#' data("gisco_nuts_2024")
#' head(gisco_nuts_2024)
#'
NULL
