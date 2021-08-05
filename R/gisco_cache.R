#' Set your GISCO cache dir
#'
#' @concept helper
#'
#' @return Invisible value
#' @description
#' This function will store your `cache_dir` path on your local machine and
#' would load it for future sessions. Type `Sys.getenv("GISCO_CACHE_DIR")` to
#' find your cached path.
#'
#' Alternatively, you can store the `cache_dir` manually with the following
#' options:
#'   * Run `Sys.setenv(GISCO_CACHE_DIR = "cache_dir")`. You would need to
#'     run this command on each session (Similar to `install = FALSE`).
#'   * Set `options(gisco_cache_dir = "cache_dir")`. Similar to the previous
#'     option.
#'   * Write this line on your .Renviron file: `GISCO_CACHE_DIR = "cache_dir"`
#'     (same behavior than `install = TRUE`). This would store your `cache_dir`
#'     permanently.
#'
#' @inheritParams gisco_get_countries
#' @param cache_dir A path to a cache directory.
#' @param install if `TRUE`, will install the key in your local machine for
#'   use in future sessions.  Defaults to `FALSE.`
#' @param overwrite If this is set to `TRUE`, it will overwrite an existing
#'   `GISCO_CACHE_DIR` that you already have in local machine.
#'
#' @seealso [rappdirs::user_cache_dir()]
#'
#' @examples
#'
#' # Default location of the downloaded files on this machine
#' rappdirs::user_cache_dir("giscoR", "R")
#'
#' # Don't run these examples! They would modify your current state
#' \dontrun{
#' gisco_set_cache_dir(verbose = TRUE)
#' }
#'
#' @export
gisco_set_cache_dir <- function(cache_dir = rappdirs::user_cache_dir("giscoR", "R"),
                                overwrite = TRUE,
                                install = TRUE,
                                verbose = FALSE) {

  # nocov start
  # Validate
  stopifnot(
    is.character(cache_dir),
    is.logical(overwrite),
    is.logical(install)
  )


  # Create cache dir if it doesn't exists
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE)
  }

  if (verbose) {
    message(
      "GISCO Cache dir is: ",
      cache_dir
    )
  }


  # Install path on environ var.

  if (install) {
    config_dir <- rappdirs::user_cache_dir("giscoR", "R")
    # Create cache dir if not presente
    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE)
    }

    gisco_file <- file.path(config_dir, "gisco_cache_dir")

    if (!file.exists(gisco_file) || overwrite == TRUE) {
      # Create file if it doesn't exist
      writeLines(cache_dir, con = gisco_file)
    } else {
      stop(
        "A cache_dir path already exists. You can overwrite it with the ",
        "argument overwrite=TRUE",
        call. = FALSE
      )
    }
  } else {
    if (verbose) {
      message(
        "To install your cache_dir path for use in future sessions, run this ",
        "function with `install = TRUE`."
      )
    }
  }

  Sys.setenv(GISCO_CACHE_DIR = cache_dir)
  return(invisible())
  # nocov end
}


#' Detect cache dir for GISCO
#'
#' @noRd
gsc_helper_detect_cache_dir <- function() {

  # Try from getenv
  getvar <- Sys.getenv("GISCO_CACHE_DIR")


  # 1. Get from option - This is from backwards compatibility only
  # nocov start
  from_option <- getOption("gisco_cache_dir", NULL)

  if (!is.null(from_option) && (is.null(getvar) || getvar == "")) {
    Sys.setenv(GISCO_CACHE_DIR = from_option)
    return(from_option)
  }




  if (is.null(getvar) || is.na(getvar) || getvar == "") {
    # Not set - tries to retrieve from cache
    cachedir <- rappdirs::user_cache_dir("giscoR", "R")
    gisco_cache_path <- file.path(cachedir, "gisco_cache_dir")

    if (file.exists(gisco_cache_path)) {
      cached_path <- readLines(gisco_cache_path)

      # Case on empty cached path - would default
      if (is.null(cached_path) ||
        is.na(cached_path) || cached_path == "") {
        gisco_set_cache_dir(
          install = TRUE, overwrite = TRUE,
          verbose = FALSE
        )
        return(rappdirs::user_cache_dir("giscoR", "R"))
      }

      # 3. Return from cached path
      Sys.setenv(GISCO_CACHE_DIR = cached_path)
      return(cached_path)
    } else {
      # 4. Default cache location

      gisco_set_cache_dir(
        install = TRUE, overwrite = TRUE,
        verbose = FALSE
      )
      return(rappdirs::user_cache_dir("giscoR", "R"))
    }
  } else {
    return(getvar)
  }
  # nocov end
}
