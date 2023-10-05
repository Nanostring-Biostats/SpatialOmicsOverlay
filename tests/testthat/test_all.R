tifFile <- downloadMouseBrainImage()

annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")

annotsDF <- readLabWorksheet(lw = annots, slideName = "D5761 (3)")

##################################  Utils  #####################################
testthat::test_that("mouse brain tiff can be downloaded",{
  #Spec 1. The function downloads the mouse brain tiff and returns a valid 
  #           file path.
  expect_true(endsWith(tifFile, "mu_brain_004.ome.tiff"))
  expect_true(file.exists(tifFile))
})

lw <- system.file("extdata", "testData", "test_LabWorksheet.txt", 
                  package = "SpatialOmicsOverlay")

testthat::test_that("read labworksheet works",{
  #Spec 1. The function only works on correct file paths.
  expect_error(readLabWorksheet(lw, "fake_slide"))
  #Spec 2. The function only works on correct slide names. 
  expect_error(readLabWorksheet("fake/file/path", "hu_brain_004b"))
  
  #Spec 3. The function only returns annotations from the specified slide.
  annots4b <- readLabWorksheet(lw, "hu_brain_004b")
  annots4a <- readLabWorksheet(lw, "hu_brain_004a")
  
  expect_true(all(colnames(annots4b) == c("Sample_ID", "slide.name", "scan.name", 
                                          "panel", "roi", "segment", "aoi", 
                                          "area", "tags", "ROILabel")))
  expect_true(all(colnames(annots4a) == c("Sample_ID", "slide.name", "scan.name", 
                                          "panel", "roi", "segment", "aoi", 
                                          "area", "tags", "ROILabel")))
  
  expect_true(all(annots4a$slide.name == "hu_brain_004a"))
  expect_true(all(annots4b$slide.name == "hu_brain_004b"))
  
  expect_false(nrow(annots4b) == nrow(annots4a))
  expect_false(any(annots4b$Sample_ID %in% annots4a$Sample_ID))
  expect_false(any(annots4b$Sample_ID %in% annots4a$Sample_ID))
})

#############################  XML Extraction  #################################
testthat::test_that("Error when xml path doesn't exist",{
  #Spec 1. The function only works with valid ometiff file.  
  expect_error(xmlExtraction("fakeFilePath.ome.tiff"))
})

xml <- xmlExtraction(ometiff = tifFile, saveFile = FALSE)

testthat::test_that("returned list is correct",{
  #Spec 2. The function returns a valid list with the expected names.
  expect_true(class(xml) == "list")
  expect_true(length(xml) > 0)
  expect_true(all(names(xml) %in% c("Plate", "Screen", "Instrument", "Image", 
                                    "StructuredAnnotations", "ROI", ".attrs")))
  expect_true(length(which(names(xml) == "ROI")) > 1)
})

###############################  XML Parsing  ##################################
scanMetadata <- parseScanMetadata(omexml = xml)

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
                           header = TRUE, sep = "\t")

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
  ps <- physicalSizes(xml)
  expect_true(all(names(ps) == c("X", "Y")))
  expect_true(class(ps) == "list")
  expect_true(class(ps$X) == "numeric")
  expect_true(class(ps$Y) == "numeric")
  expect_true(names(ps$X) == "µm/pixel")
  expect_true(names(ps$Y) == "µm/pixel")
  
  expect_equal(ps$X, c("µm/pixel"=0.3993132), tolerance = 1e-6)
  expect_equal(ps$Y, c("µm/pixel"=0.4003363), tolerance = 1e-6)
})

AOIattrs <- suppressWarnings(parseOverlayAttrs(omexml = xml,
                                               annots = annotsDF, 
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
  for(i in unique(meta(kidneyAOIattrs)$ROILabel)[6:7]){
    ROI <- meta(kidneyAOIattrs)[meta(kidneyAOIattrs)$ROILabel == i,]
    
    if(nrow(ROI) > 1){
      totalPixels <- NULL
      for(j in ROI$Sample_ID){
        pixels <- nrow(SpatialOmicsOverlay:::coordsFromMask(SpatialOmicsOverlay:::createMask(b64string = position(kidneyAOIattrs)[meta(kidneyAOIattrs)$Sample_ID == j], 
                                                 metadata = ROI[ROI$Sample_ID == j,], 
                                                 outline = FALSE), 
                                      metadata = ROI[ROI$Sample_ID == j,],
                                      outline = FALSE))
        totalPixels[j] <- pixels/scanMetadataKidney$PhysicalSizes$X
      }
      
      subsetAnnots <- kidneyAnnots[kidneyAnnots$SegmentDisplayName %in% ROI$Sample_ID,]
      
      expect_true(all(names(sort(totalPixels)) == subsetAnnots$SegmentDisplayName[order(subsetAnnots$AOISurfaceArea)]))
    }else{
      expect_true(ROI$Sample_ID == kidneyAnnots$SegmentDisplayName[kidneyAnnots$ROILabel == as.numeric(i)])
    }
  }
})

#############################  SpatialPosition  ################################
testthat::test_that("SpatialPosition is formatted correctly",{
  #Spec 1. The class is formatted correctly. 
  expect_true(class(AOIattrs) == "SpatialPosition")
  expect_true(class(AOIattrs@position) == "data.frame")
  expect_true(all(names(AOIattrs) == c("ROILabel", "Sample_ID", "Height", 
                                       "Width", "X", "Y", "Segmentation", 
                                       "Position")))
  expect_true(class(AOIattrs@position$ROILabel) == "character")
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
})

##########################  Coordinate Generation  #############################
AOImeta <- meta(kidneyAOIattrs)[meta(kidneyAOIattrs)$Sample_ID == 
                                  "normal3_scan | 002 | neg",]
AOIposition <- position(kidneyAOIattrs)[meta(kidneyAOIattrs)$Sample_ID == 
                                          "normal3_scan | 002 | neg"]

testthat::test_that("decodeB64 is correct",{
  #Spec 1. The function produces same values as python truth. 
  pythonTruth <- readRDS("testData/kidneyDecodedTruth.RDS")
  expect_true(all(as.numeric(decodeB64(b64string = AOIposition, width = AOImeta$Width,
                                       height = AOImeta$Height)) == as.numeric(pythonTruth)))
})

pythonTruth <- readRDS("testData/kidneyMaskTruth.RDS")

mask <- createMask(b64string = AOIposition, metadata = AOImeta, 
                   outline = FALSE)

testthat::test_that("createMask is correct - all coordinates",{
  #Spec 1. The function creates mask in correct dimension.
  expect_true(all(dim(mask) == c(AOImeta$Height,AOImeta$Width)))
  #Spec 2. The function produces same values as python truth. 
  expect_true(all(mask == pythonTruth))
  #Spec 3. The function produces mask of only 0 & 1.
  expect_true(all(mask %in% c(0,1)))
  #Spec 4. The function creates matrix.
  expect_true(class(mask)[1] == "matrix")
})

