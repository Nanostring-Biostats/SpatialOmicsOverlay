overlay <- readRDS("testData/AllSpatialOverlay.RData")

annots <- "workflow_and_count_files/workflow/readout_package/19July2021_MsWTA_20210804T2230/19July2021_MsWTA_20210804T2230_LabWorksheet.txt"
annots <- readLabWorksheet(annots, "4")

samples <- sampNames(overlay)[-c(1:4)]
counts <- as.data.frame(matrix(ncol = length(samples), nrow = 10, data = runif(length(samples)*10, max = 50)))
colnames(counts) <- samples
rownames(counts) <- stringi::stri_rand_strings(n = 10, length = 5)

testthat::test_that("annotation dataframe can be added as plotting Factor",{
    expect_warning(overlay <- addPlottingFactor(overlay, as.data.frame(annots), c("segment", "area")))
    expect_true(names(plotFactors(overlay)) == "segment")
    expect_true(class(plotFactors(overlay)$segment) == "factor")
    expect_identical(as.character(plotFactors(overlay)$segment),
                     annots$segment[match(rownames(plotFactors(overlay)), 
                                          annots$Sample_ID, nomatch = 0)])
    
    geneName <- rownames(counts)[6]
    
    expect_warning(overlay <- addPlottingFactor(overlay, as.data.frame(counts), geneName))
    expect_true(all(names(plotFactors(overlay)) == c("segment", geneName)))
    expect_true(class(plotFactors(overlay)[[geneName]]) == "numeric")
    expect_identical(plotFactors(overlay)[[geneName]],
                     as.numeric(counts[geneName, match(rownames(plotFactors(overlay)), 
                                            colnames(counts), nomatch = 0)]))
})

testthat::test_that("annotation matrix can be added as plotting Factor",{
    expect_warning(overlay <- addPlottingFactor(overlay, as.matrix(annots), c("segment", "area")))
    expect_true(names(plotFactors(overlay)) == "segment")
    expect_true(class(plotFactors(overlay)$segment) == "factor")
    expect_identical(as.character(plotFactors(overlay)$segment),
                     annots$segment[match(rownames(plotFactors(overlay)), 
                                          annots$Sample_ID, nomatch = 0)])
    
    geneName <- rownames(counts)[6]
    
    expect_warning(overlay <- addPlottingFactor(overlay, as.matrix(counts), geneName))
    expect_true(all(names(plotFactors(overlay)) == c("segment", geneName)))
    expect_true(class(plotFactors(overlay)[[geneName]]) == "numeric")
    expect_identical(plotFactors(overlay)[[geneName]],
                     as.numeric(counts[geneName, match(rownames(plotFactors(overlay)), 
                                                       colnames(counts), nomatch = 0)]))
})

testthat::test_that("annotation vectors can be added as plotting Factor",{
    expect_error(suppressWarnings(addPlottingFactor(overlay, annots$segment[1:4], "test")))
    
    #Character vector
    expect_warning(overlay <- addPlottingFactor(overlay, 
                                                as.character(annots$segment), 
                                                "segmentNonNamed"))
    annot <- as.character(annots$segment)
    names(annot) <- annots$Sample_ID
    expect_warning(overlay <- addPlottingFactor(overlay, annot, "segmentNamed"), NA)
    
    expect_true(class(plotFactors(overlay)$segmentNonNamed) == "factor")
    expect_true(class(plotFactors(overlay)$segmentNamed) == "factor")
    expect_false(all(plotFactors(overlay)$segmentNonNamed == plotFactors(overlay)$segmentNamed))
    expect_identical(as.character(plotFactors(overlay)$segmentNamed),
                     annots$segment[match(rownames(plotFactors(overlay)), 
                                          annots$Sample_ID, nomatch = 0)])
    
    #Factor vector
    expect_warning(overlay <- addPlottingFactor(overlay, 
                                                as.factor(annots$segment), 
                                                "segmentNonNamedFactor"))
    annot <- as.factor(annots$segment)
    names(annot) <- annots$Sample_ID
    expect_warning(overlay <- addPlottingFactor(overlay, annot, "segmentNamedFactor"), NA)
    
    expect_true(class(plotFactors(overlay)$segmentNonNamedFactor) == "factor")
    expect_true(class(plotFactors(overlay)$segmentNamedFactor) == "factor")
    expect_false(all(plotFactors(overlay)$segmentNonNamedFactor == plotFactors(overlay)$segmentNamedFactor))
    expect_true(all(plotFactors(overlay)$segmentNonNamed == plotFactors(overlay)$segmentNonNamedFactor))
    expect_true(all(plotFactors(overlay)$segmentNamed == plotFactors(overlay)$segmentNamedFactor))
    expect_identical(as.character(plotFactors(overlay)$segmentNamedFactor),
                     annots$segment[match(rownames(plotFactors(overlay)), 
                                          annots$Sample_ID, nomatch = 0)])
    
    #Numeric vector
    expect_warning(overlay <- addPlottingFactor(overlay, 
                                                as.numeric(annots$area), 
                                                "areaNonNamed"))
    annot <-  as.numeric(annots$area)
    names(annot) <- annots$Sample_ID
    expect_warning(overlay <- addPlottingFactor(overlay, annot, "areaNamed"), NA)
    
    expect_true(class(plotFactors(overlay)$areaNonNamed) == "numeric")
    expect_true(class(plotFactors(overlay)$areaNamed) == "numeric")
    
    expect_false(all(plotFactors(overlay)$areaNonNamed == plotFactors(overlay)$areaNamed))
    expect_identical(plotFactors(overlay)$areaNamed,
                     annots$area[match(rownames(plotFactors(overlay)), 
                                       annots$Sample_ID, nomatch = 0)])
})

library(GeomxTools)

GxT <- readRDS("testData/muBrain_GxT.RDS")

testthat::test_that("annotation GeoMxSet object can be added as plotting Factor",{
    overlay <- addPlottingFactor(overlay, GxT, "segment")
    
    expect_true(class(plotFactors(overlay)$segment) == "factor")
    expect_identical(as.character(plotFactors(overlay)$segment),
                     sData(GxT)$segment[match(rownames(plotFactors(overlay)), 
                                              sData(GxT)$SampleID, nomatch = 0)])
    
    overlay <- addPlottingFactor(overlay, GxT, "Abr")
    
    expect_true(class(plotFactors(overlay)$Abr) == "numeric")
    expect_true(all(plotFactors(overlay)$Abr ==
                     exprs(GxT)["Abr", match(rownames(plotFactors(overlay)), 
                                             sData(GxT)$SampleID, nomatch = 0)]))
})
