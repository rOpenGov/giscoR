#' GISCO geodata bulk download
#'
#' @description
#' Download zipped data from GISCO to the [`cache_dir`][gisco_set_cache_dir()]
#' and extract the relevant files.
#'
#' @family extra
#' @encoding UTF-8
#' @inheritParams gisco_get_countries
#' @param year A character string or numeric value with the release year of the
#'   file, see **Details**.
#'
#' @param id A character string or numeric value with the dataset type to
#'   download, see **Details**. Values supported are:
#' - `"countries"`
#' - `"coastal_lines"`
#' - `"communes"`
#' - `"lau"`
#' - `"nuts"`
#' - `"urban_audit"`
#' - `"postal_codes"`
#'
#'   This argument replaces the previous (deprecated) argument `id_giscoR`.
#' @param recursive `r lifecycle::badge("deprecated")` `recursive` is no
#'   longer supported. This function will never perform recursive
#'   extraction of child `.zip` files. This is the case for "`shp.zip` inside
#'   the top-level `.zip`, which will not be unzipped.
#' @param ... Ignored. The argument `id_giscoR`
#'   (`r lifecycle::badge("deprecated")`) is captured via `...` and redirected
#'   to `id` with a [warning][lifecycle::deprecate_warn].
#'
#' @param ext The extension of the file or files to download. Available
#'   formats are `"shp"`, `"geojson"`, `"svg"`, `"json"` and `"gdb"`. See
#'   **Details**.
#'
#' @return
#' An invisible character vector with the full path of the files extracted.
#' See **Examples**.
#'
#' @details
#' Some arguments only apply to a specific value of `"id"`. For example
#' `"resolution"` is ignored for values `"communes"`, `"lau"`,
#' `"urban_audit"` and `"postal_codes"`.
#'
#' See years available in the corresponding functions:
#' - [gisco_get_countries()].
#' - [gisco_get_coastal_lines()].
#' - [gisco_get_communes()].
#' - [gisco_get_lau()].
#' - [gisco_get_nuts()].
#' - [gisco_get_urban_audit()].
#' - [gisco_get_postal_codes()].
#'
#' The usual extensions used across \CRANpkg{giscoR} are `"gpkg"` and `"shp"`,
#' but other formats are already available on GISCO. After a bulk download, you
#' may need to adjust the default `ext` value in the corresponding function
#' to connect it with the downloaded files (see **Examples**).
#'
#' @source <https://gisco-services.ec.europa.eu/distribution/v2/>.
#'
#' @examplesIf gisco_check_access()
#' tmp <- file.path(tempdir(), "testexample")
#' \donttest{
#' dest_files <- gisco_bulk_download(
#'   id = "countries", resolution = 60,
#'   year = 2024, ext = "geojson",
#'   cache_dir = tmp
#' )
#' # Read one file.
#' library(sf)
#' read_sf(dest_files[1]) |> head()
#'
#' # Connect the function with the downloaded data.
#'
#' connect <- gisco_get_countries(
#'   resolution = 60,
#'   year = 2024, ext = "geojson",
#'   cache_dir = tmp, verbose = TRUE
#' )
#'
#' # The message shows that the file is already cached.
#' }
#' # Clean up.
#' unlink(tmp, force = TRUE)
#' @export
#'
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
        "Child `.zip` files inside the top-level `.zip` will not be unzipped."
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

  # Set standard arguments for the call.
  year <- as.character(year)

  make_params <- make_bulk_params(id = id, year = year, resolution = resolution)

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

  # Restore legacy commune resolution handling.
  if (id == "communes" && as.character(year) %in% c("2004", "2006", "2008")) {
    make_params$resolution <- 1
  }

  api_entry <- bulk_download_api_entry(routes)
  zipname <- build_bulk_zip_name(
    id,
    year,
    make_params$resolution,
    ext
  )
  url <- file.path(api_entry, zipname)
  subdir <- bulk_download_subdir(id)

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

  # Clean the cache directory name before extracting.
  unzip_dir <- gsub(paste0("/", zipname), "", destfile)

  infiles <- list_bulk_zip_files(destfile)
  # Extract files.
  outfiles <- infiles[grep(ext, infiles$Name), ]$Name

  if (verbose) {
    for_bullets <- outfiles
    names(for_bullets) <- rep(">", length(for_bullets))
    cli::cli_alert_info("Extracting files:")
    cli::cli_bullets(for_bullets)
  }

  unlink(file.path(unzip_dir, outfiles))

  extract_bulk_zip_files(destfile, files = outfiles, exdir = unzip_dir)

  out_full <- file.path(unzip_dir, outfiles)

  invisible(out_full)
}

#' Get the bulk-download API entry from a distribution route
#'
#' @param route A distribution API route.
#'
#' @return A character string with the bulk-download API entry.
#' @noRd
bulk_download_api_entry <- function(route) {
  gsub("/shp/.*", "/download", route)
}

#' Get the dataset alias used in bulk-download file names
#'
#' @param id A dataset ID.
#'
#' @return A character string with the bulk-download alias.
#' @noRd
bulk_download_alias <- function(id) {
  switch(id,
    "coastal_lines" = "coastline",
    "urban_audit" = "urau",
    "postal_codes" = "pcode",
    id
  )
}

#' Get the cache subdirectory used by bulk download
#'
#' @param id A dataset ID.
#'
#' @return A character string with the cache subdirectory.
#' @noRd
bulk_download_subdir <- function(id) {
  switch(id,
    "coastal_lines" = "coastal",
    id
  )
}

#' Build a bulk-download ZIP file name
#'
#' @param id A dataset ID.
#' @param year A year.
#' @param resolution A resolution, or `NULL`.
#' @param ext A file extension.
#'
#' @return A character string with the ZIP file name.
#' @noRd
build_bulk_zip_name <- function(id, year, resolution = NULL, ext) {
  zipname <- paste0("ref-", bulk_download_alias(id), "-", year)
  if (!is.null(resolution)) {
    zipname <- paste0(zipname, "-", format_bulk_resolution(resolution))
  }
  paste0(zipname, ".", ext, ".zip")
}

#' List files in a bulk-download ZIP
#'
#' @param zipfile A ZIP file path.
#'
#' @return A data frame returned by [unzip()].
#' @noRd
list_bulk_zip_files <- function(zipfile) {
  unzip(zipfile, list = TRUE, junkpaths = TRUE)
}

#' Extract selected files from a bulk-download ZIP
#'
#' @param zipfile A ZIP file path.
#' @param files Files to extract.
#' @param exdir Extraction directory.
#'
#' @return The result of [unzip()].
#' @noRd
extract_bulk_zip_files <- function(zipfile, files, exdir) {
  unzip(zipfile, files = files, exdir = exdir)
}

#' Set arguments for bulk download
#'
#' @param id A dataset ID.
#' @param year A year.
#' @param resolution A resolution.
#'
#' @return A list of arguments.
#' @noRd
make_bulk_params <- function(id, year, resolution = NULL) {
  # Keep every bulk-download parameter explicit.
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
