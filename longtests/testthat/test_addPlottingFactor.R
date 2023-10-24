if(!file.exists("muBrain.RDS")){
  tifFile <- downloadMouseBrainImage()
  annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                        package = "SpatialOmicsOverlay")
  
  overlay <- suppressWarnings(readSpatialOverlay(ometiff = tifFile, annots = annots, 
                                                 slideName = "D5761 (3)", outline = FALSE))
  
  saveRDS(overlay, "muBrain.RDS")
}else{
  overlay <- readRDS( "muBrain.RDS")
}

annots <- system.file("extdata", "muBrain_LabWorksheet.txt", 
                      package = "SpatialOmicsOverlay")
annots <- readLabWorksheet(annots, "D5761 (3)")

samples <- sampNames(overlay)[-c(1:4)]
counts <- as.data.frame(matrix(ncol = length(samples), nrow = 10, 
                               data = runif(length(samples)*10, max = 50)))
colnames(counts) <- samples
rownames(counts) <- stringi::stri_rand_strings(n = 10, length = 5)

testthat::test_that("annotation dataframe can be added as plotting Factor",{
    #Spec 1. The function only works on one factor at a time regardless of input 
    #           type. 
    #Spec 3. The function works with a data.frame input, column name 
    #           plotting factor.
    expect_warning(overlay <- addPlottingFactor(overlay, as.data.frame(annots), 
                                                c("segment", "area")),
                   regexp = "Plotting factors must be added 1 at a time")
    expect_true(names(plotFactors(overlay)) == "segment")
    expect_true(class(plotFactors(overlay)$segment) == "factor")
    expect_identical(as.character(plotFactors(overlay)$segment),
                     annots$segment[match(rownames(plotFactors(overlay)), 
                                          annots$Sample_ID, nomatch = 0)])
    
    geneName <- rownames(counts)[6]
    
    #Spec 2. The function gives warning for annotation missing for samples 
    #           in object regardless of input type. 
    #Spec 4. The function works with a data.frame input, row name plotting 
    #           factor. 
    expect_warning(overlay <- addPlottingFactor(overlay, as.data.frame(counts), 
                                                geneName),
                   regexp = "Missing annotations in annots")
    expect_true(all(names(plotFactors(overlay)) == c("segment", geneName)))
    expect_true(class(plotFactors(overlay)[[geneName]]) == "numeric")
    expect_identical(plotFactors(overlay)[[geneName]],
                     as.numeric(counts[geneName, match(rownames(plotFactors(overlay)), 
                                            colnames(counts), nomatch = 0)]))
    
    #Spec 14. The function can handle NULL inputs. 
    expect_error(addPlottingFactor(overlay, as.data.frame(counts), 
                                   NULL),
                 regexp = "Please provide valid plottingFactor")
})

testthat::test_that("annotation matrix can be added as plotting Factor",{
    #Spec 1. The function only works on one factor at a time regardless of input 
    #           type. 
    #Spec 5. The function works with a matrix input, column name plotting factor.
    expect_warning(overlay <- addPlottingFactor(overlay, as.matrix(annots),
                                                c("segment", "area")),
                   regexp = "Plotting factors must be added 1 at a time")
    expect_true(names(plotFactors(overlay)) == "segment")
    expect_true(class(plotFactors(overlay)$segment) == "factor")
    expect_identical(as.character(plotFactors(overlay)$segment),
                     annots$segment[match(rownames(plotFactors(overlay)), 
                                          annots$Sample_ID, nomatch = 0)])
    
    geneName <- rownames(counts)[6]
    
    #Spec 2. The function gives warning for annotation missing for samples 
    #           in object regardless of input type.
    #Spec 6. The function works with a matrix input, row name plotting factor.  
    expect_warning(overlay <- addPlottingFactor(overlay, as.matrix(counts), 
                                                geneName),
                   regexp = "Missing annotations in annots")
    expect_true(all(names(plotFactors(overlay)) == c("segment", geneName)))
    expect_true(class(plotFactors(overlay)[[geneName]]) == "numeric")
    expect_identical(plotFactors(overlay)[[geneName]],
                     as.numeric(counts[geneName, match(rownames(plotFactors(overlay)), 
                                                       colnames(counts), 
                                                       nomatch = 0)]))
    
    #Spec 14. The function can handle NULL inputs. 
    expect_error(addPlottingFactor(overlay, as.matrix(counts), 
                                   NULL),
                 regexp = "Please provide valid plottingFactor")
})