testthat::test_that("coordsFromMask is correct - all coordinates",{
  #Spec 1. The function creates coordinates for mask = 1 points. Coordinates 
  #           are put into full image range and changed from base1 to base0.
  coords <- coordsFromMask(mask = mask, metadata = AOImeta, 
                           outline = FALSE)
  
  expectedCoords <- as.data.frame(which(mask == 1, arr.ind = TRUE))
  colnames(expectedCoords) <- c("Y", "X")
  expectedCoords[["X"]] <- expectedCoords[["X"]] + AOImeta$X - 1
  expectedCoords[["Y"]] <- expectedCoords[["Y"]] + AOImeta$Y - 1
  
  expect_true(all(expectedCoords == coords))
})

outlineMask <- createMask(b64string = AOIposition, metadata = AOImeta, 
                          outline = TRUE)

testthat::test_that("createMask is correct - outline coordinates",{
  #Spec 1. The function creates mask in correct dimension.
  expect_true(all(dim(outlineMask) == c(AOImeta$Height,AOImeta$Width)))
  #Spec 2. The function has fewer matches with the python truth
  propTrue <- table(outlineMask == pythonTruth)
  expect_true(propTrue["TRUE"] < propTrue["FALSE"])
  #Spec 3. The function produces mask of only 0 & 1.
  expect_true(all(outlineMask %in% c(0,1)))
  #Spec 4. The function creates matrix.
  expect_true(class(outlineMask)[1] == "matrix")
  
  #Spec 5. The function create mask with < 0.1% of points with 7 or more neighbors.
  expect_true(length(which(boundary(outlineMask) >= 7)) < length(outlineMask)*0.001)
})

testthat::test_that("coordsFromMask is correct - outline coordinates",{
  #Spec 1. The function creates coordinates for mask = 1 points. Coordinates 
  #           are put into full image range and changed from base1 to base0.
  coords <- coordsFromMask(outlineMask, AOImeta, outline = FALSE)
  
  expectedCoords <- as.data.frame(which(outlineMask == 1, arr.ind = TRUE))
  colnames(expectedCoords) <- c("Y", "X")
  expectedCoords[["X"]] <- expectedCoords[["X"]] + AOImeta$X - 1
  expectedCoords[["Y"]] <- expectedCoords[["Y"]] + AOImeta$Y - 1
  
  expect_true(all(expectedCoords == coords))
})

testthat::test_that("Pencil Sorting works as expected",{
  sortedCoords <- coordsFromMask(outlineMask, AOImeta, outline = TRUE)
  
  sortedCoords$dif <- NA
  
  for(i in 1:nrow(sortedCoords)){
    if(i == nrow(sortedCoords)){
      sortedCoords$dif[i] <- abs(sortedCoords$ycoor[i] - sortedCoords$ycoor[1]) +
        abs(sortedCoords$xcoor[i] - sortedCoords$xcoor[1]) 
    }else{
      sortedCoords$dif[i] <- abs(sortedCoords$ycoor[i] - sortedCoords$ycoor[i+1]) +
        abs(sortedCoords$xcoor[i] - sortedCoords$xcoor[i+1])
    }
  }
  
  #Spec 1. The function sorts outline coordinates by proximity. >99% of 
  #           differences between adjacent coordinates is 1.
  expect_true(length(which(sortedCoords$dif == 1)) > nrow(sortedCoords)*0.99)
  #Spec 2. The function sorts outline coordinates by proximity. The max 
  #           difference is <100.
  expect_true(max(sortedCoords$dif) < 100)
})

scanMetadataKidney[["Segmentation"]] <- ifelse(all(meta(kidneyAOIattrs)$Segmentation == "Geometric"),
                                               yes = "Geometric", no = "Segmented")

kidneyOverlay <- createCoordFile(SpatialOverlay(slideName = "normal3", 
                                                scanMetadata = scanMetadataKidney, 
                                                overlayData = kidneyAOIattrs), 
                                 outline = FALSE)

testthat::test_that("createCoordFile puts data in correct spot",{
  #Spec 1. The function places coordinates in correct location. 
  expect_true(!is.null(coords(kidneyOverlay)))
})

coords <- coords(kidneyOverlay)

testthat::test_that("createCoordFile is correct",{
    #Spec 2. The function produces same values as python truth. 
  pythonTruth <- readRDS("testData/kidneyCoordsTruth.RDS")
  pythonTruth <- pythonTruth[,c("ROILabel","AOI","ycoor","xcoor")]
  pythonTruth <- pythonTruth[order(pythonTruth$ROILabel, 
                                   pythonTruth$AOI,
                                   pythonTruth$xcoor),]
  
  numCoords <- sample(x = 1:nrow(coords), size = 1e6, replace = FALSE)
  
  expect_true(all(coords[numCoords,c("ycoor", "xcoor")] == 
                    pythonTruth[numCoords,c("ycoor","xcoor")]))
})

testthat::test_that("Outline points on segemented data - warning",{
  #Spec 3. The function only returns outline coordinates on Geometric data. 
  expect_warning(createCoordFile(SpatialOverlay(slideName = "normal3", 
                                                scanMetadata = scanMetadataKidney, 
                                                overlayData = SpatialPosition(head(kidneyAOIattrs@position, 2))), 
                                 outline = TRUE))
})

testthat::test_that("boundary is behaving as expected",{
  #Spec 1. The function returns expected number of neighbors. 
  testBound <- matrix(1, ncol = 3, nrow = 3)
  expect_equal(matrix(boundary(testBound), ncol = 3, nrow = 3),
               matrix(c(3,5,3,5,8,5,3,5,3), ncol = 3, nrow = 3))
  
  testBound <- matrix(0, ncol = 3, nrow = 3)
  expect_equal(matrix(boundary(testBound), ncol = 3, nrow = 3),
               matrix(0, ncol = 3, nrow = 3))
  
  testBound <- matrix(c(1,1,1,0,0,0,1,1,1), ncol = 3, nrow = 3)
  expect_equal(matrix(boundary(testBound), ncol = 3, nrow = 3),
               matrix(c(1,2,1,4,6,4,1,2,1), ncol = 3, nrow = 3))
  
  testBound <- matrix(c(0,0,0,1,1,1,0,0,0), ncol = 3, nrow = 3)
  expect_equal(matrix(boundary(testBound), ncol = 3, nrow = 3),
               matrix(c(2,3,2,1,2,1,2,3,2), ncol = 3, nrow = 3))
  
  testBound <- matrix(c(0,0,0,0,1,0,0,0,0), ncol = 3, nrow = 3)
  expect_equal(matrix(boundary(testBound), ncol = 3, nrow = 3),
               matrix(c(1,1,1,1,0,1,1,1,1), ncol = 3, nrow = 3))
})

############################  readSpatialOverlay  ##############################
library(GeomxTools)
annotsGxT <- readRDS(unzip(system.file("extdata", "muBrain_GxT.zip", 
                                       package = "SpatialOmicsOverlay")))
annotsGxT <- annotsGxT[,which(sData(annotsGxT)$segment == "Full ROI")[1:3]]

subsetAnnots <- system.file("extdata", "muBrain_subset_LabWorksheet.txt", 
                            package = "SpatialOmicsOverlay")

overlay <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, annots = subsetAnnots,
                                               slideName = "D5761 (3)", outline = FALSE,
                                               image = FALSE))

colnames(annotsGxT@protocolData@data)[which(colnames(annotsGxT@protocolData@data) == "ScanLabel")] <- "slide name"
colnames(annotsGxT@phenoData@data)[which(colnames(annotsGxT@phenoData@data) == "SegmentLabel")] <- "segment"

