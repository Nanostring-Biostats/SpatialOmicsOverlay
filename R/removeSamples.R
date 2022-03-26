#' Remove sample(s) from SpatialOverlay
#' 
#' @param object SpatialOverlay object
#' @param remove sampNames of overlay to remove
#' 
#' @return SpatialOverlay object without samples in remove
#' 
#' @examples
#' 
#' @export 
#' 

removeSample <- function(object, remove){
    w2kp <- which(!sampNames(object) %in% remove)
    
    if(length(w2kp) == length(sampNames(object))){
        warning("No valid sample names; returning original object")
            return(object)
    }else{
        AOIattrs <- SpatialPosition(overlay(object)@position[w2kp,])
        
        scan_metadata <- scanMeta(object)
        
        if(any(meta(AOIattrs)$Segmentation == "Segmented")){
            scan_metadata[["Segmentation"]] <- "Segmented"
        }else{
            scan_metadata[["Segmentation"]] <- "Geometric"
        }
        
        if(!is.null(coords(object))){
            newCoords <- coords(object)[!coords(object)$sampleID %in% remove,]
        }else{
            newCoords <- coords(object)
        }
        
        if(!is.null(plotFactors(object))){
            plotFacts <- as.data.frame(plotFactors(object)[w2kp,])
            colnames(plotFacts) <- colnames(plotFactors(object))
            rownames(plotFacts) <- rownames(plotFactors(object))[w2kp]
            
            for(i in 1:ncol(plotFacts)){
                if(class(plotFacts[,i]) == "character"){
                    plotFacts[,i] <- as.factor(plotFacts[,i])
                }
            }
        }else{
            plotFacts <- plotFactors(object)
        }
        
        return(SpatialOverlay(slideName = slideName(object),
                              scanMetadata = scan_metadata,
                              overlayData = AOIattrs,
                              coords = newCoords,
                              plottingFactors = plotFacts,
                              workflow = object@workflow,
                              image = object@image))
    }
    
    
}
