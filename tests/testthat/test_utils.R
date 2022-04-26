
testthat::test_that("bookendStr prints correctly",{
    #Spec 1. The function returns a string in the expected format. 
    start_string <- stringi::stri_rand_strings(n = 1, length = 25)
    reps <- 10
    string <- paste(rep(start_string, reps), collapse = "")
    for(i in 1:(nchar(start_string)-1)){
        tester <- bookendStr(string, bookend = i)
        tester <- stringr::str_split(tester, pattern = "\\(|\\.\\.\\.", 
                                     simplify = T)
        expect_identical(tester[,1], paste0(substr(start_string, 1, i), " "))
        expect_identical(tester[,2], paste0(" ", substr(start_string, 
                                                        nchar(start_string)-(i-1), 
                                                        nchar(start_string)), " "))
        expect_identical(tester[,3], paste(nchar(start_string)*reps, 
                                           "total char)"))
    }
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

testthat::test_that("mouse brain tiff can be downloaded",{
    #Spec 1. The function downloads the mouse brain tiff and returns a valid 
    #           file path.
    tifFile <- downloadMouseBrainImage()
    
    expect_true(endsWith(tifFile, "mu_brain_004.ome.tiff"))
    expect_true(file.exists(tifFile))
})