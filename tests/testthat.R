library(testthat)
library(vdiffr)

options( java.parameters = "-Xmx4g" )
library( "RBioFormats" )

library(SpatialOmicsOverlay)

# #run tests
test_check("SpatialOmicsOverlay")


