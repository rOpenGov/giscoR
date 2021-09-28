#' Get location of airports and ports from GISCO API
#'
#' Loads a `sf` object from GISCO API or your local library.
#'
#' @concept infrastructure
#' @family infrastructure
#'
#' @return A `POINT` object on EPSG:4326.
#'
#' @param year Year of reference.
#'
#' @inheritParams gisco_get_countries
#'
#'
#' @source
#' <https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/transport-networks>
#'
#' @author dieghernan, <https://github.com/dieghernan/>
#'
#' @details
#' # Years available
#'
#' * **`gisco_get_airports`**:  "2006" and "2013"
#' * **`gisco_get_ports`**: "2009" and "2013"
#'
#'  Ports 2009 contains worldwide information, the rest of datasets refer
#'  to Europe. All shapefiles provided in EPSG:4326
#'
#' @examples
#' \donttest{
#' library(sf)
#'
#' NL <- gisco_get_countries(country = "NL")
#'
#' AirP_NL <- gisco_get_airports(country = "NL")
#'
#' AirP_NL <- st_transform(AirP_NL, st_crs(NL))
#'
#' Ports <- gisco_get_ports()
#' # Transform an intersect with NL
#'
#' Ports <- st_transform(Ports, st_crs(NL))
#'
#' PortsNL <- st_intersection(Ports, NL)
#'
#' # Bind
#' PortsNL_bind <- st_as_sf(type = "Port", st_geometry(PortsNL))
#' AirP_NL_bind <- st_as_sf(type = "Airport", st_geometry(AirP_NL))
#'
#' Full <- rbind(AirP_NL_bind, PortsNL_bind)
#'
#' library(ggplot2)
#'
#' ggplot(NL) +
#'   geom_sf(fill = "wheat") +
#'   geom_sf(data = Full, aes(shape = type, color = type)) +
#'   labs(
#'     title = "Trasport network on the Netherlands",
#'     shape = NULL,
#'     color = NULL,
#'     caption = gisco_attributions()
#'   )
#' }
#'
#' @export
gisco_get_airports <- function(year = "2013", country = NULL) {
  year <- as.character(year)
  if (!(year %in% c("2006", "2013"))) {
    stop("Year should be 2006 or 2013")
  }

  if (year == "2013") {
    data_sf <- airports2013
  } else if (year == "2006") {
    data_sf <- airports2006
  }

  if (!is.null(country) & "CNTR_CODE" %in% names(data_sf)) {
    country <- gsc_helper_countrynames(country, "eurostat")
    data_sf <- data_sf[data_sf$CNTR_CODE %in% country, ]
  }
  return(data_sf)
}

#' @rdname gisco_get_airports
#'
#' @export
gisco_get_ports <- function(year = "2013") {
  year <- as.character(year)
  if (!(year %in% c("2009", "2013"))) {
    stop("Year should be 2009 or 2013")
  }

  if (year == "2013") {
    data_sf <- ports2013
  } else if (year == "2009") {
    data_sf <- ports2009
  }
  return(data_sf)
}
