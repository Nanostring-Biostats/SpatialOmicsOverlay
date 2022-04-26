tiff <- downloadMouseBrainImage()

overlay <- readRDS( "testData/muBrain.RDS")

overlayImage6 <- addImageOmeTiff(overlay, tiff, res = 6)
overlayImage8 <- addImageOmeTiff(overlay, tiff, res = 8)

testthat::test_that("Image is added correctly",{
    #Spec 1. The function outputs a list in the image slot containing the 
    #           expected filePath, imagePointer, and resolution.
    expect_true(all(names(overlayImage6@image) == c("filePath", 
                                                    "imagePointer", 
                                                    "resolution")))
    expect_true(all(names(overlayImage8@image) == c("filePath", 
                                                    "imagePointer", 
                                                    "resolution")))
    
    expect_true(overlayImage6@image$filePath == tiff)
    expect_true(overlayImage8@image$filePath == tiff)
    
    expect_true(overlayImage6@image$resolution == 6)
    expect_true(overlayImage8@image$resolution == 8)
    
    #Spec 2. The imagePointer is an magick-image with the correct dimensions
    expect_true(class(showImage(overlayImage6)) == "magick-image")
    expect_true(class(showImage(overlayImage8)) == "magick-image")
    
    expect_true(image_info(showImage(overlayImage6))$width == 1024)
    expect_true(image_info(showImage(overlayImage6))$height == 1024)
    
    expect_true(image_info(showImage(overlayImage8))$width == 256)
    expect_true(image_info(showImage(overlayImage8))$height == 256)
    
    #Spec 4. The function produces reproducible results
    vdiffr::expect_doppelganger("add ometiff res 6", showImage(overlayImage6)) 
    vdiffr::expect_doppelganger("add ometiff res 8", showImage(overlayImage8))
})

testthat::test_that("Coordinates are scaled",{
    #Spec 3. The function scales the coordinates.
    expect_true(overlayImage6@workflow$scaled)
    expect_true(overlayImage8@workflow$scaled)
    
    #Spec 1. The function scales the coordinates based on the size of the image. 
    expect_true(nrow(coords(overlayImage6)) > 
                    nrow(coords(overlayImage8)))
    expect_true(max(coords(overlayImage6)$xcoor) > 
                    max(coords(overlayImage8)$xcoor))
    expect_true(max(coords(overlayImage6)$ycoor) > 
                    max(coords(overlayImage8)$ycoor))
    
    #Spec 2. The coordinates are all smaller than the image size.
    expect_true(all(coords(overlayImage6)$xcoor < 1024))
    expect_true(all(coords(overlayImage6)$ycoor < 1024))
    
    expect_true(all(coords(overlayImage8)$xcoor < 256))
    expect_true(all(coords(overlayImage8)$ycoor < 256))
    
    #Spec 3. There are no duplicated coordinates. 
    expect_false(any(duplicated(coords(overlayImage6))))
    expect_false(any(duplicated(coords(overlayImage8))))
})

testthat::test_that("scaleCoords errors",{
    #Spec 4. Coordinates can't be rescaled.
    expect_error(scaleCoords(overlayImage6))
    #Spec 5. An image must be in object to scale coordinates.
    expect_warning(scaleCoords(overlay))
})

overlayImage4Chan6 <- add4ChannelImage(overlay, tiff, res = 6)
overlayImage4Chan8 <- add4ChannelImage(overlay, tiff, res = 8)

testthat::test_that("4 channel image is added correctly",{
    #Spec 1. The function outputs a list in the image slot containing the 
    #           expected filePath, imagePointer, and resolution.
    expect_true(all(names(overlayImage4Chan6@image) == c("filePath", 
                                                         "imagePointer", 
                                                         "resolution")))
    expect_true(all(names(overlayImage4Chan8@image) == c("filePath", 
                                                         "imagePointer", 
                                                         "resolution")))
    
    expect_true(overlayImage4Chan6@image$filePath == tiff)
    expect_true(overlayImage4Chan8@image$filePath == tiff)
    
    expect_true(overlayImage4Chan6@image$resolution == 6)
    expect_true(overlayImage4Chan8@image$resolution == 8)
    
    #Spec 2. The imagePointer is an AnnotatedImage with the correct dimensions.  
    expect_true(class(showImage(overlayImage4Chan6)) == "AnnotatedImage")
    expect_true(class(showImage(overlayImage4Chan8)) == "AnnotatedImage")
    
    expect_true(all(dim(imageData(overlayImage4Chan6)) == c(1024,1024,4)))
    expect_true(all(dim(imageData(overlayImage4Chan8)) == c(256,256,4)))
})

testthat::test_that("Coordinates are scaled",{
    #Spec 3. The function scales the coordinates.
    expect_true(overlayImage4Chan6@workflow$scaled)
    expect_true(overlayImage4Chan8@workflow$scaled)
    
    expect_true(nrow(coords(overlayImage4Chan6)) > 
                    nrow(coords(overlayImage4Chan8)))
    expect_true(max(coords(overlayImage4Chan6)$xcoor) > 
                    max(coords(overlayImage4Chan8)$xcoor))
    expect_true(max(coords(overlayImage4Chan6)$ycoor) > 
                    max(coords(overlayImage4Chan8)$ycoor))
    
    expect_true(all(coords(overlayImage4Chan6)$xcoor < 1024))
    expect_true(all(coords(overlayImage4Chan6)$ycoor < 1024))
    
    expect_true(all(coords(overlayImage4Chan8)$xcoor < 256))
    expect_true(all(coords(overlayImage4Chan8)$ycoor < 256))
    
    expect_false(any(duplicated(coords(overlayImage4Chan6))))
    expect_false(any(duplicated(coords(overlayImage4Chan8))))
})

image <- imageExtraction(ometiff = tiff, res = 8, scanMeta = scanMeta(overlay), 
                         saveFile = TRUE, fileType = "png", color = TRUE)

pngFile <- gsub(".ome.tiff", ".png", tiff)

overlayImageFile <- addImageFile(overlay, imageFile = pngFile, res = 8)

testthat::test_that("Image from file works", {
    #Spec 1. The function outputs a list in the image slot containing the 
    #           expected filePath, imagePointer, and resolution. 
    expect_true(all(names(overlayImageFile@image) == c("filePath", 
                                                       "imagePointer", 
                                                       "resolution")))
    
    expect_true(overlayImageFile@image$filePath == pngFile)
    
    expect_true(overlayImageFile@image$resolution == 8)
    
    #Spec 2. The imagePointer is a magick-image with the correct dimensions. 
    expect_true(class(showImage(overlayImageFile)) == "magick-image")
    
    expect_true(image_info(showImage(overlayImageFile))$width == 256)
    expect_true(image_info(showImage(overlayImageFile))$height == 256)
    
    #Spec 4. The function produces reproducible results
    vdiffr::expect_doppelganger("add image file", showImage(overlayImageFile)) 
})

testthat::test_that("Coordinates are scaled",{
    #Spec 3. The function scales the coordinates.
    expect_true(overlayImageFile@workflow$scaled)
    
    expect_true(all(coords(overlayImageFile)$xcoor < 256))
    expect_true(all(coords(overlayImageFile)$ycoor < 256))
    
    expect_false(any(duplicated(coords(overlayImageFile))))
})
