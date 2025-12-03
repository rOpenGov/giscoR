# Education services in Europe

This dataset is an integration of Member States official data on the
location of education services. Additional information on these services
is included when available (see **Details**).

## Usage

``` r
gisco_get_education(
  year = c(2023, 2020),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL
)
```

## Source

<https://ec.europa.eu/eurostat/web/gisco/geodata/basic-services>

There are no specific download rules for the datasets shown below.
However, please refer to [the general copyright
notice](https://ec.europa.eu/eurostat/web/gisco/geodata) and licence
provisions, which must be complied with. Permission to download and use
these data is subject to these rules being accepted.

The data are extracted from official national registers. They may
contain inconsistencies, inaccuracies and gaps, due to the heterogeneity
of the input national data.

## Arguments

- year:

  character string or number. Release year of the file. One of `2023`,
  `2020`.

- cache:

  logical. Whether to do caching. Default is `TRUE`. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  logical. Should the cached file be refreshed?. Default is `FALSE`.
  When set to `TRUE` it would force a new download.

- cache_dir:

  character string. A path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- verbose:

  logical. If `TRUE` displays informational messages.

- country:

  character vector of country codes. It could be either a vector of
  country names, a vector of ISO3 country codes or a vector of Eurostat
  country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

Files are distributed [EPSG:4326](https://epsg.io/4326).

Brief description of each attribute:

|                  |                                                                                                                  |
|------------------|------------------------------------------------------------------------------------------------------------------|
| **Attribute**    | **Description**                                                                                                  |
| `id`             | The education service identifier. This identifier is based on national identification codes, if it exists.       |
| `name`           | The name of the education institution.                                                                           |
| `site_name`      | The name of the specific site or branch of an education institution.                                             |
| `lat`            | Latitude (WGS 84).                                                                                               |
| `lon`            | Longitude (WGS 84).                                                                                              |
| `street`         | Street name.                                                                                                     |
| `house_number`   | House number.                                                                                                    |
| `postcode`       | Postcode.                                                                                                        |
| `address`        | Address information when the different components of the address are not separated in the source.                |
| `city`           | City name (sometimes refers to a region or municipality).                                                        |
| `cntr_id`        | Country code (2 letters, ISO 3166-1 alpha-2).                                                                    |
| `levels`         | Education levels represented by a single integer or range (ISCED 2011).                                          |
| `max_students`   | Measure of capacity by maximum number of students.                                                               |
| `enrollment`     | Measure of capacity by number of enrolled students.                                                              |
| `fields`         | Academic disciplines the institution specializes in (ISCED-F 2013).                                              |
| `facility_type`  | Type of institution in reference to ownership and operation e.g. Catholic, International, etc.                   |
| `public_private` | The public or private status of the education service.                                                           |
| `tel`            | Telephone number.                                                                                                |
| `email`          | Email address.                                                                                                   |
| `url`            | URL link to the institution’s website.                                                                           |
| `ref_date`       | The reference date (`DD/MM/YYYY`) the data refers to. The dataset represents the reality as it was at this date. |
| `geo_qual`       | Geolocation quality indicator: 1=Good, 2=Medium, 3=Low, 4=From source, -1=Unknown, -2=Not geocoded.              |
| `comments`       | Some additional information on the education service.                                                            |

## See also

Other basic services datasets:
[`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md)

## Examples

``` r
# \donttest{
edu_BEL <- gisco_get_education(country = "Belgium")
edu_BEL
#> Simple feature collection with 11616 features and 24 fields (with 1 geometry empty)
#> Geometry type: GEOMETRY
#> Dimension:     XY
#> Bounding box:  xmin: 2.585864 ymin: 49.52634 xmax: 6.141682 ymax: 51.4919
#> Geodetic CRS:  WGS 84
#> # A tibble: 11,616 × 25
#>    id     name  site_name   lat   lon street house_number postcode address city 
#>  * <chr>  <chr> <chr>     <dbl> <dbl> <chr>  <chr>        <chr>    <chr>   <chr>
#>  1 BE_F0… Midd… NA         51.0  5.35 KEMPI… 400          3500     NA      HASS…
#>  2 BE_F0… Midd… NA         50.9  5.32 KLEIN… 7            3500     NA      HASS…
#>  3 BE_F0… Mosa… NA         51.1  5.74 KLOOS… 14           3640     NA      KINR…
#>  4 BE_F0… Onze… NA         51.0  3.14 MANDE… 170          8800     NA      ROES…
#>  5 BE_F0… Vrij… NA         50.9  3.12 BLEKE… 77           8800     NA      ROES…
#>  6 BE_F0… Heil… NA         51.0  3.20 WEZES… 2            8850     NA      ARDO…
#>  7 BE_F0… Insp… NA         51.0  5.37 LYCEU… 11           3530     NA      HOUT…
#>  8 BE_F0… Insp… NA         51.0  5.37 HEREB… 41           3530     NA      HOUT…
#>  9 BE_F0… Insp… NA         51.0  5.37 HEREB… 41           3530     NA      HOUT…
#> 10 BE_F0… Virg… NA         50.9  5.34 GUFFE… 27           3500     NA      HASS…
#> # ℹ 11,606 more rows
#> # ℹ 15 more variables: cntr_id <chr>, levels <chr>, max_students <chr>,
#> #   enrollment <chr>, fields <chr>, facility_type <chr>, public_private <chr>,
#> #   tel <chr>, email <chr>, url <chr>, ref_date <chr>, pub_date <chr>,
#> #   geo_qual <chr>, comments <chr>, geometry <POINT [°]>
# }
```
