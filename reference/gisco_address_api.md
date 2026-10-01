# GISCO Address API

Functions to interact with the [GISCO Address
API](https://gisco-services.ec.europa.eu/addressapi/docs/screen/home),
which supports geocoding and reverse geocoding with a pan-European
address database.

Each endpoint supported by
[giscoR](https://CRAN.R-project.org/package=giscoR) has a specific
function. See **Details**. Search supports structured queries and
freeform queries with `q`. Autocomplete through `/search?suggest=` is
not implemented in [giscoR](https://CRAN.R-project.org/package=giscoR).

Structured searches support approximate string matching. The API's
freeform query parameter `q` does not support approximate string
matching.

## Usage

``` r
gisco_address_api_search(
  country = NULL,
  province = NULL,
  city = NULL,
  road = NULL,
  housenumber = NULL,
  postcode = NULL,
  verbose = FALSE,
  q = NULL
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

gisco_address_api_most_populated_cell(
  province = NULL,
  city = NULL,
  verbose = FALSE
)
```

## Source

<https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.

## Arguments

- country:

  A country code (`country = "LU"`).

- province:

  A province within a country. This is a generic term whose
  administrative level varies by country. For a list of provinces within
  a country, use the provinces endpoint
  (`gisco_address_api_provinces(country = "LU")`).

- city:

  A city within a province. This is a generic term whose administrative
  level varies by country. For a list of cities within a province, use
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

- q:

  A single non-empty string for a freeform address search, or `NULL` for
  a structured search. The string can contain a street, house number,
  city or postcode. Freeform queries do not support approximate
  matching.

- x, y:

  Longitude and latitude coordinates to convert into human-readable
  addresses. Reverse geocoding returns at most five results.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) in
most cases, except `gisco_address_api_search()`,
`gisco_address_api_reverse()` and `gisco_address_api_bbox()`, which
return an [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object when geometry is available. Searches with no results return an
empty
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).
`gisco_address_api_bbox()` returns `NULL` when no bounding box is found.
Failed requests return `NULL`.

`gisco_address_api_most_populated_cell()` returns a one-row
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) for
the most populated census grid cell, or `NULL` when no cell is found or
the request fails. Its numeric `X` and `Y` columns preserve the API
coordinates, whose CRS is not specified in the API documentation.

## Details

For `gisco_address_api_most_populated_cell()`, supply a non-empty string
for `province` or `city`. If both are supplied, the search is restricted
to the city within the province.

The following table describes the endpoints supported by
[giscoR](https://CRAN.R-project.org/package=giscoR), based on the [GISCO
Address API endpoint
documentation](https://gisco-services.ec.europa.eu/addressapi/docs/screen/endpoints):

|  |  |
|----|----|
| **Endpoint** | **Description** |
| `/countries` | All country codes compatible with the GISCO Address API. Check the coverage map for available countries and see the [list of official country codes](https://style-guide.europa.eu/en/content/-/isg/topic?identifier=annex-a5-list-countries-territories-currencies). |
| `/provinces` | All provinces within the specified country. The endpoint can also retrieve the province for a specified city. |
| `/cities` | All cities within a specified province or country. |
| `/roads` | Roads or streets within a specified city, limited to 1,000 results. |
| `/housenumbers` | House numbers or names within the specified road, limited to 1,000 results. In some countries, an address may not have a road component, so the road can be omitted. |
| `/postcodes` | Postcodes within the specified address component, such as country, province or city, limited to 1,000 results. |
| `/search` | Structured or freeform queries to the address database. Various argument combinations can retrieve addresses that share an address component. **The API returns at most 1,000 addresses**. |
| `/reverse` | Structured addresses for longitude and latitude coordinates, limited to five results. |
| `/bbox` | A [WKT](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry) bounding box for an address component, depending on the specified arguments. |
| `/most-populated-cell` | The most populated census grid cell for a province or city. If both are supplied, the search is restricted to the city within the province. |
| `/copyright` | The copyright text for each available country in the GISCO Address API. |

Use `q` in `gisco_address_api_search()` for a freeform search. Unlike
structured searches, freeform queries do not support approximate
matching. Autocomplete through `/search?suggest=` is not implemented in
[giscoR](https://CRAN.R-project.org/package=giscoR).

The resulting object may include these variables:

|  |  |
|----|----|
| **Property name** | **Description** |
| `LD` | Locator designator, which represents the house number part of the address. |
| `TF` | Thoroughfare, which represents the street or road part of the address. |
| `L0` | Level 0 of the API administrative levels. Values are two-character country codes. |
| `L1` | Level 1 of the API administrative levels. Values are province names. "Province" is a generic term that may vary by country. |
| `L2` | Level 2 of the API administrative levels. Values are town or city names. "City" is a generic term that may vary by country. |
| `I3` | ISO 3166-1 alpha-3 country code. |
| `PC` | Postal code. |
| `N0` | NUTS 0. |
| `N1` | NUTS 1. |
| `N2` | NUTS 2. |
| `N3` | NUTS 3. |
| `X` and `Y` | Numeric coordinates extracted from the API's `XY` pair. Search and reverse geocoding return longitude and latitude. The most-populated-cell function preserves the API coordinates, whose CRS is not specified in the API documentation. |
| `OL` | The [Open Location Code](https://github.com/google/open-location-code) for the address. |

## See also

[gisco_id_api](https://ropengov.github.io/giscoR/reference/gisco_id_api.md)
for GISCO ID service API lookups.

See the GISCO Address API documentation at
<https://gisco-services.ec.europa.eu/addressapi/docs/screen/home>.

GISCO API tools:
[`gisco_id_api`](https://ropengov.github.io/giscoR/reference/gisco_id_api.md)

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
#> 2 8B    RUE A… LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#> 3 8A    RUE A… LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#> 4 5     RUE A… LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#> # ℹ 2 more variables: Y <dbl>, geometry <POINT [°]>

# Freeform search.
gisco_address_api_search(q = "alphonse weicker luxembourg")
#> Simple feature collection with 40 features and 14 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 5.545892 ymin: 49.61484 xmax: 6.216722 ymax: 49.70204
#> Geodetic CRS:  WGS 84
#> # A tibble: 40 × 15
#>    LD    TF    L2    L1    L0    I3    PC    N0    N1    N2    N3    OL        X
#>  * <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <dbl>
#>  1 8B    RUE … LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#>  2 8A    RUE … LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#>  3 4     RUE … LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#>  4 5     RUE … LUXE… LUXE… LU    LUX   2721  LU    LU0   LU00  LU000 8FX8…  6.17
#>  5 2     RUE … VILL… PROV… BE    BEL   6740  BE    BE3   BE34  BE345 8FX7…  5.55
#>  6 40A   RUE … VILL… PROV… BE    BEL   6740  BE    BE3   BE34  BE345 8FX7…  5.56
#>  7 2     RUE … SAND… LUXE… LU    LUX   5255  LU    LU0   LU00  LU000 8FX8…  6.22
#>  8 1     RUE … SAND… LUXE… LU    LUX   5255  LU    LU0   LU00  LU000 8FX8…  6.22
#>  9 7     RUE … SAND… LUXE… LU    LUX   5255  LU    LU0   LU00  LU000 8FX8…  6.22
#> 10 3     RUE … SAND… LUXE… LU    LUX   5255  LU    LU0   LU00  LU000 8FX8…  6.22
#> # ℹ 30 more rows
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

# Most populated census grid cell in Madrid.
gisco_address_api_most_populated_cell(city = "Madrid")
#> # A tibble: 1 × 7
#>   L1     L2     L0    I3    OL                 X       Y
#>   <chr>  <chr>  <chr> <chr> <chr>          <dbl>   <dbl>
#> 1 MADRID MADRID ES    ESP   CRX2X2X2+X2X 3159500 2027500
```
