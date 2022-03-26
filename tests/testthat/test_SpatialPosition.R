tifFile <- "testData/image_files/mu_brain_004.ome.tiff"
annots <- "testData/workflow_and_count_files/workflow/readout_package/19July2021_MsWTA_20210804T2230/19July2021_MsWTA_20210804T2230_LabWorksheet.txt"

annots <- readLabWorksheet(lw = annots, slideName = "4")

extracted <- xmlExtraction(ometiff = tifFile, saveFile = T)

AOIattrs <- suppressWarnings(parseOverlayAttrs(omexml = extracted, annots = annots, 
                                         labworksheet = TRUE))

testthat::test_that("SpatialPosition is formatted correctly",{
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
    expect_identical(meta(AOIattrs), AOIattrs@position[,1:7]) 
    expect_true(class(meta(AOIattrs)) == "data.frame")
    expect_identical(position(AOIattrs), AOIattrs@position$Position)
    expect_true(class(position(AOIattrs)) == "character")
})

