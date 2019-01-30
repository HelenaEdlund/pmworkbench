# script with mixed function calls to help building and documenting

library(devtools)
library(sinew)
library(roxygen2)

makeOxygen()
devtools::document()

devtools::test()

# use_vignette(vignetteName, pkg="../pmxplore")

# dump(function_name, file = "../pmxplore/R/file_name.R")