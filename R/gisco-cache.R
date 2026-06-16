#' Set your \CRANpkg{giscoR} cache directory
#'
#' @description
#' Stores your `cache_dir` path on your local machine and loads it in future
#' sessions. Use `Sys.getenv("GISCO_CACHE_DIR")` or
#' [gisco_detect_cache_dir()] to find your cached path.
#'
#' @rdname gisco_set_cache_dir
#'
#' @family cache utilities
#' @encoding UTF-8
#' @inheritParams gisco_get_nuts
#' @param cache_dir A path to a cache directory. If `NULL`, the function
#'   stores cached files in a temporary directory (see [base::tempdir()]).
#' @param install If `TRUE`, install the cache path on your local machine for
#'   use in future sessions. Defaults to `FALSE`. If `cache_dir` is `FALSE`,
#'   `install` is automatically set to `FALSE`.
#' @param overwrite If `TRUE`, overwrite an existing
#'   `GISCO_CACHE_DIR` that you already have on your local machine.
#'
#' @return
#' `gisco_set_cache_dir()` invisibly returns a character string with the path
#' to your `cache_dir`, but it is mainly called for its side effect.
#'
#' @details
#' By default, when no cache `cache_dir` is set, the package uses a folder
#' inside [base::tempdir()] (so files are temporary and are removed when the
#' \R session ends). To persist a cache across \R sessions, use
#' `gisco_set_cache_dir(cache_dir, install = TRUE)`, which writes the chosen
#' path to a small configuration file under
#' `tools::R_user_dir("giscoR", "config")`.
#'
#' @section Caching strategies:
#'
#' Some files can be read from their online source without caching using the
#' option `cache = FALSE`. Otherwise the source file is downloaded to
#' your computer. \CRANpkg{giscoR} implements the following caching options:
#'
#' - For occasional use, rely on the default [tempdir()]-based cache (no
#'   install).
#' - Modify the cache for a single session by setting
#'   `gisco_set_cache_dir(cache_dir = "a/path/here")`.
#' - For reproducible workflows, install a persistent cache with
#'   `gisco_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`, which
#'   keeps the path across \R sessions.
#' - For caching specific files, use the `cache_dir` argument in the
#'   corresponding function. See example in [gisco_get_nuts()].
#'
#' Sometimes cached files may be corrupt. In that case, try downloading the
#' data by setting `update_cache = TRUE` in the corresponding function.
#'
#' If you experience a download problem, try to download the corresponding
#' file by another method and save it in your `cache_dir`. Use
#' `verbose = TRUE` to debug the API query and [gisco_detect_cache_dir()] to
#' identify your cached path.
#'
#' @note
#'
#' In \CRANpkg{giscoR} >= 1.0.0 the location of the configuration file has
#' moved from `rappdirs::user_config_dir("giscoR", "R")` to
#' `tools::R_user_dir("giscoR", "config")`. We have implemented a function
#' that migrates previous configuration files from one location to another
#' with a message. The message appears only once to inform you of the
#' migration.
#'
#' @seealso [tools::R_user_dir()]
#' @examples
#'
#' # Do not run this. It modifies your current state.
#' \dontrun{
#' my_cache <- gisco_detect_cache_dir()
#'
#' # Set an example cache.
#' ex <- file.path(tempdir(), "example", "cachenew")
#' gisco_set_cache_dir(ex)
#'
#' gisco_detect_cache_dir()
#'
#' # Restore the initial cache.
#' gisco_set_cache_dir(my_cache)
#' identical(my_cache, gisco_detect_cache_dir())
#' }
#'
#' @export
gisco_set_cache_dir <- function(
  cache_dir = NULL,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
) {
  cache_dir <- ensure_null(cache_dir)

  # Use a temporary cache when no path is provided.
  if (is.null(cache_dir)) {
    make_msg(
      "info",
      verbose,
      "Using a temporary cache directory, see {.fn base::tempdir}.",
      "Set {.arg cache_dir} to a value to store permanently."
    )

    # Create a folder in the session temporary directory.
    cache_dir <- file.path(tempdir(), "giscoR")
    is_temp <- TRUE
    install <- FALSE
  } else {
    is_temp <- FALSE
  }

  # Validate inputs.
  stopifnot(is.character(cache_dir), is.logical(overwrite), is.logical(install))

  # Create and expand the cache path.
  cache_dir <- create_cache_dir(cache_dir)
  msg <- paste0("{.pkg giscoR} cache directory is {.path ", cache_dir, "}.")
  make_msg("info", verbose, msg)

  # Install the cache path in the environment variable.
  # nocov start

  if (install) {
    config_dir <- tools::R_user_dir("giscoR", "config")
    # Create cache directory if not present.

    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE)
    }

    giscor_file <- file.path(config_dir, "gisco_cache_dir")

    if (!file.exists(giscor_file) || overwrite) {
      # Create file if it does not exist.
      writeLines(cache_dir, con = giscor_file)
    } else {
      cli::cli_abort(c(
        "A {.arg cache_dir} path already exists.",
        "You can overwrite it with {.arg overwrite} = {.val {TRUE}}."
      ))
    }
    # nocov end
  } else {
    make_msg(
      "info",
      verbose && !is_temp,
      "To install your {.arg cache_dir} path for future sessions,",
      "run this function with {.arg install} = {.val {TRUE}}."
    )
  }

  Sys.setenv(GISCO_CACHE_DIR = cache_dir)
  invisible(cache_dir)
}

