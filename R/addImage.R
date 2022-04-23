#' Add image to SpatialOverlay from OME-TIFF
#' 
#' @param overlay SpatialOverlay object
#' @param ometiff File path to OME-TIFF. NULL indicates pull info from overlay 
#' @param res resolution layer, 1 = largest & higher values = smaller. The 
#'              images increase in resolution and memory. The largest image your 
#'              environment can hold is recommended.  NULL indicates pull info 
#'              from overlay 
#' @param ... Extra variables 
#' 
#' @return SpatialOverlay object with image
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' 
#' image <- downloadMouseBrainImage()
#' 
#' muBrain <- addImageOmeTiff(overlay = muBrain, 
#'                            ometiff = image, res = 8)
#' showImage(muBrain)
#' 
#' @export
addImageOmeTiff <- function(overlay, ometiff = NULL, res = NULL, ...){
    
    if(is.null(ometiff)){
        ometiff <- imageInfo(overlay)$filePath
    }
    if(is.null(res)){
        res <- res(overlay)
    }
    
    overlay@image <- list(filePath = ometiff, 
                          imagePointer = imageExtraction(ometiff = ometiff,
                                                         res = res,
                                                         ...),
                          resolution = res)
    
    print("Calculating and scaling coordinates")
    overlay <- createCoordFile(overlay, outline(overlay))
    overlay <- scaleCoords(overlay)

    return(overlay)
}

#' Add image to SpatialOverlay from disk
#' 
#' @param overlay SpatialOverlay object
#' @param imageFile path to image
#' @param res what resolution is the image given? 
#'              1 = largest, higher number = smaller
#'              This value will affect the coordinates of the overlays. 
#'              res = 2, resolution is 1/2 the size as the raw image
#'              res = 3, resolution is 1/4 the size as the raw image
#'              res = 4, resolution is 1/8 the size as the raw image 
#'              resolution = 1/2^(res-1)              
#'               
#' @return SpatialOverlay object with image
#' 
#' @importFrom magick image_read
#' 
#' @export
addImageFile <- function(overlay, imageFile = NULL, res = NULL){
    if(is.null(res)){
        res <- res(overlay)
    }
    
    overlay@image <- list(filePath = imageFile, 
                          imagePointer = image_read(imageFile),
                          resolution = res)
    
    print("Calculating and scaling coordinates")
    overlay <- createCoordFile(overlay, outline(overlay))
    overlay <- scaleCoords(overlay)

    return(overlay)
}

#' Add 4-channel image to SpatialOverlay from OME-TIFF. Allows for recoloring 
#' of image
#' 
#' @param overlay SpatialOverlay object
#' @param ometiff File path to OME-TIFF. NULL indicates pull info from overlay 
#' @param res resolution layer, 1 = largest & higher values = smaller. The 
#'              images increase in resolution and memory. The largest image your 
#'              environment can hold is recommended.  NULL indicates pull info 
#'              from overlay 
#' @param ... Extra variables 
#'               
#' @return SpatialOverlay object with image
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' 
#' image <- downloadMouseBrainImage()
#'
#' muBrain <- add4ChannelImage(overlay = muBrain, 
#'                             ometiff = image, res = 8)
#'
#' dim(EBImage::imageData(showImage(muBrain)))
#' 
#' @export
add4ChannelImage <- function(overlay, ometiff = NULL, res = NULL, ...){
    
    if(is.null(ometiff)){
        ometiff <- imageInfo(overlay)$filePath
    }
    if(is.null(res)){
        res <- res(overlay)
    }
    
    overlay@image <- list(filePath = ometiff, 
                          imagePointer = imageExtraction(ometiff = ometiff,
                                                         res = res,
                                                         color = FALSE,
                                                         ...),
                          resolution = res)
    
    print("Calculating and scaling coordinates")
    overlay <- createCoordFile(overlay, outline(overlay))
    overlay <- scaleCoords(overlay)

    return(overlay)
}
