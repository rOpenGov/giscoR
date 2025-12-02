# Data frame with different country code schemes and world regions

A data frame containing conversions between different country code
schemes (Eurostat/ISO2 and 3) as well as geographic regions as provided
by the World Bank and the UN (M49). This dataset is extracted from
[countrycode](https://CRAN.R-project.org/package=countrycode) package.

## Format

A data frame object with 249 rows and 13 variables:

- ISO3_CODE:

  Eurostat code of each country.

- CNTR_CODE:

  ISO 3166-1 alpha-2 code of each country.

- iso2c:

  ISO 3166-1 alpha-3 code of each country.

- iso.name.en:

  ISO English short name.

- cldr.short.en:

  English short name as provided by the Unicode Common Locale Data
  Repository.

- continent:

  As provided by the World Bank.

- un.region.code:

  Numeric region code UN (M49).

- un.region.name:

  Region name UN (M49).

- un.regionintermediate.code:

  Numeric intermediate Region.

- un.regionintermediate.name:

  Intermediate Region name UN (M49).

- un.regionsub.code:

  Numeric sub-region code UN (M49).

- un.regionsub.name:

  Sub-Region name UN (M49).

- eu:

  Logical indicating if the country belongs to the European Union.

## Source

[countrycode::codelist](https://vincentarelbundock.github.io/countrycode/reference/codelist.html)
**v1.2.0**.

## World Regions

Regions are defined as per the geographic regions defined by the UN (see
<https://unstats.un.org/unsd/methodology/m49/>. Under this scheme Cyprus
is assigned to Asia.

## See also

[`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)
and
[countrycode::codelist](https://vincentarelbundock.github.io/countrycode/reference/codelist.html),
included in
[countrycode](https://CRAN.R-project.org/package=countrycode).

See also the [Unicode Common Locale Data
Repository](https://cldr.unicode.org/translation/displaynames/countryregion-territory-names).

Other dataset:
[`gisco_coastallines`](https://ropengov.github.io/giscoR/dev/reference/gisco_coastallines.md),
[`gisco_countries`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries.md),
[`gisco_countries_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_countries_2024.md),
[`gisco_db`](https://ropengov.github.io/giscoR/dev/reference/gisco_db.md),
[`gisco_nuts`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts.md),
[`gisco_nuts_2024`](https://ropengov.github.io/giscoR/dev/reference/gisco_nuts_2024.md)

## Examples

``` r
data("gisco_countrycode")
dplyr::glimpse(gisco_countrycode)
#> Rows: 249
#> Columns: 13
#> $ ISO3_CODE                  <chr> "ABW", "AFG", "AGO", "AIA", "ALA", "ALB", "…
#> $ CNTR_CODE                  <chr> "AW", "AF", "AO", "AI", NA, "AL", "AD", "AE…
#> $ iso2c                      <chr> "AW", "AF", "AO", "AI", "AX", "AL", "AD", "…
#> $ iso.name.en                <chr> "Aruba", "Afghanistan", "Angola", "Anguilla…
#> $ cldr.short.en              <chr> "Aruba", "Afghanistan", "Angola", "Anguilla…
#> $ continent                  <chr> "Americas", "Asia", "Africa", "Americas", "…
#> $ un.region.code             <dbl> 19, 142, 2, 19, 150, 150, 150, 142, 19, 142…
#> $ un.region.name             <chr> "Americas", "Asia", "Africa", "Americas", "…
#> $ un.regionintermediate.code <dbl> 29, NA, 17, 29, NA, NA, NA, NA, 5, NA, NA, …
#> $ un.regionintermediate.name <chr> "Caribbean", NA, "Middle Africa", "Caribbea…
#> $ un.regionsub.code          <dbl> 419, 34, 202, 419, 154, 39, 39, 145, 419, 1…
#> $ un.regionsub.name          <chr> "Latin America and the Caribbean", "Souther…
#> $ eu                         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, F…
```