overlayBound <- readSpatialOverlay(ometiff = tifFile, 
                                   annots = annotsGxT, 
                                   slideName = "D5761 (3)", 
                                   outline = TRUE,
                                   image = FALSE)

testthat::test_that("annotation input types",{
  #Spec 1. The function works with either a labworksheet or a geomxset object 
  #           as annotation.
  
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
  expect_true(slideName(overlay) == "D5761 (3)")

  expect_identical(scanMeta(overlay)[1:3], parseScanMetadata(omexml = xml))
  expect_identical(overlay(overlay), suppressWarnings(parseOverlayAttrs(omexml = xml,
                                                                        annots = readLabWorksheet(subsetAnnots,
                                                                                                  slideName = "D5761 (3)"),
                                                                        labworksheet = TRUE)))
})

testthat::test_that("readSpatialOverlay works as expected - outline points",{
  #Spec 1. The function returns a SpatialOverlay object.
  expect_true(class(overlayBound) == "SpatialOverlay")
  
  #Spec 2. The function returns a SpatialOverlay object with the expected 
  #           values in the correct locations.
  expect_true(labWork(overlayBound) == TRUE)
  expect_true(seg(overlayBound) == "Geometric")
  expect_true(outline(overlayBound) == TRUE)
  expect_true(is.null(plotFactors(overlayBound)))
  expect_true(slideName(overlayBound) == "D5761 (3)")
  
  annots <- sData(annotsGxT)
  annots <- annots[annots$`slide name` == "D5761 (3)",]
  annots$Sample_ID <- gsub(".dcc", "", rownames(annots))
  colnames(annots)[colnames(annots) == "roi"] <- "ROILabel"
  
  expect_identical(scanMeta(overlayBound)[1:3], parseScanMetadata(omexml = xml))
  expect_identical(overlay(overlayBound), suppressWarnings(parseOverlayAttrs(omexml = xml, 
                                                                             annots = annots, 
                                                                             labworksheet = TRUE)))
})

############################  Image Extraction  ################################
fullSizeX <- 32768
fullSizeY <- 32768

#scanMeta <- parseScanMetadata(xml)

testthat::test_that("correct image gets xml", {
  #Spec 1. The function only extracts valid res layers.
  expect_error(imageExtraction(ometiff = tifFile, res = 9),
               regexp = "valid res integers for this image must be between 1 and")
  #Spec 2. The function extracts expected res layer.
  image <- imageExtraction(ometiff = tifFile, res = 8, 
                           scanMeta = scanMetadata)
  expect_true(class(image) == "magick-image")
  expect_true(image_info(image)$width == fullSizeX/2^(8-1))
  expect_true(image_info(image)$height == fullSizeY/2^(8-1))
})

testthat::test_that("checkValidRes is correct",{
  #Spec 1. The function returns expected value.
  expect_true(checkValidRes(tifFile) == 8)
})  

################################  Add Image  ###################################
overlayImage <- addImageOmeTiff(overlayBound, tifFile, res = 8)

testthat::test_that("Image is added correctly",{
  #Spec 1. The function outputs a list in the image slot containing the 
  #           expected filePath, imagePointer, and resolution.
  expect_true(all(names(overlayImage@image) == c("filePath", 
                                                 "imagePointer", 
                                                 "resolution")))
  
  expect_true(overlayImage@image$filePath == tifFile)
  
  expect_true(overlayImage@image$resolution == 8)
  
  #Spec 2. The imagePointer is an magick-image with the correct dimensions
  expect_true(class(showImage(overlayImage)) == "magick-image")
  
  expect_true(image_info(showImage(overlayImage))$width == 256)
  expect_true(image_info(showImage(overlayImage))$height == 256)
  
  #Spec 4. The function produces reproducible results
  # vdiffr::expect_doppelganger("add ometiff res 8", showImage(overlayImage))
})

testthat::test_that("Coordinates are scaled",{
  #Spec 3. The function scales the coordinates.
  expect_true(overlayImage@workflow$scaled)
  
  #Spec 2. The coordinates are all smaller than the image size.
  expect_true(all(coords(overlayImage)$xcoor < 256))
  expect_true(all(coords(overlayImage)$ycoor < 256))
  
  #Spec 3. There are no duplicated coordinates. 
  expect_false(any(duplicated(coords(overlayImage))))
})

testthat::test_that("scaleCoords errors",{
  #Spec 4. Coordinates can't be rescaled.
  expect_error(scaleCoords(overlayImage))
  #Spec 5. An image must be in object to scale coordinates.
  expect_warning(scaleCoords(overlayBound))
})

overlay4chan <- add4ChannelImage(overlayBound, tifFile, res = 8)

testthat::test_that("4 channel image is added correctly",{
  #Spec 1. The function outputs a list in the image slot containing the 
  #           expected filePath, imagePointer, and resolution.
  expect_true(all(names(overlay4chan@image) == c("filePath", 
                                                 "imagePointer", 
                                                 "resolution")))
  
  expect_true(overlay4chan@image$filePath == tifFile)
  
  expect_true(overlay4chan@image$resolution == 8)
  
  #Spec 2. The imagePointer is an AnnotatedImage with the correct dimensions.
  expect_true(class(showImage(overlay4chan)) == "AnnotatedImage")
  
  expect_true(all(dim(imageData(overlay4chan)) == c(256,256,4)))
})

testthat::test_that("Coordinates are scaled",{
  #Spec 3. The function scales the coordinates.
  expect_true(overlay4chan@workflow$scaled)
  
  expect_true(all(coords(overlay4chan)$xcoor < 256))
  expect_true(all(coords(overlay4chan)$ycoor < 256))
  
  expect_false(any(duplicated(coords(overlay4chan))))
})

############################  addPlottingFactor  ###############################
samples <- sampNames(overlayBound)
counts <- as.data.frame(matrix(ncol = length(samples), nrow = 10, 
                               data = runif(length(samples)*10, max = 50)))
colnames(counts) <- samples
rownames(counts) <- stringi::stri_rand_strings(n = 10, length = 5)

testthat::test_that("annotation dataframe can be added as plotting Factor",{
  #Spec 1. The function only works on one factor at a time regardless of input 
  #           type. 
  #Spec 3. The function works with a data.frame input, column name 
  #           plotting factor.
  expect_warning(overlayBound <- addPlottingFactor(overlayBound, as.data.frame(annotsDF), 
                                                   c("segment", "area")))
  expect_true(names(plotFactors(overlayBound)) == "segment")
  expect_true(class(plotFactors(overlayBound)$segment) == "factor")
  expect_identical(as.character(plotFactors(overlayBound)$segment),
                   annotsDF$segment[match(rownames(plotFactors(overlayBound)), 
                                          annotsDF$Sample_ID, nomatch = 0)])
  
  geneName <- rownames(counts)[6]
  
  #Spec 2. The function gives warning for annotation missing for samples 
  #           in object regardless of input type. 
  #Spec 4. The function works with a data.frame input, row name plotting 
  #           factor. 
  overlayBound <- addPlottingFactor(overlayBound, as.data.frame(counts), 
                                    geneName)
  expect_true(all(names(plotFactors(overlayBound)) == c("segment", geneName)))
  expect_true(class(plotFactors(overlayBound)[[geneName]]) == "numeric")
  expect_identical(plotFactors(overlayBound)[[geneName]],
                   as.numeric(counts[geneName, match(rownames(plotFactors(overlayBound)), 
                                                     colnames(counts), nomatch = 0)]))
})

