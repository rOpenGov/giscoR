# nocov start

# Load database on load
.onLoad <- function(libname, pkgname) {
  # Ensure that db is loaded on load
  db <- get_db() # nolint
}

# nocov end
