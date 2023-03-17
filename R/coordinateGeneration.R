DIRECTIONS <- c("left", "right", "up", "down")


#' Create coordinate file for entire scan
#' 
#' @param overlay SpatialOverlay object
#' @param outline returned coordinates only contain boundaries, 
#'                   will not work for segmented ROIs
#' 
#' @return df of coordinates for every AOI in the scan
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' 
#' muBrain <- createCoordFile(muBrain, outline = FALSE)
#' 
#' head(coords(muBrain))
#' 
#' @importFrom dplyr bind_rows
#' @importFrom pbapply pbapply 
#' 
#' @export 
#' 
createCoordFile <- function(overlay, outline = TRUE){
    if(!is(overlay,"SpatialOverlay")){
        stop("Overlay must be a SpatialOverlay object")
    }
    
    if(seg(overlay) == "Segmented" & outline == TRUE){
        outline <- FALSE
        
        warning("Outline coordinates do not work in segmented data. Continuing with all coordinates", 
                immediate. = TRUE)
    }
    
    overlayData <- overlay(overlay)
    
    numericCols <- c("Height", "Width", "X", "Y")
    
    coordValues <- suppressWarnings(pbapply(spatialPos(overlayData), 1, 
                                            function(x){
                                                metadata <- as.data.frame(x[which(names(x) != "Position")])
                                                if(nrow(metadata) > ncol(metadata)){
                                                    metadata <- as.data.frame(t(metadata))
                                                }
                                                for(i in numericCols){
                                                    metadata[[i]] <- as.numeric(metadata[[i]])
                                                }
                                                
                                                cbind(sampleID=x["Sample_ID"],
                                                      coordsFromMask(mask = createMask(b64string = x["Position"],
                                                                                       metadata = metadata,
                                                                                       outline = outline),
                                                                     metadata = metadata,
                                                                     outline = outline))
                                            }))
    
    coordValues <- dplyr::bind_rows(coordValues)
    coordValues$xcoor <- as.numeric(coordValues$xcoor)
    coordValues$ycoor <- as.numeric(coordValues$ycoor)
    
    overlay@coords <- coordValues
    
    overlay@workflow$outline <- outline
    overlay@workflow$scaled <- FALSE
    
    return(overlay)
}

#' Create a binary mask from a base 64 string 
#' 
#' @param b64string base 64 string 
#' @param metadata metadata of AOI including: Height, Width of AOI
#' @param outline only the outline points should be returned
#' 
#' @return binary mask image 
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' 
#' samp <- which(sampNames(muBrain) == "DSP-1012996073013-H-F12")
#' 
#' ROIMask <- createMask(b64string = position(overlay(muBrain))[samp], 
#'                       metadata = meta(overlay(muBrain))[samp,],
#'                       outline = TRUE)
#' 
#' pheatmap::pheatmap(ROIMask, cluster_rows = FALSE, cluster_cols = FALSE)
#' 
#' @export 
#' 
createMask <- function(b64string, metadata, outline = TRUE){
    base8 <- decodeB64(b64string = b64string, 
                       height = metadata$Height, 
                       width = metadata$Width)
    
    mask <- matrix(as.numeric(base8), 
                   nrow = metadata$Height, 
                   ncol = metadata$Width, 
                   byrow = TRUE)
    
    if(outline == TRUE){
        outlines <- NULL
        
        outlines <- as.vector(mask)
        neighbors <- boundary(mask)
        
        # points with all neighbors with 1 are inside points and can be removed
        outlines[which(neighbors == 8)] <- 0
        
        mask <- matrix(outlines, 
                       nrow = metadata$Height, 
                       ncol = metadata$Width, 
                       byrow = FALSE)
    }
    return(mask)
}

#' Return positive coordinates from mask 
#' 
#' @param mask base 64 string 
#' @param metadata metadata of AOI including: X,Y position in full image
#' @param outline only the outline points should be returned
#' 
#' @return df of positive coordinates of AOI
#' 
#' @noRd
coordsFromMask <- function(mask, metadata, outline = TRUE){
    coords <- as.data.frame(which(mask != 0, arr.ind = TRUE))
    names(coords) <- c("ycoor", "xcoor")
    
    # put AOI in scheme of entire image
    # while R is 1-based, magick images are 0-based 
    coords$xcoor <- coords$xcoor + metadata$X - 1
    coords$ycoor <- coords$ycoor + metadata$Y - 1
    
    if(outline == TRUE){
        coords <- pencilCoordSorting(coords)
    }
    
    return(coords)
}

