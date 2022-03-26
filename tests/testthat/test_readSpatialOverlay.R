tifFile <- "testData/image_files/mu_brain_004.ome.tiff"
annots <- "testData/workflow_and_count_files/workflow/readout_package/19July2021_MsWTA_20210804T2230/19July2021_MsWTA_20210804T2230_LabWorksheet.txt"

overlay <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, annots = annots, 
                                               slideName = "4", outline = FALSE))

testthat::test_that("readSpatialOverlay works as expected - all points",{
    expect_true(class(overlay) == "SpatialOverlay")
    expect_true(labWork(overlay) == TRUE)
    expect_true(seg(overlay) == "Segmented")
    expect_true(outline(overlay) == FALSE)
    expect_true(is.null(plotFactors(overlay)))
    
    annots <- readLabWorksheet(lw = annots, slideName = "4")
    labWorksheet <- TRUE
    xml <- xmlExtraction(ometiff = tifFile, saveFile = FALSE)
    
    expect_identical(scanMeta(overlay)[1:3], parseScanMetatdata(omexml = xml))
    expect_identical(overlay(overlay), suppressWarnings(parseOverlayAttrs(omexml = xml, 
                                                               annots = annots, 
                                                               labworksheet = TRUE)))
    expect_identical(coords(overlay), coords(createCoordFile(overlay, outline = FALSE)))
 })
