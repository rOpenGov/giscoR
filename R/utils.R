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
