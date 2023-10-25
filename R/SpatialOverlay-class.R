setClassUnion("dfOrNULL", c("data.frame", "NULL"))

# Class definition
setClass("SpatialOverlay",
         slots = c(slideName = "character",
                   scanMetadata = "list",
                   overlayData = "SpatialPosition",
                   coords = "dfOrNULL",
                   plottingFactors = "dfOrNULL",
                   workflow = "list",
                   image = "list"),
         prototype = prototype(
             new("VersionedBiobase",
                 versions = c(SpatialOverlay = "1.0")),
             slideName = "slide",
             scanMetadata = list(),
             overlayData = SpatialPosition(),
             coords = NULL,
             plottingFactors = NULL,
             workflow = list(),
             image = list()))

# Show method
setMethod("show", signature = "SpatialOverlay",
          function(object) {
              cat(class(object), "\n")
              cat("Slide Name:", slideName(object), "\n")
              rows <- nrow(meta(overlay(object)))
              cat("Overlay Data:", rows, "samples", "\n")
              cat("   Overlay Names:", sampNames(object)[1], "...",
                  sampNames(object)[rows], "(", rows, "total )", "\n")
              cat("Scan Metadata", "\n")
              cat("   Panels:", paste(scanMeta(object)$Panels, sep = ", "), "\n")
              cat("   Segmentation:", scanMeta(object)$Segmentation, "\n")
              if(!is.null(plotFactors(object))){
                  cat("Plotting Factors:", "\n")
                  cat("   varLabels:", colnames(plotFactors(object)), "\n")
              }
              if(!is.null(coords(object))){
                  cat("Outline:", outline(object), "\n")
              }
              if(!is.null(object@image$filePath)){
                  cat("Image:", object@image$filePath,"\n")
              }
          })

# Constructors
setGeneric("SpatialOverlay",
           function(slideName,
                    scanMetadata,
                    overlayData,
                    coords = NULL,
                    plottingFactors = NULL,
                    workflow = list(outline=FALSE,
                                    labWorksheet=TRUE,
                                    scaled=FALSE),
                    image = list(filePath = NULL,
                                 imagePointer = NULL,
                                 resolution = NULL))
               standardGeneric("SpatialOverlay"))

setMethod("SpatialOverlay", "character",
          function(slideName, scanMetadata, overlayData, coords,
                   plottingFactors, workflow, image)
          {
              new2("SpatialOverlay",
                   slideName = slideName, scanMetadata = scanMetadata,
                   overlayData = overlayData, coords = coords,
                   plottingFactors = plottingFactors, workflow = workflow,
                   image = image)
          })

# setMethod("SpatialOverlay", "environment",
#           function(slideName, scanMetadata, overlayData, coords,
#                    plottingFactors, workflow, image)
#           {
#               new2("SpatialOverlay",
#                    slideName = slideName, scanMetadata = scanMetadata,
#                    overlayData = overlayData, coords = coords,
#                    plottingFactors = plottingFactors, workflow = workflow,
#                    image = image)
#           })

# setMethod("SpatialOverlay", "character",
#           function(slideName, scanMetadata, overlayData, coords,
#                    plottingFactors, workflow, image)
#           {
#               new2("SpatialOverlay",
#                    slideName = slideName, scanMetadata = scanMetadata,
#                    overlayData = overlayData, coords = coords,
#                    plottingFactors = plottingFactors, workflow = workflow,
#                    image = image)
#           })

