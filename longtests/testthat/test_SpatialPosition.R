if(!file.exists("muBrain.RDS")){
  tifFile <- downloadMouseBrainImage()
  annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                        package = "SpatialOmicsOverlay")
  
  overlay <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, annots = annots, 
                                                 slideName = "4", outline = FALSE))
  
  saveRDS(overlay, "muBrain.RDS")
}else{
  overlay <- readRDS( "muBrain.RDS")
}

annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")

AOIattrs <- overlay(overlay)

testthat::test_that("SpatialPosition is formatted correctly",{
    #Spec 1. The class is formatted correctly. 
    expect_true(class(AOIattrs) == "SpatialPosition")
    expect_true(class(AOIattrs@position) == "data.frame")
    expect_true(all(names(AOIattrs) == c("ROILabel", "Sample_ID", "Height", 
                                         "Width", "X", "Y", "Segmentation", 
                                         "Position")))
    expect_true(class(AOIattrs@position$ROILabel) == "numeric")
    expect_true(class(AOIattrs@position$Sample_ID) == "character")
    expect_true(class(AOIattrs@position$Height) == "numeric")
    expect_true(class(AOIattrs@position$Width) == "numeric")
    expect_true(class(AOIattrs@position$X) == "numeric")
    expect_true(class(AOIattrs@position$Y) == "numeric")
    expect_true(class(AOIattrs@position$Segmentation) == "character")
    expect_true(class(AOIattrs@position$Position) == "character")
    
    expect_true(all(AOIattrs@position$Segmentation %in% c("Segmented", "Geometric")))
    
    expect_false(any(duplicated(AOIattrs@position$Sample_ID)))
})

testthat::test_that("SpatialPosition accessors are correct",{
    #Spec 2. The class accessors work as expected. 
    expect_identical(meta(AOIattrs), AOIattrs@position[,1:7]) 
    expect_true(class(meta(AOIattrs)) == "data.frame")
    expect_identical(position(AOIattrs), AOIattrs@position$Position)
    expect_true(class(position(AOIattrs)) == "character")
    expect_identical(spatialPos(AOIattrs), AOIattrs@position)
    expect_true(class(spatialPos(AOIattrs)) == "data.frame")
})

