#' Clear your **giscoR** cache dir
#'
#' @name gisco_clear_cache
#' @family cache utilities
#'
#' @return Invisible. This function is called for its side effects.
#'
#' @description
#' **Use this function with caution**. This function would clear your cached
#' data and configuration, specifically:
#'
#' * Deletes the **giscoR** config directory
#'   (`rappdirs::user_config_dir("giscoR", "R")`).
#' * Deletes the `cache_dir` directory.
#' * Deletes the values on stored on `Sys.getenv("GISCO_CACHE_DIR")` and
#'   `options(gisco_cache_dir)`.
#'
#' @param config if `TRUE`, will delete the configuration folder of
#'   **giscoR**.
#' @param cached_data If this is set to `TRUE`, it will delete your
#'   `cache_dir` and all its content.
#' @inheritParams gisco_set_cache_dir
#'
#' @details
#' This is an overkill function that is intended to reset your status
#' as it you would never have installed and/or used **giscoR**.
#'
#' @examples
#'
#' # Don't run this! It would modify your current state
#' \dontrun{
#' gisco_clear_cache(verbose = TRUE)
#'
#' Sys.getenv("GISCO_CACHE_DIR")
#'
#' # Set new cache on a temp dir
#' newcache <- gisco_set_cache_dir(file.path(tempdir(), "giscoR", "pkgdown"))
#'
#' newcache
#'
#' Sys.getenv("GISCO_CACHE_DIR")
#' }
#' @export
gisco_clear_cache <- function(config = FALSE,
                              cached_data = TRUE,
                              verbose = FALSE) {
  # nocov start
  config_dir <- rappdirs::user_config_dir("giscoR", "R")
  data_dir <- gsc_helper_detect_cache_dir()
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)
    if (verbose) message("giscoR cache config deleted")
  }
  # nocov end
  if (cached_data && dir.exists(data_dir)) {
    unlink(data_dir, recursive = TRUE, force = TRUE)
    if (verbose) message("giscoR cached data deleted: ", data_dir)
  }


  Sys.setenv(GISCO_CACHE_DIR = "")
  options(gisco_cache_dir = NULL)

  # Reset cache dir
  return(invisible())
}
