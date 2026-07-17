# GISCO geodata single-unit download

Download datasets of single spatial units from GISCO to the
[`cache_dir`](https://ropengov.github.io/giscoR/dev/reference/gisco_set_cache_dir.md).

Unlike
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md)
or
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md)
(which download full datasets and apply filters), these functions
download a single-unit file, reducing the time needed to download and
read data into your R session.

## Usage

``` r
gisco_get_unit_country(
  unit = "ES",
  year = 2024,
  epsg = c(4326, 3857, 3035),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = c(1, 3, 10, 20, 60),
  spatialtype = c("RG", "LB")
)

gisco_get_unit_nuts(
  unit = "ES416",
  year = 2024,
  epsg = c(4326, 3857, 3035),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = c(1, 3, 10, 20, 60),
  spatialtype = c("RG", "LB")
)

gisco_get_unit_urban_audit(
  unit = "ES001F",
  year = 2024,
  epsg = c(4326, 3857, 3035),
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  spatialtype = c("RG", "LB")
)
```

## Source

GISCO countries distribution API:
<https://gisco-services.ec.europa.eu/distribution/v2/countries/>.

GISCO NUTS distribution API:
<https://gisco-services.ec.europa.eu/distribution/v2/nuts/>.

GISCO Urban Audit distribution API:
<https://gisco-services.ec.europa.eu/distribution/v2/urau/>.

All source files are `.geojson` files.

## Arguments

- unit:

  A character vector of unit IDs to download. See **Details**.

- year:

  A character string or numeric value with the release year of the file.

- epsg:

  A character string or numeric value with the coordinate reference
  system as a 4-digit [EPSG code](https://epsg.io/). One of:

  - `"4326"`: [WGS84](https://epsg.io/4326).

  - `"3035"`: [ETRS89 / ETRS-LAEA](https://epsg.io/3035).

  - `"3857"`: [Pseudo-Mercator](https://epsg.io/3857).

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

- resolution:

  A character string or numeric value with the geospatial data
  resolution. One of:

  - `"60"`: 1:60 million.

  - `"20"`: 1:20 million.

  - `"10"`: 1:10 million.

  - `"03"`: 1:3 million.

  - `"01"`: 1:1 million.

- spatialtype:

  A character string with the type of geometry to return. Options
  available are:

  - `"RG"`: Regions - `MULTIPOLYGON/POLYGON` object.

  - `"LB"`: Labels - `POINT` object.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

Check the available `unit` IDs for the required argument combination
with
[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md).

## Copyright

See the GISCO copyright provisions for administrative and statistical
units:

- Administrative units:
  <https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units>.

- Statistical units:
  <https://ec.europa.eu/eurostat/web/gisco/geodata/statistical-units>.

## Note

Check the download and usage provisions in
[`gisco_attributions()`](https://ropengov.github.io/giscoR/dev/reference/gisco_attributions.md).

## See also

[`gisco_get_metadata()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_metadata.md),
[`gisco_get_countries()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_countries.md),
[`gisco_get_nuts()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_nuts.md),
[`gisco_get_urban_audit()`](https://ropengov.github.io/giscoR/dev/reference/gisco_get_urban_audit.md).

See
[gisco_id_api](https://ropengov.github.io/giscoR/dev/reference/gisco_id_api.md)
to download via GISCO ID service API.

Bulk and single-unit downloads:
[`gisco_bulk_download()`](https://ropengov.github.io/giscoR/dev/reference/gisco_bulk_download.md)

## Examples

``` r
# Get metadata.
cities <- gisco_get_metadata("urban_audit", year = 2024)

# Valencia, Spain.
valencia <- cities[grep("Valencia", cities$URAU_NAME, fixed = TRUE), ]
valencia
#> # A tibble: 2 × 8
#>   URAU_CODE URAU_CATG CNTR_CODE URAU_NAME CITY_CPTL FUA_CODE AREA_SQM NUTS3_2024
#>   <chr>     <chr>     <chr>     <chr>     <chr>     <chr>       <dbl> <chr>     
#> 1 ES003C    C         ES        Valencia  ""        "ES003F"     402. ES523     
#> 2 ES003F    F         ES        Valencia  ""        ""          5430. ES523     
if (
  requireNamespace("dplyr", quietly = TRUE) &&
    requireNamespace("ggplot2", quietly = TRUE)
) {
library(dplyr)
# Get `sf` objects and order by `AREA_SQM`.
valencia_sf <- gisco_get_unit_urban_audit(
  unit = valencia$URAU_CODE,
  year = 2024
) |>
  arrange(desc(AREA_SQM))
# Plot.
library(ggplot2)

ggplot(valencia_sf) +
  geom_sf(aes(fill = URAU_CATG)) +
  scale_fill_viridis_d() +
  labs(
    title = "Valencia",
    subtitle = "Urban Audit 2020",
    fill = "Category"
  )
}
```