#' @rdname gisco_set_cache_dir
#' @return
#' `gisco_detect_cache_dir()` returns the path to the `cache_dir` used in this
#' session.
#'
#' @examples
#'
#' gisco_detect_cache_dir()
#'
#' @export
gisco_detect_cache_dir <- function() {
  cd <- detect_cache_dir_muted()
  cli::cli_alert_info("{.path {cd}}")
  cd
}

#' Clear your \CRANpkg{giscoR} cache directory
#'
#' @description
#' **Use this function with caution**. It clears your cached data and
#' configuration, specifically:
#'
#' - Deletes the \CRANpkg{giscoR} config directory
#'   (`tools::R_user_dir("giscoR", "config")`).
#' - Deletes the `cache_dir` directory.
#' - Deletes the value stored in `Sys.getenv("GISCO_CACHE_DIR")`.
#'
#' @rdname gisco_clear_cache
#' @family cache utilities
#' @encoding UTF-8
#' @inheritParams gisco_set_cache_dir
#'
#' @param config If `TRUE`, delete the configuration folder of
#'   \CRANpkg{giscoR}.
#' @param cached_data If `TRUE`, delete your `cache_dir` and all its content.
#' @return Invisible. Called for its side effects.
#'
#' @details
#' Fully resets your cache state as if you had never installed or used
#' \CRANpkg{giscoR}.
#'
#' @seealso [tools::R_user_dir()]
#'
#' @examples
#'
#' # Do not run this. It modifies your current state.
#' \dontrun{
#' my_cache <- gisco_detect_cache_dir()
#'
#' # Set an example cache.
#' ex <- file.path(tempdir(), "example", "cache")
#' gisco_set_cache_dir(ex, verbose = FALSE)
#'
#' # Restore the initial cache.
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
  migrate_cache()

  config_dir <- tools::R_user_dir("giscoR", "config")
  data_dir <- detect_cache_dir_muted()

  # nocov start
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)

    if (verbose) {
      cli::cli_alert_warning("Deleted {.pkg giscoR} cache configuration.")
    }
  }
  # nocov end
  if (cached_data && dir.exists(data_dir)) {
    siz <- file.size(list.files(data_dir, recursive = TRUE, full.names = TRUE))
    siz <- sum(siz, na.rm = TRUE)
    class(siz) <- class(object.size("a"))

    siz <- format(siz, unit = "auto")

    unlink(data_dir, recursive = TRUE, force = TRUE)
    if (verbose) {
      cli::cli_alert_warning(
        "Deleted {.pkg giscoR} data: {.file {data_dir}} ({siz})."
      )
    }
  }

  Sys.setenv(GISCO_CACHE_DIR = "")

  # Reset cache directory.
  invisible()
}

# Internal functions ----

#' Detect cache directory silently
#'
#' @return Path to cache directory.
#' @noRd
detect_cache_dir_muted <- function() {
  migrate_cache()

  # Try the environment variable.
  getvar <- Sys.getenv("GISCO_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || !nzchar(getvar)) {
    # If unset, try to retrieve the value from the cache config.
    cache_config <- file.path(
      tools::R_user_dir("giscoR", "config"),
      "gisco_cache_dir"
    )

    # nocov start
    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config)

      # Use the default when the cached path is empty.
      if (any(is.null(cached_path), is.na(cached_path), !nzchar(cached_path))) {
        cache_dir <- gisco_set_cache_dir(overwrite = TRUE, verbose = FALSE)
        return(cache_dir)
      }

      # Return the cached path.
      Sys.setenv(GISCO_CACHE_DIR = cached_path)
      cached_path
      # nocov end
    } else {
      # Use the default cache location.

      cache_dir <- gisco_set_cache_dir(overwrite = TRUE, verbose = FALSE)
      cache_dir
    }
  } else {
    getvar
  }
}

#' Create `cache_dir` if it does not exist
#'
#' @param cache_dir A path to a cache directory.
#' @return Path to cache directory.
#'
#' @noRd
create_cache_dir <- function(cache_dir = NULL) {
  # Check the cache directory from options if it is not set.
  if (is.null(cache_dir)) {
    cache_dir <- detect_cache_dir_muted()
  }

  cache_dir <- path.expand(cache_dir)

  # Create the cache directory if needed.
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  cache_dir
}

#' Migrate cache config from rappdirs to tools
#'
#' One-time function for \CRANpkg{giscoR} >= 1.0.0.
#' @param old A path to the old cache config folder.
#' @param new A path to the new cache config folder.
#'
#' @noRd
migrate_cache <- function(
  old = rappdirs::user_config_dir("giscoR", "R"),
  new = tools::R_user_dir("giscoR", "config")
) {
  fname <- "gisco_cache_dir"

  old_fname <- file.path(old, fname)
  new_fname <- file.path(new, fname)

  if (file.exists(new_fname)) {
    unlink(old, force = TRUE, recursive = TRUE)
    return(invisible())
  }

  if (file.exists(old_fname)) {
    cache_dir <- readLines(old_fname)
    gisco_set_cache_dir(cache_dir, install = TRUE, verbose = FALSE)
    cli::cli_alert_success(c(
      "{.pkg giscoR} >= 1.0.0: cache configuration migrated. ",
      "See {.strong Note} in {.fn giscoR::gisco_set_cache_dir} for details."
    ))
    cli::cli_alert_info(
      "This is a one-time message and will not be displayed again."
    )
  }
  unlink(old, force = TRUE, recursive = TRUE)

  invisible()
}
