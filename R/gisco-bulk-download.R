#' GISCO API bulk download
#'
#' @description
#' Download zipped data from GISCO to the [`cache_dir`][gisco_set_cache_dir()]
#' and extract the relevant ones.
#'
#' @family extra
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @export
#'
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' @return
#' A (invisible) character vector with the full path of the files extracted.
#' See **Examples**.
#'
#' @param year character string or number. Release year of the file, see
#'   **Details**.
#'
#' @param id character string or number. Type of dataset to be
#'   downloaded, see **Details**. Values supported are:
#'   - `"countries"`
#'   - `"coastal_lines"`
#'   - `"communes"`
#'   - `"lau"`
#'   - `"nuts"`
#'   - `"urban_audit"`
#'   - `"postal_codes"`
#'
#'   This argument replaces the previous (deprecated) argument `id_giscoR`.
#' @param recursive `r lifecycle::badge("deprecated")` `recursive` is no
#'   longer supported; this function will never perform recursive extraction of
#'   child `.zip` files. This is the case of "`shp.zip` inside the top-level
#'   `.zip`, that won't be unzipped.
#' @param ... Ignored. The argument `id_giscoR`
#'   (`r lifecycle::badge("deprecated")`) would be captured via `...` and
#'   re-directed to `id` with a [warning][lifecycle::deprecate_warn].
#'
#' @param ext Extension of the file(s) to be downloaded. Formats available are
#' `"shp"`, `"geojson"`, `"svg"`, `"json"`, `"gdb"`. See **Details**.
#'
#' @details
#' Some arguments only apply to a specific value of `"id"`. For example
#' `"resolution"` would be ignored for values `"communes"`, `"lau"`,
#' `"urban_audit"` and `"postal_codes"`.
#'
#' See years available in the corresponding functions:
#'  * [gisco_get_countries()].
#'  * [gisco_get_coastal_lines()].
#'  * [gisco_get_communes()].
#'  * [gisco_get_lau()].
#'  * [gisco_get_nuts()].
#'  * [gisco_get_urban_audit()].
#'  * [gisco_get_postal_codes()].
#'
#' The usual extensions used across \CRANpkg{giscoR} are `"gpkg"` and `"shp"`,
#' however other formats are already available on GISCO. Note that after
#' performing a bulk download you may need to adjust the default `"ext"` value
#' in the corresponding function to connect it with the downloaded files (see
#' **Examples**).
#'
#' @examplesIf gisco_check_access()
#' tmp <- file.path(tempdir(), "testexample")
#' \donttest{
#' dest_files <- gisco_bulk_download(
#'   id = "countries", resolution = 60,
#'   year = 2024, ext = "geojson",
#'   cache_dir = tmp
#' )
#' # Read one
#' library(sf)
#' read_sf(dest_files[1]) |> head()
#'
#' # Now we can connect the function with the downloaded data like:
#'
#' connect <- gisco_get_countries(
#'   resolution = 60,
#'   year = 2024, ext = "geojson",
#'   cache_dir = tmp, verbose = TRUE
#' )
#'
#' # Message shows that file is already cached ;)
#' }
#' # Clean
#' unlink(tmp, force = TRUE)
gisco_bulk_download <- function(
  id = c(
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
  ext = c("shp", "geojson", "svg", "json", "gdb"),
  recursive = deprecated(),
  ...
) {
  dots <- list(...)

  if (lifecycle::is_present(recursive)) {
    lifecycle::deprecate_warn(
      "1.0.0",
      "giscoR::gisco_bulk_download(recursive)",
      details = paste0(
        "Child `.zip` files inside the top-level `.zip` won't be unzipped."
      )
    )
  }

  if ("id_giscoR" %in% names(dots)) {
    lifecycle::deprecate_warn(
      "1.0.0",
      "giscoR::gisco_bulk_download(id_giscoR)",
      "giscoR::gisco_bulk_download(id)"
    )
    id <- dots$id_giscoR
  }

  id <- match_arg_pretty(id)
  ext <- match_arg_pretty(ext)

  # Standard arguments for the call
  year <- as.character(year)

  make_params <- make_bulk_params(
    id = id,
    year = year,
    resolution = resolution
  )

  routes <- get_url_db(
    id = id,
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
  if (id == "communes" && as.character(year) %in% c("2004", "2006", "2008")) {
    make_params$resolution <- 1
  }

  api_entry <- gsub("/shp/.*", "/download", routes)
  get_alias <- switch(id,
    "coastal_lines" = "coastline",
    "urban_audit" = "urau",
    "postal_codes" = "pcode",
    id
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

  subdir <- switch(id,
    "coastal_lines" = "coastal",
    id
  )

  destfile <- download_url(
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

  out_full <- file.path(unzip_dir, outfiles)

  invisible(out_full)
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
