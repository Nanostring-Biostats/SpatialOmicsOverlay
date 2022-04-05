
testthat::test_that("bookendStr prints correctly",{
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

testthat::test_that("read labworksheet works",{
    expect_error(readLabWorksheet("testData/test_LabWorksheet.txt", "fake_slide"))
    expect_error(readLabWorksheet("fake/file/path", "hu_brain_004b"))
    
    annots4b <- readLabWorksheet("testData/test_LabWorksheet.txt", "hu_brain_004b")
    annots4a <- readLabWorksheet("testData/test_LabWorksheet.txt", "hu_brain_004a")
    
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
    tifFile <- downloadMouseBrainImage()
    
    expect_true(endsWith(tifFile, "mu_brain_004.ome.tiff"))
    expect_true(grepl("/.cache/R/SpatialOmicsOverlay/", tifFile))
    expect_true(file.exists(tifFile))
})