usethis::use_cran_comments()
usethis::use_news_md()

devtools::install(build_vignettes = TRUE)

citation("giscoR")


roxygen2::roxygenise()


devtools::check_rhub()



roxygen2::roxygenise()

devtools::release()

devtools::spell_check()

devtools::spe

lau_esp <- gisco_get_lau(country = "Espagne")

devtools::check_win_release()

devtools::install(build_vignettes = TRUE)

usethis::use_vignette("a")

devtools::build_vignettes()
devtools::document()

pkgdown::build_favicons()


rm(list = ls())
par(mar=c(0,0,0,0))
roxygen2::roxygenize()


devtools::check_win_release()

citation("giscoR")
devtools::check_win_release()

tinytest::test_all()

example("gisco_countries_20M_2016","giscoR")
gisco_coastallines_20M_2016

library(sf)
library(cartography)
europe <-
  gisco_get_countries(
    epsg = 3857,
    year = "2020",
    region = "Europe",
    resolution = "03"
  )
cities <-
  gisco_get_urban_audit(
    year = 2020,
    epsg = 3857,
    level = "GREATER_CITIES",
    country = "BEL"
  )

# Focus on Belgium
bbox <-
  st_bbox(c(
    xmin = 150000,
    xmax = 950000,
    ymax = 6900000,
    ymin = 6300000
  ),
  crs = st_crs(europe))
bbox <- st_bbox(cities)

# Plot
opar <- par(no.readonly = TRUE)
par(mar = c(1, 1, 1, 1))
plot(
  st_geometry(europe),
  xlim = bbox[c(1, 3)],
  ylim = bbox[c(2, 4)],
  col = "antiquewhite",
  graticule = TRUE
)
box()
plot(st_geometry(cities),
     col = "darkblue",
     border = "white",
     add = TRUE)

# Labels
labelLayer(
  st_crop(europe, bbox),
  txt = "NAME_ENGL",
  family = "serif",
  font = 3,
  cex = 0.8
)
labelLayer(
  cities,
  txt = "URAU_NAME",
  overlap = FALSE,
  col = "darkblue",
  halo = TRUE
)
layoutLayer(
  "Greater Cities of Belgium - Eurostat (2020)",
  col = "darkblue",
  sources = gisco_attributions(copyright = FALSE),
  horiz = FALSE,
  posscale = "bottomleft"
)
par(opar)


gisco_g
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

gisco_countries$CNTR_NAME
iconv(gisco_countries$CNTR_NAME, "ISO_8859-2", "UTF-8")

install.packages("qpdf")

devtools::check_win_release()

vignette("giscoR")

citation("eurostat")


Sys.getenv("_R_CHECK_DONTTEST_EXAMPLES_")
Sys.setenv("_R_CHECK_DONTTEST_EXAMPLES_" = FALSE)

devtools::build_manual(path = "./devel/")
