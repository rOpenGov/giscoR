# GISCO Address API

Functions to interact with the [GISCO Address
API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home),
which supports geocoding and reverse geocoding with a pan-European
address database.

Each endpoint is implemented through a specific function. See
**Details**.

The API supports fuzzy searching (also referred to as approximate string
matching) for all arguments of each endpoint.

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

## Source

<https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.

## Arguments

- country:

  A country code (`country = "LU"`).

- province:

  A province within a country. For a list of provinces within a country,
  use the provinces endpoint
  (`gisco_address_api_provinces(country = "LU")`).

- city:

  A city within a province. For a list of cities within a province, use
  the cities endpoint
  (`gisco_address_api_cities(province = "capellen")`).

- road:

  A road within a city.

- housenumber:

  The house number or house name within a road or street.

- postcode:

  A postcode to use with the previous arguments.

- verbose:

  A logical value. If `TRUE` displays informational messages.

- x, y:

  Longitude and latitude coordinates to convert into a human-readable
  address.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) in
most cases, except `gisco_address_api_search()`,
`gisco_address_api_reverse()`, and `gisco_address_api_bbox()`, which
return a [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object.

## Details

The following table describes the API endpoints, based on the [GISCO
Address API
endpoints](https://gisco-services.ec.europa.eu/addressapi/docs/screen/endpoints):

|  |  |
|----|----|
| **Endpoint** | **Description** |
| `/countries` | All country codes compatible with the address API. Check the coverage map for available countries and see the [list of official country codes](https://style-guide.europa.eu/en/content/-/isg/topic?identifier=annex-a5-list-countries-territories-currencies). |
| `/provinces` | All provinces within the specified country. It can also retrieve the province of a specified city. |
| `/cities` | All cities within a specified province or country. |
| `/roads` | All roads or streets within a specified city. |
| `/housenumbers` | All house numbers or names within the specified road. In some countries, an address may not have a road component. If a road is not specified, **the API returns at most 1,000 house numbers**. |
| `/postcodes` | All postcodes within the specified address component: country, province or city. |
| `/search` | Structured queries to the address database. Various argument combinations can retrieve addresses that share an address component. **The API returns at most 100 addresses**. |
| `/reverse` | A structured address for longitude and latitude coordinates. |
| `/bbox` | A [WKT](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry) bounding box for an address component, depending on the arguments specified. |
| `/copyright` | The copyright text for each available country in the Address API. |

The resulting object may include these variables:

|  |  |
|----|----|
| **Property name** | **Description** |
| `LD` | Locator designator, which represents the house number part of the address. |
| `TF` | Thoroughfare, which represents the street or road part of the address. |
| `L0` | Level 0 of the API administrative levels. Values are two-character country codes. |
| `L1` | Level 1 of the API administrative levels. Values are province names. "Province" is a generic term that may differ between countries. |
| `L2` | Level 2 of the API administrative levels. Values are town or city names. "City" is a generic term that may differ between countries. |
| `PC` | Postal code. |
| `N0` | NUTS 0. |
| `N1` | NUTS 1. |
| `N2` | NUTS 2. |
| `N3` | NUTS 3. |
| `X` and `Y` | Longitude and latitude coordinates of the address point. |
| `OL` | The [Open Location Code](https://github.com/google/open-location-code) for the address. |

## See also

See the docs at
<https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.

Other API tools:
[`gisco_id_api`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)

## Examples

``` r
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

# Geocode and reverse geocode with `sf` objects.
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
```
