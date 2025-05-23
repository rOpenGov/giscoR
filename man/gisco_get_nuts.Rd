% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gisco_get_nuts.R
\name{gisco_get_nuts}
\alias{gisco_get_nuts}
\title{Get GISCO NUTS \code{\link[sf:sf]{sf}} polygons, points and lines}
\source{
\url{https://gisco-services.ec.europa.eu/distribution/v2/}
}
\usage{
gisco_get_nuts(
  year = "2016",
  epsg = "4326",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  resolution = "20",
  spatialtype = "RG",
  country = NULL,
  nuts_id = NULL,
  nuts_level = "all"
)
}
\arguments{
\item{year}{Release year of the file. One
of \code{"2003"}, \code{"2006"}, \code{"2010"}, \code{"2013"}, \code{"2016"}, \code{"2021"} or \code{"2024"}.}

\item{epsg}{projection of the map: 4-digit \href{https://epsg.io/}{EPSG code}.
One of:
\itemize{
\item \code{"4258"}: ETRS89
\item \code{"4326"}: WGS84
\item \code{"3035"}: ETRS89 / ETRS-LAEA
\item \code{"3857"}: Pseudo-Mercator
}}

\item{cache}{A logical whether to do caching. Default is \code{TRUE}. See
\strong{About caching}.}

\item{update_cache}{A logical whether to update cache. Default is \code{FALSE}.
When set to \code{TRUE} it would force a fresh download of the source
\code{.geojson} file.}

\item{cache_dir}{A path to a cache directory. See \strong{About caching}.}

\item{verbose}{Logical, displays information. Useful for debugging,
default is \code{FALSE}.}

\item{resolution}{Resolution of the geospatial data. One of
\itemize{
\item \code{"60"}: 1:60million
\item \code{"20"}: 1:20million
\item \code{"10"}: 1:10million
\item \code{"03"}: 1:3million
\item \code{"01"}: 1:1million
}}

\item{spatialtype}{Type of geometry to be returned:
\itemize{
\item \code{"BN"}: Boundaries - \code{LINESTRING} object.
\item \code{"LB"}: Labels - \code{POINT} object.
\item \code{"RG"}: Regions - \code{MULTIPOLYGON/POLYGON} object.
}

\strong{Note that} parameters \code{country}, \code{nuts_level} and \code{nuts_id} would be only
applied when \code{spatialtype} is \code{"BN"} or \code{"RG"}.}

\item{country}{Optional. A character vector of country codes. It could be
either a vector of country names, a vector of ISO3 country codes or a
vector of Eurostat country codes. Mixed types (as \code{c("Italy","ES","FRA")})
would not work. See also \code{\link[countrycode:countrycode]{countrycode::countrycode()}}.}

\item{nuts_id}{Optional. A character vector of NUTS IDs.}

\item{nuts_level}{NUTS level. One of \code{"0"}, \code{"1"}, \code{"2"} or \code{"3"}.
See \strong{Description}.}
}
\value{
A \code{\link[sf:sf]{sf}} object specified by \code{spatialtype}. The resulting
\code{\link[sf:sf]{sf}} object would present an additional column \code{geo} (equal to
\code{NUTS_ID}) for improving compatibility with \CRANpkg{eurostat} package. See
\code{\link[eurostat:get_eurostat_geospatial]{eurostat::get_eurostat_geospatial()}}).

See also \link{gisco_nuts} to understand the columns and values provided.
}
\description{
Returns
\href{https://en.wikipedia.org/wiki/Nomenclature_of_Territorial_Units_for_Statistics}{NUTS regions}
polygons, lines and points at a specified scale, as provided by GISCO.

NUTS are provided at three different levels:
\itemize{
\item \code{"0"}: Country level
\item \code{"1"}: Groups of states/regions
\item \code{"2"}: States/regions
\item \code{"3"}: Counties/provinces/districts
}

Note that NUTS-level definition may vary across countries. See also \url{https://ec.europa.eu/eurostat/web/gisco/geodata//statistical-units/territorial-units-statistics}.
}
\section{About caching}{
You can set your \code{cache_dir} with \code{\link[=gisco_set_cache_dir]{gisco_set_cache_dir()}}.

Sometimes cached files may be corrupt. On that case, try re-downloading
the data setting \code{update_cache = TRUE}.

If you experience any problem on download, try to download the
corresponding \code{.geojson} file by any other method and save it on your
\code{cache_dir}. Use the option \code{verbose = TRUE} for debugging the API query.

For a complete list of files available check \link{gisco_db}.
}

\examples{
nuts2 <- gisco_get_nuts(nuts_level = 2)

library(ggplot2)

ggplot(nuts2) +
  geom_sf() +
  # ETRS89 / ETRS-LAEA
  coord_sf(
    crs = 3035, xlim = c(2377294, 7453440),
    ylim = c(1313597, 5628510)
  ) +
  labs(title = "NUTS-2 levels")
\donttest{
# NUTS-3 for Germany
germany_nuts3 <- gisco_get_nuts(nuts_level = 3, country = "Germany")

ggplot(germany_nuts3) +
  geom_sf() +
  labs(
    title = "NUTS-3 levels",
    subtitle = "Germany",
    caption = gisco_attributions()
  )


# Select specific regions
select_nuts <- gisco_get_nuts(nuts_id = c("ES2", "FRJ", "FRL", "ITC"))

ggplot(select_nuts) +
  geom_sf(aes(fill = CNTR_CODE)) +
  scale_fill_viridis_d()
}
}
\seealso{
\link{gisco_nuts}, \code{\link[=gisco_get_countries]{gisco_get_countries()}},
\code{\link[eurostat:get_eurostat_geospatial]{eurostat::get_eurostat_geospatial()}}

Other political: 
\code{\link{gisco_bulk_download}()},
\code{\link{gisco_get_coastallines}()},
\code{\link{gisco_get_countries}()},
\code{\link{gisco_get_lau}()},
\code{\link{gisco_get_postalcodes}()},
\code{\link{gisco_get_units}()},
\code{\link{gisco_get_urban_audit}()}
}
\concept{political}