testthat::test_that("annotation vectors can be added as plotting Factor",{
  #Spec 7. If vectors aren't named they must be the same length as number of 
  #           samples in object.
  expect_error(suppressWarnings(addPlottingFactor(overlayBound, 
                                                  annotsDF$segment[1],
                                                  "test")))
  
  #Spec 8. The function only matches vectors if they are named, otherwise 
  #           assumed in correct order.
  #Spec 9. The function works with character vectors.
  expect_warning(overlayBound <- addPlottingFactor(overlayBound, 
                                                   as.character(annotsDF$segment), 
                                                   "segmentNonNamed"))
  annot <- as.character(annotsDF$segment)
  names(annot) <- annotsDF$Sample_ID
  expect_warning(overlayBound <- addPlottingFactor(overlayBound, annot, "segmentNamed"), 
                 NA)
  
  expect_true(class(plotFactors(overlayBound)$segmentNonNamed) == "factor")
  expect_true(class(plotFactors(overlayBound)$segmentNamed) == "factor")
  # expect_false(all(plotFactors(overlayBound)$segmentNonNamed == plotFactors(overlayBound)$segmentNamed))
  expect_identical(as.character(plotFactors(overlayBound)$segmentNamed),
                   annotsDF$segment[match(rownames(plotFactors(overlayBound)), 
                                          annotsDF$Sample_ID, nomatch = 0)])
  
  #Spec 8. The function only matches vectors if they are named, otherwise 
  #           assumed in correct order.
  #Spec 10. The function works with factor vectors.
  expect_warning(overlayBound <- addPlottingFactor(overlayBound, 
                                                   as.factor(annotsDF$segment), 
                                                   "segmentNonNamedFactor"))
  annot <- as.factor(annotsDF$segment)
  names(annot) <- annotsDF$Sample_ID
  expect_warning(overlayBound <- addPlottingFactor(overlayBound, annot, "segmentNamedFactor"), NA)
  
  expect_true(class(plotFactors(overlayBound)$segmentNonNamedFactor) == "factor")
  expect_true(class(plotFactors(overlayBound)$segmentNamedFactor) == "factor")
  # expect_false(all(plotFactors(overlayBound)$segmentNonNamedFactor == plotFactors(overlayBound)$segmentNamedFactor))
  expect_true(all(plotFactors(overlayBound)$segmentNonNamed == plotFactors(overlayBound)$segmentNonNamedFactor))
  expect_true(all(plotFactors(overlayBound)$segmentNamed == plotFactors(overlayBound)$segmentNamedFactor))
  expect_identical(as.character(plotFactors(overlayBound)$segmentNamedFactor),
                   annotsDF$segment[match(rownames(plotFactors(overlayBound)), 
                                          annotsDF$Sample_ID, nomatch = 0)])
  
  #Spec 8. The function only matches vectors if they are named, otherwise 
  #           assumed in correct order.
  #Spec 11. The function works with numeric vectors.
  expect_warning(overlayBound <- addPlottingFactor(overlayBound, 
                                                   as.numeric(annotsDF$area), 
                                                   "areaNonNamed"))
  annot <-  as.numeric(annotsDF$area)
  names(annot) <- annotsDF$Sample_ID
  expect_warning(overlayBound <- addPlottingFactor(overlayBound, annot, "areaNamed"), NA)
  
  expect_true(class(plotFactors(overlayBound)$areaNonNamed) == "numeric")
  expect_true(class(plotFactors(overlayBound)$areaNamed) == "numeric")
  
  # expect_false(all(plotFactors(overlayBound)$areaNonNamed == plotFactors(overlayBound)$areaNamed))
  expect_identical(plotFactors(overlayBound)$areaNamed,
                   annotsDF$area[match(rownames(plotFactors(overlayBound)), 
                                       annotsDF$Sample_ID, nomatch = 0)])
})

testthat::test_that("annotation GeoMxSet object can be added as plotting Factor",{
  #Spec 12. The function works with a NanostringGeomxSet input, column name 
  #           plotting factor. 
  overlayBound <- suppressWarnings(addPlottingFactor(overlayBound, annotsGxT, "segment"))
  
  expect_true(class(plotFactors(overlayBound)$segment) == "factor")
  expect_identical(as.character(plotFactors(overlayBound)$segment),
                   sData(annotsGxT)$segment[match(rownames(plotFactors(overlayBound)), 
                                                  sData(annotsGxT)$SampleID, nomatch = 0)])
  
  #Spec 13. The function works with a NanostringGeomxSet input, row name 
  #           plotting factor.
  overlayBound <- addPlottingFactor(overlayBound, annotsGxT, "Calm1")
  
  expect_true(class(plotFactors(overlayBound)$Calm1) == "numeric")
  expect_true(all(plotFactors(overlayBound)$Calm1 ==
                    exprs(annotsGxT)["Calm1", match(rownames(plotFactors(overlayBound)), 
                                                    sData(annotsGxT)$SampleID, nomatch = 0)]))
})

overlayBound <- addPlottingFactor(overlayBound, as.data.frame(annotsDF), "segment")
overlay4chan <- addPlottingFactor(overlay4chan, as.data.frame(annotsDF), "segment")
overlayImage <- addPlottingFactor(overlayImage, as.data.frame(annotsDF), "segment")
kidneyOverlay <- addPlottingFactor(kidneyOverlay, kidneyAnnots, "Segment_type")

###############################  removeSample  #################################
segmentedROIs <- meta(overlay(kidneyOverlay))$Sample_ID[which(meta(overlay(kidneyOverlay))$Segmentation == "Segmented")]

geometricOverlay <- removeSample(kidneyOverlay, c(segmentedROIs,sampNames(kidneyOverlay)[-28]))

testthat::test_that("removeSamples only removes valid sample names", {
  #Spec 1. The function only works on valid sample names. 
  expect_warning(temp <- removeSample(overlay = kidneyOverlay, remove = "fakeSample"))
  expect_identical(kidneyOverlay, temp)
})

testthat::test_that("removeSamples works as intended", {
  #Spec 4. The function works after adding coordinates and plotting factors. 
  expect_false(length(sampNames(kidneyOverlay)) == length(sampNames(geometricOverlay)))
  expect_true(all(sampNames(geometricOverlay) %in% sampNames(kidneyOverlay)))
  expect_false(all(sampNames(kidneyOverlay) %in% sampNames(geometricOverlay)))
  expect_false(any(segmentedROIs %in% sampNames(geometricOverlay)))
  expect_true(1 == length(sampNames(geometricOverlay)))
  expect_false(seg(kidneyOverlay) == seg(geometricOverlay))
  expect_false(nrow(plotFactors(geometricOverlay)) == nrow(plotFactors(kidneyOverlay)))
  expect_false(any(segmentedROIs %in% rownames(plotFactors(geometricOverlay))))
  expect_false(any(segmentedROIs %in% coords(geometricOverlay)$sampleID))
})

