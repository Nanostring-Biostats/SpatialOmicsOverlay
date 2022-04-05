# load(unzip("testData/figureReady.zip"))

tifFile <- downloadMouseBrainImage()
annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")

annots <- readLabWorksheet(lw = annots, slideName = "4")

extracted <- xmlExtraction(ometiff = tifFile, saveFile = T)

scanMetadata <- parseScanMetadata(omexml = extracted)

testthat::test_that("scanMetadata works on non expected variables",{
    expect_identical(scanMetadata, 
                     parseScanMetadata(omexml = tifFile))
})

testthat::test_that("scanMetadata is formatted correctly",{
    expect_true(class(scanMetadata) == "list")
    # expect_identical(scanMetadata, scan_metadata)
    expect_true(all(names(scanMetadata) == c("Panels", "PhysicalSizes", 
                                             "Fluorescence")))
    expect_true(all(names(scanMetadata$PhysicalSizes) == c("X", "Y")))
    expect_true(all(names(scanMetadata$Fluorescence) == c("Dye","DisplayName",
                                                          "Color","WaveLength",
                                                          "Target","ExposureTime",
                                                          "MinIntensity", "MaxIntensity",
                                                          "ColorCode")))
})

kidneyXML <- readRDS("testData/kidneyXML.RDS")
kidneyAnnots <- read.table("testData/kidney_annotations_allROIs.txt", 
                           header = T, sep = "\t")

scanMetadataKidney <- parseScanMetadata(kidneyXML)

testthat::test_that("fluorData works with 1 or 2 annotations in xml",{
    #E11 data, each fluor takes up 2 annotations
    #kidney data, each fluor takes only 1 annotation
    
    expect_true(nrow(scanMetadata$Fluorescence) == nrow(scanMetadataKidney$Fluorescence))
    
    expect_true(length(unique(scanMetadata$Fluorescence$Dye)) == nrow(scanMetadata$Fluorescence))
    expect_true(length(unique(scanMetadata$Fluorescence$DisplayName)) == nrow(scanMetadata$Fluorescence))
    expect_true(length(unique(scanMetadata$Fluorescence$Color)) == nrow(scanMetadata$Fluorescence))
    expect_true(length(unique(scanMetadata$Fluorescence$WaveLength)) == nrow(scanMetadata$Fluorescence))
    
    expect_true(length(unique(scanMetadataKidney$Fluorescence$Dye)) == nrow(scanMetadataKidney$Fluorescence))
    expect_true(length(unique(scanMetadataKidney$Fluorescence$DisplayName)) == nrow(scanMetadataKidney$Fluorescence))
    expect_true(length(unique(scanMetadataKidney$Fluorescence$Color)) == nrow(scanMetadataKidney$Fluorescence))
    expect_true(length(unique(scanMetadataKidney$Fluorescence$WaveLength)) == nrow(scanMetadataKidney$Fluorescence))
})

testthat::test_that("Physical Sizes returns correctly",{
    ps <- physicalSizes(extracted)
    expect_true(all(names(ps) == c("X", "Y")))
    expect_true(class(ps) == "list")
    expect_true(class(ps$X) == "numeric")
    expect_true(class(ps$Y) == "numeric")
    expect_true(names(ps$X) == "µm/pixel")
    expect_true(names(ps$Y) == "µm/pixel")
})

testthat::test_that("Errors when incorrect boolean for labworksheet",{
    expect_error(parseOverlayAttrs(omexml = extracted, annots = annots, 
                                         labworksheet = FALSE))
})


testthat::test_that("Warnings occur when AOIs are missing or mislabeled",{
    expect_warning(AOIattrs <- parseOverlayAttrs(omexml = extracted, annots = annots, 
                                        labworksheet = TRUE))
})

AOIattrs <- suppressWarnings(parseOverlayAttrs(omexml = extracted, annots = annots, 
                                    labworksheet = TRUE))

testthat::test_that("AOIattrs are correct",{
    expect_true(class(AOIattrs) == "SpatialPosition")
    expect_true(class(meta(AOIattrs)) == "data.frame")
    expect_true(all(c("ROILabel","Sample_ID","Height","Width",
                  "X","Y","Segmentation") %in% colnames(meta(AOIattrs))))
    expect_true(class(position(AOIattrs)) == "character")
    expect_true(length(position(AOIattrs)) == nrow(meta(AOIattrs)))
    expect_true(all(position(AOIattrs) == AOIattrs@position$Position))
})

kidneyAOIattrs <- parseOverlayAttrs(kidneyXML, kidneyAnnots, 
                                          labworksheet = FALSE)
#number of pixels used as proxy for AOI size
#for segmented ROIs compared order of #pixels and area
#for geometric ROIs matched on ROILabel
testthat::test_that("annotMatching is correct",{
    for(i in unique(meta(kidneyAOIattrs)$ROILabel)){
        ROI <- meta(kidneyAOIattrs)[meta(kidneyAOIattrs)$ROILabel == i,]
        
        if(nrow(ROI) > 1){
            totalPixels <- NULL
            for(j in ROI$Sample_ID){
                pixels <- nrow(coordsFromMask(createMask(b64string = position(kidneyAOIattrs)[meta(kidneyAOIattrs)$Sample_ID == j], 
                                                         metadata = ROI[ROI$Sample_ID == j,], 
                                                         outline = FALSE), 
                                              metadata = ROI[ROI$Sample_ID == j,],
                                              outline = FALSE))
                totalPixels[j] <- pixels/scanMetadataKidney$PhysicalSizes$X
            }
            
            subsetAnnots <- kidneyAnnots[kidneyAnnots$SegmentID %in% ROI$Sample_ID,]
            
            expect_true(all(names(sort(totalPixels)) == subsetAnnots$SegmentID[order(subsetAnnots$AOISurfaceArea)]))
        }else{
            expect_true(ROI$Sample_ID == kidneyAnnots$SegmentID[kidneyAnnots$ROILabel == i])
        }
    }
})

