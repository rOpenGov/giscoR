# World countries `POLYGON` [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object 2024

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
including all countries as provided by GISCO (2024 version).

## Format

A `MULTIPOLYGON` data frame (resolution: 1:20million, EPSG:4326) object
with 260 rows and variables:

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

Other dataset:
[`gisco_coastallines`](https://ropengov.github.io/giscoR/reference/gisco_coastallines.md),
[`gisco_countries`](https://ropengov.github.io/giscoR/reference/gisco_countries.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/reference/gisco_db.md),
[`gisco_nuts`](https://ropengov.github.io/giscoR/reference/gisco_nuts.md)

## Examples

``` r
data("gisco_countries_2024")
head(gisco_countries_2024)
#> Simple feature collection with 6 features and 11 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -180 ymin: -89 xmax: 179.7788 ymax: 42.6412
#> Geodetic CRS:  WGS 84
#> # A tibble: 6 × 12
#>   CNTR_ID CNTR_NAME          NAME_ENGL NAME_FREN ISO3_CODE SVRG_UN CAPT  EU_STAT
#>   <chr>   <chr>              <chr>     <chr>     <chr>     <chr>   <chr> <chr>  
#> 1 AQ      Antarctica         Antarcti… Antarcti… ATA       Sovere… NA    F      
#> 2 AR      Argentina          Argentina Argentine ARG       UN Mem… Buen… F      
#> 3 AS      American Samoa-Sā… American… Samoa am… ASM       US Non… Pago… F      
#> 4 AD      Andorra            Andorra   Andorre   AND       UN Mem… Ando… F      
#> 5 AE      الإمارات العربية … United A… Émirats … ARE       UN Mem… Abu … F      
#> 6 AF      افغانستان-افغانست… Afghanis… Afghanis… AFG       UN Mem… Kabul F      
#> # ℹ 4 more variables: EFTA_STAT <chr>, CC_STAT <chr>, NAME_GERM <chr>,
#> #   geometry <MULTIPOLYGON [°]>
```
