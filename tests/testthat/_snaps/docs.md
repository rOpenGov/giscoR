# Check docs

    Code
      for_docs("communes", "year")
    Output
      [1] "\\code{\"2001\"}, \\code{\"2004\"}, \\code{\"2006\"}, \\code{\"2008\"}, \\code{\"2010\"}, \\code{\"2013\"}, \\code{\"2016\"}"

---

    Code
      for_docs("communes", "year", decreasing = TRUE)
    Output
      [1] "\\code{\"2016\"}, \\code{\"2013\"}, \\code{\"2010\"}, \\code{\"2008\"}, \\code{\"2006\"}, \\code{\"2004\"}, \\code{\"2001\"}"

---

    Code
      for_docs("communes", "ext")
    Output
      [1] "\\code{\"geojson\"}, \\code{\"gpkg\"}, \\code{\"shp\"}"

---

    Code
      for_docs("communes", "spatialtype", formatted = FALSE)
    Output
      [1] "BN"     "COASTL" "INLAND" "LB"     "RG"    

