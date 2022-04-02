
#' Add plotting factor to \code{\link{SpatialOverlay}} object
#' 
#' @param overlay \code{\link{SpatialOverlay}} object
#' @param annots object with annotation: can be \code{NanoStringGeoMxSet}, 
#'                  \code{data.frame}, \code{matrix}, or vector containing 
#'                  \code{character}, \code{factor}, or \code{numeric}
#' @param plottingFactor  column or row from annots to add as plotting factor, 
#'                        if using vector this will be the name of the new 
#'                        plotting factor
#' @param ... if using \code{NanoStringGeoMxSet}, name of count matrix to pull 
#'               counts from
#' 
#' @return \code{\link{SpatialOverlay}} object with new plotting factor
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrain_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#'
#' muBrainLW <- system.file("extdata", "muBrain_LabWorksheet.txt", 
#'                          package = "SpatialOmicsOverlay")
#'
#' muBrainLW <- readLabWorksheet(muBrainLW, slideName = "4")
#'
#' muBrain <- addPlottingFactor(overlay = muBrain, 
#'                              annots = muBrainLW, 
#'                              plottingFactor = "segment")
#'
#' library(GeomxTools)
#' muBrainGxT <- readRDS(system.file("extdata", "muBrain_GxT.RDS", 
#'                                   package = "SpatialOmicsOverlay"))
#'
#' muBrain <- addPlottingFactor(overlay = muBrain, 
#'                              annots = muBrainGxT, 
#'                              plottingFactor = "Calm1",
#'                              countMatrix = "exprs")
#'
#' muBrain <- addPlottingFactor(overlay = muBrain,
#'                              annots = seq_len(length(sampNames(muBrain))),
#'                              plottingFactor = "ROINum")
#' 
#' head(plotFactors(muBrain))
#' 
#' @export 
#' 
setGeneric("addPlottingFactor", signature = "annots",
           function(overlay, annots, plottingFactor, ...) 
               standardGeneric("addPlottingFactor"))

#' Add plotting factor to \code{\link{SpatialOverlay}} object
#' 
#' @param overlay \code{\link{SpatialOverlay}} object
#' @param annots \code{NanoStringGeoMxSet} object
#' @param plottingFactor  column or row from annots to add as plotting factor
#' @param countMatrix name of count matrix to pull counts from
#' 
#' @return \code{\link{SpatialOverlay}} object with new plotting factor
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrain_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#'
#' muBrainGxT <- readRDS(system.file("extdata", "muBrain_GxT.RDS", 
#'                                   package = "SpatialOmicsOverlay"))
#'
#' muBrain <- addPlottingFactor(overlay = muBrain, 
#'                              annots = muBrainGxT, 
#'                              plottingFactor = "Calm1",
#'                              countMatrix = "exprs")
#' 
#' head(plotFactors(muBrain))
#' 
#' @export 
#' 

