
#' Add plotting factor to \code{\link{SpatialOverlay}} object
#' 
#' @param object \code{\link{SpatialOverlay}} object
#' @param annots object with annotation: can be \code{NanoStringGeoMxSet}, 
#'                  \code{data.frame}, \code{matrix}, or vector containing 
#'                  \code{character}, \code{factor}, or \code{numeric}
#' @param plottingFactor  column or row from annots to add as plotting factor, 
#'                        if using vector this will be the name of the new plotting factor
#' @param ... if using \code{NanoStringGeoMxSet}, name of count matrix to pull counts from
#' 
#' @return \code{\link{SpatialOverlay}} object with new plotting factor
#' 
#' @examples
#' 
#' @export 
#' 


setGeneric("addPlottingFactor", signature = "annots",
           function(object, annots, plottingFactor, ...) standardGeneric("addPlottingFactor"))


setMethod("addPlottingFactor",  "NanoStringGeoMxSet",
          function(object, annots, plottingFactor, countMatrix = "exprs"){
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
              
              samples <- sampNames(object)
              
              sampIDs <- which(apply(as.matrix(sData(annots)), 2, function(x){any(samples %in% x)}))
              
              if(length(sampIDs) == 0){
                  stop("Sample IDs in SpatialOverlay do not match given annots")
              }
              
              gxtSamples <- sData(annots)[[sampIDs]]
              
              annots <- annots[,match(samples, gxtSamples, nomatch = 0)]
              samples <- samples[match(gxtSamples, samples, nomatch = 0)]

              
              if(length(samples) != length(sampNames(object))){
                  warning(paste("Missing annotations in annots. Samples missing:", 
                                paste(sampNames(object)[!sampNames(object) %in% samples], 
                                      collapse = ", ")))
                  object <- removeSample(object = object, 
                                         remove = sampNames(object)[which(!sampNames(object) %in% samples)])
              }
              
              if(plottingFactor %in% colnames(plotFactors(object))){
                  if(axis == "col"){
                      plotFactors(object)[[plottingFactor]] <- sData(annots)[[plottingFactor]]
                  }else{
                      plotFactors(object)[[plottingFactor]] <- assayDataElement(annots, 
                                                                                elt = countMatrix)[rownames(annots) == 
                                                                                                       plottingFactor,]
                  }
              }else{
                  if(axis == "col"){
                      plotFactors(object) <- as.data.frame(cbind(plotFactors(object), sData(annots)[[plottingFactor]]))
                  }else{
                      plotFactors(object) <- as.data.frame(cbind(plotFactors(object), 
                                                                 assayDataElement(annots, 
                                                                                  elt = countMatrix)[rownames(annots) == 
                                                                                                         plottingFactor,]))
                  }
                  
                  rownames(plotFactors(object)) <- samples
                  colnames(plotFactors(object))[ncol(plotFactors(object))] <- plottingFactor
              }
              
              if(class(plotFactors(object)[,ncol(plotFactors(object))]) == "character"){
                  plotFactors(object)[,ncol(plotFactors(object))] <- as.factor(plotFactors(object)[,ncol(plotFactors(object))])
              }
              
              return(object)
          })
          
setMethod("addPlottingFactor",  "matrix",
          function(object, annots, plottingFactor){
              return(addPlottingFactor(annots = as.data.frame(annots), 
                                       object = object, 
                                       plottingFactor = plottingFactor))
          })    

