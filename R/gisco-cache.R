#' Set your \CRANpkg{giscoR} cache dir
#'
#' @family cache utilities
#' @seealso [rappdirs::user_config_dir()]
#'
#' @rdname gisco_set_cache_dir
#'
#' @description
#' This function will store your `cache_dir` path on your local machine and
#' would load it for future sessions. Type `Sys.getenv("GISCO_CACHE_DIR")` to
#' find your cached path or use [gisco_detect_cache_dir()].
#'
#' @inheritParams gisco_get_nuts
#' @param cache_dir A path to a cache directory. On missing value the function
#'   would store the cached files on a temporary dir (See [base::tempdir()]).
#' @param install If `TRUE`, will install the key in your local machine for
#'   use in future sessions.  Defaults to `FALSE.` If `cache_dir` is `FALSE`
#'   this argument is set to `FALSE` automatically.
#' @param overwrite If this is set to `TRUE`, it will overwrite an existing
#'   `GISCO_CACHE_DIR` that you already have in local machine.
#'
#' @details
#' By default, when no cache `cache_dir` is set the package uses a folder inside
#' [base::tempdir()] (so files are temporary and are removed when the **R**
#' session ends). To persist a cache across **R** sessions, use
#' `gisco_set_cache_dir(cache_dir, install = TRUE)` which writes the chosen
#' path to a small configuration file under
#' `rappdirs::user_config_dir("giscoR", "R")`.
#'
#' @return
#' `gisco_set_cache_dir()` returns an (invisible) character with the path to
#' your `cache_dir`, but it is mainly called for its side effect.
#'
#' @section Caching strategies:
#'
#' Some files can be read from its online source without caching using the
#' option `cache = FALSE`. Otherwise the source file would be downloaded to
#' your computer. \CRANpkg{giscoR} implements the following caching options:
#'
#' - For occasional use, rely on the default [tempdir()]-based cache (no
#'   install).
#' - Modify the cache for a single session setting
#'   `gisco_set_cache_dir(cache_dir = "a/path/here)`.
#' - For reproducible workflows, install a persistent cache with
#'   `gisco_set_cache_dir(cache_dir = "a/path/here, install = TRUE)` that would
#'   be kept across **R** sessions.
#' - For caching specific files, use the `cache_dir` argument in the
#'   corresponding function. See example in [gisco_get_nuts()].
#'
#' Sometimes cached files may be corrupt. On that case, try re-downloading
#' the data setting `update_cache = TRUE` in the corresponding function.
#'
#'  If you experience any problem on download, try to download the
#'  corresponding file by any other method and save it on your
#'  `cache_dir`. Use the option `verbose = TRUE` for debugging the API query
#'  and [gisco_detect_cache_dir()] to identify your cached path.
#'
#'
#' @examples
#'
#' # Don't run this! It would modify your current state
#' \dontrun{
#' my_cache <- gisco_detect_cache_dir()
#'
#' # Set an example cache
#' ex <- file.path(tempdir(), "example", "cachenew")
#' gisco_set_cache_dir(ex)
#'
#' gisco_detect_cache_dir()
#'
#' # Restore initial cache
#' gisco_set_cache_dir(my_cache)
#' identical(my_cache, gisco_detect_cache_dir())
#' }
#'
#' @export
gisco_set_cache_dir <- function(
  cache_dir,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
) {
  # Default if not provided
  if (missing(cache_dir) || cache_dir == "") {
    make_msg(
      "info",
      verbose,
      "Using a temporary cache dir (see {.fn base::tempdir}). ",
      "Set {.arg cache_dir} to a value for store permanently."
    )

    # Create a folder on tempdir
    cache_dir <- file.path(tempdir(), "giscoR")
    is_temp <- TRUE
    install <- FALSE
  } else {
    is_temp <- FALSE
  }

  # Validate
  stopifnot(
    is.character(cache_dir),
    is.logical(overwrite),
    is.logical(install)
  )

  # Create and expand
  cache_dir <- create_cache_dir(cache_dir)
  msg <- paste0("{.pkg giscoR} cache dir is {.path ", cache_dir, "}.")
  make_msg("info", verbose, msg)

  # Install path on environ var.
  # nocov start

  if (install) {
    config_dir <- rappdirs::user_config_dir("giscoR", "R")
    # Create cache dir if not presente
    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE)
    }

    giscor_file <- file.path(config_dir, "gisco_cache_dir")

    if (!file.exists(giscor_file) || overwrite == TRUE) {
      # Create file if it doesn't exist
      writeLines(cache_dir, con = giscor_file)
    } else {
      cli::cli_abort(
        c(
          "A {.arg cache_dir} path already exists.",
          "You can overwrite it with {.arg overwrite = TRUE}."
        )
      )
    }
    # nocov end
  } else {
    make_msg(
      "info",
      verbose && !is_temp,
      "To install your {.arg cache_dir} path for use in future sessions",
      "run this function with {.arg install = TRUE}."
    )
  }

  Sys.setenv(GISCO_CACHE_DIR = cache_dir)
  invisible(cache_dir)
}

