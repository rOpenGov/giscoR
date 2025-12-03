# All NUTS `POLYGON` object

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
including all NUTS levels as provided by GISCO (2016 version).

## Format

A `POLYGON` data frame (resolution: 1:20million, EPSG:4326) object with
2,016 rows and 11 variables:

- NUTS_ID:

  NUTS identifier.

- LEVL_CODE:

  NUTS level code `(0,1,2,3)`.

- URBN_TYPE:

  Urban Type, see **Details**.

- CNTR_CODE:

  Eurostat Country code.

- NAME_LATN:

  NUTS name on Latin characters.

- NUTS_NAME:

  NUTS name on local alphabet.

- MOUNT_TYPE:

  Mount Type, see **Details**.

- COAST_TYPE:

  Coast Type, see **Details**.

- FID:

  FID.

- geo:

  Same as NUTS_ID, provided for compatibility with
  [eurostat](https://CRAN.R-project.org/package=eurostat).

- geometry:

  geometry field.

## Source

[NUTS_RG_20M_2016_4326.geojson](https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/)
file.

## Details

**MOUNT_TYPE**: Mountain typology:

- `1`: More than 50 % of the surface is covered by topographic mountain
  areas.

- `2`: More than 50 % of the regional population lives in topographic
  mountain areas.

- `3`: More than 50 % of the surface is covered by topographic mountain
  areas and where more than 50 % of the regional population lives in
  these mountain areas.

- `4`: Non-mountain region / other regions.

- `0`: No classification provided.

**URBN_TYPE**: Urban-rural typology:

- `1`: Predominantly urban region.

- `2`: Intermediate region.

- `3`: Predominantly rural region.

- `0`: No classification provided.

**COAST_TYPE**: Coastal typology:

- `1`: Coastal (on coast).

- `2`: Coastal (less than 50% of population living within 50 km. of the
  coastline).

- `3`: Non-coastal region.

- `0`: No classification provided.

## See also

[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.md)

Other dataset:
[`gisco_coastallines`](https://ropengov.github.io/giscoR/reference/gisco_coastallines.md),
[`gisco_countries`](https://ropengov.github.io/giscoR/reference/gisco_countries.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md)

## Examples

``` r
data("gisco_nuts")
head(gisco_nuts)
#> Simple feature collection with 6 features and 10 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -63.08825 ymin: -21.39077 xmax: 55.83808 ymax: 70.08134
#> Geodetic CRS:  WGS 84
#>   NUTS_ID LEVL_CODE URBN_TYPE CNTR_CODE                  NAME_LATN
#> 1      ES         0         0        ES                     ESPAÑA
#> 2      FI         0         0        FI            SUOMI / FINLAND
#> 3      IS         0         0        IS                     ÍSLAND
#> 4     PT2         1         0        PT REGIÃO AUTÓNOMA DOS AÇORES
#> 5      FR         0         0        FR                     FRANCE
#> 6      HR         0         0        HR                   HRVATSKA
#>                    NUTS_NAME MOUNT_TYPE COAST_TYPE FID geo
#> 1                     ESPAÑA          0          0  ES  ES
#> 2            SUOMI / FINLAND          0          0  FI  FI
#> 3                     ÍSLAND          0          0  IS  IS
#> 4 REGIÃO AUTÓNOMA DOS AÇORES          0          0 PT2 PT2
#> 5                     FRANCE          0          0  FR  FR
#> 6                   HRVATSKA          0          0  HR  HR
#>                         geometry
#> 1 MULTIPOLYGON (((4.17069 40....
#> 2 MULTIPOLYGON (((28.8195 69....
#> 3 MULTIPOLYGON (((-21.25398 6...
#> 4 MULTIPOLYGON (((-25.18988 3...
#> 5 MULTIPOLYGON (((55.32105 -2...
#> 6 MULTIPOLYGON (((16.37339 46...
```
