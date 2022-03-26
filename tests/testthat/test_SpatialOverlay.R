overlay <- readRDS("testData/AllSpatialOverlay.RData")

annots <- "testData/workflow_and_count_files/workflow/readout_package/19July2021_MsWTA_20210804T2230/19July2021_MsWTA_20210804T2230_LabWorksheet.txt"
annots <- readLabWorksheet(annots, "4")

overlay <- addPlottingFactor(overlay, annots, "segment")

testthat::test_that("SpatialOverlay is formatted correctly",{
    expect_true(all(names(scanMeta(overlay)) == c("Panels", "PhysicalSizes", "Fluorescence", "Segmentation")))
    expect_true(class(scanMeta(overlay)$Panels) == "character")
    expect_true(all(names(scanMeta(overlay)$PhysicalSizes) == c("X", "Y")))
    expect_true(class(scanMeta(overlay)$PhysicalSizes$X) == "numeric")
    expect_true(class(scanMeta(overlay)$PhysicalSizes$Y) == "numeric")
    expect_true(class(scanMeta(overlay)$Fluorescence) == "data.frame")
    expect_true(all(names(scanMeta(overlay)$Fluorescence) == c("Dye", "DisplayName",
                                                               "Color", "WaveLength",
                                                               "Target", "ExposureTime")))
    expect_true(all(names(overlay@workflow) %in% c("labWorksheet", "outline")))
    expect_true(all(coords(overlay)$sampleID %in% sampNames(overlay)))
    expect_true(all(rownames(plotFactors(overlay)) == sampNames(overlay)))
})

testthat::test_that("SpatialOverlay accessor work as expected",{
    expect_true(slideName(overlay) == "4")
    expect_identical(slideName(overlay), overlay@slideName)
    
    expect_true(class(overlay(overlay)) == "SpatialPosition")
    expect_identical(overlay(overlay), overlay@overlayData)
    
    expect_true(class(scanMeta(overlay)) == "list")
    expect_identical(scanMeta(overlay), overlay@scanMetadata)
    
    expect_true(class(coords(overlay)) == "data.frame")
    expect_identical(coords(overlay), overlay@coords)
    
    expect_true(class(plotFactors(overlay)) == "data.frame")
    expect_identical(plotFactors(overlay), overlay@plottingFactors)
    
    expect_true(class(labWork(overlay)) == "logical")
    expect_identical(labWork(overlay), overlay@workflow$labWorksheet)
    
    expect_true(class(outline(overlay)) == "logical")
    expect_identical(outline(overlay), overlay@workflow$outline)
    
    expect_true(class(scaleBarRatio(overlay)) == "numeric")
    expect_identical(scaleBarRatio(overlay), overlay@scanMetadata$PhysicalSizes$X)
    
    expect_true(class(fluor(overlay)) == "data.frame")
    expect_identical(fluor(overlay), overlay@scanMetadata$Fluorescence)
    
    expect_true(class(seg(overlay)) == "character")
    expect_identical(seg(overlay), overlay@scanMetadata$Segmentation)
     
    expect_true(class(sampNames(overlay)) == "character")
    expect_identical(sampNames(overlay), meta(overlay(overlay))$Sample_ID)
})

geometricOverlay <- removeSample(overlay, sampNames(overlay)[5:length(sampNames(overlay))])

testthat::test_that("SpatialOverlay replacers work as expected",{
    expect_false(ncol(plotFactors(geometricOverlay)) == ncol(plotFactors(addPlottingFactor(geometricOverlay, annots, "area"))))
    expect_false(nrow(coords(geometricOverlay)) == nrow(coords(createCoordFile(geometricOverlay, outline = TRUE))))
})
