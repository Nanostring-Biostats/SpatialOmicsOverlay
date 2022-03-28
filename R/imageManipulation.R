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

changeImageColoring <- function(){
    
}

changeColoringIntensity <- function(){
    
}

#' Flip y axis in image and overlay points 
#' 
#' @param overlay SpatialOverlay object
#' 
#' @return SpatialOverlay object with y axis flipped
#' 
#' @examples
#' 
#' @importFrom image_flip magick
#' 
#' @export 
#' 
flipY <- function(overlay){
    overlay@image$imagePointer <- image_flip(image(overlay))
    
    coords(overlay)$ycoor <- abs(image_info(image(overlay))$height - 
                                     coords(overlay)$ycoor)
    
    return(overlay)
}

#' Flip x axis in image and overlay points 
#' 
#' @param overlay SpatialOverlay object
#' 
#' @return SpatialOverlay object with x axis flipped
#' 
#' @examples
#' 
#' @importFrom image_flop magick
#' 
#' @export 
#' 
flipX <- function(overlay){
    overlay@image$imagePointer <- image_flop(image(overlay))
    
    coords(overlay)$xcoor <- abs(image_info(image(overlay))$width - 
                                     coords(overlay)$xcoor)
    
    return(overlay)
}

#' Create coordinate file for entire scan
#' 
#' @param overlay SpatialOverlay object
#' @param xmin minimum x coordinate
#' @param xmax maximum x cooridnate
#' @param ymin minimum y coordinate
#' @param ymax maximum y coordinate
#' 
#' @return df of coordinates for every AOI in the scan
#' 
#' @examples
#' 
#' @importFrom image_crop magick
#' @importFrom image_info magick
#' 
#' 
crop <- function(overlay, xmin, xmax, ymin, ymax){
    if(class(xmin) != "numeric" | class(xmax) != "numeric" |
       class(ymin) != "numeric" | class(ymax) != "numeric"){
        stop("min/max coordinate values must be numeric")
    }
    
    if(xmin < 0 | ymin < 0 | xmax < 0 | ymax < 0){
        stop("min/max coordinate values must be greater than 0")
    }
    
    maxWidth <- image_info(overlay@image$imagePointer)$width
    maxHeight <- image_info(overlay@image$imagePointer)$height
    
    if(xmax <= xmin){
        stop("xmax must be greater than xmin")
    }
    if(ymax > ymin){
        ymax <- maxHeight - ymax
        ymin <- maxHeight - ymin
    }
    
    width  <- xmax - xmin
    height <- ymin - ymax
    
    if(xmax > maxWidth){
        stop("xmax must be within image")
    }
    if(ymin > maxHeight){
        stop("ymin must be within image")
    }
    
    overlay@image$imagePointer <- image_crop(overlay@image$imagePointer, 
                                             paste0(width,  "x", height,
                                                    "+", xmin, "+", ymax))
    
    coords(overlay) <- coords(overlay)[coords(overlay)$xcoor >= xmin &
                                       coords(overlay)$xcoor <= xmax &
                                       coords(overlay)$ycoor >= (maxHeight - ymin) &
                                       coords(overlay)$ycoor <= (maxHeight - ymax),]
    
    coords(overlay)$xcoor <- coords(overlay)$xcoor - xmin
    coords(overlay)$ycoor <- coords(overlay)$ycoor - (maxHeight - ymin)
    
    return(overlay)
}

#' Crop to zoom in on given ROIs
#' 
#' @param overlay SpatialOverlay object
#' @param sampleIDs sampleIDs of ROIs to keep in image
#' @param buffer percent of new image size to add to each edge as a buffer 
#' @param sampsOnly should only ROIs with given sampleIDs be in image
#' 
#' @return SpatialOverlay object
#' 
#' @examples
#' 
#' @importFrom image_info magick
#' 
#' @export 
#' 
cropSamples <- function(overlay, sampleIDs, buffer = 0.1, sampsOnly = TRUE){
    if(!all(sampleIDs %in% sampNames(overlay))){
        warning("invalid sampleIDs given, proceeding with only valid sampleIDs", 
                immediate. = TRUE)
        
        sampleIDs <- sampleIDs[sampleIDs %in% sampNames(overlay)]
        
        if(length(sampleIDs) == 0){
            stop("No valid sampleIDs")
        }
    }
    
    if(is.null(coords(overlay))){
        stop("No coordinates for found. Run createCoordFile() before running this function")
    }
    
    sampCoords <- coords(overlay)[coords(overlay)$sampleID %in% sampleIDs,]
    
    maxHeight <- image_info(overlay@image$imagePointer)$height
    
    xmin <- min(sampCoords$xcoor)
    xmax <- max(sampCoords$xcoor)
    ymin <- maxHeight - min(sampCoords$ycoor)
    ymax <- maxHeight - max(sampCoords$ycoor)
    
    xbuf <- (xmax-xmin)*(buffer)
    ybuf <- (ymin-ymax)*(buffer)
    
    xmin <- xmin-xbuf
    xmax <- xmax+xbuf
    ymin <- ymin+ybuf
    ymax <- ymax-ybuf
    
    overlay <- crop(overlay, xmin = xmin, xmax = xmax, 
                    ymin = ymin, ymax = ymax)
    
    if(sampsOnly == TRUE){
        coords(overlay) <- coords(overlay)[coords(overlay)$sampleID %in% sampleIDs,]
    }
    
    return(overlay)
}

#' Crop to remove black boundary around tissue.
#' 
#' @param overlay SpatialOverlay object
#' @param buffer percent of new image size to add to each edge as a buffer 
#' 
#' @return SpatialOverlay object 
#' 
#' @examples
#' 
#' 
#' @export 
#'
cropTissue <- function(overlay, buffer = 0.05){
    image_data <- imageData(as_EBImage(overlay@image$imagePointer))
    
    
    red <- image_data[,,1] > 0.1
    green <- image_data[,,2] > 0.1
    blue <- image_data[,,3] > 0.1
    
    bg <- matrix(boundary(red & green & blue), 
                 nrow = nrow(red), ncol = ncol(red))
    
    xmin <- min(which(rowSums(bg) > nrow(red)*0.03))
    xmax <- max(which(rowSums(bg) > nrow(red)*0.03))
    ymin <- max(which(colSums(bg) > ncol(red)*0.03))
    ymax <- min(which(colSums(bg) > ncol(red)*0.03))
    
    xbuf <- (xmax-xmin)*(buffer)
    ybuf <- (ymin-ymax)*(buffer)
    
    xmin <- xmin-xbuf
    xmax <- xmax+xbuf
    ymin <- ymin+ybuf
    ymax <- ymax-ybuf
    
    overlay <- crop(overlay, xmin = xmin, xmax = xmax, 
         ymin = ymin, ymax = ymax)
    
    return(overlay)
}
