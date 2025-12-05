#' Create messages based on type
#'
#' @param type character string. Type of message. Accepted values are
#'  `"generic"`, `"success"`, `"warning"`, `"danger"` or `"info"`.
#'
#' @param verbose logical. Whether to print the message or not.
#' @param ... Character strings to be combined into the message.
#'
#' @returns
#' Invisibly returns `NULL`. Prints messages to the console if `verbose` is
#' `TRUE`.
#'
#' @noRd
make_msg <- function(type = "generic", verbose, ...) {
  if (!verbose) {
    return(invisible())
  }
  dots <- list(...)
  msg <- paste(dots, collapse = " ")

  if (type == "generic") {
    cli::cli_alert(msg)
  }
  if (type == "success") {
    cli::cli_alert_success(msg)
  }
  if (type == "warning") {
    cli::cli_alert_warning(msg)
  }
  if (type == "danger") {
    cli::cli_alert_danger(msg)
  }
  if (type == "info") {
    cli::cli_alert_info(msg)
  }
  invisible()
}

#' Match argument with pretty error message
#'
#' @param arg The argument to match.
#' @param choices The possible choices for the argument.
#'
#' @returns
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

  lmatch <- match(arg, choices)
  # Hint
  aproxmatch <- pmatch(arg, choices)[1]

  if (length(arg) > 1 || is.na(lmatch)) {
    # Create error message
    if (length(choices) == 1) {
      msg <- paste0("{.str ", choices, "}")
    } else {
      l_choices <- length(choices)
      msg <- paste0("{.str ", choices[-l_choices], "}", collapse = ", ")
      msg <- paste0(msg, " or {.str ", choices[l_choices], "}")
      # Add one of at the begining
      msg <- paste0("one of ", msg)
    }

    msg <- paste0(msg, ", not ")
    bad_arg <- paste0("{.str ", arg, "}", collapse = " or ")
    msg <- paste0(msg, bad_arg, ".")

    # Maybe is a regex?
    reg_msg <- NULL
    if (!is.na(aproxmatch)) {
      aprox <- choices[aproxmatch]
      aprox_val <- paste0("{.str ", aprox, "}", collapse = " or ")
      reg_msg <- paste0("Did you mean ", aprox_val, "?")
    }

    cli::cli_abort(
      c(
        paste0("{.arg {arg_name}} should be ", msg),
        "i" = reg_msg
      ),
      call = NULL
    )
  }

  choices[lmatch]
}


#' Row bind data frames or lists with different columns, filling missing
#' columns with `NA`.
#'
#' @param a_list A list of data frames or lists to row bind.
#' @return
#' A data frame resulting from row binding the input data frames or sf objects.
#'
#' @noRd
rbind_fill <- function(a_list) {
  # Drop nulls
  is_null <- vapply(a_list, is.null, FUN.VALUE = logical(1))
  a_list <- a_list[!is_null]
  if (length(a_list) == 0) {
    return(NULL)
  }
  # Get all names
  nms <- unique(unlist(lapply(a_list, names)))

  a_list <- lapply(
    a_list,
    function(x) {
      for (i in nms[!nms %in% names(x)]) {
        x[[i]] <- NA
      }
      x
    }
  )
  names(a_list) <- NULL
  binded <- do.call(rbind, a_list)
  binded
}
