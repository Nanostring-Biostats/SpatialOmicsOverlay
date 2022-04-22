library(testthat)
library(vdiffr)
library(SpatialOmicsOverlay)

tifFile <- downloadMouseBrainImage()
annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")

overlay <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, annots = annots, 
                                               slideName = "4", outline = FALSE))

dir.create("testthat/testData")
saveRDS(overlay, "testthat/testData/muBrain.RDS")

#run tests
test_check("SpatialOmicsOverlay")

unlink("testthat/testData", recursive = TRUE)

