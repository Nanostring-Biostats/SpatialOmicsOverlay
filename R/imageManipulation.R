#' Turn 4-channel composite image into RGB
#' 
#' @param omeImage AnnotatedImage from read.image
#' @param scanMeta scanMeta data from SpatialOverlay
#' 
#' @return AnnotatedImage with RGB matrix
#' 
#' @importFrom EBImage imageData
#' @importFrom EBImage imageData<-
#' @importFrom EBImage normalize
#' @importFrom grDevices col2rgb
#' 
#' @noRd

imageColoring <- function(omeImage, scanMeta){
    red <- matrix(0, nrow = nrow(imageData(omeImage)), 
                  ncol = ncol(imageData(omeImage)))
    green <- matrix(0, nrow = nrow(imageData(omeImage)), 
                    ncol = ncol(imageData(omeImage)))
    blue <- matrix(0, nrow = nrow(imageData(omeImage)), 
                   ncol = ncol(imageData(omeImage)))
    
    if("MinIntensity" %in% colnames(scanMeta$Fluorescence)){
        for(i in seq_len(nrow(scanMeta$Fluorescence))){
            imageData(omeImage)[,,i] <- normalize(imageData(omeImage)[,,i],
                                                  inputRange = 
                                                      c(as.numeric(scanMeta$Fluorescence$MinIntensity[i]),
                                                        as.numeric(scanMeta$Fluorescence$MaxIntensity[i])))
        }
    }
    
    omeImage <- normalize(omeImage)
    
    for(i in seq_len(nrow(scanMeta$Fluorescence))){
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

#' Update color scheme for changing to RGB image
#' 
#' @param overlay SpatialOverlay object, with 4channel image
#' @param color color to change dye to, hex or color name
#' @param dye which dye to change color, can be from Dye or DisplayName column 
#'               from fluor(overlay)
#' 
#' @return SpatialOverlay object with updated fluor data
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
#' fluor(muBrain)
#' 
#' muBrain <- changeImageColoring(overlay = muBrain, color = "magenta", 
#'                                dye = "Cy5")
#' muBrain <- changeImageColoring(overlay = muBrain, color = "#42f5ef", 
#'                                dye = "Alexa 488")
#' 
#' fluor(muBrain)
#' 
#' @importFrom plotrix color.id
#' @importFrom stringr str_to_title
#' 
#' @export
#'
changeImageColoring <- function(overlay, color, dye){
    if(!is(showImage(overlay),"AnnotatedImage")){
        stop("Image in overlay must be the raw 4-channel image, please run add4ChannelImage()")
    }
    
    if(!dye %in% fluor(overlay)$Dye & !dye %in% fluor(overlay)$DisplayName){
        stop("dye not found in overlay object")
    }
    
    dyeCol <- ifelse(dye %in% fluor(overlay)$Dye, "Dye", "DisplayName")
    dyeRow <- which(fluor(overlay)[[dyeCol]] == dye)
    
    overlay@scanMetadata$Fluorescence$ColorCode[dyeRow] <- color
    
    if(startsWith(color, "#")){
        overlay@scanMetadata$Fluorescence$Color[dyeRow] <- str_to_title(color.id(color)[1L])
    }else{
        overlay@scanMetadata$Fluorescence$Color[dyeRow] <- str_to_title(color)
    }
    
    return(overlay)
}

#' Update color intensities for changing to RGB image
#' 
#' @param overlay SpatialOverlay object
#' @param minInten value to change MinIntensity to; NULL indicates no change
#' @param maxInten value to change MaxIntensity to; NULL indicates no change
#' @param dye which dye to change color, can be from Dye or DisplayName column 
#'                from fluor(overlay)
#' 
#' @return SpatialOverlay object with updated fluor data
#' 
#' @examples
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' 
#' image <- downloadMouseBrainImage()
#' 
#' muBrain <- add4ChannelImage(overlay = muBrain, 
#'                             ometiff = image, res = 8)
#' 
#' fluor(muBrain)
#' 
#' muBrain <- changeColoringIntensity(overlay = muBrain, 
#'                                    minInten = 500, 
#'                                    maxInten = 10000, 
#'                                    dye = "Cy5")
#' 
#' fluor(muBrain)
#' 
#' @export
#'
changeColoringIntensity <- function(overlay, minInten = NULL,
                                    maxInten = NULL, dye){
    if(!is(showImage(overlay),"AnnotatedImage")){
        stop("Image in overlay must be the raw 4-channel image, please run add4ChannelImage()")
    }
    
    if(!dye %in% fluor(overlay)$Dye & !dye %in% fluor(overlay)$DisplayName){
        stop("dye not found in overlay object")
    }
    
    if(is.null(minInten) & is.null(maxInten)){
        stop("changes must be made to minInten and/or maxInten")
    }
    
    if(!is(minInten,"numeric")){
        stop("minInten must be numeric")
    }
    
    if(!is(maxInten,"numeric")){
        stop("maxInten must be numeric")
    }
    
    if(minInten < 0){
        stop("minInten must be a positive value")
    }
    
    if(maxInten < 0){
        stop("maxInten must be a positive value")
    }
    
    dyeCol <- ifelse(dye %in% fluor(overlay)$Dye, "Dye", "DisplayName")
    dyeRow <- which(fluor(overlay)[[dyeCol]] == dye)
    
    if(!is.null(minInten)){
        overlay@scanMetadata$Fluorescence$MinIntensity[dyeRow] <- minInten
    }
    
    if(!is.null(maxInten)){
        overlay@scanMetadata$Fluorescence$MaxIntensity[dyeRow] <- maxInten
    }
    
    return(overlay)
}

#' recolor images after changing colors and/or color intensities
#' 
#' @param overlay SpatialOverlay object
#' 
#' @return SpatialOverlay object with RGB image
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
#' muBrain <- changeImageColoring(overlay = muBrain, color = "magenta", 
#'                                dye = "Cy5")
#' showImage(recolor(muBrain))
#' 
#' @export
#'
recolor <- function(overlay){
    if(!is(showImage(overlay),"AnnotatedImage")){
        stop("Image in overlay must be the raw 4-channel image, please run add4ChannelImage()")
    }
    
    overlay@image$imagePointer <- image_read(imageColoring(showImage(overlay), 
                                                           scanMeta(overlay)))
    if(scaled(overlay) == FALSE){
        overlay <- scaleCoords(overlay)
    }
    
    overlay <- cropTissue(overlay)
    
    return(overlay)
}

#' Flip y axis in image and overlay points 
#' 
#' @param overlay SpatialOverlay object
#' 
#' @return SpatialOverlay object with y axis flipped
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
#' 
#' showImage(flipY(muBrain))
#' 
#' @importFrom magick image_flip
#' 
#' @export 
#' 
flipY <- function(overlay){
    overlay@image$imagePointer <- image_flip(showImage(overlay))
    
    overlay@coords$ycoor <- abs(image_info(showImage(overlay))$height - 
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
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' 
#' image <- downloadMouseBrainImage()
#' 
#' muBrain <- addImageOmeTiff(overlay = muBrain, 
#'                            ometiff = image, res = 8)
#' 
#' showImage(flipX(muBrain))
#' 
#' @importFrom magick image_flop
#' 
#' @export 
#' 
flipX <- function(overlay){
    overlay@image$imagePointer <- image_flop(showImage(overlay))
    
    overlay@coords$xcoor <- abs(image_info(showImage(overlay))$width - 
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
#' @param coords should coords be cropped
#' 
#' @return df of coordinates for every AOI in the scan
#' 
#' @importFrom magick image_crop
#' @importFrom magick image_info
#' 
#' @noRd
crop <- function(overlay, xmin, xmax, ymin, ymax, coords = TRUE){
    if(!is(xmin,"numeric") | !is(xmax,"numeric") |
       !is(ymin,"numeric") | !is(ymax,"numeric")){
        stop("min/max coordinate values must be numeric")
    }
    
    if(xmin < 0 | ymin < 0 | xmax < 0 | ymax < 0){
        stop("min/max coordinate values must be greater than 0")
    }
    
    maxWidth <- image_info(showImage(overlay))$width
    maxHeight <- image_info(showImage(overlay))$height
    
    if(xmax <= xmin){
        stop("xmax must be greater than xmin")
    }
    if(ymax > ymin){
        temp <- ymax
        ymax <- ymin
        ymin <- temp
        
        rm(temp)
    }
    
    width  <- xmax - xmin
    height <- ymin - ymax
    
    if(xmax > maxWidth){
        xmax <- maxWidth
    }
    if(ymin > maxHeight){
        ymin <- maxHeight
    }
    
    overlay@image$imagePointer <- image_crop(showImage(overlay), 
                                             paste0(width,  "x", height,
                                                    "+", xmin, "+", ymax))
    
    if(coords == TRUE){
        overlay@coords <- coords(overlay)[coords(overlay)$xcoor >= xmin &
                                           coords(overlay)$xcoor <= xmax &
                                           coords(overlay)$ycoor >= (maxHeight - ymin) &
                                           coords(overlay)$ycoor <= (maxHeight - ymax),]
        
        overlay@coords$xcoor <- coords(overlay)$xcoor - xmin
        overlay@coords$ycoor <- coords(overlay)$ycoor - (maxHeight - ymin)
        
        remove <- sampNames(overlay)[which(!sampNames(overlay) %in% 
                                               unique(coords(overlay)$sampleID))]
        
        if(length(remove) > 0){
            overlay <- removeSample(overlay, remove)
        }
    }
    
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
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' 
#' image <- downloadMouseBrainImage()
#' 
#' muBrain <- addImageOmeTiff(overlay = muBrain, 
#'                            ometiff = image, res = 8)
#' 
#' samps <- sampNames(muBrain)
#' 
#' muBrainCrop <- suppressWarnings(cropSamples(overlay = muBrain, 
#'                                             sampleIDs = samps, 
#'                                             sampsOnly = TRUE))
#' 
#' plotSpatialOverlay(overlay = muBrainCrop, scaleBar = FALSE,
#'                    hiRes = TRUE, legend = FALSE)
#' 
#' @importFrom magick image_info
#' 
#' @export 
#' 
cropSamples <- function(overlay, sampleIDs, buffer = 0.1, sampsOnly = TRUE){
    if(!all(sampleIDs %in% sampNames(overlay))){
        missing <- sampleIDs[which(!sampleIDs %in% sampNames(overlay))]
        warning(paste("invalid sampleIDs given, proceeding with only valid sampleIDs. 
                      Ignored sampleIDs:", paste(missing, collapse = ", ")), 
                immediate. = TRUE)
        
        sampleIDs <- sampleIDs[sampleIDs %in% sampNames(overlay)]
        
        if(length(sampleIDs) == 0){
            stop("No valid sampleIDs")
        }
    }
    if(is.null(sampleIDs) | length(sampleIDs) == 0){
        stop("No valid sampleIDs")
    }
    
    if(is.null(coords(overlay))){
        stop("No coordinates found. Run createCoordFile() before running this function")
    }
    
    if(is.null(showImage(overlay))){
        stop("No image found. Run addImageOmeTiff() before running this function")
    }
    
    if(is(showImage(overlay),"AnnotatedImage")){
        stop("Image must be RGB. Run recolor() before running this function")
    }
    
    sampCoords <- coords(overlay)[coords(overlay)$sampleID %in% sampleIDs,]
    
    maxHeight <- image_info(showImage(overlay))$height
    
    xmin <- min(sampCoords$xcoor)
    xmax <- max(sampCoords$xcoor)
    ymin <- maxHeight - min(sampCoords$ycoor)
    ymax <- maxHeight - max(sampCoords$ycoor)
    
    xbuf <- (xmax-xmin)*(buffer)
    ybuf <- (ymin-ymax)*(buffer)
    
    xmin <- max(xmin-xbuf, 0)
    xmax <- min(xmax+xbuf, image_info(showImage(overlay))$width)
    ymin <- min(ymin+ybuf, maxHeight)
    ymax <- max(ymax-ybuf, 0)
    
    overlay <- crop(overlay, xmin = xmin, xmax = xmax, 
                    ymin = ymin, ymax = ymax)
    
    if(sampsOnly == TRUE){
        
        remove <- sampNames(overlay)[which(!sampNames(overlay) %in% sampleIDs)]
        
        if(length(remove) > 0){
            overlay <- removeSample(overlay, remove)
        }
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
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' 
#' image <- downloadMouseBrainImage()
#' 
#' muBrain <- addImageOmeTiff(overlay = muBrain, 
#'                            ometiff = image, res = 8)
#' 
#' muBrainCrop <- cropTissue(overlay = muBrain)
#' 
#' plotSpatialOverlay(overlay = muBrainCrop, legend = FALSE, 
#'                    hiRes = FALSE, scaleBar = FALSE)
#'                    
#' @importFrom EBImage imageData
#' @importFrom magick as_EBImage
#' @importFrom magick image_read
#' @importFrom magick image_info
#' 
#' @export 
#'
cropTissue <- function(overlay, buffer = 0.05){
    if(is.null(showImage(overlay))){
        stop("No image found. Run addImageOmeTiff() before running this function")
    }
    
    if(is(showImage(overlay),"AnnotatedImage")){
        coords <- TRUE
        image_data <- imageData(showImage(overlay))
        overlay@image$imagePointer <- image_read(imageColoring(showImage(overlay),
                                                               scanMeta(overlay)))
    }else{
        coords <- TRUE
        image_data <- imageData(as_EBImage(showImage(overlay)))
        
        if(is.null(coords(overlay))){
            stop("No coordinates found. Run createCoordFile() before running this function")
        }
    }
    
    red <- image_data[,,1] > 0.05
    green <- image_data[,,2] > 0.05
    blue <- image_data[,,3] > 0.05
    
    bg <- matrix(boundary(red & green & blue), 
                 nrow = nrow(red), ncol = ncol(red))
    
    xmin <- min(which(rowSums(bg) > nrow(red)*0.03))
    xmax <- max(which(rowSums(bg) > nrow(red)*0.03))
    ymin <- max(which(colSums(bg) > ncol(red)*0.03))
    ymax <- min(which(colSums(bg) > ncol(red)*0.03))
    
    xbuf <- (xmax-xmin)*(buffer)
    ybuf <- (ymin-ymax)*(buffer)
    
    xmin <- max(xmin-xbuf, 0)
    xmax <- min(xmax+xbuf, image_info(showImage(overlay))$width)
    ymin <- min(ymin+ybuf, image_info(showImage(overlay))$height)
    ymax <- max(ymax-ybuf, 0)
    
    overlay <- crop(overlay, xmin = xmin, xmax = xmax, 
                    ymin = ymin, ymax = ymax, coords = coords)
    
    return(overlay)
}
