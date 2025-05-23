
<!-- README.md is generated from README.Rmd. Please edit that file -->

# giscoR <a href='https://ropengov.github.io/giscoR/'><img src="man/figures/logo.png" align="right" height="139"/></a>

<!-- badges: start -->

[![rOG-badge](https://ropengov.github.io/rogtemplate/reference/figures/ropengov-badge.svg)](https://ropengov.org/)
[![CRAN
status](https://www.r-pkg.org/badges/version/giscoR)](https://CRAN.R-project.org/package=giscoR)
[![CRAN
results](https://badges.cranchecks.info/worst/giscoR.svg)](https://cran.r-project.org/web/checks/check_results_giscoR.html)
[![Downloads](https://cranlogs.r-pkg.org/badges/giscoR)](https://CRAN.R-project.org/package=giscoR)
[![r-universe](https://ropengov.r-universe.dev/badges/giscoR)](https://ropengov.r-universe.dev/giscoR)
[![R-CMD-check](https://github.com/rOpenGov/giscoR/actions/workflows/check-full.yaml/badge.svg)](https://github.com/rOpenGov/giscoR/actions/workflows/check-full.yaml)
[![R-hub](https://github.com/rOpenGov/giscoR/actions/workflows/rhub.yaml/badge.svg)](https://github.com/rOpenGov/giscoR/actions/workflows/rhub.yaml)
[![codecov](https://codecov.io/gh/ropengov/giscoR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ropengov/giscoR)
[![CodeFactor](https://www.codefactor.io/repository/github/ropengov/giscor/badge)](https://www.codefactor.io/repository/github/ropengov/giscor)
[![DOI](https://img.shields.io/badge/DOI-10.32614/CRAN.package.giscoR-blue)](https://doi.org/10.32614/CRAN.package.giscoR)
[![Project Status:
Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

<!-- badges: end -->

[**giscoR**](https://ropengov.github.io/giscoR//) is an API package that
helps to retrieve data from [Eurostat - GISCO (the Geographic
Information System of the
COmmission)](https://ec.europa.eu/eurostat/web/gisco). It also provides
some lightweight data sets ready to use without downloading.

[GISCO](https://ec.europa.eu/eurostat/web/gisco) is a geospatial open
data repository including several data sets as countries, coastal lines,
labels or [NUTS
levels](https://ec.europa.eu/eurostat/web/regions-and-cities/overview).
The data sets are usually provided at several resolution levels
(60M/20M/10M/03M/01M) and in 3 different projections (4326/3035/3857).

Note that the package does not provide metadata on the downloaded files,
the information is available on the [API
webpage](https://gisco-services.ec.europa.eu/distribution/v2/).

Full site with examples and vignettes on
<https://ropengov.github.io/giscoR/>

## Installation

Install **giscoR** from
[**CRAN**](https://CRAN.R-project.org/package=giscoR):

``` r
install.packages("giscoR")
```

You can install the developing version of **giscoR** with:

``` r
remotes::install_github("rOpenGov/giscoR")
```

Alternatively, you can install **giscoR** using the
[r-universe](https://ropengov.r-universe.dev/giscoR):

``` r
install.packages("giscoR",
  repos = c("https://ropengov.r-universe.dev", "https://cloud.r-project.org")
)
```

## Usage

This script highlights some features of **giscoR** :

``` r
library(giscoR)
library(sf)
library(dplyr)

# Different resolutions
DNK_res60 <- gisco_get_countries(resolution = "60", country = "DNK") %>%
  mutate(res = "60M")
DNK_res20 <-
  gisco_get_countries(resolution = "20", country = "DNK") %>%
  mutate(res = "20M")
DNK_res10 <-
  gisco_get_countries(resolution = "10", country = "DNK") %>%
  mutate(res = "10M")
DNK_res03 <-
  gisco_get_countries(resolution = "03", country = "DNK") %>%
  mutate(res = "03M")


DNK_all <- bind_rows(DNK_res60, DNK_res20, DNK_res10, DNK_res03)

# Plot ggplot2

library(ggplot2)

ggplot(DNK_all) +
  geom_sf(fill = "#c8102e") +
  facet_wrap(vars(res)) +
  theme_minimal()
```

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-example-1.png" width="100%" />

``` r


# Labels and Lines available

labs <- gisco_get_countries(
  spatialtype = "LB",
  region = "Africa",
  epsg = "3857"
)

coast <- gisco_get_countries(
  spatialtype = "COASTL",
  epsg = "3857"
)

# For zooming
afr_bbox <- st_bbox(labs)

ggplot(coast) +
  geom_sf(col = "deepskyblue4", linewidth = 3) +
  geom_sf(data = labs, fill = "springgreen4", col = "darkgoldenrod1", size = 5, shape = 21) +
  coord_sf(
    xlim = afr_bbox[c("xmin", "xmax")],
    ylim = afr_bbox[c("ymin", "ymax")]
  )
```

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-example-2.png" width="100%" />

### Labels

An example of a labeled map using **ggplot2**:

``` r
ITA <- gisco_get_nuts(country = "Italy", nuts_level = 1)

ggplot(ITA) +
  geom_sf() +
  geom_sf_text(aes(label = NAME_LATN)) +
  theme(axis.title = element_blank())
```

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-labels-1.png" width="100%" />

### Thematic maps

An example of a thematic map plotted with the **ggplot2** package. The
information is extracted via the **eurostat** package ([Lahti et al.
2017](#ref-RJ-2017-019)). We would follow the fantastic approach
presented by [Milos Popovic](https://milospopovic.net/) on [this
post](https://milospopovic.net/how-to-make-choropleth-map-in-r/):

We start by extracting the corresponding geographic data:

``` r
# Get shapes
nuts3 <- gisco_get_nuts(
  year = "2021",
  epsg = "3035",
  resolution = "10",
  nuts_level = "3"
)

# Group by NUTS by country and convert to lines
country_lines <- nuts3 %>%
  group_by(
    CNTR_CODE
  ) %>%
  summarise(n = n()) %>%
  st_cast("MULTILINESTRING")
```

We now download the data from Eurostat:

``` r
# Use eurostat
library(eurostat)
popdens <- get_eurostat("demo_r_d3dens") %>%
  filter(TIME_PERIOD == "2021-01-01")
```

By last, we merge and manipulate the data for creating the final plot:

``` r
# Merge data
nuts3_sf <- nuts3 %>%
  left_join(popdens, by = "geo")

nuts3_sf <- nuts3 %>%
  left_join(popdens, by = c("NUTS_ID" = "geo"))


# Breaks and labels

br <- c(0, 25, 50, 100, 200, 500, 1000, 2500, 5000, 10000, 30000)
labs <- prettyNum(br[-1], big.mark = ",")

# Label function to be used in the plot, mainly for NAs
labeller_plot <- function(x) {
  ifelse(is.na(x), "No Data", x)
}
nuts3_sf <- nuts3_sf %>%
  # Cut with labels
  mutate(values_cut = cut(values, br, labels = labs))


# Palette
pal <- hcl.colors(length(labs), "Lajolla")


# Plot
ggplot(nuts3_sf) +
  geom_sf(aes(fill = values_cut), linewidth = 0, color = NA, alpha = 0.9) +
  geom_sf(data = country_lines, col = "black", linewidth = 0.1) +
  # Center in Europe: EPSG 3035
  coord_sf(
    xlim = c(2377294, 7453440),
    ylim = c(1313597, 5628510)
  ) +
  # Legends
  scale_fill_manual(
    values = pal,
    # Label for NA
    labels = labeller_plot,
    drop = FALSE, guide = guide_legend(direction = "horizontal", nrow = 1)
  ) +
  # Theming
  theme_void() +
  # Theme
  theme(
    plot.title = element_text(
      color = rev(pal)[2], size = rel(1.5),
      hjust = 0.5, vjust = -6
    ),
    plot.subtitle = element_text(
      color = rev(pal)[2], size = rel(1.25),
      hjust = 0.5, vjust = -10, face = "bold"
    ),
    plot.caption = element_text(color = "grey60", hjust = 0.5, vjust = 0),
    legend.text = element_text(color = "grey20", hjust = .5),
    legend.title = element_text(color = "grey20", hjust = .5),
    legend.position = "bottom",
    legend.title.position = "top",
    legend.text.position = "bottom",
    legend.key.height = unit(.5, "line"),
    legend.key.width = unit(2.5, "line")
  ) +
  # Annotate and labs
  labs(
    title = "Population density in 2021",
    subtitle = "NUTS-3 level",
    fill = "people per sq. kilometer",
    caption = paste0(
      "Source: Eurostat, ", gisco_attributions(),
      "\nBased on Milos Popovic: ",
      "https://milospopovic.net/how-to-make-choropleth-map-in-r/"
    )
  )
```

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-thematic-1.png" width="100%" />

## A note on caching

Some data sets (as Local Administrative Units - LAU, or high-resolution
files) may have a size larger than 50MB. You can use **giscoR** to
create your own local repository at a given local directory passing the
following function:

``` r
gisco_set_cache_dir("./path/to/location")
```

You can also download manually the files (`.geojson` format) and store
them on your local directory.

## Recommended packages

### API data packages

- **eurostat** ([Lahti et al. 2017](#ref-RJ-2017-019)): This is an API
  package that provides access to open data from Eurostat.

### Plotting **sf** objects

Some packages recommended for visualization are:

- [**tmap**](https://r-tmap.github.io/tmap/)
- [**ggplot2**](https://github.com/tidyverse/ggplot2) +
  [**ggspatial**](https://github.com/paleolimbot/ggspatial) +
  [**tidyterra**](https://dieghernan.github.io/tidyterra/)
- [**mapsf**](https://riatelab.github.io/mapsf/)
- [**leaflet**](https://rstudio.github.io/leaflet/)

## Contribute

Check the GitHub page for [source
code](https://github.com/rOpenGov/giscoR/).

Contributions are very welcome:

- [Use issue tracker](https://github.com/rOpenGov/giscoR/issues) for
  feedback and bug reports.
- [Send pull requests](https://github.com/rOpenGov/giscoR/)
- [Star us on the GitHub page](https://github.com/rOpenGov/giscoR)

## Citation

To cite ‘giscoR’ in publications use:

Hernangómez D (2025). *giscoR: Download Map Data from GISCO API -
Eurostat*. <doi:10.32614/CRAN.package.giscoR>
<https://doi.org/10.32614/CRAN.package.giscoR>,
<https://ropengov.github.io/giscoR/>.

A BibTeX entry for LaTeX users is

    @Manual{R-giscoR,
      title = {{giscoR}: Download Map Data from GISCO API - Eurostat},
      doi = {10.32614/CRAN.package.giscoR},
      author = {Diego Hernangómez},
      year = {2025},
      version = {0.6.1},
      url = {https://ropengov.github.io/giscoR/},
      abstract = {Tools to download data from the GISCO (Geographic Information System of the Commission) Eurostat database <https://ec.europa.eu/eurostat/web/gisco>. Global and European map data available. This package is in no way officially related to or endorsed by Eurostat.},
    }

## Copyright notice

> When data downloaded from this page is used in any printed or
> electronic publication, in addition to any other provisions applicable
> to the whole Eurostat website, data source will have to be
> acknowledged in the legend of the map and in the introductory page of
> the publication with the following copyright notice:
>
> - EN: © EuroGeographics for the administrative boundaries.
> - FR: © EuroGeographics pour les limites administratives.
> - DE: © EuroGeographics bezüglich der Verwaltungsgrenzen.
>
> For publications in languages other than English, French or German,
> the translation of the copyright notice in the language of the
> publication shall be used.
>
> If you intend to use the data commercially, please contact
> [EuroGeographics](https://eurogeographics.org/maps-for-europe/licensing/)
> for information regarding their licence agreements.
>
> *From [GISCO
> Web](https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units)*

## Disclaimer

This package is in no way officially related to or endorsed by Eurostat.

## References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-RJ-2017-019" class="csl-entry">

Lahti, Leo, Janne Huovari, Markus Kainu, and Przemysław Biecek. 2017.
“<span class="nocase">Retrieval and Analysis of Eurostat Open Data with
the eurostat Package</span>.” *The R Journal* 9 (1): 385–92.
<https://doi.org/10.32614/RJ-2017-019>.

</div>

</div>

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

All contributions to this project are gratefully acknowledged using the
[`allcontributors` package](https://github.com/ropensci/allcontributors)
following the [allcontributors](https://allcontributors.org)
specification. Contributions of any kind are welcome!

### Code

<table class="table allctb-table">
<tr>
<td align="center">
<a href="https://github.com/dieghernan">
<img src="https://avatars.githubusercontent.com/u/25656809?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/commits?author=dieghernan">dieghernan</a>
</td>
</tr>
</table>

### Issue Authors

<table class="table allctb-table">
<tr>
<td align="center">
<a href="https://github.com/lodderig">
<img src="https://avatars.githubusercontent.com/u/3128982?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Alodderig">lodderig</a>
</td>
<td align="center">
<a href="https://github.com/umbe1987">
<img src="https://avatars.githubusercontent.com/u/15016826?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Aumbe1987">umbe1987</a>
</td>
<td align="center">
<a href="https://github.com/martinhulenyi">
<img src="https://avatars.githubusercontent.com/u/23149739?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Amartinhulenyi">martinhulenyi</a>
</td>
<td align="center">
<a href="https://github.com/pitkant">
<img src="https://avatars.githubusercontent.com/u/69813611?u=824c10fc689a7f3589c9640bb7edf23513a12e42&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Apitkant">pitkant</a>
</td>
<td align="center">
<a href="https://github.com/mdnahinalam">
<img src="https://avatars.githubusercontent.com/u/62886579?u=d2e677a6e9899bcfb21dd72471efba0069461410&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Amdnahinalam">mdnahinalam</a>
</td>
<td align="center">
<a href="https://github.com/richardtc">
<img src="https://avatars.githubusercontent.com/u/1285650?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Arichardtc">richardtc</a>
</td>
<td align="center">
<a href="https://github.com/maurolepore">
<img src="https://avatars.githubusercontent.com/u/5856545?u=640bf30b4798fd06becb5a22d56f38d63cab78d2&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Amaurolepore">maurolepore</a>
</td>
<td align="center">
<a href="https://github.com/vincentarelbundock">
<img src="https://avatars.githubusercontent.com/u/987057?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Avincentarelbundock">vincentarelbundock</a>
</td>
</tr>
<tr>
<td align="center">
<a href="https://github.com/swimmer008">
<img src="https://avatars.githubusercontent.com/u/84015506?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Aswimmer008">swimmer008</a>
</td>
<td align="center">
<a href="https://github.com/RemiDumas">
<img src="https://avatars.githubusercontent.com/u/42999492?u=df4135b75c626a031ec914a4c2a8fe21f3266f1d&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3ARemiDumas">RemiDumas</a>
</td>
<td align="center">
<a href="https://github.com/hannesaddec">
<img src="https://avatars.githubusercontent.com/u/13235761?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Ahannesaddec">hannesaddec</a>
</td>
<td align="center">
<a href="https://github.com/kalegoddess">
<img src="https://avatars.githubusercontent.com/u/179786080?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Akalegoddess">kalegoddess</a>
</td>
<td align="center">
<a href="https://github.com/raffaem">
<img src="https://avatars.githubusercontent.com/u/54762742?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Araffaem">raffaem</a>
</td>
<td align="center">
<a href="https://github.com/dominicroye">
<img src="https://avatars.githubusercontent.com/u/42300133?u=0b58f378f813ca0444df64c8f73b3d1ec497a82c&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3Adominicroye">dominicroye</a>
</td>
<td align="center">
<a href="https://github.com/FSS-learning">
<img src="https://avatars.githubusercontent.com/u/185188279?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+author%3AFSS-learning">FSS-learning</a>
</td>
</tr>
</table>

### Issue Contributors

<table class="table allctb-table">
<tr>
<td align="center">
<a href="https://github.com/vin-ni">
<img src="https://avatars.githubusercontent.com/u/9806572?u=043bf244790f0e44886f5a734fc2cd052af5af26&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+commenter%3Avin-ni">vin-ni</a>
</td>
<td align="center">
<a href="https://github.com/matteodefelice">
<img src="https://avatars.githubusercontent.com/u/6360066?u=609873695a6ad7ca9fdad647d29a7c972ccfdbb8&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+commenter%3Amatteodefelice">matteodefelice</a>
</td>
<td align="center">
<a href="https://github.com/GB-IHE">
<img src="https://avatars.githubusercontent.com/u/76434717?u=cf2235261c22d1703cc8f668525075efd4c321dd&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+commenter%3AGB-IHE">GB-IHE</a>
</td>
<td align="center">
<a href="https://github.com/webervienna">
<img src="https://avatars.githubusercontent.com/u/113052114?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+commenter%3Awebervienna">webervienna</a>
</td>
<td align="center">
<a href="https://github.com/joelangley9">
<img src="https://avatars.githubusercontent.com/u/164087714?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+commenter%3Ajoelangley9">joelangley9</a>
</td>
<td align="center">
<a href="https://github.com/pradisteph">
<img src="https://avatars.githubusercontent.com/u/169450649?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenGov/giscoR/issues?q=is%3Aissue+commenter%3Apradisteph">pradisteph</a>
</td>
</tr>
</table>
<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->