##############################  SpatialOverlay  ################################
testthat::test_that("SpatialOverlay is formatted correctly",{
  #Spec 1. The class is formatted correctly.
  expect_true(all(names(scanMeta(overlayBound)) == c("Panels", "PhysicalSizes", 
                                                     "Fluorescence", 
                                                     "Segmentation")))
  expect_true(class(scanMeta(overlayBound)$Panels) == "character")
  expect_true(all(names(scanMeta(overlayBound)$PhysicalSizes) == c("X", "Y")))
  expect_true(class(scanMeta(overlayBound)$PhysicalSizes$X) == "numeric")
  expect_true(class(scanMeta(overlayBound)$PhysicalSizes$Y) == "numeric")
  expect_true(class(scanMeta(overlayBound)$Fluorescence) == "data.frame")
  expect_true(all(names(scanMeta(overlayBound)$Fluorescence) == c("Dye", 
                                                                  "DisplayName",
                                                                  "Color", 
                                                                  "WaveLength",
                                                                  "Target", 
                                                                  "ExposureTime",
                                                                  "MinIntensity", 
                                                                  "MaxIntensity",
                                                                  "ColorCode")))
  expect_true(all(names(overlayBound@workflow) %in% c("labWorksheet", "outline", 
                                                      "scaled")))
  expect_true(all(coords(overlayBound)$sampleID %in% sampNames(overlayBound)))
  expect_true(all(rownames(plotFactors(overlayBound)) == sampNames(overlayBound)))
  
  expect_true(all(names(overlayBound@image) %in% c("filePath", "imagePointer", 
                                                   "resolution")))
})

testthat::test_that("SpatialOverlay accessor work as expected",{
  #Spec 2. The class accessors work as expected.
  expect_true(slideName(overlayBound) == "D5761 (3)")
  expect_identical(slideName(overlayBound), overlayBound@slideName)
  
  expect_true(class(overlay(overlayBound)) == "SpatialPosition")
  expect_identical(overlay(overlayBound), overlayBound@overlayData)
  
  expect_true(class(scanMeta(overlayBound)) == "list")
  expect_identical(scanMeta(overlayBound), overlayBound@scanMetadata)
  
  expect_true(class(coords(overlayBound)) == "data.frame")
  expect_identical(coords(overlayBound), overlayBound@coords)
  
  expect_true(class(plotFactors(overlayBound)) == "data.frame")
  expect_identical(plotFactors(overlayBound), overlayBound@plottingFactors)
  
  expect_true(class(labWork(overlayBound)) == "logical")
  expect_identical(labWork(overlayBound), overlayBound@workflow$labWorksheet)
  
  expect_true(class(outline(overlayBound)) == "logical")
  expect_identical(outline(overlayBound), overlayBound@workflow$outline)
  
  expect_true(class(scaleBarRatio(overlayBound)) == "numeric")
  expect_identical(scaleBarRatio(overlayBound), overlayBound@scanMetadata$PhysicalSizes$X)
  
  expect_true(class(fluor(overlayBound)) == "data.frame")
  expect_identical(fluor(overlayBound), overlayBound@scanMetadata$Fluorescence)
  
  expect_true(class(seg(overlayBound)) == "character")
  expect_identical(seg(overlayBound), overlayBound@scanMetadata$Segmentation)
  
  expect_true(class(sampNames(overlayBound)) == "character")
  expect_identical(sampNames(overlayBound), meta(overlay(overlayBound))$Sample_ID)
  
  expect_true(class(res(overlayImage)) == "numeric")
  expect_true(res(overlayImage) == overlayImage@image$resolution)
  
  expect_true(class(showImage(overlayImage)) == "magick-image")
  expect_identical(showImage(overlayImage), overlayImage@image$imagePointer)
})

testthat::test_that("SpatialOverlay replacers work as expected",{
  #Spec 3. The class replacers work as expected. 
  expect_false(ncol(plotFactors(geometricOverlay)) == ncol(plotFactors(addPlottingFactor(geometricOverlay, 
                                                                                         kidneyAnnots, 
                                                                                         "disease_status"))))
  expect_false(nrow(coords(geometricOverlay)) == nrow(coords(createCoordFile(geometricOverlay, 
                                                                             outline = TRUE))))
})

############################  Image Manipulation  ##############################
testthat::test_that("cropTissue works",{
  tissue <- cropTissue(overlayImage)
  
  #Spec 1. The function returns smaller image.
  expect_true(image_info(showImage(overlayImage))$width >
                image_info(showImage(tissue))$width)
  expect_true(image_info(showImage(overlayImage))$height >
                image_info(showImage(tissue))$height)
  
  #Spec 2. The function returns all original coordinates.
  expect_true(nrow(coords(overlayImage)) == nrow(coords(tissue)))
  
  #Spec 3. The function produces reproducible results.
  # vdiffr::expect_doppelganger("cropTissue", showImage(tissue)) 
})

testthat::test_that("cropSamples works",{
  samps <- sampNames(overlayImage)[1]
  sampOnlyImage <- cropSamples(overlayImage, sampleIDs = samps, sampsOnly = TRUE)
  
  #Spec 1. The function returns smaller image.
  expect_true(image_info(showImage(overlayImage))$width >
                image_info(showImage(sampOnlyImage))$width)
  expect_true(image_info(showImage(overlayImage))$height >
                image_info(showImage(sampOnlyImage))$height)
  
  #Spec 2. The function returns all coordinates of only the given samples. 
  expect_true(nrow(coords(overlayImage)) > nrow(coords(sampOnlyImage)))
  expect_true(nrow(coords(overlayImage)[coords(overlayImage)$sampleID %in% samps,]) ==
                nrow(coords(sampOnlyImage)))
  
  #Spec 3. The function produces reproducible results.
  # vdiffr::expect_doppelganger("cropSamples sampsOnly", showImage(sampOnlyImage)) 
  
  sampImage <- cropSamples(overlayImage, sampleIDs = samps, sampsOnly = FALSE)
  
  #Spec 1. The function returns smaller image.
  expect_true(image_info(showImage(overlayImage))$width >
                image_info(showImage(sampImage))$width)
  expect_true(image_info(showImage(overlayImage))$height >
                image_info(showImage(sampImage))$height)
  
  #Spec 2. The function returns all coordinates of the given samples. 
  expect_true(nrow(coords(overlayImage)) > nrow(coords(sampImage)))
  # expect_true(nrow(coords(overlayImage)[coords(overlayImage)$sampleID %in% samps,]) <
  #                 nrow(coords(sampImage)))
  
  #Spec 3. The function returns coordinates within dimensions of cropped image. 
  expect_true(all(coords(sampOnlyImage)$xcoor < 
                    image_info(showImage(sampOnlyImage))$width))
  expect_true(all(coords(sampOnlyImage)$ycoor < 
                    image_info(showImage(sampOnlyImage))$height))
  
  expect_true(all(coords(sampImage)$xcoor <
                    image_info(showImage(sampImage))$width + 1))
  expect_true(all(coords(sampImage)$ycoor <
                    image_info(showImage(sampImage))$height + 1))
  
  #Spec 4. The function produces reproducible results.
  # vdiffr::expect_doppelganger("cropSamples all ROIs", showImage(sampImage)) 
  
  #Spec 5. The function only works with valid sampleIDs.
  expect_error(expect_warning(cropSamples(overlayImage, 
                                          sampleIDs = "fakeID", 
                                          sampsOnly = TRUE)))
  
  expect_warning(cropSamples(overlayImage, 
                             sampleIDs = c(samps,"fakeID"), 
                             sampsOnly = TRUE))
})

