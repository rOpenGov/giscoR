# GISCO Address API

Access the [GISCO Address
API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home),
that allows to carry out both geocoding and reverse geocoding using a
pan-european address database.

Each endpoint available is implemented through a specific function, see
**Details**.

The API supports fuzzy searching (also referred to as approximate string
matching) for all parameters of each endpoint.

## Usage

``` r
gisco_address_api_search(
  country = NULL,
  province = NULL,
  city = NULL,
  road = NULL,
  housenumber = NULL,
  postcode = NULL,
  verbose = FALSE
)

gisco_address_api_reverse(x, y, country = NULL, verbose = FALSE)

gisco_address_api_bbox(
  country = NULL,
  province = NULL,
  city = NULL,
  road = NULL,
  postcode = NULL,
  verbose = FALSE
)

gisco_address_api_countries(verbose = FALSE)

gisco_address_api_provinces(country = NULL, city = NULL, verbose = FALSE)

gisco_address_api_cities(country = NULL, province = NULL, verbose = FALSE)

gisco_address_api_roads(
  country = NULL,
  province = NULL,
  city = NULL,
  verbose = FALSE
)

gisco_address_api_housenumbers(
  country = NULL,
  province = NULL,
  city = NULL,
  road = NULL,
  postcode = NULL,
  verbose = FALSE
)

gisco_address_api_postcodes(
  country = NULL,
  province = NULL,
  city = NULL,
  verbose = FALSE
)

gisco_address_api_copyright(verbose = FALSE)
```

## Arguments

- country:

  Country code (`country = "LU"`).

- province:

  A province within a country. For a list of provinces within a certain
  country use the provinces endpoint
  (`gisco_address_api_provinces(country = "LU")`).

- city:

  A city within a province. For a list of cities within a certain
  province use the cities endpoint
  (`gisco_address_api_cities(province = "capellen")`).

- road:

  A road within a city.

- housenumber:

  The house number or house name within a road or street.

- postcode:

  Can be used in combination with the previous parameters.

- verbose:

  logical. If `TRUE` displays informational messages.

- x, y:

  x and y coordinates (as longitude and latitude) to be converted into a
  human-readable address.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) in
most cases, except `gisco_address_api_search()`,
`gisco_address_api_reverse()` and `gisco_address_api_bbox()`, that
return a [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object.

## Details

Brief description of the API endpoints (source [GISCO Address API
Endpoints](https://gisco-services.ec.europa.eu/addressapi/docs/screen/endpoints)):

|                 |                                                                                                                                                                                                                                                                                         |
|-----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Endpoint**    | **Description**                                                                                                                                                                                                                                                                         |
| `/countries`    | Returns all country codes that are compatible with the address API. Check the coverage map for available countries and see [here for a list of official country codes](https://style-guide.europa.eu/en/content/-/isg/topic?identifier=annex-a5-list-countries-territories-currencies). |
| `/provinces`    | Returns all provinces within the specified country. Can also be used to get the province of a specified city.                                                                                                                                                                           |
| `/cities`       | Returns all cities within a specified province or country.                                                                                                                                                                                                                              |
| `/roads`        | Returns all roads or streets within a specified city.                                                                                                                                                                                                                                   |
| `/housenumbers` | Returns all house numbers or names within the specified road. It is possible that in certain countries an address may not have a road component. In this case, if a road is not specified then the number of house numbers returned by **the API is limited to 1000**.                  |
| `/postcodes`    | Returns all postcodes within the specified address component (Country or Province or City).                                                                                                                                                                                             |
| `/search`       | The search endpoint allows structured queries to the address database. Please note that various combinations of each of the parameters can be used in order to retrieve the addresses that share an address component. **The API is limited to a maximum of 100 addresses**.            |
| `/reverse`      | The API's reverse theme allows you to specify x and y coordinates in order to retrieve a structured address.                                                                                                                                                                            |
| `/bbox`         | Returns a [WKT](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry) bounding box for an address component depending on the parameters specified.                                                                                                                  |
| `/copyright`    | Returns the copyright text for each available country in the Address API.                                                                                                                                                                                                               |

The resulting object may present the following variables:

|                   |                                                                                                                                                                 |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Property name** | **Description**                                                                                                                                                 |
| `LD`              | Refers to "Locator Designator" and represents the house number part of the address                                                                              |
| `TF`              | Refers to "Thoroughfare" and represents the street or road part of the address                                                                                  |
| `L0`              | Refers to Level 0 of the API administrative levels. Values are country codes consisting of 2 characters.                                                        |
| `L1`              | Refers to Level 1 of the API administrative levels. Values are province names. Please note that "province" is a generic term that may differ between countries. |
| `L2`              | Refers to Level 2 of the API administrative levels. Values are town or city names. Please note that "city" is a generic term that may differ between countries. |
| `PC`              | Postal Code                                                                                                                                                     |
| `N0`              | Refers to "NUTS 0"                                                                                                                                              |
| `N1`              | Refers to "NUTS 1"                                                                                                                                              |
| `N2`              | Refers to "NUTS 2"                                                                                                                                              |
| `N3`              | Refers to "NUTS 3"                                                                                                                                              |
| `X` and `Y`       | Refers to the x and y coordinates of the address point                                                                                                          |
| `OL`              | Refers to the address' [Open Location Code](https://github.com/google/open-location-code)                                                                       |

## See also

See the docs:
<https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.

## Examples

``` r
# \donttest{
# Cities in a region

gisco_address_api_cities(country = "PT", province = "LISBOA")
#> # A tibble: 9 × 1
#>   L2                 
#>   <chr>              
#> 1 AMADORA            
#> 2 CASCAIS            
#> 3 LISBOA             
#> 4 LOURES             
#> 5 MAFRA              
#> 6 ODIVELAS           
#> 7 OEIRAS             
#> 8 SINTRA             
#> 9 VILA FRANCA DE XIRA


# Geocode and reverse geocode with sf objects
# Structured search
struct <- gisco_address_api_search(
  country = "ES", city = "BARCELONA",
  road = "GRACIA"
)

struct
#> Simple feature collection with 80 features and 13 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 2.145219 ymin: 41.39211 xmax: 2.16427 ymax: 41.39642
#> Geodetic CRS:  WGS 84
#> # A tibble: 80 × 14
#>    LD    TF    L2    L1    L0    PC    N0    N1    N2    N3    OL        X     Y
#>  * <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <dbl> <dbl>
#>  1 1     CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#>  2 3     CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#>  3 7     CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#>  4 8     CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#>  5 9     CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#>  6 10    CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#>  7 11    CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#>  8 12    CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#>  9 14    CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#> 10 16    CL T… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#> # ℹ 70 more rows
#> # ℹ 1 more variable: geometry <POINT [°]>

# Reverse geocoding
reverse <- gisco_address_api_reverse(x = struct$X[1], y = struct$Y[1])

reverse
#> Simple feature collection with 5 features and 13 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 2.145121 ymin: 41.39326 xmax: 2.145538 ymax: 41.39367
#> Geodetic CRS:  WGS 84
#> # A tibble: 5 × 14
#>   LD    TF     L2    L1    L0    PC    N0    N1    N2    N3    OL        X     Y
#> * <chr> <chr>  <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <dbl> <dbl>
#> 1 1     CL TR… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#> 2 1     CL CA… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#> 3 3     CL TR… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#> 4 2     CL CA… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#> 5 7     CL TR… BARC… CATA… ES    8021  ES    ES5   ES51  ES511 8FH4…  2.15  41.4
#> # ℹ 1 more variable: geometry <POINT [°]>
# }
```
