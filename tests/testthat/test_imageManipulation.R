tiff <- downloadMouseBrainImage()
overlay <- readRDS(unzip("testData/muBrain.zip", exdir = "testData/"))

overlayImage <- addImageOmeTiff(overlay, tiff, res = 8)

testthat::test_that("cropTissue works",{
    tissue <- cropTissue(overlayImage)
    
    expect_true(image_info(showImage(overlayImage))$width >
                     image_info(showImage(tissue))$width)
    expect_true(image_info(showImage(overlayImage))$height >
                     image_info(showImage(tissue))$height)
    
    expect_true(nrow(coords(overlayImage)) == nrow(coords(tissue)))
})

testthat::test_that("cropSamples works",{
    samps <- sampNames(overlayImage)[sample(x = 1:length(sampNames(overlayImage)),
                                            size = 2, replace = FALSE)]
    sampOnlyImage <- cropSamples(overlayImage, sampleIDs = samps, sampsOnly = TRUE)
    
    expect_true(image_info(showImage(overlayImage))$width >
                    image_info(showImage(sampOnlyImage))$width)
    expect_true(image_info(showImage(overlayImage))$height >
                    image_info(showImage(sampOnlyImage))$height)
    
    expect_true(nrow(coords(overlayImage)) > nrow(coords(sampOnlyImage)))
    expect_true(nrow(coords(overlayImage)[coords(overlayImage)$sampleID %in% samps,]) ==
                nrow(coords(sampOnlyImage)))
    
    sampImage <- cropSamples(overlayImage, sampleIDs = samps, sampsOnly = FALSE)
    
    expect_true(image_info(showImage(overlayImage))$width >
                    image_info(showImage(sampImage))$width)
    expect_true(image_info(showImage(overlayImage))$height >
                    image_info(showImage(sampImage))$height)
    
    expect_true(nrow(coords(overlayImage)) > nrow(coords(sampImage)))
    expect_true(nrow(coords(overlayImage)[coords(overlayImage)$sampleID %in% samps,]) <
                    nrow(coords(sampImage)))
    
    expect_true(all(coords(sampOnlyImage)$xcoor < 
                        image_info(showImage(sampOnlyImage))$width))
    expect_true(all(coords(sampOnlyImage)$ycoor < 
                        image_info(showImage(sampOnlyImage))$height))
    
    expect_true(all(coords(sampImage)$xcoor <
                        image_info(showImage(sampImage))$width + 1))
    expect_true(all(coords(sampImage)$ycoor <
                        image_info(showImage(sampImage))$height + 1))
    
    expect_error(expect_warning(cropSamples(overlayImage, 
                                            sampleIDs = "fakeID", 
                                            sampsOnly = TRUE)))
    
    expect_warning(cropSamples(overlayImage, 
                               sampleIDs = c(samps,"fakeID"), 
                               sampsOnly = TRUE))
})

testthat::test_that("flipX works",{
    expect_true(all(abs(image_info(showImage(overlayImage))$width - 
                        coords(overlayImage)$xcoor) == 
                        coords(flipX(overlayImage))$xcoor))
})

testthat::test_that("flipY works",{
    expect_true(all(abs(image_info(showImage(overlayImage))$height - 
                            coords(overlayImage)$ycoor) == 
                        coords(flipY(overlayImage))$ycoor))
})

testthat::test_that("coloring changes need 4 channel image",{
    expect_error(changeColoringIntensity(overlay, minInten = 0, 
                                         maxInten = 100000, dye = "Cy3"))
    expect_error(changeImageColoring(overlay, "orange", "Cy3"))
})

overlay <- add4ChannelImage(overlay, tiff, res = 8)

testthat::test_that("changeColorIntensity works",{
    fluorChange <- changeColoringIntensity(overlay, minInten = 0, 
                                           maxInten = 100000, dye = "Cy3")
    fluorChange <- changeColoringIntensity(fluorChange, minInten = 0, 
                                           maxInten = 100, dye = "Alexa 647")
    
    expect_false(all(fluor(overlay)$MinIntensity == fluor(fluorChange)$MinIntensity))
    expect_false(all(fluor(overlay)$MaxIntensity == fluor(fluorChange)$MaxIntensity))
    
    cy3 <- which(fluor(overlay)$DisplayName == "Cy3")
    alexa647 <- which(fluor(overlay)$Dye == "Alexa 647")
    
    expect_true(fluor(fluorChange)$MinIntensity[cy3] == 0)
    expect_true(fluor(fluorChange)$MaxIntensity[cy3] == 100000)
    
    expect_true(fluor(fluorChange)$MinIntensity[alexa647] == 0)
    expect_true(fluor(fluorChange)$MaxIntensity[alexa647] == 100)
})

testthat::test_that("changeImageColoring works",{
    fluorChange <- changeImageColoring(overlay, "orange", dye = "Cy3")
    fluorChange <- changeImageColoring(fluorChange, "#03fcf8", dye = "Alexa 647")
    fluorChange <- changeImageColoring(fluorChange, "#03c6fc", dye = "FITC")
    
    expect_false(all(fluor(overlay)$ColorCode == fluor(fluorChange)$ColorCode))
    
    cy3 <- which(fluor(overlay)$DisplayName == "Cy3")
    alexa647 <- which(fluor(overlay)$Dye == "Alexa 647")
    fitc <- which(fluor(overlay)$DisplayName == "FITC")
    
    expect_true(fluor(fluorChange)$ColorCode[cy3] == "orange")
    expect_true(fluor(fluorChange)$ColorCode[alexa647] == "#03fcf8")
    
    expect_true(fluor(fluorChange)$Color[cy3] == "Orange")
    expect_true(fluor(fluorChange)$Color[alexa647] == "Cyan")
    expect_true(fluor(fluorChange)$Color[fitc] == "Deepskyblue")
})

# need help writing a test that isn't just a copy of the function
testthat::test_that("imageColoring works",{
    overlayRGB <- imageColoring(showImage(overlay), scanMeta(overlay))
    
    expect_true(dim(imageData(overlayRGB))[3] == 3)
})

# need help writing a coloring test
testthat::test_that("recoloring works",{
    fluorChange <- changeImageColoring(overlay, "orange", dye = "Cy3")
    overlayRGB <- recolor(fluorChange)
    
    expect_true(overlay@workflow$scaled)
    
    expect_true(image_info(showImage(overlayImage))$width >
                    image_info(showImage(overlayRGB))$width)
    expect_true(image_info(showImage(overlayImage))$height >
                    image_info(showImage(overlayRGB))$height)
    
    expect_false(all(imageData(as_EBImage(showImage(overlayRGB))) == 
                         imageData(as_EBImage(showImage(cropTissue(overlayImage))))))
})