testthat::test_that("flipX works",{
  #Spec 1. The function returns expected coordinates.
  expect_true(all(abs(image_info(showImage(overlayImage))$width - 
                        coords(overlayImage)$xcoor) == 
                    coords(flipX(overlayImage))$xcoor))
  
  #Spec 2. The function produces reproducible results.
  # vdiffr::expect_doppelganger("flipX", showImage(flipX(overlayImage)))
})

testthat::test_that("flipY works",{
  #Spec 1. The function returns expected coordinates.
  expect_true(all(abs(image_info(showImage(overlayImage))$height - 
                        coords(overlayImage)$ycoor) == 
                    coords(flipY(overlayImage))$ycoor))
  
  #Spec 2. The function produces reproducible results.
  # vdiffr::expect_doppelganger("flipY", showImage(flipY(overlayImage)))
})

testthat::test_that("coloring changes need 4 channel image",{
  #Spec 1. The function only works on 4-channel images.
  expect_error(changeColoringIntensity(overlayBound, minInten = 0, 
                                       maxInten = 100000, dye = "Cy3"))
  #Spec 1. The function only works on 4-channel images.
  expect_error(changeImageColoring(overlayBound, "orange", "Cy3"))
})

testthat::test_that("changeColorIntensity works",{
  #Spec 2. The function changes min/max intensity values of only correct fluor.
  fluorChange <- changeColoringIntensity(overlay4chan, minInten = 0, 
                                         maxInten = 100000, dye = "Cy3")
  fluorChange <- changeColoringIntensity(fluorChange, minInten = 0, 
                                         maxInten = 100, dye = "Alexa 647")
  
  cy3 <- which(fluor(overlay4chan)$DisplayName == "Cy3")
  alexa647 <- which(fluor(overlay4chan)$Dye == "Alexa 647")
  
  expect_true(all(fluor(overlay4chan)$MinIntensity[-c(cy3,alexa647)] == 
                    fluor(fluorChange)$MinIntensity[-c(cy3,alexa647)]))
  expect_true(all(fluor(overlay4chan)$MaxIntensity[-c(cy3,alexa647)] == 
                    fluor(fluorChange)$MaxIntensity[-c(cy3,alexa647)]))
  
  expect_true(fluor(fluorChange)$MinIntensity[cy3] == 0)
  expect_true(fluor(fluorChange)$MaxIntensity[cy3] == 100000)
  
  expect_true(fluor(fluorChange)$MinIntensity[alexa647] == 0)
  expect_true(fluor(fluorChange)$MaxIntensity[alexa647] == 100)
})

testthat::test_that("changeImageColoring works",{
  #Spec 2. The function changes ColorCode values of only correct fluor.
  fluorChange <- changeImageColoring(overlay4chan, "orange", dye = "Cy3")
  fluorChange <- changeImageColoring(fluorChange, "#03fcf8", dye = "Alexa 647")
  fluorChange <- changeImageColoring(fluorChange, "#03c6fc", dye = "FITC")
  
  expect_false(all(fluor(overlay4chan)$ColorCode == fluor(fluorChange)$ColorCode))
  
  cy3 <- which(fluor(overlay4chan)$DisplayName == "Cy3")
  alexa647 <- which(fluor(overlay4chan)$Dye == "Alexa 647")
  fitc <- which(fluor(overlay4chan)$DisplayName == "FITC")
  
  expect_true(all(fluor(overlay4chan)$ColorCode[-c(cy3,alexa647,fitc)] == 
                    fluor(fluorChange)$ColorCode[-c(cy3,alexa647,fitc)]))
  
  expect_true(fluor(fluorChange)$ColorCode[cy3] == "orange")
  expect_true(fluor(fluorChange)$ColorCode[alexa647] == "#03fcf8")
  expect_true(fluor(fluorChange)$ColorCode[fitc] == "#03c6fc")
  
  expect_true(fluor(fluorChange)$Color[cy3] == "Orange")
  expect_true(fluor(fluorChange)$Color[alexa647] == "Cyan")
  expect_true(fluor(fluorChange)$Color[fitc] == "Deepskyblue")
})

# need help writing a test that isn't just a copy of the function
testthat::test_that("imageColoring works",{
  #Spec 1. The function creates RGB image arrays.
  overlayRGB <- imageColoring(showImage(overlay4chan), scanMeta(overlay4chan))
  
  expect_true(dim(imageData(overlayRGB))[3] == 3)
  
  #Spec 2. The function produces reproducible results.
  # vdiffr::expect_doppelganger("imageColoring", image_read(overlayRGB))
})

testthat::test_that("recoloring works",{
  fluorChange <- changeImageColoring(overlay4chan, "orange", dye = "Cy3")
  overlayRGB <- recolor(fluorChange)
  
  #Spec 1. The function scales coordinates.
  expect_true(overlayRGB@workflow$scaled)
  
  expect_true(image_info(showImage(overlayImage))$width >
                image_info(showImage(overlayRGB))$width)
  expect_true(image_info(showImage(overlayImage))$height >
                image_info(showImage(overlayRGB))$height)
  
  #Spec 2. The function creates RGB image arrays.
  expect_false(all(imageData(as_EBImage(showImage(overlayRGB))) == 
                     imageData(as_EBImage(showImage(cropTissue(overlayImage))))))
  
  expect_true(dim(imageData(as_EBImage(showImage(overlayRGB))))[3] == 3)
  
  #Spec 3. The function produces reproducible results.
  # vdiffr::expect_doppelganger("recolor", showImage(overlayRGB))
})

################################  Plotting  ####################################
testthat::test_that("plotSpatialOverlay requires valid colorBy variable",{
  #Spec 1. The function requires valid colorBy variable.
  expect_error(plotSpatialOverlay(overlayBound, colorBy = "tissue", 
                                  hiRes = FALSE, scaleBar = FALSE))
})

testthat::test_that("plotSpatialOverlay prints",{
  expect_error(gp <- plotSpatialOverlay(overlayImage, colorBy = "segment", 
                                        hiRes = FALSE, scaleBar = FALSE, 
                                        fluorLegend = TRUE), NA)
  expect_error(gp, NA)
  expect_true(all(class(gp) == c("gg","ggplot")))
  
  #Spec 6. The function produces reproducible figures.
  # vdiffr::expect_doppelganger("lowRes fluorLegend", gp)
})

