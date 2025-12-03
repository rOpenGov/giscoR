# NUTS 2024 [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object

This dataset represents the regions for levels 0, 1, 2 and 3 of the
Nomenclature of Territorial Units for Statistics (NUTS) for 2024.

## Format

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object with
`MULTIPOLYGON` geometries, resolution: 1:20 million and
[EPSG:4326](https://epsg.io/4326). with 263 rows and 10 variables:

- `NUTS_ID`:

  NUTS identifier.

- `LEVL_CODE`:

  NUTS level code `(0,1,2,3)`.

- `CNTR_CODE`:

  Eurostat Country code.

- `NAME_LATN`:

  NUTS name on Latin characters.

- `NUTS_NAME`:

  NUTS name on local alphabet.

- `MOUNT_TYPE`:

  Mount Type, see **Details**.

- `URBN_TYPE`:

  Urban Type, see **Details**.

- `COAST_TYPE`:

  Coast Type, see **Details**.

- `geo`:

  Same as `NUTS_ID`, provided for compatibility with
  [eurostat](https://CRAN.R-project.org/package=eurostat).

- `geometry`:

  geometry field.

## Source

[NUTS_RG_20M_2024_4326.gpkg](https://gisco-services.ec.europa.eu/distribution/v2/nuts/gpkg/)
file.

## Details

`MOUNT_TYPE`: Mountain typology:

- `1`: More than 50 % of the surface is covered by topographic mountain
  areas.

- `2`: More than 50 % of the regional population lives in topographic
  mountain areas.

- `3`: More than 50 % of the surface is covered by topographic mountain
  areas and where more than 50 % of the regional population lives in
  these mountain areas.

- `4`: Non-mountain region / other regions.

- `0`: No classification provided.

`URBN_TYPE`: Urban-rural typology:

- `1`: Predominantly urban region.

- `2`: Intermediate region.

- `3`: Predominantly rural region.

- `0`: No classification provided.

`COAST_TYPE`: Coastal typology:

- `1`: Coastal (on coast).

- `2`: Coastal (less than 50% of population living within 50 km. of the
  coastline).

- `3`: Non-coastal region.

- `0`: No classification provided.

## See also

[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)

Other datasets:
[`gisco_coastal_lines`](https://ropengov.github.io/giscoR/dev/reference/gisco_coastal_lines.md),
[`gisco_countries_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries_2024.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md)

## Examples

``` r
data("gisco_nuts_2024")
head(gisco_nuts_2024)
#> Simple feature collection with 6 features and 9 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 19.30265 ymin: 40.72684 xmax: 20.59774 ymax: 42.63906
#> Geodetic CRS:  WGS 84
#> # A tibble: 6 × 10
#>   NUTS_ID LEVL_CODE CNTR_CODE NAME_LATN NUTS_NAME MOUNT_TYPE URBN_TYPE
#>   <chr>       <int> <chr>     <chr>     <chr>          <int>     <int>
#> 1 AL011           3 AL        Dibër     Dibër             NA        NA
#> 2 AL012           3 AL        Durrës    Durrës            NA        NA
#> 3 AL013           3 AL        Kukës     Kukës             NA        NA
#> 4 AL014           3 AL        Lezhë     Lezhë             NA        NA
#> 5 AL015           3 AL        Shkodër   Shkodër           NA        NA
#> 6 AL021           3 AL        Elbasan   Elbasan           NA        NA
#> # ℹ 3 more variables: COAST_TYPE <int>, geo <chr>, geometry <MULTIPOLYGON [°]>
```