setMethod("addPlottingFactor",  "NanoStringGeoMxSet",
    function(overlay, annots, plottingFactor, countMatrix = "exprs"){
        if(length(plottingFactor) > 1){
          warning("Plotting factors must be added 1 at a time, continuing with only the first factor")
          plottingFactor <- plottingFactor[1]
        }
        if(!plottingFactor %in% colnames(sData(annots)) & 
         !plottingFactor %in% rownames(annots)){
          stop("plottingFactor was not in given annots")
        }
        
        if(plottingFactor %in% colnames(sData(annots))){
          axis <- "col"
        }else{
          axis <- "row"
        }
        
        samples <- sampNames(overlay)
        
        gxtSamples <- gsub(".dcc", "", rownames(sData(annots)))
        
        if(any(!samples %in% gxtSamples)){
          sampIDs <- which(apply(as.matrix(sData(annots)), 2, 
                                 function(x){any(samples %in% x)}))
          
          if(length(sampIDs) == 0){
              stop("Sample IDs in SpatialOverlay do not match given annots")
          }
          
          gxtSamples <- sData(annots)[[sampIDs]]
        }
        
        annots <- annots[,match(samples, gxtSamples, nomatch = 0)]
        samples <- samples[match(gxtSamples, samples, nomatch = 0)]
        
        
        if(length(samples) != length(sampNames(overlay))){
          warning(paste("Missing annotations in annots. Samples missing:", 
                        paste(sampNames(overlay)[!sampNames(overlay) %in% 
                                                     samples], 
                              collapse = ", ")))
          overlay <- removeSample(overlay = overlay, 
                                  remove = sampNames(overlay)[which(!sampNames(overlay) %in% 
                                                                        samples)])
        }
        
        if(plottingFactor %in% colnames(plotFactors(overlay))){
          if(axis == "col"){
              plotFactors(overlay)[[plottingFactor]] <- sData(annots)[[plottingFactor]]
          }else{
              plotFactors(overlay)[[plottingFactor]] <- Biobase::assayDataElement(annots, 
                                                                                  elt = countMatrix)[rownames(annots) == 
                                                                                                         plottingFactor,]
          }
        }else{
          if(axis == "col"){
              plotFactors(overlay) <- as.data.frame(cbind(plotFactors(overlay), 
                                                          sData(annots)[[plottingFactor]]))
          }else{
              plotFactors(overlay) <- as.data.frame(cbind(plotFactors(overlay), 
                                                          Biobase::assayDataElement(annots, 
                                                                                    elt = countMatrix)[rownames(annots) == 
                                                                                                           plottingFactor,]))
          }
          
          rownames(plotFactors(overlay)) <- samples
          colnames(plotFactors(overlay))[ncol(plotFactors(overlay))] <- plottingFactor
        }
        
        if(is(plotFactors(overlay)[,ncol(plotFactors(overlay))], "character")){
          plotFactors(overlay)[,ncol(plotFactors(overlay))] <- as.factor(plotFactors(overlay)[,ncol(plotFactors(overlay))])
        }
        
        return(overlay)
    })
              
              
#' Add plotting factor to \code{\link{SpatialOverlay}} object
#' 
#' @param overlay \code{\link{SpatialOverlay}} object
#' @param annots \code{matrix} containing plottingFactor, column or column names 
#'                must contian matching sample names to overlay
#' @param plottingFactor  column or row name from annots to add as plotting 
#'                            factor
#' 
#' @return \code{\link{SpatialOverlay}} object with new plotting factor
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrain_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#'
#' muBrainLW <- system.file("extdata", "muBrain_LabWorksheet.txt", 
#'                          package = "SpatialOmicsOverlay")
#'
#' muBrainLW <- readLabWorksheet(muBrainLW, slideName = "4")
#'
#' muBrain <- addPlottingFactor(overlay = muBrain, 
#'                              annots = as.matrix(muBrainLW), 
#'                              plottingFactor = "segment")
#'
#' 
#' @export 
#' 
#' 
setMethod("addPlottingFactor",  "matrix",
    function(overlay, annots, plottingFactor){
        return(addPlottingFactor(annots = as.data.frame(annots), 
                                 overlay = overlay, 
                                 plottingFactor = plottingFactor))
    })    

