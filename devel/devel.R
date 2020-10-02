rm(list = ls())
par(mar=c(0,0,0,0))
roxygen2::roxygenize()

pkgdown::build_a

a <- "Diego Hernangomez [aut, cre] (<https://orcid.org/0000-0001-8457-4658>)"

options(gisco_cache_dir = "~/R/mapslib/GISCO")

gisco_g

meta$author

citation("giscoR")

citation("knitr")

roxygen2::roxygenise()

library(giscoR)

library(sf)

gisco

sf_world <- gisco_get_countries()
sf_africa <- gisco_get_countries(region = 'Africa')
sf_benelux <- gisco_get_countries(resolution = "20", country_iso3 = c('BEL','NLD','LUX'))

plot(st_geometry(sf_world), col = "seagreen2")
title(sub = gisco_attributions(), line = 1)

plot(st_geometry(sf_africa),
     col = c("springgreen4", "darkgoldenrod1", "red2"))
title(sub = gisco_attributions(), line = 1)

plot(st_geometry(sf_benelux), col = c("grey10","deepskyblue2","orange"))
title(sub = gisco_attributions(), line = 1)

tinytest::test_package("giscoR")

covr::report()


citation("eurostat")


Sys.getenv("_R_CHECK_DONTTEST_EXAMPLES_")
Sys.setenv("_R_CHECK_DONTTEST_EXAMPLES_" = FALSE)
