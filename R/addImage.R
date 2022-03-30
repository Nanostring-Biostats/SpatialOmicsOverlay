#' Add image to SpatialOverlay from OME-TIFF
#' 
#' @param overlay SpatialOverlay object
#' @param ometiff File path to OME-TIFF. NULL indicates pull info from overlay 
#' @param res resolution layer, 1 = largest & higher values = smaller. The images increase 
#'              in resolution and memory. The largest image your environment 
#'              can hold is recommended.  NULL indicates pull info from overlay 
#' @param ... Extra variables for \code{\link{imageExtraction}}
#' 
#' @return SpatialOverlay object with image
#' 
#' @examples
#' 
#' @export
addImageOmeTiff <- function(overlay, ometiff = NULL, res = NULL, ...){
    
    if(is.null(ometiff)){
        ometiff <- overlay@image$filePath
    }
    if(is.null(res)){
        res <- overlay@image$resolution
    }
    
    if(is.null(overlay@image$resolution)){
        difRes <- 0
    }else{
        difRes <- res - overlay@image$resolution
    }
    
    overlay@image <- list(filePath = ometiff, 
                     imagePointer = imageExtraction(ometiff = ometiff,
                                                    res = res,
                                                    ...),
                     resolution = res)
    
    if(difRes != 0){
        warning("Resolutions do not match, rescaling coordinates", 
                immediate. = TRUE)
        if(difRes < 0){
            warning("Coordinates need to be recalculated", immediate. = TRUE)
            overlay <- createCoordFile(overlay, overlay@workflow$outline)
        }
        overlay <- scaleCoords(overlay)
    }
    
    return(overlay)
}

#' Add image to SpatialOverlay from disk
#' 
#' @param overlay SpatialOverlay object
#' @param imageFile path to image
#' @param res resolution layer, 1 = largest & higher values = smaller. The images increase 
#'              in resolution and memory. The largest image your environment 
#'              can hold is recommended.  
#'               
#' @return SpatialOverlay object with image
#' 
#' @examples
#' 
#' @importFrom image_read magick
#' 
#' @export
addImageFile <- function(overlay, imageFile, res, ...){
    overlay@image <- list(filePath = imageFile, 
                          imagePointer = image_read(imageFile),
                          resolution = res)
    
    return(overlay)
}

#' Add image to SpatialOverlay from disk
#' 
#' @param overlay SpatialOverlay object
#' @param imageFile path to image. NULL indicates pull infor from overlay
#' @param res resolution layer, 1 = largest & higher values = smaller. The images increase 
#'              in resolution and memory. The largest image your environment 
#'              can hold is recommended. NULL indicates pull info from overlay  
#'               
#' @return SpatialOverlay object with image
#' 
#' @examples
#' 
#' @export
add4ChannelImage <- function(overlay, ometiff = NULL, res = NULL, ...){
    
    if(is.null(ometiff)){
        ometiff <- overlay@image$filePath
    }
    if(is.null(res)){
        res <- overlay@image$resolution
    }
    
    if(is.null(overlay@image$resolution)){
        difRes <- 0
    }else{
        difRes <- res - overlay@image$resolution
    }
    
    overlay@image <- list(filePath = ometiff, 
                          imagePointer = imageExtraction(ometiff = ometiff,
                                                         res = res,
                                                         color = FALSE,
                                                         ...),
                          resolution = res)
    
    if(difRes != 0){
        warning("Resolutions do not match, rescaling coordinates", 
                immediate. = TRUE)
        if(difRes < 0){
            warning("Coordinates need to be recalculated", immediate. = TRUE)
            overlay <- createCoordFile(overlay, overlay@workflow$outline)
        }
        overlay <- scaleCoords(overlay)
    }
    
    return(overlay)
}