testthat::test_that("scaleBarMicrons works as intended", {
  
  # Should have "2625" labeled
  # gp1 <- plotSpatialOverlay(overlayImage, colorBy = "segment", 
  #                           scaleBar = TRUE, hiRes = FALSE, scaleBarColor = "white")
  # 
  # # Should have "2000" labled
  # gp2 <- plotSpatialOverlay(overlayImage, colorBy = "segment", 
  #                           scaleBar = TRUE, hiRes = FALSE, scaleBarColor = "white", 
  #                           scaleBarMicrons = 2000)
  # Should have "2625" labeled AND have a warning that the bar was set to high
  expect_warning(gp3 <- plotSpatialOverlay(overlayImage, colorBy = "segment", 
                                           scaleBar = TRUE, hiRes = FALSE, scaleBarColor = "white", 
                                           scaleBarMicrons = 2000000), 
                 "scaleBarMicrons is bigger than image, will use given scaleBarWidth value instead")
  
  # doppelgangers from the above
  #Spec 1. The function uses scaleBarWidth if scaleBarMicrons is not set.
  # vdiffr::expect_doppelganger("scale bar check 1", gp1)
  #Spec 2. The function sets scale bar to be equal to scaleBarMicrons.
  # vdiffr::expect_doppelganger("scale bar check 2", gp2)
  #Spec 3. The function uses scaleBarWidth if scaleBarMicrons is not valid. 
  # vdiffr::expect_doppelganger("scale bar check 3", gp3)
})

scaleBar <- scaleBarMath(scanMetadata = scanMetadataKidney, 
                         pts = coords(overlayBound), 
                         scaleBarWidth = 0.2)

testthat::test_that("scaleBarMath is correct",{
  #Spec 1. The function expects size to be between 0-1.
  expect_error(scaleBarMath(scanMetadata = scanMetadataKidney, 
                            pts = coords(overlayBound), size = 10))
  
  #Spec 2. The function returns a list with the expected names and values.
  expect_true(class(scaleBar) == "list")
  
  expect_true(all(names(scaleBar) == c("um", "pixels", "axis", 
                                       "minX", "maxX", 
                                       "minY", "maxY")))
  axis <- scaleBar$axis
  expect_true(axis == "X")
  scaleBar <- scaleBar[-3]
  
  expect_true(all(lapply(scaleBar, class) == "numeric"))
  
  expect_true(scaleBar$minX == min(coords(overlayBound)$xcoor))
  expect_true(scaleBar$minY == min(coords(overlayBound)$ycoor))
  
  expect_true(scaleBar$maxX == max(coords(overlayBound)$xcoor))
  expect_true(scaleBar$maxY == max(coords(overlayBound)$ycoor))
  
  #Spec 3. The function returns a um value in valid sizes.
  validSizes <- sort(c(seq(5,25,5), seq(30, 50, 10), 
                       seq(75,5000,25), seq(5100, 25000, 100)))
  
  expect_true(scaleBar$um %in% validSizes)
  
  #Spec 4. The function calculates the number of pixels for scale bar 
  #           correctly.
  expect_true(scaleBar$pixels == scaleBar$um / scanMetadataKidney$PhysicalSizes$X)
})

testthat::test_that("scaleBarCalculation is correct",{
  #Spec 1. The function only works with valid corner value.
  expect_error(scaleBarCalculation(scaleBar = scaleBar, corner = "fakeCorner"))
  
  #Spec 2. The function returns a list of numeric values.
  scaleBarPts <- scaleBarCalculation(scaleBar = scaleBar, corner = "bottomright")
  expect_true(all(lapply(scaleBarPts, class) == "numeric"))
  
  #Spec 3. The function calculates the scale bar points the same across the 
  #           different corner options. 
  validCorners <- c("bottomright", "bottomleft", "bottomcenter", 
                    "topright", "topleft", "topcenter")
  scaleBarPts <- list()
  
  for(i in validCorners){
    scaleBarPts[[i]] <- scaleBarCalculation(scaleBar = scaleBar, corner = i)
    
    expect_true(scaleBarPts[[i]]$start >= scaleBar$minX & 
                  scaleBarPts[[i]]$start <= scaleBar$maxX)
    expect_true(scaleBarPts[[i]]$end >= scaleBar$minX & 
                  scaleBarPts[[i]]$end <= scaleBar$maxX)
    
    expect_true(scaleBarPts[[i]]$lineY >= scaleBar$minY & 
                  scaleBarPts[[i]]$lineY <= scaleBar$maxY)
    expect_true(scaleBarPts[[i]]$textY >= scaleBar$minY & 
                  scaleBarPts[[i]]$textY <= scaleBar$maxY)
    
    expect_equal((scaleBarPts[[i]]$end - scaleBarPts[[i]]$start), 
                 scaleBar$pixels, tolerance = 1e-8)
  }
  
  left <- grep(names(scaleBarPts), pattern = "left")
  right <- grep(names(scaleBarPts), pattern = "right")
  center <- grep(names(scaleBarPts), pattern = "center")
  top <- grep(names(scaleBarPts), pattern = "top")
  bottom <- grep(names(scaleBarPts), pattern = "bottom")
  
  for(i in top){
    for(j in top){
      if(i != j){
        expect_equal(scaleBarPts[[i]]$lineY, scaleBarPts[[j]]$lineY)
        expect_equal(scaleBarPts[[i]]$textY, scaleBarPts[[j]]$textY)
      }
    }
  }
  
  for(i in bottom){
    for(j in bottom){
      if(i != j){
        expect_equal(scaleBarPts[[i]]$lineY, scaleBarPts[[j]]$lineY)
        expect_equal(scaleBarPts[[i]]$textY, scaleBarPts[[j]]$textY)
      }
    }
  }
  
  expect_true(scaleBarPts[[top[1]]]$lineY != scaleBarPts[[bottom[1]]]$lineY)
  expect_true(scaleBarPts[[top[1]]]$textY != scaleBarPts[[bottom[1]]]$textY)
  
  expect_equal(scaleBarPts[[left[1]]]$start, scaleBarPts[[left[2]]]$start)
  expect_equal(scaleBarPts[[left[1]]]$end, scaleBarPts[[left[2]]]$end)
  
  expect_equal(scaleBarPts[[right[1]]]$start, scaleBarPts[[right[2]]]$start)
  expect_equal(scaleBarPts[[right[1]]]$end, scaleBarPts[[right[2]]]$end)
  
  expect_equal(scaleBarPts[[center[1]]]$start, scaleBarPts[[center[2]]]$start)
  expect_equal(scaleBarPts[[center[1]]]$end, scaleBarPts[[center[2]]]$end)
  
  expect_true(scaleBarPts[[left[1]]]$start != scaleBarPts[[right[1]]]$start)
  expect_true(scaleBarPts[[left[1]]]$start != scaleBarPts[[center[1]]]$start)
  expect_true(scaleBarPts[[center[1]]]$start != scaleBarPts[[right[1]]]$start)
  
  expect_true(scaleBarPts[[left[1]]]$end != scaleBarPts[[right[1]]]$end)
  expect_true(scaleBarPts[[left[1]]]$end != scaleBarPts[[center[1]]]$end)
  expect_true(scaleBarPts[[center[1]]]$end != scaleBarPts[[right[1]]]$end)
  
})

testthat::test_that("scaleBarPrinting is correct",{
  #Spec 1. The function only works with valid corner value.
  expect_error(gp <- plotSpatialOverlay(overlayBound, colorBy = "segment", 
                                        hiRes = FALSE, scaleBar = TRUE, 
                                        corner = "fakeCorner"))
  #Spec 2. The function produces a ggplot object.
  expect_error(gp <- plotSpatialOverlay(overlayBound, colorBy = "segment", 
                                        hiRes = FALSE, scaleBar = TRUE), NA)
  
  #Spec 3. The function produces reproducible figures. 
  # vdiffr::expect_doppelganger("no image scaleBar", gp)
})