#' Sort coordinates like a pencil drawing  
#' 
#' @description 
#' When outline coordinates are generated they are ordered by column but 
#' geom_polygon expects them to be in order like you are tracing the shape 
#' with a pencil. This function orders them by finding the closest x,y 
#' coordinate to the previous point
#' 
#' @param coords All x,y coordinates for an ROI 
#' @param rangeWidth size of range to search for closest coordinate
#' 
#' @return df of ordered coordinates
#' 
#' @noRd
pencilCoordSorting <- function(coords, rangeWidth = 100){
    outlineCoords <- coords[1L,]
    used <- NULL
    for(i in seq_len(nrow(coords))){
        lastPoint <- as.numeric(rownames(outlineCoords)[nrow(outlineCoords)]) 
        used <- c(used, lastPoint)         
        range <- (lastPoint-rangeWidth):(lastPoint+rangeWidth)
        available <- coords[range[-which(range %in% used | 
                                             range <= 0 | 
                                             range > nrow(coords))],] 
        if(nrow(available) == 0){
            next
        }
        closest <- order(abs(coords$ycoor[lastPoint] - available$ycoor) +              
                             abs(coords$xcoor[lastPoint] - available$xcoor),           
                         decreasing = FALSE)[1]
        if((abs(outlineCoords$ycoor[i] - available$ycoor[closest]) +
            abs(outlineCoords$xcoor[i] - available$xcoor[closest])) > 50){
            range <- seq_len(nrow(coords))
            available <- coords[range[-which(range %in% used)],] 
            if(nrow(available) == 0){
                next
            }
            closest <- order(abs(outlineCoords$ycoor[i] - available$ycoor) +
                                 abs(outlineCoords$xcoor[i] - available$xcoor),
                             decreasing = FALSE)[1]
        }
        
        outlineCoords <- rbind(outlineCoords,                                     
                               available[closest,])                                  
    } 
    
    return(outlineCoords)
}

#' Return points for boundary mask 
#' 
#' @note 
#' code modified from Stack Overflow
#' https://stackoverflow.com/questions/29105175/find-neighbouring-elements-of-a-matrix-in-r
#' 
#' @param mat mask
#' 
#' @return total number of neighbors for each pixel
#' 
#' @noRd
boundary <-  function(mat) {
    mat.pad <- rbind(NA, cbind(NA, mat, NA), NA)
    indrow <- 2:(nrow(mat) + 1) # row indices of the "middle"
    indcol <- 2:(ncol(mat) + 1) # column indices of the "middle"
    neigh <- colSums(na.rm = TRUE,
                     rbind(N  = as.vector(mat.pad[indrow - 1, indcol    ]),
                           NE = as.vector(mat.pad[indrow - 1, indcol + 1]),
                           E  = as.vector(mat.pad[indrow    , indcol + 1]),
                           SE = as.vector(mat.pad[indrow + 1, indcol + 1]),
                           S  = as.vector(mat.pad[indrow + 1, indcol    ]),
                           SW = as.vector(mat.pad[indrow + 1, indcol - 1]),
                           W  = as.vector(mat.pad[indrow    , indcol - 1]),
                           NW = as.vector(mat.pad[indrow - 1, indcol - 1])))
    return(neigh)
}

#' Scale coordinates to the size of the image
#' 
#' @param overlay SpatialOverlay object
#' 
#' @return SpatialOverlay object 
#' 
#' @importFrom dplyr distinct
#' @importFrom magick image_info
#' @importFrom magick image_read
#' 
#' @noRd
scaleCoords <- function(overlay){
    if(!is(overlay,"SpatialOverlay")){
        stop("overlay must be a SpatialOverlay")
    }
    if(scaled(overlay) == TRUE){
        stop("Coordinates are already scaled and can't be scaled again")
    }
    if(is.null(showImage(overlay))){
        warning("No image has been added to the SpatialOverlay object, no scaling will be done")
    }else{
        scaling <- 1/2^(res(overlay)-1)
        
        if(is(showImage(overlay),"AnnotatedImage")){
            temp <- image_read(imageColoring(showImage(overlay),
                                             scanMeta(overlay)))
        }else{
            temp <- showImage(overlay)
        }
        
        #scale and center y axis
        overlay@coords$ycoor <- image_info(temp)$height - 
            round(coords(overlay)$ycoor * scaling) 
        
        overlay@coords$xcoor <- round(coords(overlay)$xcoor * scaling)
        
        overlay@coords <- distinct(coords(overlay))
        
        overlay@workflow$scaled <- TRUE
    }
    
    return(overlay)
}

#' Move coordinates if they don't match image
#' 
#' @description If generated coordinates do not match the image use this 
#' function to move coordinates. Coordinates are only changed 1 pixel at a time. 
#' 
#' @param overlay SpatialOverlay object
#' @param direction which direction should coordinates move: left, right, up, down
#' 
#' @return SpatialOverlay object 
#' 
#' @examples
#' 
#' muBrain <- readRDS(unzip(system.file("extdata", "muBrainSubset_SpatialOverlay.zip", 
#'                                     package = "SpatialOmicsOverlay")))
#' head(coords(muBrain), 3)
#' head(coords(moveCoords(muBrain, direction = "up")), 3)                                    
#' 
#' @export
moveCoords <- function(overlay, direction = "right"){
    if(!is(overlay,"SpatialOverlay")){
        stop("Overlay must be a SpatialOverlay object")
    }
    
    direction <- tolower(direction)
    if(!direction %in% DIRECTIONS){
        stop(paste("direction is not valid: options -",
                   paste(DIRECTIONS, collapse = ", ")))
    }
    
    if(direction == "right"){
        overlay@coords$xcoor <- overlay@coords$xcoor + 1
    }else if(direction == "left"){
        overlay@coords$xcoor <- overlay@coords$xcoor - 1
    }else if(direction == "up"){
        overlay@coords$ycoor <- overlay@coords$ycoor + 1
    }else{
        overlay@coords$ycoor <- overlay@coords$ycoor - 1
    }
    
    return(overlay)
}
