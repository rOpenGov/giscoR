# Healthcare services in Europe

The dataset contains information on healthcare services considered
hospitals by Member States. The definition varies slightly from country
to country, but roughly includes the following:

- Hospitals comprise licensed establishments primarily engaged in
  providing medical, diagnostic and treatment services that include
  physician, nursing and other health services to inpatients and the
  specialized accommodation services required by inpatients.

## Usage

``` r
gisco_get_healthcare(
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

There are no specific download rules for the datasets shown below.
However, please refer to [the general copyright
notice](https://ec.europa.eu/eurostat/web/gisco/geodata) and license
provisions, which apply to these datasets. Permission to download and
use these data is subject to acceptance of those rules.

The data are extracted from official national registers. They may
contain inconsistencies, inaccuracies and gaps due to the heterogeneity
of the national input data.

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

  A logical value. If `TRUE` displays informational messages.

- country:

  A character vector of country codes. It can be either a vector of
  country names, a vector of ISO 3166-1 alpha-3 country codes or a
  vector of Eurostat country codes. See also
  [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html).

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

Files are distributed in [EPSG:4326](https://epsg.io/4326).

The following table describes each attribute:

|  |  |
|----|----|
| **Attribute** | **Description** |
| `id` | The healthcare service identifier, based on national identification codes when available. |
| `hospital_name` | The name of the healthcare institution. |
| `site_name` | The name of a specific site or branch of a healthcare institution. |
| `lat` | Latitude (WGS 84). |
| `lon` | Longitude (WGS 84). |
| `street` | Street name. |
| `house_number` | House number. |
| `postcode` | Postcode. |
| `address` | Address information when the different components of the address are not separated in the source. |
| `city` | City name (sometimes refers to a region or municipality). |
| `cntr_id` | Country code (2 letters, ISO 3166-1 alpha-2). |
| `emergency` | `yes` or `no`, indicating whether the healthcare site provides emergency medical services. |
| `cap_beds` | Measure of capacity by number of beds (most common). |
| `cap_prac` | Measure of capacity by number of practitioners. |
| `cap_rooms` | Measure of capacity by number of rooms. |
| `facility_type` | Type of healthcare service (e.g., psychiatric hospital), based on national classification. |
| `public_private` | `public` or `private` status of the healthcare service. |
| `list_specs` | List of specialties recognized in the EU and EEA according to the 2005 EU Directive (Annex V). |
| `tel` | Telephone number. |
| `email` | Email address. |
| `url` | URL for the institution's website. |
| `ref_date` | The reference date (`DD/MM/YYYY`) for the data. |
| `pub_date` | The publication date of the dataset by Eurostat (`DD/MM/YYYY`). |
| `geo_qual` | Geolocation quality indicator: 1 = Good, 2 = Medium, 3 = Low, 4 = From source, -1 = Unknown, -2 = Not geocoded. |
| `comments` | Additional information on the healthcare service. |

## See also

Basic services datasets:
[`gisco_get_education()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_education.md)

## Examples

``` r
health_benelux <- gisco_get_healthcare(
  country = c("BE", "NL", "LU"),
  year = 2023
)

# Plot if downloaded.
if (!is.null(health_benelux)) {
  benelux <- gisco_get_countries(country = c("BE", "NL", "LU"))

  library(ggplot2)
  ggplot(benelux) +
    geom_sf(fill = "grey10", color = "grey20") +
    geom_sf(
      data = health_benelux, color = "red",
      size = 0.2, alpha = 0.25
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
      title = "Healthcare services", subtitle = "Benelux (2023)",
      caption = "Source: Eurostat, Healthcare 2023 dataset."
    ) +
    coord_sf(crs = 3035)
}
```