testthat::test_that("plotting occurs on images",{
  #Spec 5. The function works on with both 4-channel and RGB images. 
  #4 channel
  expect_error(gp4 <- plotSpatialOverlay(overlay4chan, 
                                         colorBy = "segment", 
                                         scaleBar = FALSE, 
                                         image = TRUE), NA)
  expect_error(gp4, NA)
  expect_true(all(class(gp4) == c("gg","ggplot")))
  
  #Spec 6. The function produces reproducible figures.
  # vdiffr::expect_doppelganger("4-channel no scaleBar", gp4)
})

scaleBar <- scaleBarMath(scanMetadata = scanMeta(overlayImage), 
                         pts = coords(overlayImage), 
                         scaleBarWidth = 0.2,
                         image = overlayImage@image)

testthat::test_that("scale bar math on images",{
  #Spec 2. The function returns a list with the expected names and values.
  expect_true(class(scaleBar) == "list")
  
  expect_true(all(names(scaleBar) == c("um", "pixels", "axis", 
                                       "minX", "maxX", 
                                       "minY", "maxY")))
  axis <- scaleBar$axis
  expect_true(axis == "X")
  scaleBar <- scaleBar[-3]
  
  expect_true(all(lapply(scaleBar, class) == "numeric"))
  
  expect_true(scaleBar$minX == image_info(showImage(overlayImage))$width * 0.02)
  expect_true(scaleBar$minY == image_info(showImage(overlayImage))$height * 0.02)
  
  expect_true(scaleBar$maxX == image_info(showImage(overlayImage))$width * 0.98)
  expect_true(scaleBar$maxY == image_info(showImage(overlayImage))$height * 0.98)
  
  #Spec 3. The function returns a um value in valid sizes.
  validSizes <- sort(c(seq(5,25,5), seq(30, 50, 10), 
                       seq(75,5000,25), seq(5100, 25000, 100)))
  
  expect_true(scaleBar$um %in% validSizes)
  
  #Spec 4. The function calculates the number of pixels for scale bar 
  #           correctly.
  expect_true(scaleBar$pixels == scaleBar$um / (scaleBarRatio(overlayImage) * 
                                                  2^(overlayImage@image$resolution-1)))
})

testthat::test_that("scale bar calculation on images",{
  expect_error(scaleBarCalculation(scaleBar = scaleBar, corner = "fakeCorner"))
  
  #Spec 2. The function returns a list of numeric values.
  scaleBarPts <- scaleBarCalculation(scaleBar = scaleBar, corner = "bottomright")
  expect_true(all(lapply(scaleBarPts, class) == "numeric"))
  
  #Spec 3. The function calculates the scale bar points the same across the 
  #           different corner options.
  validCorners <- c("bottomright", "bottomleft", "bottomcenter", 
                    "topright", "topleft", "topcenter")
  
  scaleBarPts <- list()
  
  for(i in validCorners){
    scaleBarPts[[i]] <- scaleBarCalculation(scaleBar = scaleBar, corner = i)
    
    expect_true(scaleBarPts[[i]]$start >= scaleBar$minX & 
                  scaleBarPts[[i]]$start <= scaleBar$maxX)
    expect_true(scaleBarPts[[i]]$end >= scaleBar$minX & 
                  scaleBarPts[[i]]$end <= scaleBar$maxX)
    
    expect_true(scaleBarPts[[i]]$lineY >= scaleBar$minY & 
                  scaleBarPts[[i]]$lineY <= scaleBar$maxY)
    expect_true(scaleBarPts[[i]]$textY >= scaleBar$minY & 
                  scaleBarPts[[i]]$textY <= scaleBar$maxY)
    
    expect_equal((scaleBarPts[[i]]$end - scaleBarPts[[i]]$start), 
                 scaleBar$pixels, tolerance = 1e-8)
  }
  
  left <- grep(names(scaleBarPts), pattern = "left")
  right <- grep(names(scaleBarPts), pattern = "right")
  center <- grep(names(scaleBarPts), pattern = "center")
  top <- grep(names(scaleBarPts), pattern = "top")
  bottom <- grep(names(scaleBarPts), pattern = "bottom")
  
  for(i in top){
    for(j in top){
      if(i != j){
        expect_equal(scaleBarPts[[i]]$lineY, scaleBarPts[[j]]$lineY)
        expect_equal(scaleBarPts[[i]]$textY, scaleBarPts[[j]]$textY)
      }
    }
  }
  
  for(i in bottom){
    for(j in bottom){
      if(i != j){
        expect_equal(scaleBarPts[[i]]$lineY, scaleBarPts[[j]]$lineY)
        expect_equal(scaleBarPts[[i]]$textY, scaleBarPts[[j]]$textY)
      }
    }
  }
  
  expect_true(scaleBarPts[[top[1]]]$lineY != scaleBarPts[[bottom[1]]]$lineY)
  expect_true(scaleBarPts[[top[1]]]$textY != scaleBarPts[[bottom[1]]]$textY)
  
  expect_equal(scaleBarPts[[left[1]]]$start, scaleBarPts[[left[2]]]$start)
  expect_equal(scaleBarPts[[left[1]]]$end, scaleBarPts[[left[2]]]$end)
  
  expect_equal(scaleBarPts[[right[1]]]$start, scaleBarPts[[right[2]]]$start)
  expect_equal(scaleBarPts[[right[1]]]$end, scaleBarPts[[right[2]]]$end)
  
  expect_equal(scaleBarPts[[center[1]]]$start, scaleBarPts[[center[2]]]$start)
  expect_equal(scaleBarPts[[center[1]]]$end, scaleBarPts[[center[2]]]$end)
  
  expect_true(scaleBarPts[[left[1]]]$start != scaleBarPts[[right[1]]]$start)
  expect_true(scaleBarPts[[left[1]]]$start != scaleBarPts[[center[1]]]$start)
  expect_true(scaleBarPts[[center[1]]]$start != scaleBarPts[[right[1]]]$start)
  
  expect_true(scaleBarPts[[left[1]]]$end != scaleBarPts[[right[1]]]$end)
  expect_true(scaleBarPts[[left[1]]]$end != scaleBarPts[[center[1]]]$end)
  expect_true(scaleBarPts[[center[1]]]$end != scaleBarPts[[right[1]]]$end)
})

testthat::test_that("scale bar prints",{
  #Spec 2. The function produces a ggplot object.
  expect_error(gp <- plotSpatialOverlay(overlayImage, colorBy = "segment", 
                                        hiRes = FALSE, scaleBar = TRUE), NA)
  
  #Spec 3. The function produces reproducible figures.
  # vdiffr::expect_doppelganger("image scaleBar", gp)
})

testthat::test_that("fluorLegend works",{
  
  #Spec 1. The function only works on valid nrow values.  
  expect_error(fluorLegend(overlayImage, nrow = 6, textSize = 10, alpha = 1))
  
  # overlay4chan <- changeImageColoring(overlay4chan, color = "magenta", 
  #                                     dye = "Texas Red")
  
  # vdiffr::expect_doppelganger("fluorLegend 2 row", fluorLegend(overlay4chan, nrow = 2,
  #                                                              textSize = 25, alpha = 0.1,
  #                                                              boxColor = "orange"))
})
