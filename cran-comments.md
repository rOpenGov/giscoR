* This the resubmission of a new release.

## Test environments
* local R installation, R 3.6.3 on Windows 10 x64
* Mac OS X (on github actions), R 4.0.2 - release
* Windows x86_64-w64-mingw32 (64-bit) (on github actions), R 4.0.2 - release
* ubuntu 16.04 (on travis-ci) - devel
* ubuntu 16.04 (on travis-ci), R 4.0.2 - release
* ubuntu 16.04 (on travis-ci) - R 3.6.3 - oldrel
* ubuntu 16.04 (on travis-ci) - R 3.5.0


## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

There is a note on github actions related with CRAN incoming feasibility 

* checking CRAN incoming feasibility ... Note_to_CRAN_maintainers
Maintainer: 'Diego Hernangomez <diego.hernangomezherrero@gmail.com>'

## What I have done

- Failures on test were due to inability of reaching the gisco-servicer server when checking on win-builder-release. This failure was not present on any other environment tests.

I have created internal datasets on sysdata.rda to avoid this failure and moved functions, examples and test to these datasets.

Full test suite works fine downloading datasets when server is reachable.

