#' Read an aggregated GISCO dataset
#'
#' @inheritParams download_url
#' @param filters A named list where names are column names and values are the
#'   values to match, or a function that receives the local file path and
#'   returns that list.
#' @param operator A character string used to combine filters.
#' @param post_process Optional function applied after reading the file.
#'
#' @return An `sf` object, or `NULL` when the dataset cannot be read.
#' @noRd
read_gisco_dataset <- function(
  url,
  name = basename(url),
  cache = TRUE,
  cache_dir = NULL,
  subdir,
  update_cache = FALSE,
  verbose = FALSE,
  filters = NULL,
  operator = "AND",
  post_process = NULL
) {
  if (all(isFALSE(cache), !grepl("\\.zip$|\\.shp$", url, ignore.case = TRUE))) {
    msg <- paste0("{.url ", url, "}.")
    make_msg("info", verbose, "Reading from", msg)
    data_sf <- read_geo_file_sf(url)
  } else {
    file_local <- download_url(
      url,
      name,
      cache_dir,
      subdir,
      update_cache,
      verbose
    )
    if (is.null(file_local)) {
      return(NULL)
    }
    if (is.function(filters)) {
      filters <- filters(file_local)
    }
    data_sf <- read_geo_file_sf_filtered(
      file_local,
      filters = filters,
      operator = operator,
      verbose = verbose
    )
  }

  if (!is.null(post_process)) {
    data_sf <- post_process(data_sf)
  }
  data_sf
}

#' Read a packaged GISCO dataset when it matches the requested file
#'
#' @inheritParams download_url
#' @param filename A character string with the requested file name.
#' @param pattern A regular expression matching the packaged dataset file.
#' @param data An `sf` object included in the package.
#' @param data_name A character string with the packaged dataset object name.
#' @param post_process Optional function applied before returning the data.
#'
#' @return An `sf` object, or `NULL` when the packaged dataset does not match.
#' @noRd
read_packaged_gisco_dataset <- function(
  filename,
  pattern,
  data,
  data_name,
  update_cache = FALSE,
  verbose = FALSE,
  post_process = NULL
) {
  if (!all(isFALSE(update_cache), grepl(pattern, filename))) {
    return(NULL)
  }

  make_msg(
    "info",
    verbose,
    paste0("Loaded from {.help giscoR::", data_name, "} dataset."),
    "Use {.arg update_cache} = {.val {TRUE}} to reload from file."
  )

  if (!is.null(post_process)) {
    data <- post_process(data)
  }
  data
}
