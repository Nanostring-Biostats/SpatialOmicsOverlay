#' Remove sample(s) from SpatialOverlay
#' 
#' @param overlay SpatialOverlay object
#' @param remove sampNames of overlay to remove
#' 
#' @return SpatialOverlay object without samples in remove
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' 
#' muBrainLW <- system.file("extdata", "muBrain_LabWorksheet.txt", 
#'                          package = "SpatialOmicsOverlay")
#' 
#' muBrainLW <- readLabWorksheet(muBrainLW, slideName = "4")
#' 
#' samps <- muBrainLW$Sample_ID[muBrainLW$segment != "Full ROI"]
#' 
#' muBrainSub <- removeSample(overlay = muBrain, remove = samps)
#' 
#' muBrain
#' muBrainSub
#' 
#' @export 
#' 

removeSample <- function(overlay, remove){
    w2kp <- which(!sampNames(overlay) %in% remove)
    
    if(length(w2kp) == length(sampNames(overlay))){
        warning("No valid sample names; returning original overlay")
        return(overlay)
    }else{
        AOIattrs <- SpatialPosition(spatialPos(overlay(overlay))[w2kp,])
        
        scan_metadata <- scanMeta(overlay)
        
        if(any(meta(AOIattrs)$Segmentation == "Segmented")){
            scan_metadata[["Segmentation"]] <- "Segmented"
        }else{
            scan_metadata[["Segmentation"]] <- "Geometric"
        }
        
        if(!is.null(coords(overlay))){
            newCoords <- coords(overlay)[!coords(overlay)$sampleID %in% remove,]
        }else{
            newCoords <- coords(overlay)
        }
        
        if(!is.null(plotFactors(overlay))){
            plotFacts <- as.data.frame(plotFactors(overlay)[w2kp,])
            colnames(plotFacts) <- colnames(plotFactors(overlay))
            rownames(plotFacts) <- rownames(plotFactors(overlay))[w2kp]
            
            for(i in seq_len(ncol(plotFacts))){
                if(is(plotFacts[,i],"character")){
                    plotFacts[,i] <- as.factor(plotFacts[,i])
                }
            }
        }else{
            plotFacts <- plotFactors(overlay)
        }
        
        return(SpatialOverlay(slideName = slideName(overlay),
                              scanMetadata = scan_metadata,
                              overlayData = AOIattrs,
                              coords = newCoords,
                              plottingFactors = plotFacts,
                              workflow = workflow(overlay),
                              image = imageInfo(overlay)))
    }
}
