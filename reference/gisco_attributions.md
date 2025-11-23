# Attribution when publishing GISCO data

Get the legal text to be used along with the data downloaded with this
package.

## Usage

``` r
gisco_attributions(lang = "en", copyright = FALSE)
```

## Arguments

- lang:

  Language (two-letter ISO code). See
  [countrycode::codelist](https://vincentarelbundock.github.io/countrycode/reference/codelist.html)
  and **Details**.

- copyright:

  Boolean `TRUE/FALSE`. Whether to display the copyright notice or not
  on the console.

## Value

A string with the attribution to be used.

## Details

Current languages supported are:

- `"en"`: English.

- `"da"`: Danish.

- `"de"`: German.

- `"es"`: Spanish.

- `"fi"`: Finish.

- `"fr"`: French.

- `"no"`: Norwegian.

- `"sv"`: Swedish.

Please consider
[contributing](https://github.com/rOpenGov/giscoR/issues) if you spot
any mistake or want to add a new language.

## Note

COPYRIGHT NOTICE

When data downloaded from GISCO is used in any printed or electronic
publication, in addition to any other provisions applicable to the whole
Eurostat website, data source will have to be acknowledged in the legend
of the map and in the introductory page of the publication with the
following copyright notice:

- EN: (C) EuroGeographics for the administrative boundaries.

- FR: (C) EuroGeographics pour les limites administratives.

- DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen.

For publications in languages other than English, French or German, the
translation of the copyright notice in the language of the publication
shall be used.

If you intend to use the data commercially, please contact
EuroGeographics for information regarding their licence agreements.

## See also

Other helper:
[`gisco_check_access()`](https://ropengov.github.io/giscoR/reference/gisco_check_access.md)

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
#> - EN: (C) EuroGeographics for the administrative boundaries
#> - FR: (C) EuroGeographics pour les limites administratives
#> - DE: (C) EuroGeographics bezuglich der Verwaltungsgrenzen
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
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

countrycode::codelist %>%
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
