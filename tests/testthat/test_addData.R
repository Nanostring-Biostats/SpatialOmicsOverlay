tifFile <- downloadMouseBrainImage()
annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")

overlay <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, annots = annots, 
                                               slideName = "4", outline = FALSE))

saveRDS(overlay, "testData/muBrain.RDS")