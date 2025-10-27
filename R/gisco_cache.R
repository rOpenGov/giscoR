#' Set your \CRANpkg{giscoR} cache dir
#'
#' @family cache utilities
#' @seealso [rappdirs::user_config_dir()]
#'
#' @rdname gisco_set_cache_dir
#'
#' @return
#' `gisco_set_cache_dir()` returns an (invisible) character with the path to
#' your `cache_dir`, but it is mainly called for its side effect.
#'
#' @description
#' This function will store your `cache_dir` path on your local machine and
#' would load it for future sessions. Type `Sys.getenv("GISCO_CACHE_DIR")` to
#' find your cached path or use [gisco_detect_cache_dir()].
#'
#' Alternatively, you can store the `cache_dir` manually with the following
#' options:
#'   * Run `Sys.setenv(GISCO_CACHE_DIR = "cache_dir")`. You would need to
#'     run this command on each session (Similar to `install = FALSE`).
#'   * Write this line on your `.Renviron` file:
#'     `GISCO_CACHE_DIR = "value_for_cache_dir"` (same behavior than
#'     `install = TRUE`). This would store your `cache_dir` permanently. See
#'     also `usethis::edit_r_environ()`.
#'
#' @inheritParams gisco_get_nuts
#' @param cache_dir A path to a cache directory. On missing value the function
#'   would store the cached files on a temporary dir (See [base::tempdir()]).
#' @param install If `TRUE`, will install the key in your local machine for
#'   use in future sessions.  Defaults to `FALSE.` If `cache_dir` is `FALSE`
#'   this parameter is set to `FALSE` automatically.
#' @param overwrite If this is set to `TRUE`, it will overwrite an existing
#'   `GISCO_CACHE_DIR` that you already have in local machine.
#'
#'
#' @examples
#'
#' # Don't run this! It would modify your current state
#' \dontrun{
#' gisco_set_cache_dir(verbose = TRUE)
#' }
#'
#' Sys.getenv("GISCO_CACHE_DIR")
#' @export
gisco_set_cache_dir <- function(
  cache_dir,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
) {
  # Default if not provided
  if (missing(cache_dir) || cache_dir == "") {
    gsc_message(
      verbose,
      "Using a temporary cache dir. ",
      "Set 'cache_dir' to a value for store permanently"
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

  # Expand
  cache_dir <- path.expand(cache_dir)

  # Create cache dir if it doesn't exists
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE)
  }

  gsc_message(
    verbose,
    "giscoR cache dir is: ",
    cache_dir
  )

  # Install path on environ var.

  if (install) {
    # nocov start
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
      stop(
        "A cache_dir path already exists.\nYou can overwrite it with the ",
        "argument overwrite = TRUE",
        call. = FALSE
      )
    }
    # nocov end
  } else {
    gsc_message(
      verbose && !is_temp,
      "To install your cache_dir path for use in future sessions,",
      "\nrun this function with `install = TRUE`."
    )
  }

  Sys.setenv(GISCO_CACHE_DIR = cache_dir)
  return(invisible(cache_dir))
}

gisco_clear_cache <- function(
  config = TRUE,
  cached_data = TRUE,
  verbose = FALSE
) {
  config_dir <- rappdirs::user_config_dir("giscoR", "R")
  data_dir <- gsc_helper_detect_cache_dir()
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)
    gsc_message(verbose, "giscoR cache config deleted")
  }

  if (cached_data && dir.exists(data_dir)) {
    unlink(data_dir, recursive = TRUE, force = TRUE, expand = TRUE)
    gsc_message(verbose, "giscoR cached data deleted: ", data_dir)
  }

  Sys.setenv(GISCO_CACHE_DIR = "")
  options(gisco_cache_dir = NULL)
  return(invisible())
}

#' Detect cache dir for giscoR
#'
#' @noRd
gsc_helper_detect_cache_dir <- function() {
  # Try from getenv
  getvar <- Sys.getenv("GISCO_CACHE_DIR")

  # 1. Get from option - This is from backwards compatibility only
  # nocov start
  from_option <- getOption("gisco_cache_dir", NULL)

  if (!is.null(from_option) && (is.null(getvar) || getvar == "")) {
    cache_dir <- gisco_set_cache_dir(from_option, install = FALSE)
    return(cache_dir)
  }

  if (is.null(getvar) || is.na(getvar) || getvar == "") {
    # Not set - tries to retrieve from cache
    cache_config <- file.path(
      rappdirs::user_config_dir("giscoR", "R"),
      "GISCO_CACHE_DIR"
    )

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
        cache_dir <- gisco_set_cache_dir(
          overwrite = TRUE,
          verbose = FALSE
        )
        return(cache_dir)
      }

      # 3. Return from cached path
      Sys.setenv(GISCO_CACHE_DIR = cached_path)
      cached_path
    } else {
      # 4. Default cache location

      cache_dir <- gisco_set_cache_dir(
        overwrite = TRUE,
        verbose = FALSE
      )
      cache_dir
    }
  } else {
    getvar
  }
  # nocov end
}


#' @export
#' @rdname gisco_set_cache_dir
#' @param ... Ignored
#' @return
#' `gisco_detect_cache_dir()` returns the path to the `cache_dir` used in this
#' session.
#'
#' @examples
#'
#' gisco_detect_cache_dir()
#'
gisco_detect_cache_dir <- function(...) {
  # nocov start
  # This is just a wrapper

  list(...)
  cache <- gsc_helper_detect_cache_dir()

  cache
  # nocov end
}
#' Creates `cache_dir`
#'
#' @inheritParams gisco_get_countries
#'
#' @noRd
gsc_helper_cachedir <- function(cache_dir = NULL) {
  # Check cache dir from options if not set
  if (is.null(cache_dir)) {
    cache_dir <- gsc_helper_detect_cache_dir()
  }

  # Create cache dir if needed
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  return(cache_dir)
}