setMethod("addPlottingFactor",  "data.frame",
          function(object, annots, plottingFactor){
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
              
              samples <- sampNames(object)
              
              if(axis == "col"){
                  sampIDs <- which(apply(annots, 2, function(x){any(samples %in% x)}))
                  
                  if(length(sampIDs) == 0){
                      stop("Sample IDs in SpatialOverlay do not match given annots")
                  }
                  
                  annots <- annots[match(samples, annots[,sampIDs], nomatch = 0),]
                  samples <- samples[match(annots[,sampIDs], samples, nomatch = 0)]
              }else{
                  annots <- annots[,match(samples, colnames(annots), nomatch = 0)]
                  samples <- samples[match(colnames(annots), samples, nomatch = 0)]
              }
              
              if(length(samples) != length(sampNames(object))){
                  warning(paste("Missing annotations in annots. Samples missing:", 
                                paste(sampNames(object)[!sampNames(object) %in% samples], 
                                      collapse = ", ")))
                  object <- removeSample(object = object, 
                                         remove = sampNames(object)[which(!sampNames(object) %in% samples)])
              }
              
              if(plottingFactor %in% colnames(plotFactors(object))){
                  if(axis == "col"){
                      plotFactors(object)[[plottingFactor]] <- annots[[plottingFactor]]
                  }else{
                      plotFactors(object)[[plottingFactor]] <- t(annots[rownames(annots) == plottingFactor,])
                  }
              }else{
                  if(axis == "col"){
                      plotFactors(object) <- as.data.frame(cbind(plotFactors(object), annots[[plottingFactor]]))
                  }else{
                      plotFactors(object) <- as.data.frame(cbind(plotFactors(object), t(annots[rownames(annots) == plottingFactor,])))
                  }
                  rownames(plotFactors(object)) <- samples
                  colnames(plotFactors(object))[ncol(plotFactors(object))] <- plottingFactor
              }
              
              if(class(plotFactors(object)[,ncol(plotFactors(object))]) == "character"){
                  plotFactors(object)[,ncol(plotFactors(object))] <- as.factor(plotFactors(object)[,ncol(plotFactors(object))])
              }
              
              return(object)
          }) 

setMethod("addPlottingFactor",  "character",
          function(object, annots, plottingFactor){
              if(is.null(names(annots))){
                  warning("No names on vector, assuming data is in same order as object", 
                          immediate. = TRUE)
              }
              
              samples <- names(annots)
              
              if(length(annots) < length(sampNames(object))){
                  if(is.null(names(annots))){
                      stop("Length of annots does not match samples in object & there are no names to match to")
                  }
                  
                  warning(paste("Missing annotations in annots. Samples missing:", 
                                paste(sampNames(object)[!sampNames(object) %in% samples], 
                                      collapse = ", ")))
                  object <- removeSample(object = object, 
                                         remove = sampNames(object)[which(!sampNames(object) %in% samples)])
              }
              
              samples <- sampNames(object)
              
              if(plottingFactor %in% colnames(plotFactors(object))){
                  if(is.null(names(annots))){
                      annots <- annots[1:length(samples)]
                  }else{
                      annots <- annots[match(samples, names(annots), nomatch = 0)]
                      samples <- samples[match(names(annots), samples, nomatch = 0)]
                  }
                  plotFactors(object)[[plottingFactor]] <- annots
              }else{
                  if(!is.null(samples)){
                      if(is.null(names(annots))){
                          annots <- annots[1:length(samples)]
                      }else{
                          annots <- annots[match(samples, names(annots), nomatch = 0)]
                          samples <- samples[match(names(annots), samples, nomatch = 0)]
                      }
                      plotFactors(object) <- as.data.frame(cbind(plotFactors(object), annots))
                  }else{
                      plotFactors(object) <- as.data.frame(cbind(plotFactors(object), t(annots)))
                  }
                  
                  rownames(plotFactors(object)) <- samples
                  colnames(plotFactors(object))[ncol(plotFactors(object))] <- plottingFactor
              }
              
              if(class(plotFactors(object)[,ncol(plotFactors(object))]) == "character"){
                  plotFactors(object)[,ncol(plotFactors(object))] <- as.factor(plotFactors(object)[,ncol(plotFactors(object))])
              }
              
              return(object)
          }) 

setMethod("addPlottingFactor",  "numeric",
          function(object, annots, plottingFactor){
             object <- addPlottingFactor(object, 
                                         setNames(as.character(annots), 
                                                  names(annots)), 
                                         plottingFactor)
              
             plotFactors(object)[,ncol(plotFactors(object))] <- as.numeric(as.character(plotFactors(object)[,ncol(plotFactors(object))]))
 
             return(object)
          }) 

setMethod("addPlottingFactor",  "factor",
          function(object, annots, plottingFactor){
              addPlottingFactor(object, 
                                setNames(as.character(annots), 
                                         names(annots)), 
                                plottingFactor)
          }) 
