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

overlay <- createCoordFile(SpatialOverlay(slideName = "normal3", 
                                          scanMetadata = scanMetadataKidney, 
                                          overlayData = kidneyAOIattrs), 
                           outline = FALSE)

testthat::test_that("plotSpatialOverlay requires valid colorBy variable",{
    #Spec 1. The function requires valid colorBy variable.
    expect_error(plotSpatialOverlay(overlay, colorBy = "tissue", 
                                    hiRes = F, scaleBar = F),
                 regexp = "colorBy not in plotFactors")
})

overlay <- addPlottingFactor(overlay, kidneyAnnots, plottingFactor = "Segment_type")

testthat::test_that("plotSpatialOverlay prints",{
    #Spec 2. The function returns a ggplot object for high resolution, low 
    #           resolution and outline graphing.
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                          hiRes = F, scaleBar = F), NA)
    expect_error(gp, NA)
    expect_true(all(class(gp) == c("gg","ggplot")))
    
    #Spec 6. The function produces reproducible figures.
    vdiffr::expect_doppelganger("lowRes no scaleBar", gp)
    
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                      hiRes = T, scaleBar = F), NA)
    expect_error(gp, NA)
    expect_true(all(class(gp) == c("gg","ggplot")))
    
    #Spec 6. The function produces reproducible figures.
    #resulting image is too large 
    #vdiffr::expect_doppelganger("hiRes no scaleBar", gp)
    
    expect_error(plotSpatialOverlay(overlay, hiRes = F, scaleBar = F), NA)
    
    #Spec 3. The function returns a ggplot object without legend if desired.
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                hiRes = F, scaleBar = F, legend = F), NA)
    
    #Spec 6. The function produces reproducible figures.
    vdiffr::expect_doppelganger("lowRes no scaleBar no legend", gp)
    
    #Spec 4. The function returns a ggplot object with fluorescence legend if 
    #           desired.
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                    hiRes = F, scaleBar = F, 
                                    fluorLegend = T), NA)
    
    #Spec 6. The function produces reproducible figures.
    vdiffr::expect_doppelganger("lowRes fluorLegend", gp)
})

geometricOverlay <- removeSample(overlay, 
                                 meta(overlay(overlay))$Sample_ID[
                                     which(meta(overlay(overlay))$Segmentation == 
                                               "Segmented")])

overlayOutline <- createCoordFile(geometricOverlay, outline = TRUE)


testthat::test_that("plotSpatialOverlay prints",{
    #Spec 2. The function returns a ggplot object for high resolution, low 
    #           resolution and outline graphing.
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                          scaleBar = F), NA)
    expect_error(gp, NA)
    expect_true(all(class(gp) == c("gg","ggplot")))
    
    #Spec 6. The function produces reproducible figures.
    #resulting image too large
    #vdiffr::expect_doppelganger("outline no scaleBar", gp)
    
    expect_error(plotSpatialOverlay(overlay, scaleBar = F), NA)
    
    #Spec 3. The function returns a ggplot object without legend if desired.
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                    scaleBar = F, legend = F), NA)
    
    #Spec 6. The function produces reproducible figures.
    #resulting image too large
    # vdiffr::expect_doppelganger("outline no scaleBar no legend", gp)
    
    #Spec 4. The function returns a ggplot object with fluorescence legend if 
    #           desired.
    expect_error(gp <- plotSpatialOverlay(overlayOutline, colorBy = "Segment_type", 
                                    scaleBar = F, fluorLegend = T, hiRes = F), NA)
    
    #Spec 6. The function produces reproducible figures.
    #resulting image too large
    #vdiffr::expect_doppelganger("outline fluorLegend", gp)
    
    
})


testthat::test_that("scaleBarMicrons works as intended", {
 
 # Should have "2075" labeled
 gp1 <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                           scaleBar = TRUE, hiRes = FALSE, scaleBarColor = "black")
 
 # Should have "2000" labled
 gp2 <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                           scaleBar = TRUE, hiRes = FALSE, scaleBarColor = "black", 
                           scaleBarMicrons = 2000)
 # Should have "2075" labeled AND have a warning that the bar was set to high
 expect_warning(gp3 <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                          scaleBar = TRUE, hiRes = FALSE, scaleBarColor = "black", 
                                          scaleBarMicrons = 2000000), 
                "scaleBarMicrons is bigger than image, will use given scaleBarWidth value instead")
 
 # doppelgangers from the above
 #Spec 1. The function uses scaleBarWidth if scaleBarMicrons is not set.
 vdiffr::expect_doppelganger("scale bar check 1", gp1)
 #Spec 2. The function sets scale bar to be equal to scaleBarMicrons.
 vdiffr::expect_doppelganger("scale bar check 2", gp2)
 #Spec 3. The function uses scaleBarWidth if scaleBarMicrons is not valid. 
 vdiffr::expect_doppelganger("scale bar check 3", gp3)
})


scaleBar <- scaleBarMath(scanMetadata = scanMetadataKidney, 
                         pts = coords(overlay), 
                         scaleBarWidth = 0.2)

