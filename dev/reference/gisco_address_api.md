# GISCO Address API

Functions to interact with the [GISCO Address
API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home),
which supports geocoding and reverse geocoding with a pan-European
address database.

Each endpoint is implemented through a specific function. See
**Details**.

The API supports fuzzy searching, also referred to as approximate string
matching, for all arguments of each endpoint.

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

  A logical value indicating whether to display informational messages.

- x, y:

  Longitude and latitude coordinates to convert into a human-readable
  address.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) in
most cases, except `gisco_address_api_search()`,
`gisco_address_api_reverse()` and `gisco_address_api_bbox()`, which
return a [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object.

## Details

The following table describes the API endpoints, based on the [GISCO
Address API endpoint
documentation](https://gisco-services.ec.europa.eu/addressapi/docs/screen/endpoints):

|  |  |
|----|----|
| **Endpoint** | **Description** |
| `/countries` | All country codes compatible with the address API. Check the coverage map for available countries and see the [list of official country codes](https://style-guide.europa.eu/en/content/-/isg/topic?identifier=annex-a5-list-countries-territories-currencies). |
| `/provinces` | All provinces within the specified country. It can also retrieve the province for a specified city. |
| `/cities` | All cities within a specified province or country. |
| `/roads` | All roads or streets within a specified city. |
| `/housenumbers` | All house numbers or names within the specified road. In some countries, an address may not have a road component. If a road is not specified, **the API returns at most 1,000 house numbers**. |
| `/postcodes` | All postcodes within the specified address component, such as country, province or city. |
| `/search` | Structured queries to the address database. Various argument combinations can retrieve addresses that share an address component. **The API returns at most 100 addresses**. |
| `/reverse` | A structured address for longitude and latitude coordinates. |
| `/bbox` | A [WKT](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry) bounding box for an address component, depending on the specified arguments. |
| `/copyright` | The copyright text for each available country in the Address API. |

The resulting object may include these variables:

|  |  |
|----|----|
| **Property name** | **Description** |
| `LD` | Locator designator, which represents the house number part of the address. |
| `TF` | Thoroughfare, which represents the street or road part of the address. |
| `L0` | Level 0 of the API administrative levels. Values are two-character country codes. |
| `L1` | Level 1 of the API administrative levels. Values are province names. "Province" is a generic term that may vary by country. |
| `L2` | Level 2 of the API administrative levels. Values are town or city names. "City" is a generic term that may vary by country. |
| `PC` | Postal code. |
| `N0` | NUTS 0. |
| `N1` | NUTS 1. |
| `N2` | NUTS 2. |
| `N3` | NUTS 3. |
| `X` and `Y` | Longitude and latitude coordinates of the address point. |
| `OL` | The [Open Location Code](https://github.com/google/open-location-code) for the address. |

## See also

See the GISCO Address API documentation at
<https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.

GISCO API tools:
[`gisco_id_api`](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)

## Examples

``` r
# Cities in a region.

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
# Structured search.
struct <- gisco_address_api_search(
  country = "LU", city = "Luxembourg",
  road = "Rue Alphonse Weicker"
)

struct
#> Simple feature collection with 4 features and 14 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 6.168695 ymin: 49.63166 xmax: 6.169666 ymax: 49.63328
#> Geodetic CRS:  WGS 84
#> # A tibble: 4 × 15
#>   LD    TF     L2    L1    L0    I3    PC    N0    N1    N2    N3    OL        X
#> * <chr> <chr>  <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <dbl>
#> 1 4     RUE A… LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#> 2 8A    RUE A… LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#> 3 8B    RUE A… LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#> 4 5     RUE A… LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#> # ℹ 2 more variables: Y <dbl>, geometry <POINT [°]>

# Reverse geocoding.
reverse <- gisco_address_api_reverse(x = struct$X[1], y = struct$Y[1])

reverse
#> Simple feature collection with 5 features and 14 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 6.16786 ymin: 49.6315 xmax: 6.169307 ymax: 49.63328
#> Geodetic CRS:  WGS 84
#> # A tibble: 5 × 15
#>   LD    TF     L2    L1    L0    I3    PC    N0    N1    N2    N3    OL        X
#> * <chr> <chr>  <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <dbl>
#> 1 4     RUE A… LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#> 2 3     RUE J… LUXE… LUXE… LU    LUX   2180  LU    LU0   LU00  LU000 8FX8…  6.17
#> 3 41B   AVENU… LUXE… LUXE… LU    LUX   1855  LU    LU0   LU00  LU000 8FX8…  6.17
#> 4 2     RUE J… LUXE… LUXE… LU    LUX   2180  LU    LU0   LU00  LU000 8FX8…  6.17
#> 5 5     RUE A… LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#> # ℹ 2 more variables: Y <dbl>, geometry <POINT [°]>
```
