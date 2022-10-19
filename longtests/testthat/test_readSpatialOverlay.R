tifFile <- downloadMouseBrainImage()
annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")

annotsGxT <- readRDS(unzip(system.file("extdata", "muBrain_GxT.zip", 
                                 package = "SpatialOmicsOverlay")))
annotsGxT <- annotsGxT[,sData(annotsGxT)$segment == "Full ROI"]

overlay <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, annots = annots, 
                                               slideName = "4", outline = FALSE))

testthat::test_that("annotation input types",{
    #Spec 1. The function works with either a labworksheet or a geomxset object 
    #           as annotation.
    expect_error(overlay <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, 
                                                                annots = annots, 
                                                                slideName = "4", 
                                                                outline = FALSE)), NA)
    
    expect_error(overlayBound <- readSpatialOverlay(ometiff = tifFile, 
                                                    annots = annotsGxT, 
                                                    slideName = "4", 
                                                    outline = TRUE), NA)
    
    #Spec 2. The function only returns samples in both xml and annotation
    expect_true(all(sampNames(overlayBound) %in% sampNames(overlay)))
    expect_false(all(sampNames(overlay) %in% sampNames(overlayBound)))
})


testthat::test_that("readSpatialOverlay works as expected - all points",{
    #Spec 1. The function returns a SpatialOverlay object.
    expect_true(class(overlay) == "SpatialOverlay")
    
    #Spec 2. The function returns a SpatialOverlay object with the expected 
    #           values in the correct locations.
    expect_true(labWork(overlay) == TRUE)
    expect_true(seg(overlay) == "Segmented")
    expect_true(outline(overlay) == FALSE)
    expect_true(is.null(plotFactors(overlay)))
    expect_true(slideName(overlay) == "4")
    
    annots <- readLabWorksheet(lw = annots, slideName = "4")
    labWorksheet <- TRUE
    xml <- xmlExtraction(ometiff = tifFile, saveFile = FALSE)
    
    expect_identical(scanMeta(overlay)[1:3], parseScanMetadata(omexml = xml))
    expect_identical(overlay(overlay), suppressWarnings(parseOverlayAttrs(omexml = xml, 
                                                               annots = annots, 
                                                               labworksheet = TRUE)))
    expect_identical(coords(overlay), coords(createCoordFile(overlay, 
                                                             outline = FALSE)))
 })

overlayImage <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, 
                                                    annots = annots, 
                                                    slideName = "4", 
                                                    outline = FALSE, 
                                                    image = TRUE, res = 8))

testthat::test_that("readSpatialOverlay works as expected - with image",{
    #Spec 1. The function returns a SpatialOverlay object.
    expect_true(class(overlayImage) == "SpatialOverlay")
    
    #Spec 2. The function returns a SpatialOverlay object with the expected 
    #           values in the correct locations.
    expect_true(labWork(overlayImage) == TRUE)
    expect_true(seg(overlayImage) == "Segmented")
    expect_true(outline(overlayImage) == FALSE)
    expect_true(is.null(plotFactors(overlayImage)))
    expect_true(slideName(overlayImage) == "4")
    
    annots <- readLabWorksheet(lw = annots, slideName = "4")
    labWorksheet <- TRUE
    xml <- xmlExtraction(ometiff = tifFile, saveFile = FALSE)
    
    expect_identical(scanMeta(overlayImage)[1:3], parseScanMetadata(omexml = xml))
    expect_identical(overlay(overlayImage), suppressWarnings(parseOverlayAttrs(omexml = xml, 
                                                                          annots = annots, 
                                                                          labworksheet = TRUE)))
    
    #Spec 3. The function returns a SpatialOverlay object with image in expected 
    #           location.
    expect_true(overlayImage@image$filePath == tifFile)
    expect_true(class(showImage(overlayImage)) == "magick-image")
    expect_true(overlayImage@image$resolution == 8)
    
    #Spec 4. The function returns a SpatialOverlay object with scaled 
    #           coordinates to image.
    expect_true(nrow(coords(overlayImage)) < nrow(coords(overlay)))
})

overlayBound <- readSpatialOverlay(ometiff = tifFile, annots = annotsGxT, 
                                   slideName = "4", outline = TRUE)

testthat::test_that("readSpatialOverlay works as expected - boundary points",{
    #Spec 1. The function returns a SpatialOverlay object.
    expect_true(class(overlayBound) == "SpatialOverlay")
    
    #Spec 2. The function returns a SpatialOverlay object with the expected 
    #           values in the correct locations.
    expect_true(labWork(overlayBound) == TRUE)
    expect_true(seg(overlayBound) == "Geometric")
    expect_true(outline(overlayBound) == TRUE)
    expect_true(is.null(plotFactors(overlayBound)))
    expect_true(slideName(overlayBound) == "4")
    
    annots <- sData(annotsGxT)
    annots <- annots[annots$`slide name` == "4",]
    annots$Sample_ID <- gsub(".dcc", "", rownames(annots))
    colnames(annots)[colnames(annots) == "roi"] <- "ROILabel"
    
    xml <- xmlExtraction(ometiff = tifFile, saveFile = FALSE)
    
    expect_identical(scanMeta(overlayBound)[1:3], parseScanMetadata(omexml = xml))
    expect_identical(overlay(overlayBound), suppressWarnings(parseOverlayAttrs(omexml = xml, 
                                                                          annots = annots, 
                                                                          labworksheet = TRUE)))
    expect_identical(coords(overlayBound), coords(createCoordFile(overlayBound, 
                                                             outline = TRUE)))
})
