tiff <- downloadMouseBrainImage()
overlay <- readRDS(system.file("extdata", "testData", "muBrain.RDS", 
                                     package = "SpatialOmicsOverlay"), 
                         exdir = "testData")
overlayImage <- addImageOmeTiff(overlay, tiff, res = 8)

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
    vdiffr::expect_doppelganger("cropTissue", showImage(tissue)) 
})

testthat::test_that("cropSamples works",{
    samps <- sampNames(overlayImage)[sample(x = 1:length(sampNames(overlayImage)),
                                            size = 2, replace = FALSE)]
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
    vdiffr::expect_doppelganger("cropSamples sampsOnly", showImage(sampOnlyImage)) 
    
    sampImage <- cropSamples(overlayImage, sampleIDs = samps, sampsOnly = FALSE)
    
    #Spec 1. The function returns smaller image.
    expect_true(image_info(showImage(overlayImage))$width >
                    image_info(showImage(sampImage))$width)
    expect_true(image_info(showImage(overlayImage))$height >
                    image_info(showImage(sampImage))$height)
    
    #Spec 2. The function returns all coordinates of the given samples. 
    expect_true(nrow(coords(overlayImage)) > nrow(coords(sampImage)))
    expect_true(nrow(coords(overlayImage)[coords(overlayImage)$sampleID %in% samps,]) <
                    nrow(coords(sampImage)))
    
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
    vdiffr::expect_doppelganger("cropSamples all ROIs", showImage(sampImage)) 
    
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
    vdiffr::expect_doppelganger("flipX", showImage(flipX(overlayImage)))
})

testthat::test_that("flipY works",{
    #Spec 1. The function returns expected coordinates.
    expect_true(all(abs(image_info(showImage(overlayImage))$height - 
                            coords(overlayImage)$ycoor) == 
                        coords(flipY(overlayImage))$ycoor))
    
    #Spec 2. The function produces reproducible results.
    vdiffr::expect_doppelganger("flipY", showImage(flipY(overlayImage)))
})

testthat::test_that("coloring changes need 4 channel image",{
    #Spec 1. The function only works on 4-channel images.
    expect_error(changeColoringIntensity(overlay, minInten = 0, 
                                         maxInten = 100000, dye = "Cy3"))
    #Spec 1. The function only works on 4-channel images.
    expect_error(changeImageColoring(overlay, "orange", "Cy3"))
})

overlay <- add4ChannelImage(overlay, tiff, res = 8)

testthat::test_that("changeColorIntensity works",{
    #Spec 2. The function changes min/max intensity values of only correct fluor.
    fluorChange <- changeColoringIntensity(overlay, minInten = 0, 
                                           maxInten = 100000, dye = "Cy3")
    fluorChange <- changeColoringIntensity(fluorChange, minInten = 0, 
                                           maxInten = 100, dye = "Alexa 647")
    
    cy3 <- which(fluor(overlay)$DisplayName == "Cy3")
    alexa647 <- which(fluor(overlay)$Dye == "Alexa 647")
    
    expect_true(all(fluor(overlay)$MinIntensity[-c(cy3,alexa647)] == 
                        fluor(fluorChange)$MinIntensity[-c(cy3,alexa647)]))
    expect_true(all(fluor(overlay)$MaxIntensity[-c(cy3,alexa647)] == 
                        fluor(fluorChange)$MaxIntensity[-c(cy3,alexa647)]))
    
    expect_true(fluor(fluorChange)$MinIntensity[cy3] == 0)
    expect_true(fluor(fluorChange)$MaxIntensity[cy3] == 100000)
    
    expect_true(fluor(fluorChange)$MinIntensity[alexa647] == 0)
    expect_true(fluor(fluorChange)$MaxIntensity[alexa647] == 100)
})

testthat::test_that("changeImageColoring works",{
    #Spec 2. The function changes ColorCode values of only correct fluor.
    fluorChange <- changeImageColoring(overlay, "orange", dye = "Cy3")
    fluorChange <- changeImageColoring(fluorChange, "#03fcf8", dye = "Alexa 647")
    fluorChange <- changeImageColoring(fluorChange, "#03c6fc", dye = "FITC")
    
    expect_false(all(fluor(overlay)$ColorCode == fluor(fluorChange)$ColorCode))
    
    cy3 <- which(fluor(overlay)$DisplayName == "Cy3")
    alexa647 <- which(fluor(overlay)$Dye == "Alexa 647")
    fitc <- which(fluor(overlay)$DisplayName == "FITC")
    
    expect_true(all(fluor(overlay)$ColorCode[-c(cy3,alexa647,fitc)] == 
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
    overlayRGB <- imageColoring(showImage(overlay), scanMeta(overlay))
    
    expect_true(dim(imageData(overlayRGB))[3] == 3)
    
    #Spec 2. The function produces reproducible results.
    vdiffr::expect_doppelganger("imageColoring", image_read(overlayRGB))
})

testthat::test_that("recoloring works",{
    fluorChange <- changeImageColoring(overlay, "orange", dye = "Cy3")
    overlayRGB <- recolor(fluorChange)
    
    #Spec 1. The function scales coordinates.
    expect_true(overlay@workflow$scaled)
    
    expect_true(image_info(showImage(overlayImage))$width >
                    image_info(showImage(overlayRGB))$width)
    expect_true(image_info(showImage(overlayImage))$height >
                    image_info(showImage(overlayRGB))$height)
    
    #Spec 2. The function creates RGB image arrays.
    expect_false(all(imageData(as_EBImage(showImage(overlayRGB))) == 
                         imageData(as_EBImage(showImage(cropTissue(overlayImage))))))
    
    expect_true(dim(imageData(as_EBImage(showImage(overlayRGB))))[3] == 3)
    
    #Spec 3. The function produces reproducible results.
    vdiffr::expect_doppelganger("recolor", showImage(overlayRGB))
})
