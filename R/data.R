#' Cached GISCO database
#'
#' Database with the list of files in the GISCO geodata distribution as of
#' `r unique(giscoR::gisco_db$last_updated)`.
#'
#' @name gisco_db
#' @docType data
#' @family datasets
#' @family database
#' @encoding UTF-8
#'
#' @format
#' A [tibble][tibble::tbl_df] with
#' `r prettyNum(nrow(giscoR::gisco_db), big.mark = ",")` rows.
#'
#' @details
#' This database is used to redirect the corresponding functions to the
#' correct API endpoints.
#'
#' This version of the database is used if there is a problem during update.
#' Please use [gisco_get_cached_db()] with `update_cache = TRUE` to update the
#' corresponding API endpoints.
#'
#' @source GISCO geodata distribution `datasets.json`.
#' @examples
#' data("gisco_db")
#' gisco_db |>
#'   dplyr::glimpse()
NULL

#' Countries 2024 [`sf`][sf::st_sf] object
#'
#' @description
#' This object contains world administrative boundaries at the country level.
#'
#' @name gisco_countries_2024
#' @docType data
#' @family datasets
#' @encoding UTF-8
#'
#' @format
#' A [`sf`][sf::st_sf] object with `MULTIPOLYGON` geometries, resolution:
#' 1:20 million and [EPSG:4326](https://epsg.io/4326). It has
#' `r nrow(giscoR::gisco_countries_2024)` rows and 12 variables:
#' \describe{
#'   \item{`CNTR_ID`}{Country ID from Eurostat.}
#'   \item{`CNTR_NAME`}{Official country name in local language.}
#'   \item{`NAME_ENGL`}{Country name in English.}
#'   \item{`NAME_FREN`}{Country name in French.}
#'   \item{`ISO3_CODE`}{ISO 3166-1 alpha-3 code of each country from
#'   GISCO.}
#'   \item{`SVRG_UN`}{Sovereign status according to the United Nations.}
#'   \item{`CAPT`}{Capital city.}
#'   \item{`EU_STAT`}{European Union member.}
#'   \item{`EFTA_STAT`}{EFTA member.}
#'   \item{`CC_STAT`}{EU candidate member.}
#'   \item{`NAME_GERM`}{Country name in German.}
#'   \item{`geometry`}{Geometry field.}
#' }
#' @source
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0("[CNTR_RG_20M_2024_4326.gpkg]",
#'       "(https://gisco-services.ec.europa.eu/distribution/v2/",
#'       "countries/gpkg/) file."))
#'
#' ```
#' @seealso [gisco_get_countries()]
#'
#' @examples
#'
#' data("gisco_countries_2024")
#' head(gisco_countries_2024)
#'
NULL

#' Database with different country code schemes and world regions
#'
#' @description
#' A [tibble][tibble::tbl_df] containing conversions between country code
#' schemes (Eurostat, ISO 3166-1 alpha-2 and ISO 3166-1 alpha-3) and
#' geographic regions from the World Bank and the UN
#' ([M49 Standard](https://unstats.un.org/unsd/methodology/m49/)). This
#' database was extracted from the \CRANpkg{countrycode} package.
#'
#' @name gisco_countrycode
#' @docType data
#' @family datasets
#' @encoding UTF-8
#'
#' @format
#' A data frame with
#' `r prettyNum(nrow(giscoR::gisco_countrycode), big.mark = ",")` rows and 13
#' variables:
#' \describe{
#'   \item{`ISO3_CODE`}{Eurostat code of each country.}
#'   \item{`CNTR_CODE`}{ISO 3166-1 alpha-2 code of each country.}
#'   \item{`iso2c`}{ISO 3166-1 alpha-2 code of each country.}
#'   \item{`iso.name.en`}{ISO English short name.}
#'   \item{`cldr.short.en`}{English short name as provided by the Unicode
#'     Common Locale Data Repository.}
#'   \item{`continent`}{Continent from the World Bank.}
#'   \item{`un.region.code`}{Numeric region code UN (M49).}
#'   \item{`un.region.name`}{Region name UN (M49).}
#'   \item{`un.regionintermediate.code`}{Numeric intermediate region.}
#'   \item{`un.regionintermediate.name`}{Intermediate region name UN (M49).}
#'   \item{`un.regionsub.code`}{Numeric sub-region code UN (M49).}
#'   \item{`un.regionsub.name`}{Sub-region name UN (M49).}
#'   \item{`eu`}{Logical value indicating whether the country belongs to the
#'     European Union.}
#' }
#'
#' @inheritSection gisco_get_countries World Regions
#'
#' @source [countrycode::codelist] **v1.6.1**.
#'
#' @seealso
#' [gisco_get_countries()], [countrycode::codelist].
#'
#' See also
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(" [Unicode Common Locale Data Repository]",
#'       "(https://cldr.unicode.org/translation/displaynames/",
#'       "countryregion-territory-names)."))
#'
#' ```
#'
#' @examples
#' data("gisco_countrycode")
#' dplyr::glimpse(gisco_countrycode)
NULL

#' Coastal lines 2016 [`sf`][sf::st_sf] object
#'
#' @description
#' This object contains the coastal lines of the world.
#'
#' @name gisco_coastal_lines
#' @docType data
#' @family datasets
#' @encoding UTF-8
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
#' @seealso [gisco_get_coastal_lines()]
#'
#' @examples
#' library(sf)
#' data("gisco_coastal_lines")
#' gisco_coastal_lines
#'
NULL

#' NUTS 2024 [`sf`][sf::st_sf] object
#'
#' @description
#' This dataset represents the regions for levels 0, 1, 2 and 3 of the
#' Nomenclature of Territorial Units for Statistics (NUTS) for 2024.
#'
#' @name gisco_nuts_2024
#' @docType data
#' @family datasets
#' @encoding UTF-8
#'
#' @format
#' A [`sf`][sf::st_sf] object with `MULTIPOLYGON` geometries, resolution:
#' 1:20 million and [EPSG:4326](https://epsg.io/4326). It has
#' `r nrow(giscoR::gisco_nuts_2024)` rows and 10 variables:
#' \describe{
#'   \item{`NUTS_ID`}{NUTS identifier.}
#'   \item{`LEVL_CODE`}{NUTS level code `(0,1,2,3)`.}
#'   \item{`CNTR_CODE`}{Eurostat country code.}
#'   \item{`NAME_LATN`}{NUTS name in Latin characters.}
#'   \item{`NUTS_NAME`}{NUTS name in the local alphabet.}
#'   \item{`MOUNT_TYPE`}{Mountain type, see **Details**.}
#'   \item{`URBN_TYPE`}{Urban type, see **Details**.}
#'   \item{`COAST_TYPE`}{Coastal type, see **Details**.}
#'   \item{`geo`}{Same value as `NUTS_ID`, provided for compatibility with
#'   \CRANpkg{eurostat}.}
#'   \item{`geometry`}{Geometry field.}
#' }
#'
#' @details
#'
#' `MOUNT_TYPE`: Mountain typology:
#' - `1`: More than 50 % of the surface is covered by topographic mountain
#'   areas.
#' - `2`: More than 50 % of the regional population lives in topographic
#'   mountain areas.
#' - `3`: More than 50 % of the surface is covered by topographic mountain
#'   areas and where more than 50 % of the regional population lives in these
#'   mountain areas.
#' - `4`: Non-mountain region / other regions.
#' - `0`: No classification provided.
#'
#' `URBN_TYPE`: Urban-rural typology:
#' - `1`: Predominantly urban region.
#' - `2`: Intermediate region.
#' - `3`: Predominantly rural region.
#' - `0`: No classification provided.
#'
#' `COAST_TYPE`: Coastal typology:
#' - `1`: Coastal (on coast).
#' - `2`: Coastal (less than 50 % of population living within 50 km of the
#'   coastline).
#' - `3`: Non-coastal region.
#' - `0`: No classification provided.
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
#' @seealso [gisco_get_nuts()]
#'
#' @examples
#' data("gisco_nuts_2024")
#' head(gisco_nuts_2024)
#'
NULL
