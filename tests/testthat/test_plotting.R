
# look into writing tests with vdiffr
# library(vdiffr)

kidneyXML <- readRDS("testData/kidneyXML.RDS")
kidneyAnnots <- read.table("testData/kidney_annotations_allROIs.txt", 
                           header = T, sep = "\t")

scanMetadataKidney <- parseScanMetadata(kidneyXML)

kidneyAOIattrs <- parseOverlayAttrs(kidneyXML, kidneyAnnots, labworksheet = FALSE)

scanMetadataKidney[["Segmentation"]] <- ifelse(all(meta(kidneyAOIattrs)$Segmentation == "Geometric"),
                                               yes = "Geometric",no = "Segmented")

overlay <- createCoordFile(SpatialOverlay(slideName = "normal3", 
                                          scanMetadata = scanMetadataKidney, 
                                          overlayData = kidneyAOIattrs), 
                           outline = FALSE)

testthat::test_that("plotSpatialOverlay requires valid colorBy variable",{
    expect_error(plotSpatialOverlay(overlay, colorBy = "tissue", 
                                    hiRes = F, scaleBar = F))
})

overlay <- addPlottingFactor(overlay, kidneyAnnots, plottingFactor = "Segment_type")

testthat::test_that("plotSpatialOverlay prints",{
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                          hiRes = F, scaleBar = F), NA)
    expect_error(gp, NA)
    expect_true(all(class(gp) == c("gg","ggplot")))
    
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                      hiRes = T, scaleBar = F), NA)
    expect_error(gp, NA)
    expect_true(all(class(gp) == c("gg","ggplot")))
    
    expect_error(plotSpatialOverlay(overlay, hiRes = F, scaleBar = F), NA)
    
    expect_error(plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                hiRes = F, scaleBar = F, legend = F), NA)
})

geometricOverlay <- removeSample(overlay, 
                                 meta(overlay(overlay))$Sample_ID[
                                     which(meta(overlay(overlay))$Segmentation == 
                                               "Segmented")])

overlayOutline <- createCoordFile(geometricOverlay, outline = TRUE)


testthat::test_that("plotSpatialOverlay prints",{
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                          scaleBar = F), NA)
    expect_error(gp, NA)
    expect_true(all(class(gp) == c("gg","ggplot")))
    
    expect_error(plotSpatialOverlay(overlay, scaleBar = F), NA)
    
    expect_error(plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                    scaleBar = F, legend = F), NA)
    
    expect_error(plotSpatialOverlay(overlayOutline, colorBy = "Segment_type", 
                                    scaleBar = F, legend = F), NA)
})

scaleBar <- scaleBarMath(scanMetadata = scanMetadataKidney, 
                         pts = coords(overlay), 
                         scaleBarWidth = 0.2)

testthat::test_that("scaleBarMath is correct",{
    expect_error(scaleBarMath(scanMetadata = scanMetadataKidney, 
                              pts = coords(overlay), size = 10))
    expect_true(class(scaleBar) == "list")
    
    expect_true(all(names(scaleBar) == c("um", "pixels", "axis", 
                                         "minX", "maxX", 
                                         "minY", "maxY")))
    axis <- scaleBar$axis
    expect_true(axis == "X")
    scaleBar <- scaleBar[-3]
    
    expect_true(all(lapply(scaleBar, class) == "numeric"))
    
    expect_true(scaleBar$minX == min(coords(overlay)$xcoor))
    expect_true(scaleBar$minY == min(coords(overlay)$ycoor))
    
    expect_true(scaleBar$maxX == max(coords(overlay)$xcoor))
    expect_true(scaleBar$maxY == max(coords(overlay)$ycoor))
    
    validSizes <- sort(c(seq(5,25,5), seq(30, 50, 10), 
                         seq(75,5000,25), seq(5100, 25000, 100)))
    
    expect_true(scaleBar$um %in% validSizes)
    
    expect_true(scaleBar$pixels == scaleBar$um / scanMetadataKidney$PhysicalSizes$X)
})

