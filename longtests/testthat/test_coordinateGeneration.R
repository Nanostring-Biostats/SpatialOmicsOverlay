unzip(system.file("extdata", "testData", "kidney.zip", 
                  package = "SpatialOmicsOverlay"), 
      exdir = "testData")

kidneyXML <- readRDS("testData/kidneyXML.RDS")
kidneyAnnots <- read.table("testData/kidney_annotations_allROIs.txt", 
                           header = T, sep = "\t")

scanMetadataKidney <- parseScanMetadata(kidneyXML)

kidneyAOIattrs <- parseOverlayAttrs(kidneyXML, kidneyAnnots, labworksheet = FALSE)

AOImeta <- meta(kidneyAOIattrs)[meta(kidneyAOIattrs)$SegmentDisplayName == 
                                    "normal3_scan | 002 | neg",]
AOIposition <- position(kidneyAOIattrs)[meta(kidneyAOIattrs)$SegmentDisplayName == 
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
    
    expectedCoords <- as.data.frame(which(mask == 1, arr.ind = T))
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
    coords <- coordsFromMask(outlineMask, AOImeta, outline = F)
    
    expectedCoords <- as.data.frame(which(outlineMask == 1, arr.ind = T))
    colnames(expectedCoords) <- c("Y", "X")
    expectedCoords[["X"]] <- expectedCoords[["X"]] + AOImeta$X - 1
    expectedCoords[["Y"]] <- expectedCoords[["Y"]] + AOImeta$Y - 1
    
    expect_true(all(expectedCoords == coords))
})

testthat::test_that("Pencil Sorting works as expected",{
    sortedCoords <- coordsFromMask(outlineMask, AOImeta, outline = T)
    
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
    expect_true(length(which(sortedCoords == 1)) > nrow(sortedCoords)*0.99)
    #Spec 2. The function sorts outline coordinates by proximity. The max 
    #           difference is <100.
    expect_true(max(sortedCoords$dif) < 100)
})

scanMetadataKidney[["Segmentation"]] <- ifelse(all(meta(kidneyAOIattrs)$Segmentation == "Geometric"),
                                               yes = "Geometric", no = "Segmented")

overlay <- createCoordFile(SpatialOverlay(slideName = "normal3", 
                                          scanMetadata = scanMetadataKidney, 
                                          overlayData = kidneyAOIattrs), 
                           outline = FALSE)

testthat::test_that("createCoordFile puts data in correct spot",{
    #Spec 1. The function places coordinates in correct location. 
    expect_true(!is.null(coords(overlay)))
})

coords <- coords(overlay)

testthat::test_that("createCoordFile is correct",{
    #Spec 2. The function produces same values as python truth. 
    pythonTruth <- readRDS("testData/kidneyCoordsTruth.RDS")
    pythonTruth <- pythonTruth[,c("ROILabel","AOI","ycoor","xcoor")]
    pythonTruth <- pythonTruth[order(pythonTruth$ROILabel, 
                                     pythonTruth$AOI,
                                     pythonTruth$xcoor),]
    
    expect_true(all(coords == pythonTruth[,c("AOI","ycoor","xcoor")]))
})

testthat::test_that("Outline points on segemented data - warning",{
    #Spec 3. The function only returns outline coordinates on Geometric data. 
    expect_warning(createCoordFile(SpatialOverlay(slideName = "normal3", 
                                                  scanMetadata = scanMetadataKidney, 
                                                  overlayData = kidneyAOIattrs), 
                                   outline = TRUE))
})


testthat::test_that("Boundary is behaving as expected",{
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
