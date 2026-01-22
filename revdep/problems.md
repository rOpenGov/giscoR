# clustTMB (0.1.0)

* GitHub: <https://github.com/Andrea-Havron/clustTMB>
* Email: <mailto:andrea.havron@noaa.gov>
* GitHub mirror: <https://github.com/cran/clustTMB>

Run `revdepcheck::revdep_details(, "clustTMB")` for more info

## Newly broken

*   checking running R code from vignettes ...
     ```
       'CovarianceStructure.Rmd' using 'UTF-8'... OK
       'SpatialExMeuseData.Rmd' using 'UTF-8'... failed
      ERROR
     Errors in running code in vignettes:
     when running code in 'SpatialExMeuseData.Rmd'
       ...
     > ybreaks <- seq(50.95, 51, 0.01)
     
     > ylabels <- unlist(sapply(ybreaks, function(x) paste(x, 
     +     "°N")))
     
     > Europe <- giscoR::gisco_get_countries(region = "Europe")
     
       When sourcing 'SpatialExMeuseData.R':
     Error: error al leer desde conexión
     Ejecución interrumpida
     ```

