unzip(system.file("extdata", "testData", "kidney.zip", 
                  package = "SpatialOmicsOverlay"), 
      exdir = "testData")

kidneyXML <- readRDS("testData/kidneyXML.RDS")
kidneyAnnots <- read.table("testData/kidney_annotations_allROIs.txt", 
                           header = T, sep = "\t")

scanMetadataKidney <- parseScanMetadata(kidneyXML)

kidneyAOIattrs <- parseOverlayAttrs(kidneyXML, kidneyAnnots, labworksheet = FALSE)

scanMetadataKidney[["Segmentation"]] <- ifelse(all(meta(kidneyAOIattrs)$Segmentation == "Geometric"),
                                               yes = "Geometric",no = "Segmented")

overlay <- SpatialOverlay(slideName = "normal3", 
                          scanMetadata = scanMetadataKidney, 
                          overlayData = kidneyAOIattrs)

segmentedROIs <- meta(overlay(overlay))$Sample_ID[which(meta(overlay(overlay))$Segmentation == "Segmented")]

geometricOverlay <- removeSample(overlay, segmentedROIs)

testthat::test_that("removeSamples only removes valid sample names", {
    #Spec 1. The function only works on valid sample names. 
    expect_warning(temp <- removeSample(overlay = overlay, remove = "fakeSample"),
                   regexp = "No valid sample names")
    expect_identical(overlay, temp)
})

testthat::test_that("removeSamples works as intended before coords and plotFactors", {
    #Spec 2. The function works before adding coordinates and plotting factors. 
    expect_false(length(sampNames(overlay)) == length(sampNames(geometricOverlay)))
    expect_true(all(sampNames(geometricOverlay) %in% sampNames(overlay)))
    expect_false(all(sampNames(overlay) %in% sampNames(geometricOverlay)))
    expect_false(any(segmentedROIs %in% sampNames(geometricOverlay)))
    expect_true(length(sampNames(overlay))-length(segmentedROIs) == length(sampNames(geometricOverlay)))
    expect_false(seg(overlay) == seg(geometricOverlay))
    expect_null(coords(geometricOverlay))
    expect_null(coords(overlay))
    expect_null(plotFactors(geometricOverlay))
    expect_null(plotFactors(overlay))
})

overlay <- createCoordFile(overlay, outline = FALSE)

geometricOverlay <- removeSample(overlay, segmentedROIs)

testthat::test_that("removeSamples works as intended afer coords and before plotFactors", {
    #Spec 3. The function works after adding coordinates and before plotting 
    #           factors. 
    expect_false(length(sampNames(overlay)) == length(sampNames(geometricOverlay)))
    expect_true(all(sampNames(geometricOverlay) %in% sampNames(overlay)))
    expect_false(all(sampNames(overlay) %in% sampNames(geometricOverlay)))
    expect_false(any(segmentedROIs %in% sampNames(geometricOverlay)))
    expect_true(length(sampNames(overlay))-length(segmentedROIs) == length(sampNames(geometricOverlay)))
    expect_false(seg(overlay) == seg(geometricOverlay))
    expect_null(plotFactors(geometricOverlay))
    expect_null(plotFactors(overlay))
    expect_false(any(segmentedROIs %in% coords(geometricOverlay)$sampleID))
})

overlay <- addPlottingFactor(overlay, kidneyAnnots, "Segment_type")

geometricOverlay <- removeSample(overlay, segmentedROIs)

testthat::test_that("removeSamples works as intended after coords and plotFactors", {
    #Spec 4. The function works after adding coordinates and plotting factors. 
    expect_false(length(sampNames(overlay)) == length(sampNames(geometricOverlay)))
    expect_true(all(sampNames(geometricOverlay) %in% sampNames(overlay)))
    expect_false(all(sampNames(overlay) %in% sampNames(geometricOverlay)))
    expect_false(any(segmentedROIs %in% sampNames(geometricOverlay)))
    expect_true(length(sampNames(overlay))-length(segmentedROIs) == length(sampNames(geometricOverlay)))
    expect_false(seg(overlay) == seg(geometricOverlay))
    expect_false(nrow(plotFactors(geometricOverlay)) == nrow(plotFactors(overlay)))
    expect_false(any(segmentedROIs %in% rownames(plotFactors(geometricOverlay))))
    expect_false(any(segmentedROIs %in% coords(geometricOverlay)$sampleID))
})

