# Check docs

    Code
      db_values("communes", "year")
    Output
      [1] "\\code{\"2001\"}, \\code{\"2004\"}, \\code{\"2006\"}, \\code{\"2008\"}, \\code{\"2010\"}, \\code{\"2013\"}, \\code{\"2016\"}"

---

    Code
      db_values("communes", "year", decreasing = TRUE)
    Output
      [1] "\\code{\"2016\"}, \\code{\"2013\"}, \\code{\"2010\"}, \\code{\"2008\"}, \\code{\"2006\"}, \\code{\"2004\"}, \\code{\"2001\"}"

---

    Code
      db_values("communes", "ext")
    Output
      [1] "\\code{\"geojson\"}, \\code{\"gpkg\"}, \\code{\"shp\"}"

---

    Code
      db_values("communes", "spatialtype", formatted = FALSE)
    Output
      [1] "BN"     "COASTL" "INLAND" "LB"     "RG"    

