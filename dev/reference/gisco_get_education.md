# Education services in Europe

This dataset integrates Member States' official data on the location of
education services. Additional information on these services is included
when available. See **Details**.

## Usage

``` r
gisco_get_education(
  year = c(2023, 2020),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  country = NULL
)
```

## Source

<https://ec.europa.eu/eurostat/web/gisco/geodata/basic-services>.

## Arguments

- year:

  A character string or numeric value with the release year of the file.
  One of `2023`, `2020`.

- cache:

  A logical value indicating whether to cache results. Defaults to
  `TRUE`. See **Caching strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- update_cache:

  A logical value indicating whether to refresh the cached file.
  Defaults to `FALSE`. When set to `TRUE`, it forces a new download.

- cache_dir:

  A character string with a path to a cache directory. See **Caching
  strategies** section in
  [`gisco_set_cache_dir()`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

- verbose:

  A logical value indicating whether to display informational messages.

- country:

  A character vector of country codes. It can be either a vector of
  country names, a vector of ISO 3166-1 alpha-3 country codes or a
  vector of Eurostat country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

Files are distributed in [EPSG:4326](https://epsg.io/4326).

The following table describes the education service attributes:

|  |  |
|----|----|
| **Attribute** | **Description** |
| `id` | The education service identifier, based on national identification codes when available. |
| `name` | The name of the education institution. |
| `site_name` | The name of a specific site or branch of the education institution. |
| `lat` | Latitude (WGS 84). |
| `lon` | Longitude (WGS 84). |
| `street` | Street name. |
| `house_number` | House number. |
| `postcode` | Postcode. |
| `address` | Address information when the different components of the address are not separated in the source. |
| `city` | City name. In some sources, this refers to a region or municipality. |
| `cntr_id` | Country code (2 letters, ISO 3166-1 alpha-2). |
| `levels` | Education levels represented by a single integer or range, using ISCED 2011. |
| `max_students` | Measure of capacity by maximum number of students. |
| `enrollment` | Measure of capacity by number of enrolled students. |
| `fields` | Academic disciplines in which the institution specializes, using ISCED-F 2013. |
| `facility_type` | Type of institution by ownership and operation, such as Catholic or international. |
| `public_private` | Public or private status of the education service. |
| `tel` | Telephone number. |
| `email` | Email address. |
| `url` | URL for the institution's website. |
| `ref_date` | The reference date (`DD/MM/YYYY`) for the data. The dataset represents the state on this date. |
| `pub_date` | The publication date of the dataset by Eurostat (`DD/MM/YYYY`). |
| `geo_qual` | Geolocation quality indicator: 1 = Good, 2 = Medium, 3 = Low, 4 = From source, -1 = Unknown, -2 = Not geocoded. |
| `comments` | Additional information on the education service. |

## Copyright

The general Eurostat copyright and licence provisions apply. Detailed
metadata also list source-specific licensing conditions by country and
data provider. Review the conditions for the selected data before use.

## Data quality

The data are extracted from official national registers. They may
contain inconsistencies, inaccuracies and gaps due to the heterogeneity
of the national input data.

## See also

Basic service datasets:
[`gisco_get_healthcare()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_healthcare.md)

## Examples

``` r
# \donttest{
edu_austria <- gisco_get_education(country = "Austria", year = 2023)

# Plot if downloaded.
if (!is.null(edu_austria)) {
  austria_nuts3 <- gisco_get_nuts(country = "Austria", nuts_level = 3)

  library(ggplot2)
  ggplot(austria_nuts3) +
    geom_sf(fill = "grey10", color = "grey60") +
    geom_sf(
      data = edu_austria, aes(color = rev(public_private)),
      alpha = 0.25
    ) +
    theme_void() +
    theme(
      plot.background = element_rect(fill = "black"),
      text = element_text(color = "white"),
      panel.grid = element_blank(),
      plot.title = element_text(face = "bold", hjust = 0.5),
      plot.subtitle = element_text(face = "italic", hjust = 0.5)
    ) +
    labs(
      title = "Education", subtitle = "Austria (2023)",
      caption = "Source: Eurostat, Education 2023 dataset.",
      color = "Type"
    ) +
    coord_sf(crs = 3035)
}

# }
```