#' Add plotting factor to \code{\link{SpatialOverlay}} object
#' 
#' @param overlay \code{\link{SpatialOverlay}} object
#' @param annots \code{data.frame} containing plottingFactor, column or column 
#'                     names must contian matching sample names to overlay
#' @param plottingFactor  column or row name from annots to add as plotting 
#'                           factor
#' 
#' @return \code{\link{SpatialOverlay}} object with new plotting factor
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrain_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#'
#' muBrainLW <- system.file("extdata", "muBrain_LabWorksheet.txt", 
#'                          package = "SpatialOmicsOverlay")
#'
#' muBrainLW <- readLabWorksheet(muBrainLW, slideName = "4")
#'
#' muBrain <- addPlottingFactor(overlay = muBrain, 
#'                              annots = muBrainLW, 
#'                              plottingFactor = "segment")
#'
#' 
#' @export 
#' 
#' 
setMethod("addPlottingFactor",  "data.frame",
    function(overlay, annots, plottingFactor){
        if(length(plottingFactor) > 1){
            warning("Plotting factors must be added 1 at a time, continuing with only the first factor")
            plottingFactor <- plottingFactor[1]
        }
        if(!plottingFactor %in% colnames(annots) & 
           !plottingFactor %in% rownames(annots)){
            stop("plottingFactor was not in given annots")
        }
        
        if(plottingFactor %in% colnames(annots)){
            axis <- "col"
        }else{
            axis <- "row"
        }
        
        samples <- sampNames(overlay)
        
        if(axis == "col"){
            sampIDs <- which(apply(annots, 2, function(x){any(samples %in% 
                                                                  x)}))
            
            if(length(sampIDs) == 0){
                stop("Sample IDs in SpatialOverlay do not match given annots")
            }
            
            annots <- annots[match(samples, annots[,sampIDs], 
                                   nomatch = 0),]
            samples <- samples[match(annots[,sampIDs], samples, 
                                     nomatch = 0)]
        }else{
            annots <- annots[,match(samples, colnames(annots), 
                                    nomatch = 0)]
            samples <- samples[match(colnames(annots), samples, 
                                     nomatch = 0)]
        }
        
        if(length(samples) != length(sampNames(overlay))){
            warning(paste("Missing annotations in annots. Samples missing:", 
                          paste(sampNames(overlay)[!sampNames(overlay) %in% 
                                                       samples], 
                                collapse = ", ")))
            overlay <- removeSample(overlay = overlay, 
                                    remove = sampNames(overlay)[which(!sampNames(overlay) %in% 
                                                                          samples)])
        }
        
        if(plottingFactor %in% colnames(plotFactors(overlay))){
            if(axis == "col"){
                plotFactors(overlay)[[plottingFactor]] <- annots[[plottingFactor]]
            }else{
                plotFactors(overlay)[[plottingFactor]] <- t(annots[rownames(annots) == 
                                                                       plottingFactor,])
            }
        }else{
            if(axis == "col"){
                plotFactors(overlay) <- as.data.frame(cbind(plotFactors(overlay), 
                                                            annots[[plottingFactor]]))
            }else{
                plotFactors(overlay) <- as.data.frame(cbind(plotFactors(overlay), 
                                                            t(annots[rownames(annots) == 
                                                                         plottingFactor,])))
            }
            rownames(plotFactors(overlay)) <- samples
            colnames(plotFactors(overlay))[ncol(plotFactors(overlay))] <- plottingFactor
        }
        
        if(is(plotFactors(overlay)[,ncol(plotFactors(overlay))],"character")){
            plotFactors(overlay)[,ncol(plotFactors(overlay))] <- as.factor(plotFactors(overlay)[,ncol(plotFactors(overlay))])
        }
        
        return(overlay)
    }) 

