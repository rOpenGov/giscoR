
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

[**giscoR**](https://ropengov.github.io/giscoR//) is an **R** package
that provides a simple interface to
[GISCO](https://ec.europa.eu/eurostat/web/gisco) data from Eurostat. It
allows you to download and work with global and European geospatial
datasets -such as country boundaries, NUTS regions, coastlines, and
labels- directly in **R**.

## Key features

- Retrieve **GISCO shapefiles** for countries, regions, and
  administrative units.
- Access data at multiple resolutions: `60M`, `20M`, `10M`, `03M`,
  `01M`.
- Choose from three projections: **EPSG 4326**, **3035**, or **3857**.
- Works seamlessly with **sf** objects for spatial analysis.
- Includes **caching** for faster repeated access.

## Installation

Install **giscoR** from
[**CRAN**](https://CRAN.R-project.org/package=giscoR):

``` r
install.packages("giscoR")
```

You can install the development version of **giscoR** with:

``` r
# install.packages("pak")

pak::pak("rOpenGov/giscoR")
```

Alternatively, you can install **giscoR** via
[r-universe](https://ropengov.r-universe.dev/giscoR):

``` r
install.packages("giscoR", repos = c("https://ropengov.r-universe.dev", "https://cloud.r-project.org"))
```

## Quick Example

This script highlights some features of **giscoR** :

``` r
library(giscoR)
library(sf)
library(dplyr)

# Download Denmark boundaries at different resolutions
dnk_all <- lapply(c("60", "20", "10", "03"), function(r) {
  gisco_get_countries(country = "Denmark", year = 2024, resolution = r) |>
    mutate(res = paste0(r, "M"))
}) |>
  bind_rows()

glimpse(dnk_all)
#> Rows: 4
#> Columns: 13
#> $ CNTR_ID   <chr> "DK", "DK", "DK", "DK"
#> $ CNTR_NAME <chr> "Danmark", "Danmark", "Danmark", "Danmark"
#> $ NAME_ENGL <chr> "Denmark", "Denmark", "Denmark", "Denmark"
#> $ NAME_FREN <chr> "Danemark", "Danemark", "Danemark", "Danemark"
#> $ ISO3_CODE <chr> "DNK", "DNK", "DNK", "DNK"
#> $ SVRG_UN   <chr> "UN Member State", "UN Member State", "UN Member State", "UN…
#> $ CAPT      <chr> "Copenhagen", "Copenhagen", "Copenhagen", "Copenhagen"
#> $ EU_STAT   <chr> "T", "T", "T", "T"
#> $ EFTA_STAT <chr> "F", "F", "F", "F"
#> $ CC_STAT   <chr> "F", "F", "F", "F"
#> $ NAME_GERM <chr> "Dänemark", "Dänemark", "Dänemark", "Dänemark"
#> $ geometry  <MULTIPOLYGON [°]> MULTIPOLYGON (((14.80303 55..., MULTIPOLYGON (((15.15502 55.…
#> $ res       <chr> "60M", "20M", "10M", "03M"

# Plot with ggplot2

library(ggplot2)

ggplot(dnk_all) +
  geom_sf(fill = "#c8102e") +
  facet_wrap(~res) +
  labs(
    title = "Denmark boundaries at different resolutions",
    subtitle = "Year: 2024",
    caption = gisco_attributions()
  )
```

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-example-1.png" alt="Denmark boundaries at different resolutions" width="100%" />

## Advanced Example: Thematic maps

An example of a thematic map plotted with the **ggplot2** package. The
information is extracted via the **eurostat** package ([Lahti et al.
2017](#ref-RJ-2017-019)). We would follow the fantastic approach
presented by [Milos Popovic](https://milospopovic.net/) on [this
post](https://milospopovic.net/how-to-make-choropleth-map-in-r/):

We start by extracting the corresponding geographic data:

``` r
# Get shapes
nuts3 <- gisco_get_nuts(
  year = 2021,
  epsg = 3035,
  resolution = 10,
  nuts_level = 3
)

# Get country lines (NUTS 0 level)

country_lines <- gisco_get_nuts(
  year = 2021,
  epsg = 3035,
  resolution = 10,
  spatialtype = "BN",
  nuts_level = 0
)
```

We now download the data from Eurostat:

``` r
# Use eurostat
library(eurostat)
popdens <- get_eurostat("demo_r_d3dens") |>
  filter(TIME_PERIOD == "2021-01-01")
#> indexed 0B in  0s, 0B/sindexed 1.00TB in  0s, 395.24TB/s                                                                              
```

By last, we merge and manipulate the data for creating the final plot:

``` r
# Merge data
nuts3_sf <- nuts3 |>
  left_join(popdens, by = "geo")

# Breaks and labels
br <- c(0, 25, 50, 100, 200, 500, 1000, 2500, 5000, 10000, 30000)
labs <- prettyNum(br[-1], big.mark = ",")

# Label function to be used in the plot, mainly for NAs
labeller_plot <- function(x) {
  ifelse(is.na(x), "No Data", x)
}
nuts3_sf <- nuts3_sf |>
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

<img src="https://raw.githubusercontent.com/ropengov/giscoR/main/img/README-thematic-1.png" alt="Population density in 2021" width="100%" />

## Caching

Large datasets (e.g., LAU or high-resolution files) can exceed 50MB.
Use:

``` r
gisco_set_cache_dir("./path/to/location")
```

Files will be stored locally for faster access.

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
      version = {0.9.9.9999},
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
The authors are not responsible for any misuse of the data.

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-RJ-2017-019" class="csl-entry">

Lahti, Leo, Janne Huovari, Markus Kainu, and Przemysław Biecek. 2017.
“<span class="nocase">Retrieval and Analysis of Eurostat Open Data with
the eurostat Package</span>.” *The R Journal* 9 (1): 385–92.
<https://doi.org/10.32614/RJ-2017-019>.

</div>

</div>
