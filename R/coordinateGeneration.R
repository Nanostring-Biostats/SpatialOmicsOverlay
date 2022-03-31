
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
#' muBrain <- readRDS(system.file("extdata", "muBrain_SpatialOverlay.RDS", 
#'                                package = "SpatialOmicsOverlay"))
#' 
#' muBrain <- createCoordFile(muBrain, outline = FALSE)
#' 
#' head(coords(muBrain))
#' 
#' @importFrom bind_rows dplyr
#' @importFrom pbapply pbapply 
#' 
#' @export 
#' 

createCoordFile <- function(overlay, outline = TRUE){
    if(class(overlay) != "SpatialOverlay"){
        stop("Overlay must be a SpatialOverlay object")
    }
    
    if(seg(overlay) == "Segmented" & outline == TRUE){
        outline <- FALSE
        
        warning("Outline coordinates do not work in segmented data. Continuing with all coordinates", 
                immediate. = TRUE)
    }
    
    overlayData <- overlay(overlay)
    
    numericCols <- c("Height", "Width", "X", "Y")
    
    coordValues <- suppressWarnings(pbapply(overlayData@position, 1, function(x){
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
    coordValues$ycoor <- as.numeric(coordValues$ycoor)
    coordValues$xcoor <- as.numeric(coordValues$xcoor)
    
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
#' muBrain <- readRDS(system.file("extdata", "muBrain_SpatialOverlay.RDS", 
#'                                package = "SpatialOmicsOverlay"))
#' 
#' samp <- which(sampNames(muBrain) == "DSP-1012996073013-H-B08")
#' 
#' ROIMask <- createMask(b64string = position(overlay(muBrain))[samp], 
#'                       metadata = meta(overlay(muBrain))[samp,],
#'                       outline = TRUE)
#' 
#' pheatmap::pheatmap(ROIMask, cluster_rows = FALSE, cluster_cols = FALSE)
#' 
#' ROIMask <- createMask(b64string = position(overlay(muBrain))[samp], 
#'                       metadata = meta(overlay(muBrain))[samp,],
#'                       outline = FALSE)
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
coordsFromMask <- function(mask, metadata, outline = TRUE){
    coords <- as.data.frame(which(mask != 0, arr.ind = TRUE))
    names(coords) <- c("ycoor", "xcoor")
    
    # put AOI in scheme of entire image
    # while R is 1-based, magick images are 0-based 
    coords$ycoor <- coords$ycoor + metadata$Y - 1
    coords$xcoor <- coords$xcoor + metadata$X - 1
    
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
pencilCoordSorting <- function(coords, rangeWidth = 100){
    outlineCoords <- coords[1,]
    used <- NULL
    for(i in 1:nrow(coords)){
        lastPoint <- as.numeric(rownames(outlineCoords)[nrow(outlineCoords)]) 
        used <- c(used, lastPoint)         
        range <- (lastPoint-rangeWidth):(lastPoint+rangeWidth)
        available <- coords[range[-which(range %in% used | range <= 0 | range > nrow(coords))],] 
        if(nrow(available) == 0){
            next
        }
        closest <- order(abs(coords$ycoor[lastPoint] - available$ycoor) +              
                             abs(coords$xcoor[lastPoint] - available$xcoor),           
                         decreasing = F)[1]
        if((abs(outlineCoords$ycoor[i] - available$ycoor[closest]) +
            abs(outlineCoords$xcoor[i] - available$xcoor[closest])) > 50){
            range <- 1:nrow(coords)
            available <- coords[range[-which(range %in% used)],] 
            if(nrow(available) == 0){
                next
            }
            closest <- order(abs(outlineCoords$ycoor[i] - available$ycoor) +
                                 abs(outlineCoords$xcoor[i] - available$xcoor),
                             decreasing = F)[1]
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
#' @examples
#' 
#' muBrain <- readRDS(system.file("extdata", "muBrain_SpatialOverlay.RDS", 
#'                                package = "SpatialOmicsOverlay"))
#' 
#' image <- downloadMouseBrainImage()
#' 
#' muBrain <- addImageOmeTiff(overlay = muBrain,
#'                            ometiff = image, res = 7)
#' 
#' summary(coords(muBrain))
#' 
#' muBrain <- scaleCoords(overlay = muBrain)
#' 
#' #fewer and smaller points
#' summary(coords(muBrain))
#' 
#' @importFrom distinct dplyr
#' @importFrom image_info magick
#' @importFrom image_read magick
#' 
#' @export
scaleCoords <- function(overlay){
    if(class(overlay) != "SpatialOverlay"){
        stop("overlay must be a SpatialOverlay")
    }
    if(overlay@workflow$scaled == TRUE){
        stop("Coordinates are already scaled and can't be scaled again")
    }
    if(is.null(showImage(overlay))){
        warning("No image has been added to the SpatialOverlay object, no scaling will be done")
    }else{
        scaling <- 1/2^(overlay@image$resolution-1)
        
        if(class(showImage(overlay)) == "AnnotatedImage"){
            temp <- image_read(imageColoring(showImage(overlay),
                                             scanMeta(overlay)))
        }else{
            temp <- showImage(overlay)
        }
        
        #scale and center y axis
        coords(overlay)$ycoor <- image_info(temp)$height - 
            round(coords(overlay)$ycoor * scaling) 
        
        coords(overlay)$xcoor <- round(coords(overlay)$xcoor * scaling)
        
        coords(overlay) <- distinct(coords(overlay))
        
        overlay@workflow$scaled <- TRUE
    }
    
    return(overlay)
}
