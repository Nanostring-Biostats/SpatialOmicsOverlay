#' Turn 4-channel composite image into RGB
#' 
#' @param omeImage AnnotatedImage from read.image
#' @param scanMeta scanMeta data from SpatialOverlay
#' 
#' @return AnnotatedImage with RGB matrix
#' 
#' @examples
#' 
#' @importFrom imageData EBImage
#' @importFrom imageData<- EBImage
#' @importFrom normalize EBImage
#' @importFrom col2rgb grDevices
#' 

imageColoring <- function(omeImage, scanMeta){
    red <- matrix(0, nrow = nrow(imageData(omeImage)), ncol = ncol(imageData(omeImage)))
    green <- matrix(0, nrow = nrow(imageData(omeImage)), ncol = ncol(imageData(omeImage)))
    blue <- matrix(0, nrow = nrow(imageData(omeImage)), ncol = ncol(imageData(omeImage)))
    
    if("MinIntensity" %in% colnames(scanMeta$Fluorescence)){
        for(i in 1:nrow(scanMeta$Fluorescence)){
            imageData(omeImage)[,,i] <- normalize(imageData(omeImage)[,,i],
                                                  inputRange = c(as.numeric(scanMeta$Fluorescence$MinIntensity[i]),
                                                                 as.numeric(scanMeta$Fluorescence$MaxIntensity[i])))
        }
    }
    
    omeImage <- normalize(omeImage)
    
    for(i in 1:nrow(scanMeta$Fluorescence)){
        imageLayer <- imageData(omeImage)[,,i]
        
        rgba <- col2rgb(scanMeta$Fluorescence$ColorCode[i], alpha = TRUE)
        
        red <- red+((imageLayer*rgba[1])*(1/nrow(scanMeta$Fluorescence)))
        green <- green+((imageLayer*rgba[2])*(1/nrow(scanMeta$Fluorescence)))
        blue <- blue+((imageLayer*rgba[3])*(1/nrow(scanMeta$Fluorescence)))
    }
    
    imageData(omeImage) <- array(c(red,green,blue), dim = c(nrow(imageData(omeImage)),
                                                            ncol(imageData(omeImage)),
                                                            3))
    
    return(normalize(omeImage))
}

#' #' Remove bleed over around tissue 
#' #' 
#' #' @param omeImage AnnotatedImage from read.image
#' #' @param minTresh percent of max value to set minimum threshold i.e. max * minThresh. 
#' #'                   Values below this max * minThresh value are set to 0
#' #' 
#' #' @return AnnotatedImage with color values below minThresh set to 0
#' #' 
#' #' @examples
#' #' 
#' #' @importFrom imageData EBImage
#' #' @importFrom imageData<- EBImage
#' #' @importFrom as_EBImage magick
#' #' @importFrom as_EBImage magick
#' #'
#' #' @export
#' 
#' setGeneric("removeBleedOver", function(omeImage, minTresh = 0.05) standardGeneric("removeBleedOver"))
#' 
#' 
#' setMethod("removeBleedOver",  "SpatialOverlay",
#'           function(omeImage, minTresh = 0.05){
#'               if(class(minTresh) != "numeric"){
#'                   stop("prop must be numeric")
#'               }
#'               
#'               if(minTresh > 0.5){
#'                   stop("prop must be between 0 - 0.5")
#'               }
#'               
#'               so <- omeImage
#'               
#'               omeImage <- as_EBImage(image(so))
#'               
#'               # remove bleed over around tissue
#'               imageData(omeImage)[,,1][imageData(omeImage)[,,1] < max(imageData(omeImage)[,,1])*minTresh] <- 0
#'               imageData(omeImage)[,,2][imageData(omeImage)[,,2] < max(imageData(omeImage)[,,2])*minTresh] <- 0
#'               imageData(omeImage)[,,3][imageData(omeImage)[,,3] < max(imageData(omeImage)[,,3])*minTresh] <- 0
#'               
#'               so@image$imagePointer <- image_read(omeImage)
#' 
#'               return(so)
#'           })
#' 
#' setMethod("removeBleedOver",  "Image",
#'           function(omeImage, minTresh = 0.05){
#'               if(class(minTresh) != "numeric"){
#'                   stop("prop must be numeric")
#'               }
#'               
#'               if(minTresh > 0.5){
#'                   stop("prop must be between 0 - 0.5")
#'               }
#'               
#'               # remove bleed over around tissue
#'               imageData(omeImage)[,,1][imageData(omeImage)[,,1] < max(imageData(omeImage)[,,1])*minTresh] <- 0
#'               imageData(omeImage)[,,2][imageData(omeImage)[,,2] < max(imageData(omeImage)[,,2])*minTresh] <- 0
#'               imageData(omeImage)[,,3][imageData(omeImage)[,,3] < max(imageData(omeImage)[,,3])*minTresh] <- 0
#'               
#'               return(omeImage)
#'           })

#' Flip y axis in image and overlay points 
#' 
#' @param object SpatialOverlay object
#' 
#' @return SpatialOverlay object with y axis flipped
#' 
#' @examples
#' 
#' @importFrom image_flip magick
#' 
#' @export 
#' 
flipY <- function(object){
    object@image$imagePointer <- image_flip(image(object))
    
    coords(object)$ycoor <- abs(image_info(image(object))$height - 
                                    coords(object)$ycoor)
    
    return(object)
}

#' Flip x axis in image and overlay points 
#' 
#' @param object SpatialOverlay object
#' 
#' @return SpatialOverlay object with x axis flipped
#' 
#' @examples
#' 
#' @importFrom image_flop magick
#' 
#' @export 
#' 
flipX <- function(object){
    object@image$imagePointer <- image_flop(image(object))
    
    coords(object)$xcoor <- abs(image_info(image(object))$width - 
                                    coords(object)$xcoor)
    
    return(object)
}

#' Create coordinate file for entire scan
#' 
#' @param overlay df from GeoMxmlParsing_AOIattrs
#' @param outline returned coordinates only contain outlinearies, 
#'                   will not work for segmented ROIs
#' 
#' @return df of coordinates for every AOI in the scan
#' 
#' @examples
#' 
#' @importFrom bind_rows dplyr
#' @importFrom pbapply pbapply 
#' 
#' @export 
#' 
crop <- function(object){
    
}

#' Create coordinate file for entire scan
#' 
#' @param overlay df from GeoMxmlParsing_AOIattrs
#' @param outline returned coordinates only contain outlinearies, 
#'                   will not work for segmented ROIs
#' 
#' @return df of coordinates for every AOI in the scan
#' 
#' @examples
#' 
#' @importFrom bind_rows dplyr
#' @importFrom pbapply pbapply 
#' 
#' @export 
#' 
autoCrop <- function(object){
    
}