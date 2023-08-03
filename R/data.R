#' GISCO database
#'
#' Database with the list of files that the package can load.
#'
#' @concept dataset
#'
#' @name gisco_db
#'
#' @docType data
#'
#' @format A data frame
#'
#' @details This dataframe is used to check the validity of the API calls.
#'
#' @source GISCO API `datasets.json`.
#' @keywords internal
#' @examples
#'
#' data(gisco_db)
NULL

#' World countries `POLYGON` object
#'
#' @family dataset
#'
#' @name gisco_countries
#'
#' @description A `sf` object including all
#' countries as provided by GISCO (2016 version).
#'
#' @format
#' A `MULTIPOLYGON` data frame (resolution: 1:20million, EPSG:4326) object
#' with `r nrow(giscoR::gisco_countries)` rows and 7 variables:
#' \describe{
#'   \item{id}{row ID}
#'   \item{CNTR_NAME}{Official country name on local language}
#'   \item{ISO3_CODE}{ISO 3166-1 alpha-3 code of each country, as provided by
#'   GISCO}
#'   \item{CNTR_ID}{Country ID}
#'   \item{NAME_ENGL}{Country name in English}
#'   \item{FID}{FID}
#'   \item{geometry}{geometry field}
#' }
#' @examples
#'
#' cntry <- gisco_countries
#' GBR <- subset(cntry, ISO3_CODE == "GBR")
#'
#' library(ggplot2)
#'
#' ggplot(GBR) +
#'   geom_sf(color = "red3", fill = "blue4") +
#'   theme_void()
#' @source
#' [CNTR_RG_20M_2016_4326.geojson](https://gisco-services.ec.europa.eu/distribution/v2/countries/geojson/)
#' file.
#'
#' @docType data
#'
#' @seealso [gisco_get_countries()]
#'
#' @encoding UTF-8
NULL

#' World coastal lines `POLYGON` object
#'
#' A `sf` object as provided by GISCO (2016 version).
#'
#' @family dataset
#'
#' @name gisco_coastallines
#'
#' @format
#' A `POLYGON` data frame (resolution: 1:20million, EPSG:4326) object with
#' 3 variables:
#' \describe{
#'   \item{COAS_ID}{Coast ID}
#'   \item{FID}{FID}
#'   \item{geometry}{geometry field}
#' }
#'
#' @source
#' [COAS_RG_20M_2016_4326.geojson](https://gisco-services.ec.europa.eu/distribution/v2/coas/geojson/)
#' file.
#'
#' @docType data
#'
#' @seealso [gisco_get_coastallines()]
#'
#' @examples
#'
#' coasts <- gisco_coastallines
#'
#' library(ggplot2)
#'
#' ggplot(coasts) +
#'   geom_sf(color = "blue", fill = "blue", alpha = 0.2) +
#'   # Zoom on Oceania
#'   coord_sf(
#'     xlim = c(96, 179),
#'     ylim = c(-51, 11)
#'   ) +
#'   theme_minimal() +
#'   theme(
#'     plot.background = element_rect(
#'       fill = "black",
#'       color = "black"
#'     ),
#'     panel.grid = element_blank(),
#'     axis.text = element_text(colour = "grey90")
#'   )
NULL

#' All NUTS `POLYGON` object
#'
#' A `sf` object including all NUTS levels as provided by GISCO (2016 version).
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
#'   \item{NUTS_ID}{NUTS identifier}
#'   \item{LEVL_CODE}{NUTS level code (0,1,2,3)}
#'   \item{URBN_TYPE}{Urban Type, see Details}
#'   \item{CNTR_CODE}{Eurostat Country code}
#'   \item{NAME_LATN}{NUTS name on Latin characters}
#'   \item{NUTS_NAME}{NUTS name on local alphabet}
#'   \item{MOUNT_TYPE}{Mount Type, see Details}
#'   \item{COAST_TYPE}{Coast Type, see Details}
#'   \item{FID}{FID}
#'   \item{geo}{Same as NUTS_ID, provided for compatibility with
#'     \CRANpkg{eurostat}}
#'   \item{geometry}{geometry field}
#' }
#'
#' @details
#'
#' **MOUNT_TYPE**: Mountain typology:
#'  - 1: More than 50 % of the surface is covered by topographic mountain areas.
#'  - 2: More than 50 % of the regional population lives in topographic
#'    mountain areas.
#'  - 3: More than 50 % of the surface is covered by topographic mountain areas
#'    and where more than 50 % of the regional population lives in these
#'    mountain areas.
#'  - 4: Non-mountain region / other regions.
#'  - 0: No classification provided
#'
#' **URBN_TYPE**: Urban-rural typology:
#'  - 1: Predominantly urban region.
#'  - 2: Intermediate region.
#'  - 3: Predominantly rural region.
#'  - 0: No classification provided
#'
#' **COAST_TYPE**: Coastal typology:
#'   - 1: Coastal (on coast).
#'   - 2: Coastal (less than 50% of population living within 50 km. of the
#'        coastline).
#'   - 3: Non-coastal region.
#'   - 0: No classification provided
#'
#'
#' @source
#' [NUTS_RG_20M_2016_4326.geojson](https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/)
#' file.
#'
#' @docType data
#'
#' @seealso [gisco_get_nuts()]
#'
#' @examples
#'
#' nuts <- gisco_nuts
#'
#' italy <- subset(nuts, CNTR_CODE == "IT" & LEVL_CODE == 3)
#'
#' library(ggplot2)
#'
#' ggplot(italy) +
#'   geom_sf()
#' @encoding UTF-8
NULL


#' Dataframe with different country code schemes and world regions
#'
#' @name gisco_countrycode
#'
#' @family dataset
#'
#' @description
#' A dataframe containing conversions between different country
#' code schemes (Eurostat/ISO2 and 3) as well as geographic regions as
#' provided by the World Bank and the UN (M49). This dataset
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
#'   \item{eu}{Logical indicating if the country belongs to the European.}
#' }
#'
#' @examples
#'
#' data(gisco_countrycode)
#' @source [countrycode::codelist] **v1.2.0**.
#'
#' @seealso [gisco_get_countries()],
#'  [countrycode::codelist], [countrycode::countrycode-package]
#'
#' See also the [Unicode Common Locale Data
#' Repository](https://cldr.unicode.org/translation/displaynames/countryregion-territory-names).
#'
#' @docType data
NULL

#' Disposable income of private households by NUTS 2 regions
#'
#' @name tgs00026
#'
#' @family dataset
#'
#' @source <https://ec.europa.eu/eurostat>, extracted on 2020-10-27
#'
#' @description
#' The disposable income of private households is the balance
#' of primary income (operating surplus/mixed income plus compensation of
#' employees plus property income received minus property income paid) and
#' the redistribution of income in cash. These transactions comprise social
#' contributions paid, social benefits in cash received, current taxes on
#' income and wealth paid, as well as other current transfers. Disposable
#' income does not include social transfers in kind coming from public
#' administrations or non-profit institutions serving households.
#' @format
#' data_frame:
#' \describe{
#'   \item{geo}{NUTS2 identifier}
#'   \item{time}{reference year (2007 to 2018)}
#'   \item{values}{value in euros}
#' }
#'
#' @examples
#'
#' data(tgs00026)
#' @docType data
NULL