testthat::test_that("scaleBarCalculation is correct",{
    validCorners <- c("bottomright", "bottomleft", "bottomcenter", 
                      "topright", "topleft", "topcenter")
    
    scaleBarPts <- scaleBarCalculation(scaleBar = scaleBar, corner = "bottomright")
    expect_error(scaleBarCalculation(scaleBar = scaleBar, corner = "fakeCorner"))
    expect_true(all(lapply(scaleBarPts, class) == "numeric"))
    
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
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                          hiRes = F, scaleBar = T), NA)
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                          hiRes = F, scaleBar = T, 
                                          corner = "fakeCorner"))
})

tiff <- downloadMouseBrainImage()
overlay <- readRDS(unzip("testData/muBrain.zip", exdir = "testData/"))

overlayImage8 <- add4ChannelImage(overlay, tiff, res = 8)

annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")
annots <- readLabWorksheet(annots, "4")

overlayImage8 <- addPlottingFactor(overlayImage8, annots, "segment")

testthat::test_that("plotting occurs on images",{
    #4 channel
    expect_error(gp4 <- plotSpatialOverlay(overlayImage8, 
                                          colorBy = "segment", 
                                          scaleBar = FALSE, 
                                          image = TRUE), NA)
    expect_error(gp4, NA)
    expect_true(all(class(gp4) == c("gg","ggplot")))
    
    #RGB
    expect_error(gp <- plotSpatialOverlay(recolor(overlayImage8), 
                                          colorBy = "segment", 
                                          scaleBar = FALSE, 
                                          image = TRUE), NA)
    expect_error(gp, NA)
    expect_true(all(class(gp) == c("gg","ggplot")))
    
    expect_true(all.equal(gp, gp4))
})

overlayImage8 <- recolor(overlayImage8)

scaleBar <- scaleBarMath(scanMetadata = scanMeta(overlayImage8), 
                         pts = coords(overlayImage8), 
                         scaleBarWidth = 0.2,
                         image = overlayImage8@image)

testthat::test_that("scale bar math on images",{
    expect_true(class(scaleBar) == "list")
    
    expect_true(all(names(scaleBar) == c("um", "pixels", "axis", 
                                         "minX", "maxX", 
                                         "minY", "maxY")))
    axis <- scaleBar$axis
    expect_true(axis == "X")
    scaleBar <- scaleBar[-3]
    
    expect_true(all(lapply(scaleBar, class) == "numeric"))
    
    expect_true(scaleBar$minX == image_info(showImage(overlayImage8))$width * 0.02)
    expect_true(scaleBar$minY == image_info(showImage(overlayImage8))$height * 0.02)
    
    expect_true(scaleBar$maxX == image_info(showImage(overlayImage8))$width * 0.98)
    expect_true(scaleBar$maxY == image_info(showImage(overlayImage8))$height * 0.98)
    
    validSizes <- sort(c(seq(5,25,5), seq(30, 50, 10), 
                         seq(75,5000,25), seq(5100, 25000, 100)))
    
    expect_true(scaleBar$um %in% validSizes)
    
    expect_true(scaleBar$pixels == scaleBar$um / (scaleBarRatio(overlayImage8) * 
                                                      2^(overlayImage8@image$resolution-1)))
})

testthat::test_that("scale bar calculation on images",{
    validCorners <- c("bottomright", "bottomleft", "bottomcenter", 
                      "topright", "topleft", "topcenter")
    
    scaleBarPts <- scaleBarCalculation(scaleBar = scaleBar, corner = "bottomright")
    expect_error(scaleBarCalculation(scaleBar = scaleBar, corner = "fakeCorner"))
    expect_true(all(lapply(scaleBarPts, class) == "numeric"))
    
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
    expect_error(gp <- plotSpatialOverlay(overlayImage8, colorBy = "segment", 
                                          hiRes = F, scaleBar = T), NA)
})