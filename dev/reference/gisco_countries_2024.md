# Countries 2024 [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object

This object contains world administrative boundaries at the country
level.

## Format

An [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object with
`MULTIPOLYGON` geometries, resolution: 1:20 million and
[EPSG:4326](https://epsg.io/4326). It has 263 rows and 12 variables:

- `CNTR_ID`:

  Country ID from Eurostat.

- `CNTR_NAME`:

  Official country name in the local language.

- `NAME_ENGL`:

  Country name in English.

- `NAME_FREN`:

  Country name in French.

- `ISO3_CODE`:

  ISO 3166-1 alpha-3 code of each country from GISCO.

- `SVRG_UN`:

  Sovereign status according to the United Nations.

- `CAPT`:

  Capital city.

- `EU_STAT`:

  European Union member.

- `EFTA_STAT`:

  EFTA member.

- `CC_STAT`:

  EU candidate member.

- `NAME_GERM`:

  Country name in German.

- `geometry`:

  Geometry field.

## Source

[CNTR_RG_20M_2024_4326.gpkg](https://gisco-services.ec.europa.eu/distribution/v2/countries/gpkg/)
file.

## Copyright

See the GISCO administrative unit copyright provisions:
<https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.

## Note

Check the download and usage provisions in
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

[`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)

Included datasets:
[`gisco_coastal_lines`](https://ropengov.github.io/giscoR/dev/reference/gisco_coastal_lines.md),
[`gisco_countrycode`](https://ropengov.github.io/giscoR/dev/reference/gisco_countrycode.md),
[`gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md),
[`gisco_nuts_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts_2024.md)

## Examples

``` r

data("gisco_countries_2024")
head(gisco_countries_2024)
#> Simple feature collection with 6 features and 13 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 1.442566 ymin: -13.43119 xmax: 74.88986 ymax: 42.6412
#> Geodetic CRS:  WGS 84
#> # A tibble: 6 × 14
#>   CNTR_ID COUNTRY_URI CNTR_NAME      NAME_ENGL NAME_FREN ISO3_CODE SVRG_UN CAPT 
#>   <chr>   <chr>       <chr>          <chr>     <chr>     <chr>     <chr>   <chr>
#> 1 CD      COD         Democratic Re… Democrat… Républiq… COD       UN Mem… Kins…
#> 2 CF      CAF         Central Afric… Central … Républiq… CAF       UN Mem… Bang…
#> 3 CG      COG         Congo          Congo     Congo     COG       UN Mem… Braz…
#> 4 AD      AND         Andorra        Andorra   Andorre   AND       UN Mem… Ando…
#> 5 AE      ARE         United Arab E… United A… Émirats … ARE       UN Mem… Abu …
#> 6 AF      AFG         Afghanistan    Afghanis… Afghanis… AFG       UN Mem… Kabul
#> # ℹ 6 more variables: STAT_CODE <chr>, EU_STAT <chr>, EFTA_STAT <chr>,
#> #   CC_STAT <chr>, NAME_GERM <chr>, geometry <MULTIPOLYGON [°]>
```
