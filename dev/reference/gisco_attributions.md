# Attribution for administrative and statistical GISCO data

Get the legal text to be used for administrative and statistical data
downloaded from GISCO, see section **Copyright information**.

For other datasets you may abide by the [Eurostat's general copyright
notice and licence
policy](https://ec.europa.eu/eurostat/web/main/help/copyright-notice).

## Usage

``` r
gisco_attributions(lang = "en", copyright = FALSE)
```

## Arguments

- lang:

  character. Language (two-letter ISO code). See
  [countrycode::codelist](https://vincentarelbundock.github.io/countrycode/man/codelist.html)
  and **Details**.

- copyright:

  logical `TRUE/FALSE`. Whether to display the copyright notice or not
  on the console.

## Value

A string with the attribution to be used.

## Details

Current languages supported are:

- `"en"`: English.

- `"da"`: Danish.

- `"de"`: German.

- `"es"`: Spanish.

- `"fi"`: Finnish.

- `"fr"`: French.

- `"no"`: Norwegian.

- `"sv"`: Swedish.

Please consider
[contributing](https://github.com/rOpenGov/giscoR/issues) if you spot
any mistake or want to add a new language.

## Copyright information

The provisions described in this section apply to administrative and
statistical data provided by the following functions:

**Administrative units**

- [`gisco_get_communes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_communes.md)

- [`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md)

- [`gisco_get_postal_codes()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_postal_codes.md)

**Statistical units**

- [`gisco_get_census()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_census.md)

- [`gisco_get_coastal_lines()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_coastal_lines.md)

- [`gisco_get_lau()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_lau.md)

- [`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)

- [`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)

### Copyright Notice

When data downloaded from GISCO is used in any printed or electronic
publication, in addition to any other provisions applicable to the whole
Eurostat website, data source will have to be acknowledged in the legend
of the map and in the introductory page of the publication with the
following copyright notice:

- EN: © EuroGeographics for the administrative boundaries.

- FR: © EuroGeographics pour les limites administratives.

- DE: © EuroGeographics bezüglich der Verwaltungsgrenzen.

For publications in languages other than English, French or German, the
translation of the copyright notice in the language of the publication
shall be used.

If you intend to use the data commercially, please contact
EuroGeographics for information regarding their licence agreements.

## Examples

``` r
gisco_attributions()
#> [1] "© EuroGeographics for the administrative boundaries"

gisco_attributions(lang = "es", copyright = TRUE)
#> ℹ COPYRIGHT NOTICE
#> 
#> When data downloaded from GISCO
#> is used in any printed or electronic publication,
#> in addition to any other provisions applicable to
#> the whole Eurostat website, data source will have
#> to be acknowledged in the legend of the map and in
#> the introductory page of the publication with the
#> following copyright notice:
#> 
#> - EN: © EuroGeographics for the administrative boundaries
#> - FR: © EuroGeographics pour les limites administratives
#> - DE: © EuroGeographics bezüglich der Verwaltungsgrenzen
#> 
#> For publications in languages other than English,
#> French or German, the translation of the copyright
#> notice in the language of the publication shall be
#> used.
#> 
#> If you intend to use the data commercially, please
#> contact EuroGeographics for information regarding
#> their licence agreements.
#> [1] "© Eurogeographics para los límites administrativos"

gisco_attributions(lang = "XXX")
#> ! Language xxx not supported. Switching to English.
#> ℹ Consider contributing: <https://github.com/rOpenGov/giscoR/issues>
#> [1] "© EuroGeographics for the administrative boundaries"

# Get list of codes from countrycodes
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

countrycode::codelist |>
  select(country.name.en, iso2c)
#> # A tibble: 291 × 2
#>    country.name.en   iso2c
#>    <chr>             <chr>
#>  1 Afghanistan       AF   
#>  2 Albania           AL   
#>  3 Algeria           DZ   
#>  4 American Samoa    AS   
#>  5 Andorra           AD   
#>  6 Angola            AO   
#>  7 Anguilla          AI   
#>  8 Antarctica        AQ   
#>  9 Antigua & Barbuda AG   
#> 10 Argentina         AR   
#> # ℹ 281 more rows
```