#' @export
#' @rdname gisco_set_cache_dir
#' @return
#' `gisco_detect_cache_dir()` returns the path to the `cache_dir` used in this
#' session.
#'
#' @examples
#'
#' gisco_detect_cache_dir()
#'
gisco_detect_cache_dir <- function() {
  cd <- detect_cache_dir_muted()
  cli::cli_alert_info("{.path {cd}}")
  cd
}

#' Clear your \CRANpkg{giscoR} cache dir
#'
#' @rdname gisco_clear_cache
#' @family cache utilities
#'
#' @return Invisible. This function is called for its side effects.
#'
#' @description
#' **Use this function with caution**. This function would clear your cached
#' data and configuration, specifically:
#'
#' * Deletes the \CRANpkg{giscoR} config directory
#'   (`rappdirs::user_config_dir("giscoR", "R")`).
#' * Deletes the `cache_dir` directory.
#' * Deletes the values on stored on `Sys.getenv("GISCO_CACHE_DIR")`.
#'
#' @param config if `TRUE`, will delete the configuration folder of
#'   \CRANpkg{giscoR}.
#' @param cached_data If this is set to `TRUE`, it will delete your
#'   `cache_dir` and all its content.
#' @inheritParams gisco_set_cache_dir
#'
#' @seealso [rappdirs::user_config_dir()]
#'
#' @details
#' This is an overkill function that is intended to reset your status
#' as it you would never have installed and/or used \CRANpkg{giscoR}.
#'
#' @examples
#'
#' # Don't run this! It would modify your current state
#' \dontrun{
#' my_cache <- gisco_detect_cache_dir()
#'
#' # Set an example cache
#' ex <- file.path(tempdir(), "example", "cache")
#' gisco_set_cache_dir(ex, verbose = FALSE)
#'
#' # Restore initial cache
#' gisco_clear_cache(verbose = TRUE)
#'
#' gisco_set_cache_dir(my_cache)
#' identical(my_cache, gisco_detect_cache_dir())
#' }
#' @export
gisco_clear_cache <- function(
  config = FALSE,
  cached_data = TRUE,
  verbose = FALSE
) {
  config_dir <- rappdirs::user_config_dir("giscoR", "R")
  data_dir <- detect_cache_dir_muted()

  # nocov start
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)

    if (verbose) {
      cli::cli_alert_warning("{.pkg giscoR} cache config deleted")
    }
  }
  # nocov end
  if (cached_data && dir.exists(data_dir)) {
    unlink(data_dir, recursive = TRUE, force = TRUE)
    if (verbose) {
      cli::cli_alert_warning(
        "{.pkg giscoR} data deleted: {.file {data_dir}}"
      )
    }
  }

  Sys.setenv(GISCO_CACHE_DIR = "")

  # Reset cache dir
  invisible()
}

# Internal funs
detect_cache_dir_muted <- function() {
  # Try from getenv
  getvar <- Sys.getenv("GISCO_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || getvar == "") {
    # Not set - tries to retrieve from cache
    cache_config <- file.path(
      rappdirs::user_config_dir("giscoR", "R"),
      "gisco_cache_dir"
    )

    # nocov start
    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config)

      # Case on empty cached path - would default
      if (
        any(
          is.null(cached_path),
          is.na(cached_path),
          cached_path == ""
        )
      ) {
        cache_dir <- gisco_set_cache_dir(overwrite = TRUE, verbose = FALSE)
        return(cache_dir)
      }

      # 3. Return from cached path
      Sys.setenv(GISCO_CACHE_DIR = cached_path)
      cached_path
      # nocov end
    } else {
      # 4. Default cache location

      cache_dir <- gisco_set_cache_dir(overwrite = TRUE, verbose = FALSE)
      cache_dir
    }
  } else {
    getvar
  }
}


#' Creates `cache_dir`
#' @noRd
create_cache_dir <- function(cache_dir = NULL) {
  # Check cache dir from options if not set
  if (is.null(cache_dir)) {
    cache_dir <- detect_cache_dir_muted()
  }

  cache_dir <- path.expand(cache_dir)

  # Create cache dir if needed
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  cache_dir
}