testthat::test_that("scaleBarMath is correct",{
    #Spec 1. The function expects scaleBarWidth to be between 0-1.
    expect_error(scaleBarMath(scanMetadata = scanMetadataKidney, 
                              pts = coords(overlay), scaleBarWidth = 10),
                 regexp = "scaleBarWidth must be a decimal number between 0 and 1")
    
    #Spec 2. The function returns a list with the expected names and values.
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
    expect_error(scaleBarCalculation(scaleBar = scaleBar, corner = "fakeCorner"),
                 regexp = "Provided corner is not valid")
    
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
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                          hiRes = F, scaleBar = T, 
                                          corner = "fakeCorner"),
                 regexp = "Provided corner is not valid")
    #Spec 2. The function produces a ggplot object.
    expect_error(gp <- plotSpatialOverlay(overlay, colorBy = "Segment_type", 
                                          hiRes = F, scaleBar = T), NA)
    
    #Spec 3. The function produces reproducible figures. 
    vdiffr::expect_doppelganger("no image scaleBar", gp)
})

tiff <- downloadMouseBrainImage()

if(!file.exists("muBrain.RDS")){
  tifFile <- downloadMouseBrainImage()
  annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                        package = "SpatialOmicsOverlay")
  
  overlay <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, annots = annots, 
                                                 slideName = "4", outline = FALSE))
  
  saveRDS(overlay, "muBrain.RDS")
}else{
  overlay <- readRDS( "muBrain.RDS")
}


overlayImage8 <- add4ChannelImage(overlay, tiff, res = 8)

annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")
annots <- readLabWorksheet(annots, "4")

overlayImage8 <- addPlottingFactor(overlayImage8, annots, "segment")

testthat::test_that("plotting occurs on images",{
    #Spec 5. The function works on with both 4-channel and RGB images. 
    #4 channel
    expect_error(gp4 <- plotSpatialOverlay(overlayImage8, 
                                          colorBy = "segment", 
                                          scaleBar = FALSE, 
                                          image = TRUE), NA)
    expect_error(gp4, NA)
    expect_true(all(class(gp4) == c("gg","ggplot")))
    
    #Spec 6. The function produces reproducible figures.
    #resulting image too large
    #vdiffr::expect_doppelganger("4-channel no scaleBar", gp4)
    
    #RGB
    expect_error(gp <- plotSpatialOverlay(recolor(overlayImage8), 
                                          colorBy = "segment", 
                                          scaleBar = FALSE, 
                                          image = TRUE), NA)
    expect_error(gp, NA)
    expect_true(all(class(gp) == c("gg","ggplot")))
    
    #Spec 6. The function produces reproducible figures.
    #resulting image too large
    #vdiffr::expect_doppelganger("RGB no scaleBar", gp)
    
    expect_true(all.equal(gp, gp4))
})

overlay4chan <- overlayImage8

overlayImage8 <- recolor(overlayImage8)

scaleBar <- scaleBarMath(scanMetadata = scanMeta(overlayImage8), 
                         pts = coords(overlayImage8), 
                         scaleBarWidth = 0.2,
                         image = overlayImage8@image)

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
    
    expect_true(scaleBar$minX == image_info(showImage(overlayImage8))$width * 0.02)
    expect_true(scaleBar$minY == image_info(showImage(overlayImage8))$height * 0.02)
    
    expect_true(scaleBar$maxX == image_info(showImage(overlayImage8))$width * 0.98)
    expect_true(scaleBar$maxY == image_info(showImage(overlayImage8))$height * 0.98)
    
    #Spec 3. The function returns a um value in valid sizes.
    validSizes <- sort(c(seq(5,25,5), seq(30, 50, 10), 
                         seq(75,5000,25), seq(5100, 25000, 100)))
    
    expect_true(scaleBar$um %in% validSizes)
    
    #Spec 4. The function calculates the number of pixels for scale bar 
    #           correctly.
    expect_true(scaleBar$pixels == scaleBar$um / (scaleBarRatio(overlayImage8) * 
                                                      2^(overlayImage8@image$resolution-1)))
})

testthat::test_that("scale bar calculation on images",{
    expect_error(scaleBarCalculation(scaleBar = scaleBar, corner = "fakeCorner"),
                 regexp = "Provided corner is not valid")
    
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
    expect_error(gp <- plotSpatialOverlay(overlayImage8, colorBy = "segment", 
                                          hiRes = F, scaleBar = T), NA)
    
    #Spec 3. The function produces reproducible figures.
    vdiffr::expect_doppelganger("image scaleBar", gp)
})

testthat::test_that("fluorLegend works",{
    
    #Spec 1. The function only works on valid nrow values.  
    expect_error(fluorLegend(overlayImage8, nrow = 6, textSize = 10, alpha = 1),
                 regexp = "legend can only have")
    
    #Spec 2. The function produces reproducible legends. 
    vdiffr::expect_doppelganger("fluorLegend 1 row", fluorLegend(overlayImage8, nrow = 1, 
                                                         textSize = 10, alpha = 1))
    
    overlay4chan <- changeImageColoring(overlay4chan, color = "magenta", 
                                        dye = "Texas Red")
    
    vdiffr::expect_doppelganger("fluorLegend 2 row", fluorLegend(overlay4chan, nrow = 2, 
                                                         textSize = 25, alpha = 0.1,
                                                         boxColor = "orange"))
    
    overlay4chan <- changeImageColoring(overlay4chan, color = "cyan", 
                                        dye = "FITC")
    
    vdiffr::expect_doppelganger("fluorLegend 4 row", fluorLegend(overlay4chan, nrow = 4, 
                                                         textSize = 5, alpha = 0.8,
                                                         boxColor = "blue"))
})

