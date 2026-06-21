#' Create messages by type
#'
#' @param type A character string with the message type. Accepted values are
#'   `"generic"`, `"success"`, `"warning"`, `"danger"` or `"info"`.
#'
#' @param verbose A logical value indicating whether to print the message.
#' @param ... Character strings to be combined into the message.
#'
#' @return
#' Invisibly returns `NULL`. Prints messages to the console if `verbose` is
#' `TRUE`.
#'
#' @noRd
make_msg <- function(type = "generic", verbose, ..., .envir = parent.frame()) {
  cli_abort_if_not(
    "{.arg verbose} must be a {.cls logical}." = is.logical(verbose),
    .envir = .envir
  )
  if (!verbose) {
    return(invisible())
  }
  dots <- list(...)
  msg <- paste(dots, collapse = " ")

  alert <- switch(
    type,
    generic = cli::cli_alert,
    success = cli::cli_alert_success,
    warning = cli::cli_alert_warning,
    danger = cli::cli_alert_danger,
    info = cli::cli_alert_info,
    cli::cli_alert
  )
  alert(msg)
  invisible()
}

#' Match argument with pretty error message
#'
#' @param arg The argument to match.
#' @param choices The possible choices for the argument.
#'
#' @return
#' The matched argument.
#'
#' @noRd
match_arg_pretty <- function(arg, choices) {
  arg_name <- as.character(substitute(arg)) # nolint

  if (missing(choices)) {
    formal_args <- formals(sys.function(sys_par <- sys.parent()))
    choices <- eval(
      formal_args[[as.character(substitute(arg))]],
      envir = sys.frame(sys_par)
    )
  }
  choices <- as.character(choices)

  if (is.null(arg)) {
    return(choices[1L])
  }

  arg <- as.character(arg)

  if (identical(arg, choices)) {
    return(arg[1])
  }

  if (length(arg) == 1 && arg %in% choices) {
    return(arg)
  }

  msg <- paste0(
    "{.arg {arg_name}} must be {.or {.str {choices}}}, not ",
    "{.or {.str {arg}}}."
  )

  hint <- NULL
  if (length(arg) == 1) {
    partial_match <- pmatch(arg, choices)[1]
    if (!is.na(partial_match)) {
      hint <- paste0("Did you mean {.str ", choices[partial_match], "}?")
    }
  }

  cli::cli_abort(c(msg, i = hint), call = NULL)
}

#' Warn for deprecated cache arguments on always-cached functions
#'
#' @param cache Deprecated cache argument.
#' @param what A character string identifying the deprecated call.
#'
#' @return Invisibly returns `NULL`.
#' @noRd
warn_deprecated_cache <- function(cache, what) {
  if (!lifecycle::is_present(cache)) {
    return(invisible(NULL))
  }

  lifecycle::deprecate_warn(
    when = "1.0.0",
    what = what,
    details = paste0(
      "Results are always cached. To avoid persistent cache files, use ",
      "`cache_dir = tempdir()`."
    )
  )
  invisible(NULL)
}

#' Row-bind data frames filling missing columns with `NA`
#'
#' @param a_list A list of data frames or lists to row bind.
#' @return
#' A data frame resulting from row binding the input data frames or `sf`
#' objects.
#'
#' @noRd
rbind_fill <- function(a_list) {
  # Drop NULL values.
  is_null <- vapply(a_list, is.null, FUN.VALUE = logical(1))
  a_list <- a_list[!is_null]
  if (length(a_list) == 0) {
    return(NULL)
  }
  # Collect all column names across data frames.
  nms <- unique(unlist(lapply(a_list, names)))

  a_list <- lapply(a_list, function(x) {
    for (i in nms[!nms %in% names(x)]) {
      x[[i]] <- NA
    }
    x
  })
  names(a_list) <- NULL
  binded <- do.call(rbind, a_list)
  binded
}

ensure_null <- function(x) {
  x_init <- x
  x <- as.vector(x)
  x[is.null(x)] <- NA
  x[is.na(x)] <- NA
  x[nchar(as.character(x)) == 0] <- NA
  if (all(is.na(x))) {
    return(NULL)
  }

  x_init
}

#' Format GISCO unit resolution text
#'
#' @param resolution A numeric or character resolution value.
#'
#' @return A character string used in GISCO file names.
#' @noRd
format_unit_resolution <- function(resolution) {
  sprintf("%02dm", as.numeric(resolution))
}

#' Format Urban Audit unit resolution text
#'
#' @param year A character string or numeric value with the release year.
#'
#' @return A character string used in Urban Audit unit file names.
#' @noRd
format_urau_unit_resolution <- function(year) {
  year <- as.numeric(year)
  if (year < 2014) {
    return("03M")
  }
  if (year == 2014) {
    return("100K")
  }
  "100k"
}

#' Format GISCO bulk download resolution text
#'
#' @param resolution A numeric or character resolution value.
#'
#' @return A character string used in GISCO bulk download file names.
#' @noRd
format_bulk_resolution <- function(resolution) {
  if (as.character(resolution) == "100") {
    return("100k")
  }

  format_unit_resolution(resolution)
}

# https://github.com/r-lib/cli/issues/672
# Thanks to https://github.com/wurli
cli_abort_if_not <- function(
  ...,
  .call = .envir,
  .envir = parent.frame(),
  .frame = .envir
) {
  for (i in seq_len(...length())) {
    if (!all(...elt(i))) {
      cli::cli_abort(
        ...names()[i],
        .call = .call,
        .envir = .envir,
        .frame = .frame
      )
    }
  }
  invisible(NULL)
}
