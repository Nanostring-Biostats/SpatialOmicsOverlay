#' Add image to SpatialOverlay from OME-TIFF
#' 
#' @param overlay SpatialOverlay object
#' @param ometiff File path to OME-TIFF
#' @param res resolution layer, 1 = largest & higher values = smaller. The images increase 
#'              in resolution and memory. The largest image your environment 
#'              can hold is recommended.  
#' @param ... Extra variables for \code{\link{imageExtraction}}
#' 
#' @return SpatialOverlay object with image
#' 
#' @examples
#' 
#' 
addImageOmeTiff <- function(overlay, ometiff, res, ...){
    overlay@image <- list(filePath = ometiff, 
                     imagePointer = imageExtraction(ometiff = ometiff,
                                                    res = res,
                                                    ...),
                     resolution = res)
    
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
addImageFile <- function(overlay, imageFile, res, ...){
    overlay@image <- list(filePath = imageFile, 
                          imagePointer = image_read(imageFile),
                          resolution = res)
    
    return(overlay)
}
