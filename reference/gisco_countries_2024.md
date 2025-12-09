# Countries 2024 [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object

This object contains the administrative boundaries at country level of
the world.

## Format

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object with
`MULTIPOLYGON` geometries, resolution: 1:20 million and
[EPSG:4326](https://epsg.io/4326). with 263 rows and 12 variables:

- `CNTR_ID`:

  Country ID as per Eurostat.

- `CNTR_NAME`:

  Official country name on local language.

- `NAME_ENGL`:

  Country name in English.

- `NAME_FREN`:

  Country name in French.

- `ISO3_CODE`:

  ISO 3166-1 alpha-3 code of each country, as provided by GISCO.

- `SVRG_UN`:

  Sovereign status as per United Nations.

- `CAPT`:

  Capitol city.

- `EU_STAT`:

  European Union member.

- `EFTA_STAT`:

  EFTA member.

- `CC_STAT`:

  EU candidate member.

- `NAME_GERM`:

  Country name in German.

- `geometry`:

  geometry field.

## Source

[CNTR_RG_20M_2024_4326.gpkg](https://gisco-services.ec.europa.eu/distribution/v2/countries/gpkg/)
file.

## See also

[`gisco_get_countries()`](https://ropengov.github.io/giscoR/reference/gisco_get_countries.md)

Other datasets:
[`gisco_coastal_lines`](https://ropengov.github.io/giscoR/reference/gisco_coastal_lines.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md),
[`gisco_nuts_2024`](https://ropengov.github.io/giscoR/reference/gisco_nuts_2024.md)

## Examples

``` r
data("gisco_countries_2024")
head(gisco_countries_2024)
#> Simple feature collection with 6 features and 11 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 1.442566 ymin: -13.43119 xmax: 74.88986 ymax: 42.6412
#> Geodetic CRS:  WGS 84
#> # A tibble: 6 × 12
#>   CNTR_ID CNTR_NAME          NAME_ENGL NAME_FREN ISO3_CODE SVRG_UN CAPT  EU_STAT
#>   <chr>   <chr>              <chr>     <chr>     <chr>     <chr>   <chr> <chr>  
#> 1 CD      République Démocr… Democrat… Républiq… COD       UN Mem… Kins… F      
#> 2 CF      République Centra… Central … Républiq… CAF       UN Mem… Bang… F      
#> 3 CG      Congo-Kongo-Kongó  Congo     Congo     COG       UN Mem… Braz… F      
#> 4 AD      Andorra            Andorra   Andorre   AND       UN Mem… Ando… F      
#> 5 AE      الإمارات العربية … United A… Émirats … ARE       UN Mem… Abu … F      
#> 6 AF      افغانستان-افغانست… Afghanis… Afghanis… AFG       UN Mem… Kabul F      
#> # ℹ 4 more variables: EFTA_STAT <chr>, CC_STAT <chr>, NAME_GERM <chr>,
#> #   geometry <MULTIPOLYGON [°]>
```