testthat::test_that("annotation vectors can be added as plotting Factor",{
    #Spec 7. If vectors aren't named they must be the same length as number of 
    #           samples in object.
    expect_error(suppressWarnings(addPlottingFactor(overlay, 
                                                    annots$segment[1:4],
                                                    "test")),
                 regexp = "Length of annots does not match samples in overlay")
    
    #Spec 8. The function only matches vectors if they are named, otherwise 
    #           assumed in correct order.
    #Spec 9. The function works with character vectors.
    expect_warning(overlay <- addPlottingFactor(overlay, 
                                                as.character(annots$segment), 
                                                "segmentNonNamed"),
                   regexp = "No names on vector")
    annot <- as.character(annots$segment)
    names(annot) <- annots$Sample_ID
    expect_warning(overlay <- addPlottingFactor(overlay, annot, "segmentNamed"), 
                   NA)
    
    expect_true(class(plotFactors(overlay)$segmentNonNamed) == "factor")
    expect_true(class(plotFactors(overlay)$segmentNamed) == "factor")
    expect_false(all(plotFactors(overlay)$segmentNonNamed == plotFactors(overlay)$segmentNamed))
    expect_identical(as.character(plotFactors(overlay)$segmentNamed),
                     annots$segment[match(rownames(plotFactors(overlay)), 
                                          annots$Sample_ID, nomatch = 0)])
    
    #Spec 14. The function can handle NULL inputs. 
    expect_error(addPlottingFactor(overlay, 
                                   as.character(annots$segment), 
                                   NULL),
                 regexp = "Please provide valid plottingFactor")
    
    #Spec 8. The function only matches vectors if they are named, otherwise 
    #           assumed in correct order.
    #Spec 10. The function works with factor vectors.
    expect_warning(overlay <- addPlottingFactor(overlay, 
                                                as.factor(annots$segment), 
                                                "segmentNonNamedFactor"),
                   regexp = "No names on vector")
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
    
    #Spec 14. The function can handle NULL inputs. 
    expect_error(addPlottingFactor(overlay, 
                                   as.factor(annots$segment), 
                                   NULL),
                 regexp = "Please provide valid plottingFactor")
    
    #Spec 8. The function only matches vectors if they are named, otherwise 
    #           assumed in correct order.
    #Spec 11. The function works with numeric vectors.
    expect_warning(overlay <- addPlottingFactor(overlay, 
                                                as.numeric(annots$area), 
                                                "areaNonNamed"),
                   regexp = "No names on vector")
    annot <-  as.numeric(annots$area)
    names(annot) <- annots$Sample_ID
    expect_warning(overlay <- addPlottingFactor(overlay, annot, "areaNamed"), NA)
    
    expect_true(class(plotFactors(overlay)$areaNonNamed) == "numeric")
    expect_true(class(plotFactors(overlay)$areaNamed) == "numeric")
    
    expect_false(all(plotFactors(overlay)$areaNonNamed == plotFactors(overlay)$areaNamed))
    expect_identical(plotFactors(overlay)$areaNamed,
                     annots$area[match(rownames(plotFactors(overlay)), 
                                       annots$Sample_ID, nomatch = 0)])
    
    #Spec 14. The function can handle NULL inputs. 
    expect_error(addPlottingFactor(overlay, 
                                   as.numeric(annots$area), 
                                   NULL),
                 regexp = "Please provide valid plottingFactor")
})

library(GeomxTools)

GxT <- readRDS(unzip(system.file("extdata", "muBrain_GxT.zip", 
                           package = "SpatialOmicsOverlay")))

testthat::test_that("annotation GeoMxSet object can be added as plotting Factor",{
    #Spec 12. The function works with a NanostringGeomxSet input, column name 
    #           plotting factor. 
    overlay <- addPlottingFactor(overlay, GxT, "Group")
    
    expect_true(class(plotFactors(overlay)$Group) == "factor")
    expect_identical(as.character(plotFactors(overlay)$Group),
                     sData(GxT)$Group[match(rownames(plotFactors(overlay)), 
                                              sData(GxT)$SampleID, nomatch = 0)])
    
    #Spec 13. The function works with a NanostringGeomxSet input, row name 
    #           plotting factor.
    overlay <- addPlottingFactor(overlay, GxT, "Cryab")
    
    expect_true(class(plotFactors(overlay)$Cryab) == "numeric")
    expect_true(all(plotFactors(overlay)$Cryab ==
                     exprs(GxT)["Cryab", match(rownames(plotFactors(overlay)), 
                                             sData(GxT)$SampleID, nomatch = 0)]))
    
    #Spec 14. The function can handle NULL inputs. 
    expect_error(addPlottingFactor(overlay, GxT, NULL),
                 regexp = "Please provide valid plottingFactor")
})
