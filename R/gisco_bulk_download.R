#' Bulk download from GISCO API
#'
#'
#' @family political
#'
#' @description
#' Downloads zipped data from GISCO and extract them on the
#' [`cache_dir`][gisco_set_cache_dir()] folder.
#'
#' @return Silent function.
#'
#' @param year Release year of the file. See **Details**.
#'
#' @param id_giscor Type of dataset to be downloaded. Values supported are:
#'   * `"coastallines"`.
#'   * `"communes"`.
#'   * `"countries"`.
#'   * `"lau"`.
#'   * `"nuts"`.
#'   * `"urban_audit"`.
#'
#' @inheritParams gisco_get_countries
#'
#'
#' @param ext Extension of the file(s) to be downloaded. Formats available are
#' `"geojson"`, `"shp"`, `"svg"`, `"json"`, `"gdb"`. See **Details**.
#'
#' @param recursive Tries to unzip recursively the zip files (if any) included
#' in the initial bulk download (case of `ext = "shp"`).
#' @param ... Ignored.
#'
#' @details
#'
#' See the years available in the corresponding functions:
#'  * [gisco_get_coastal_lines()].
#'  * [gisco_get_communes()].
#'  * [gisco_get_countries()].
#'  * [gisco_get_lau()].
#'  * [gisco_get_nuts()].
#'  * [gisco_get_urban_audit()].
#'
#' The usual extension used across \CRANpkg{giscoR} is `"geojson"`,
#' however other formats are already available on GISCO.
#'
#'
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>
#'
#'
#' @examplesIf gisco_check_access()
#' \dontrun{
#'
#' # Write on temp dir
#' tmp <- file.path(tempdir(), "testexample")
#'
#' ss <- gisco_bulk_download(
#'   id_giscor = "countries", resolution = "60",
#'   year = 2016, ext = "geojson",
#'   cache_dir = tmp
#' )
#' # Read one
#' library(sf)
#' f <- list.files(tmp, recursive = TRUE, full.names = TRUE)
#' f[1]
#' sf::read_sf(f[1])
#'
#' # Clean
#' unlink(tmp, force = TRUE)
#' }
#' @export
gisco_bulk_download <- function(
  id_giscor = c(
    "countries",
    "coastal_lines",
    "communes",
    "lau",
    "nuts",
    "urban_audit",
    "postal_codes"
  ),
  year = 2016,
  cache_dir = NULL,
  update_cache = FALSE,
  verbose = FALSE,
  resolution = 10,
  ext = c("shp", "geojson"),
  recursive = deprecated(),
  ...
) {
  dots <- list(...)
  if ("id_giscoR" %in% names(dots)) {
    lifecycle::deprecate_warn(
      "1.0.0",
      "gisco_bulk_download(id_giscoR)",
      "gisco_bulk_download(id_giscor)"
    )
    id_giscor <- dots$id_giscoR
  }

  id_giscor <- match_arg_pretty(id_giscor)
  ext <- match_arg_pretty(ext)

  # Standard parameters for the call
  year <- as.character(year)

  make_params <- make_bulk_params(
    id = id_giscor,
    year = year,
    resolution = resolution
  )

  routes <- get_url_db(
    id = id_giscor,
    year = year,
    epsg = make_params$epsg,
    resolution = make_params$resolution,
    spatialtype = make_params$spatialtype,
    nuts_level = make_params$nuts_level,
    level = make_params$level,
    ext = "shp",
    fn = "gisco_bulk_download"
  )

  # Restore
  if (
    id_giscor == "communes" && as.character(year) %in% c("2004", "2006", "2008")
  ) {
    make_params$resolution <- 1
  }

  api_entry <- gsub("/shp/.*", "/download", routes)
  get_alias <- switch(id_giscor,
    "coastal_lines" = "coastline",
    "urban_audit" = "urau",
    "postal_codes" = "pcode",
    id_giscor
  )
  zipname <- paste0("ref-", get_alias)
  zipname <- paste0(zipname, "-", year)
  if (!is.null(make_params$resolution)) {
    r <- sprintf("%02dm", as.numeric(make_params$resolution))
    if (make_params$resolution == "100") {
      r <- "100k"
    }
    zipname <- paste0(zipname, "-", r)
  }
  zipname <- paste0(zipname, ".", ext, ".zip")

  url <- file.path(api_entry, zipname)

  subdir <- switch(id_giscor,
    "coastal_lines" = "coastal",
    "postal_codes" = "postalcodes",
    id_giscor
  )

  destfile <- load_url(
    url,
    zipname,
    cache_dir,
    subdir,
    update_cache,
    verbose
  )

  if (is.null(destfile)) {
    return(NULL)
  }

  # Clean cache dir name for extracting
  unzip_dir <- gsub(paste0("/", zipname), "", destfile)

  infiles <- unzip(destfile, list = TRUE, junkpaths = TRUE)
  # Extract files
  outfiles <- infiles[grep(ext, infiles$Name), ]$Name

  if (verbose) {
    for_bullets <- outfiles
    names(for_bullets) <- rep(">", length(for_bullets))
    cli::cli_alert_info(c("Extracting files:"))
    cli::cli_bullets(for_bullets)
  }

  unlink(file.path(unzip_dir, outfiles))

  unzip(destfile, files = outfiles, exdir = unzip_dir)

  invisible(outfiles)
}

make_bulk_params <- function(id, year, resolution = NULL) {
  # Need this to ensure everything is captured
  make_params <- list(
    year = year,
    epsg = 4326,
    resolution = resolution,
    spatialtype = "RG",
    nuts_level = NULL,
    level = NULL,
    ext = "shp"
  )

  if (id == "urban_audit" && year < "2014") {
    make_params$level <- "CITY"
    make_params$resolution <- "03"
  }
  if (id == "urban_audit" && year >= "2014") {
    make_params$level <- "all"
    make_params$resolution <- "100"
  }

  if (id == "postal_codes") {
    make_params$resolution <- NULL
    make_params$spatialtype <- NULL
  }
  if (id == "nuts") {
    make_params$nuts_level <- "all"
  }
  if (id %in% c("communes", "lau")) {
    make_params$resolution <- "01"
  }

  if (id == "communes" && as.character(year) %in% c("2004", "2006", "2008")) {
    make_params$resolution <- NULL
  }
  make_params
}
