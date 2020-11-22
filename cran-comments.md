# giscoR v0.2.2

## Test environments

* local R installation, R version 4.0.2 on Windows 10 x64
* On github actions:
  * Mac OS X 10.15.7: devel, release, oldrel.
  * Windows 10.0.17763:, devel, release, oldrel.
  * ubuntu 20.04: devel, release, oldrel, R 3.6.0.
* r-hub: devtools::check_rhub()


## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

ON r-hub

0 errors √ | 0 warnings √ | 1 note x

NOTE: 

  Maintainer: 'Diego Hernang�mez <diego.hernangomezherrero@gmail.com>'
  New submission
  Package was archived on CRAN
  
  
    Eurostat (3:43, 20:55, 22:68)
  Possibly mis-spelled words in DESCRIPTION:
  
  CRAN repository db overrides:
    X-CRAN-Comment: Archived on 2020-11-21 for policy violation.
    GISCO (3:31, 19:46)
  
    On Internet access.
    
# This is a resubmission

I have changed the links where access was broken. Laso I have removed the vignette as `stringi` was not available on one flavour (that made my previous submission to fail).
