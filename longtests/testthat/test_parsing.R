tifFile <- downloadMouseBrainImage()
annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")

annots <- readLabWorksheet(lw = annots, slideName = "4")

extracted <- xmlExtraction(ometiff = tifFile, saveFile = T)

scanMetadata <- parseScanMetadata(omexml = extracted)

testthat::test_that("scanMetadata works on non expected variables",{
    #Spec 1. The function works on ometiff variable instead of expected xml.
    expect_identical(scanMetadata, 
                     parseScanMetadata(omexml = tifFile))
})

testthat::test_that("scanMetadata is formatted correctly",{
    #Spec 2. The function returns a list with all of the expected names.
    expect_true(class(scanMetadata) == "list")
    # expect_identical(scanMetadata, scan_metadata)
    expect_true(all(names(scanMetadata) == c("Panels", "PhysicalSizes", 
                                             "Fluorescence")))
    expect_true(all(names(scanMetadata$PhysicalSizes) == c("X", "Y")))
    expect_true(all(names(scanMetadata$Fluorescence) == c("Dye","DisplayName",
                                                          "Color","WaveLength",
                                                          "Target",
                                                          "ExposureTime",
                                                          "MinIntensity", 
                                                          "MaxIntensity",
                                                          "ColorCode")))
})

unzip(system.file("extdata", "testData", "kidney.zip", 
                  package = "SpatialOmicsOverlay"), 
      exdir = "testData")

kidneyXML <- readRDS("testData/kidneyXML.RDS")
kidneyAnnots <- read.table("testData/kidney_annotations_allROIs.txt", 
                           header = T, sep = "\t")

scanMetadataKidney <- parseScanMetadata(kidneyXML)

testthat::test_that("fluorData works with 1 or 2 annotations in xml",{
    #Spec 1. The function works on xmls where fluor data takes up 1 or 2 lines.
    
    #E11 data, each fluor takes up 2 annotations
    #kidney data, each fluor takes only 1 annotation
    
    expect_true(nrow(scanMetadata$Fluorescence) == 
                    nrow(scanMetadataKidney$Fluorescence))
    
    expect_true(length(unique(scanMetadata$Fluorescence$Dye)) == 
                    nrow(scanMetadata$Fluorescence))
    expect_true(length(unique(scanMetadata$Fluorescence$DisplayName)) == 
                    nrow(scanMetadata$Fluorescence))
    expect_true(length(unique(scanMetadata$Fluorescence$Color)) == 
                    nrow(scanMetadata$Fluorescence))
    expect_true(length(unique(scanMetadata$Fluorescence$WaveLength)) == 
                    nrow(scanMetadata$Fluorescence))
    
    expect_true(length(unique(scanMetadataKidney$Fluorescence$Dye)) == 
                    nrow(scanMetadataKidney$Fluorescence))
    expect_true(length(unique(scanMetadataKidney$Fluorescence$DisplayName)) == 
                    nrow(scanMetadataKidney$Fluorescence))
    expect_true(length(unique(scanMetadataKidney$Fluorescence$Color)) == 
                    nrow(scanMetadataKidney$Fluorescence))
    expect_true(length(unique(scanMetadataKidney$Fluorescence$WaveLength)) == 
                    nrow(scanMetadataKidney$Fluorescence))
})

testthat::test_that("fluorData works",{
    #Spec 2. The function returns a data.frame with all of the expected values
    Dye <- c("Alexa 488", "SYTO 83", "Alexa 594", "Alexa 647")
    DisplayName <- c("FITC", "Cy3", "Texas Red", "Cy5")
    Color <- c("Blue", "Green", "Yellow", "Red")
    WaveLength <- c("525nm", "568nm", "615nm", "666nm")
    Target <- c("GFAP", "DNA", "Iba-1", "NeuN")
    ExposureTime <- c("200.0 µs", "50.0 µs", "300.0 µs", "100.0 µs")
    ColorCode <- c("#0000feff", "#00fe00ff", "#fefe00ff", "#fe0000ff")
    MinIntensity <- c(50, 4, 33, 88)
    MaxIntensity <- c(18509, 805, 3174, 30000)
    
    trueDF <- as.data.frame(cbind(Dye, DisplayName, Color, WaveLength, 
                                  Target, ExposureTime, MinIntensity, 
                                  MaxIntensity, ColorCode))
    
    expect_identical(scanMetadata$Fluorescence, trueDF) 
})

testthat::test_that("Physical Sizes returns correctly",{
    #Spec 1. The function works returns list with expected names & values.
    ps <- physicalSizes(extracted)
    expect_true(all(names(ps) == c("X", "Y")))
    expect_true(class(ps) == "list")
    expect_true(class(ps$X) == "numeric")
    expect_true(class(ps$Y) == "numeric")
    expect_true(names(ps$X) == "µm/pixel")
    expect_true(names(ps$Y) == "µm/pixel")
    
    expect_equal(ps$X, c("µm/pixel"=0.3993132), tolerance = 1e-6)
    expect_equal(ps$Y, c("µm/pixel"=0.4003363), tolerance = 1e-6)
})

testthat::test_that("Errors with invalid inputs",{
    #Spec 1. The function requires correct inputs.
    expect_error(parseOverlayAttrs(omexml = extracted, annots = annots, 
                                         labworksheet = FALSE),
                 regexp = "Please change labWorksheet")
    
    expect_error(parseOverlayAttrs(omexml = extracted, annots = "annots", 
                                   labworksheet = TRUE),
                 regexp = "File must be read into R and passed as a dataframe")
})


testthat::test_that("Warnings occur when AOIs are missing or mislabeled",{
    #Spec 2. The function only works with valid sample names.
    expect_warning(AOIattrs <- parseOverlayAttrs(omexml = extracted, 
                                                 annots = annots, 
                                                 labworksheet = TRUE),
                   regexp = "Some AOIs do not match annotation file")
})

AOIattrs <- suppressWarnings(parseOverlayAttrs(omexml = extracted, annots = annots, 
                                    labworksheet = TRUE))

testthat::test_that("AOIattrs are correct",{
    #Spec 3. The function returns SpatialPosition with correct column names. 
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
    #Spec 1. The function matches sampleIDs correctly between xml and annots.
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
            
            subsetAnnots <- kidneyAnnots[kidneyAnnots$SegmentDisplayName %in% ROI$Sample_ID,]
            
            expect_true(all(names(sort(totalPixels)) == subsetAnnots$SegmentDisplayName[order(subsetAnnots$AOISurfaceArea)]))
        }else{
            expect_true(ROI$Sample_ID == kidneyAnnots$SegmentDisplayName[kidneyAnnots$ROILabel == i])
        }
    }
})