#' Add plotting factor to \code{\link{SpatialOverlay}} object
#' 
#' @param overlay \code{\link{SpatialOverlay}} object
#' @param annots character vector with the plottingFactor. if names match sample 
#'               names in overlay vector will be matched on those, 
#'               otherwise assumed in the correct order
#' @param plottingFactor  name of the new plotting factor
#' 
#' @return \code{\link{SpatialOverlay}} object with new plotting factor
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrain_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#'
#' muBrain <- addPlottingFactor(overlay = muBrain,
#'                              annots = as.character(seq_len(length(sampNames(muBrain)))),
#'                              plottingFactor = "ROINum")
#' 
#' head(plotFactors(muBrain))
#' 
#' @export 
#' 
setMethod("addPlottingFactor",  "character",
    function(overlay, annots, plottingFactor){
        if(is.null(names(annots))){
          warning("No names on vector, assuming data is in same order as overlay", 
                  immediate. = TRUE)
        }
        
        samples <- names(annots)
        
        if(length(annots) < length(sampNames(overlay))){
          if(is.null(names(annots))){
              stop("Length of annots does not match samples in overlay & there are no names to match to")
          }
          
          warning(paste("Missing annotations in annots. Samples missing:", 
                        paste(sampNames(overlay)[!sampNames(overlay) %in% 
                                                     samples], 
                              collapse = ", ")))
          overlay <- removeSample(overlay = overlay, 
                                  remove = sampNames(overlay)[which(!sampNames(overlay) %in% 
                                                                        samples)])
        }
        
        samples <- sampNames(overlay)
        
        if(plottingFactor %in% colnames(plotFactors(overlay))){
          if(is.null(names(annots))){
              annots <- annots[seq_len(length(samples))]
          }else{
              annots <- annots[match(samples, names(annots), nomatch = 0)]
              samples <- samples[match(names(annots), samples, nomatch = 0)]
          }
          plotFactors(overlay)[[plottingFactor]] <- annots
        }else{
          if(!is.null(samples)){
              if(is.null(names(annots))){
                  annots <- annots[seq_len(length(samples))]
              }else{
                  annots <- annots[match(samples, names(annots), nomatch = 0)]
                  samples <- samples[match(names(annots), samples, nomatch = 0)]
              }
              plotFactors(overlay) <- as.data.frame(cbind(plotFactors(overlay), 
                                                          annots))
          }else{
              plotFactors(overlay) <- as.data.frame(cbind(plotFactors(overlay), 
                                                          t(annots)))
          }
          
          rownames(plotFactors(overlay)) <- samples
          colnames(plotFactors(overlay))[ncol(plotFactors(overlay))] <- plottingFactor
        }
        
        if(is(plotFactors(overlay)[,ncol(plotFactors(overlay))],"character")){
          plotFactors(overlay)[,ncol(plotFactors(overlay))] <- 
              as.factor(plotFactors(overlay)[,ncol(plotFactors(overlay))])
        }
        
        return(overlay)
    }) 

#' Add plotting factor to \code{\link{SpatialOverlay}} object
#' 
#' @param overlay \code{\link{SpatialOverlay}} object
#' @param annots numeric vector with the plottingFactor. if names match sample 
#'               names in overlay vector will be matched on those, 
#'               otherwise assumed in the correct order
#' @param plottingFactor  name of the new plotting factor
#' 
#' @return \code{\link{SpatialOverlay}} object with new plotting factor
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrain_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#'
#' muBrain <- addPlottingFactor(overlay = muBrain,
#'                              annots = seq_len(length(sampNames(muBrain))),
#'                              plottingFactor = "ROINum")
#' 
#' head(plotFactors(muBrain))
#' 
#' @export 
#' 
setMethod("addPlottingFactor",  "numeric",
    function(overlay, annots, plottingFactor){
        overlay <- addPlottingFactor(overlay, 
                                   setNames(as.character(annots), 
                                            names(annots)), 
                                   plottingFactor)
        
        plotFactors(overlay)[,ncol(plotFactors(overlay))] <- as.numeric(as.character(plotFactors(overlay)[,ncol(plotFactors(overlay))]))
        
        return(overlay)
    }) 

#' Add plotting factor to \code{\link{SpatialOverlay}} object
#' 
#' @param overlay \code{\link{SpatialOverlay}} object
#' @param annots factor vector with the plottingFactor. if names match sample 
#'               names in overlay vector will be matched on those, 
#'               otherwise assumed in the correct order
#' @param plottingFactor  name of the new plotting factor
#' 
#' @return \code{\link{SpatialOverlay}} object with new plotting factor
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrain_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#'
#' muBrain <- addPlottingFactor(overlay = muBrain,
#'                              annots = as.factor(seq_len(length(sampNames(muBrain)))),
#'                              plottingFactor = "ROINum")
#' 
#' head(plotFactors(muBrain))
#' 
#' @export 
#' 
setMethod("addPlottingFactor",  "factor",
    function(overlay, annots, plottingFactor){
        addPlottingFactor(overlay, 
                          setNames(as.character(annots),
                                   names(annots)), 
                          plottingFactor)
    }) 
