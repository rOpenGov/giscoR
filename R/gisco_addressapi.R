gisco_addressapi_countries <- function(verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/countries"
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl, filename,
    cache_dir = tempdir(), update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  return(res)
}

gisco_addressapi_provinces <- function(country = NULL, city = NULL,
                                       verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/provinces?"
  custom_query <- list(
    country = country,
    city = city
  )

  apiurl <- add_custom_query(custom_query, apiurl)
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl, filename,
    cache_dir = tempdir(), update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  res <- as.data.frame(res)
  if (nrow(res) == 0) {
    message("No results, returning NULL")
    return(NULL)
  }
  return(res)
}

gisco_addressapi_cities <- function(country = NULL, province = NULL,
                                    verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/cities?"
  custom_query <- list(
    country = country,
    province = province
  )

  apiurl <- add_custom_query(custom_query, apiurl)
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl, filename,
    cache_dir = tempdir(), update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  res <- as.data.frame(res)
  if (nrow(res) == 0) {
    message("No results, returning NULL")
    return(NULL)
  }
  return(res)
}

gisco_addressapi_roads <- function(country = NULL, province = NULL, city = NULL,
                                   verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/roads?"
  custom_query <- list(
    country = country,
    province = province,
    city = city
  )

  apiurl <- add_custom_query(custom_query, apiurl)
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl, filename,
    cache_dir = tempdir(), update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  res <- as.data.frame(res)
  if (nrow(res) == 0) {
    message("No results, returning NULL")
    return(NULL)
  }
  return(res)
}

gisco_addressapi_housenumbers <- function(country = NULL, province = NULL,
                                          city = NULL, road = NULL,
                                          postcode = NULL, verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/housenumbers?"
  custom_query <- list(
    country = country,
    province = province,
    city = city,
    road = road,
    postcode = postcode
  )

  apiurl <- add_custom_query(custom_query, apiurl)
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl, filename,
    cache_dir = tempdir(), update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  res <- as.data.frame(res)
  if (nrow(res) == 0) {
    message("No results, returning NULL")
    return(NULL)
  }
  return(res)
}


gisco_addressapi_postcodes <- function(country = NULL, province = NULL,
                                       city = NULL, verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/postcodes?"
  custom_query <- list(
    country = country,
    province = province,
    city = city
  )

  apiurl <- add_custom_query(custom_query, apiurl)
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl, filename,
    cache_dir = tempdir(), update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  res <- as.data.frame(res)
  if (nrow(res) == 0) {
    message("No results, returning NULL")
    return(NULL)
  }
  return(res)
}

gisco_addressapi_copyright <- function(verbose = FALSE) {
  apiurl <- "https://gisco-services.ec.europa.eu/addressapi/copyright"
  filename <- "address.json"
  namefileload <- gsc_api_cache(
    apiurl, filename,
    cache_dir = tempdir(), update_cache = TRUE,
    verbose = verbose
  )

  if (is.null(namefileload)) {
    return(NULL)
  }

  results <- jsonlite::read_json(namefileload,
    simplifyVector = TRUE,
    flatten = TRUE
  )
  unlink(namefileload, force = TRUE)

  res <- results$results
  res <- as.data.frame(res)
  return(res)
}

# Helpers
# General ----
add_custom_query <- function(custom_query = list(), url) {
  # Remove NULLs and not populated
  custom_query <- custom_query[lengths(custom_query) > 0]

  if (any(length(custom_query) == 0, isFALSE(is_named(custom_query)))) {
    return(url)
  }

  # Collapse
  custom_query <- lapply(custom_query, paste0, collapse = ",")


  opts <- paste0(names(custom_query), "=", custom_query, collapse = "&")

  end_url <- paste0(url, opts)


  URLencode(end_url)
}

is_named <- function(x) {
  nm <- names(x)

  test_names <- c(is.null(nm), is.na(nm), nm == "")

  if (any(test_names)) {
    return(FALSE)
  }

  TRUE
}