# Validity
setValidity2("SpatialOverlay", function(object){
    msg <- NULL
    if (any(names(scanMeta(object)) != c("Panels", "PhysicalSizes", 
                                         "Fluorescence", "Segmentation"))) {
        msg <- c(msg, "Names in Scan Metadata are not valid")
    }
    if(!is(scanMeta(object)$Panels,"character")){
        msg <- c(msg, "Panels in Scan Metadata must be a character")
    }
    if(all(names(scanMeta(object)$PhysicalSizes) != c("X", "Y"))){
        msg <- c(msg, "PhysicalSizes in Scan Metadata does not contain X and Y ratio")
    }
    if(!is(scanMeta(object)$PhysicalSizes$X,"numeric") | 
       !is(scanMeta(object)$PhysicalSizes$Y,"numeric")){
        msg <- c(msg, "PhysicalSizes in Scan Metadata must be numeric")
    }
    if(!is(scanMeta(object)$Fluorescence,"data.frame")){
        msg <- c(msg, "Fluorescence in Scan Metadata must be a data.frame")
    }
    if(all(!c("Dye", "DisplayName", "Color", "WaveLength", 
              "Target", "ExposureTime", "ColorCode") %in% 
           names(scanMeta(object)$Fluorescence))){
        msg <- c(msg, "Column names in Fluorescence do not match expected")
    }
    
    if(!is.null(plotFactors(object))){
        if(any(rownames(plotFactors(object)) != sampNames(object))){
            msg <- c(msg, "plotFactors and overlay are in a different order")
        }
        char <- NULL
        for(i in seq_len(ncol(plotFactors(object)))){
            char <- c(char, class(plotFactors(object)[,i] %in% c("factor", 
                                                                 "numeric")))
        }
        if(any(char == FALSE)){
            msg <- c(msg, "plotFactors classes must be either factors or numeric")
        }
    }
    
    if(all(!names(object@workflow) %in% c("labWorksheet", "outline", "scaled"))){
        msg <- c(msg, "workflow names are not valid")
    }
    
    if(!is.null(coords(object))){
        if(any(!coords(object)$sampleID %in% sampNames(object))){
            msg <- c(msg, "coordinates for extra samples")
        }
    }
    
    if(all(!names(object@image) %in% c("filePath", "imagePointer", "resolution"))){
        msg <- c(msg, "image names are not valid")
    }
    
    if (is.null(msg)) TRUE else msg
})


# Accessors
setGeneric("slideName", signature = "object",
           function(object) standardGeneric("slideName"))
setMethod("slideName", "SpatialOverlay", function(object) 
    object@slideName)

setGeneric("overlay", signature = "object",
           function(object) standardGeneric("overlay"))
setMethod("overlay", "SpatialOverlay", function(object) 
    object@overlayData)

setGeneric("scanMeta", signature = "object",
           function(object) standardGeneric("scanMeta"))
setMethod("scanMeta", "SpatialOverlay", function(object) 
    object@scanMetadata)

setGeneric("coords", signature = "object",
           function(object) standardGeneric("coords"))
setMethod("coords", "SpatialOverlay", function(object) object@coords)

setGeneric("plotFactors", signature = "object",
           function(object) standardGeneric("plotFactors"))
setMethod("plotFactors", "SpatialOverlay", function(object) object@plottingFactors)

setGeneric("labWork", signature = "object",
           function(object) standardGeneric("labWork"))
setMethod("labWork", "SpatialOverlay", function(object) 
    object@workflow$labWorksheet)

setGeneric("outline", signature = "object",
           function(object) standardGeneric("outline"))
setMethod("outline", "SpatialOverlay", function(object) 
    object@workflow$outline)

setGeneric("seg", signature = "object",
           function(object) standardGeneric("seg"))
setMethod("seg", "SpatialOverlay", function(object) 
    object@scanMetadata$Segmentation)

setGeneric("scaleBarRatio", signature = "object",
           function(object) standardGeneric("scaleBarRatio"))
setMethod("scaleBarRatio", "SpatialOverlay", function(object) 
    object@scanMetadata$PhysicalSizes$X)

setGeneric("fluor", signature = "object",
           function(object) standardGeneric("fluor"))
setMethod("fluor", "SpatialOverlay", function(object) 
    object@scanMetadata$Fluorescence)

setGeneric("sampNames", signature = "object",
           function(object) standardGeneric("sampNames"))
setMethod("sampNames", "SpatialOverlay", function(object) 
    meta(overlay(object))$Sample_ID)

setGeneric("showImage", signature = "object",
           function(object) standardGeneric("showImage"))
setMethod("showImage", "SpatialOverlay", function(object) 
    object@image$imagePointer)

setGeneric("res", signature = "object",
           function(object) standardGeneric("res"))
setMethod("res", "SpatialOverlay", function(object) 
    object@image$resolution)

setGeneric("workflow", signature = "object",
           function(object) standardGeneric("workflow"))
setMethod("workflow", "SpatialOverlay", function(object) 
    object@workflow)

setGeneric("scaled", signature = "object",
           function(object) standardGeneric("scaled"))
setMethod("scaled", "SpatialOverlay", function(object) 
    object@workflow$scaled)

setGeneric("imageInfo", signature = "object",
           function(object) standardGeneric("imageInfo"))
setMethod("imageInfo", "SpatialOverlay", function(object) 
    object@image)
