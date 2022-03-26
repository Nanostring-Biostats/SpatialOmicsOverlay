
tifFile <- "testData/image_files/mu_brain_004.ome.tiff"

testthat::test_that("Error when xml path doesn't exist",{
    expect_error(xmlExtraction("fakeFilePath.ome.tiff"))
})

extracted <- xmlExtraction(ometiff = tifFile, saveFile = T)
xmlFile <- gsub(tifFile, pattern = "tiff", replacement = "xml")

testthat::test_that("returned list is correct",{
    expect_true(class(extracted) == "list")
    expect_true(file.exists(xmlFile))
    expect_true(length(xml) > 0)
    expect_true(all(names(xml) %in% c("Plate", "Screen", "Instrument", "Image", 
                                      "StructuredAnnotations", "ROI", ".attrs")))
    expect_true(length(which(names(xml) == "ROI")) > 1)
})

unlink(xmlFile)

extracted <- xmlExtraction(ometiff = tifFile, saveFile = F)

testthat::test_that("no file saved",{
    expect_false(file.exists(xmlFile))
})

fullSizeX <- 32768
fullSizeY <- 32768

scanMeta <- parseScanMetatdata(extracted)

testthat::test_that("correct image gets extracted", {
    expect_error(imageExtraction(ometiff = tifFile, res = 9))
    for(i in 5:8){
        image <- imageExtraction(ometiff = tifFile, res = i, scanMeta = scanMeta)
        expect_true(class(image) == "magick-image")
        expect_true(image_info(image)$width == fullSizeX/2^(i-1))
        expect_true(image_info(image)$height == fullSizeY/2^(i-1))
    }
})

testthat::test_that("saved images are as expected",{
    #tiff
    image <- imageExtraction(ometiff = tifFile, res = 8, scanMeta = scanMeta, 
                             saveFile = T, fileType = "tiff")
    imageFile <- gsub(".ome.tiff", ".tiff", tifFile)
    expect_true(file.exists(imageFile))
    unlink(imageFile)
    
    #png
    image <- imageExtraction(ometiff = tifFile, res = 8, scanMeta = scanMeta, 
                             saveFile = T, fileType = "png")
    imageFile <- gsub(".ome.tiff", ".png", tifFile)
    expect_true(file.exists(imageFile))
    unlink(imageFile)
    
    #jpg
    image <- imageExtraction(ometiff = tifFile, res = 8, scanMeta = scanMeta, 
                             saveFile = T, fileType = "jpg")
    imageFile <- gsub(".ome.tiff", ".jpeg", tifFile)
    expect_true(file.exists(imageFile))
    unlink(imageFile)
    
    #jpeg
    image <- imageExtraction(ometiff = tifFile, res = 8, scanMeta = scanMeta, 
                             saveFile = T, fileType = "jpeg")
    imageFile <- gsub(".ome.tiff", ".jpeg", tifFile)
    expect_true(file.exists(imageFile))
    unlink(imageFile)
    
    expect_error(imageExtraction(ometiff = tifFile, res = 8, scanMeta = scanMeta, 
                                 saveFile = T, fileType = "fakeFile"))
})
    