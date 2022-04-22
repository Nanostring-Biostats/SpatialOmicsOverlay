#' Extract xml from OME-TIFF
#' 
#' @param ometiff path to OME-TIFF 
#' @param saveFile should xml be saved, file is saved in working directory with 
#'                 same name as OME-TIFF 
#' @param outdir output directory for saved xml. If NULL, saved in same directory as OME-TIFF
#' 
#' @return list of xml data
#' 
#' @examples
#' 
#' @importFrom XML xmlInternalTreeParse
#' @importFrom XML xmlToList
#' 
#' 

# Need to update error checking & saving for URIs

xmlExtraction <- function(ometiff, saveFile = FALSE, outdir = NULL){
    attachJar()
    
    if(!file.exists(ometiff)){
        stop("ometiff file does not exist")
    }
    
    # auto catches NULL POINTER error that occurs on first try
    try(omexml <- read.omexml(ometiff), silent = TRUE)
    
    if(!exists("omexml")){
        omexml <- xmlInternalTreeParse(read.omexml(ometiff), 
                                       options = HUGE)
    }else{
        omexml <- xmlInternalTreeParse(omexml, 
                                       options = HUGE)
    }
    
    
    if(saveFile){
        if(is.null(outdir)){
            xmlName <- gsub(pattern = "tiff", 
                            replacement = "xml", 
                            x = basename(ometiff))
            
            xmlName <- paste0(dirname(ometiff), "/", xmlName)
        }else{
            xmlName <- paste0(outdir, "/", basename(ometiff))
        }
        
        saveXML(doc = omexml, file = xmlName)
    }
    
    omexml <- xmlToList(omexml, simplify = TRUE)
    
    return(omexml)
}

#' Extract image from OME-TIFF
#' 
#' @param ometiff path to OME-TIFF
#' @param res resolution layer, 1 = largest & higher values = smaller. The 
#'              images increase in resolution and memory. The largest image 
#'              your environment can hold is recommended.  
#' @param scanMeta scan metadata from parseScanMetadata(). If NULL, that 
#'                   function is automatically called.
#' @param saveFile should xml be saved, file is saved in working directory with 
#'                 same name as OME-TIFF
#' @param fileType type of image file. Options: tiff, png, jpeg
#' @param color should image be colored RGB or 4-channel BW 
#' @param outdir output directory for saved image. If NULL, saved in same directory as OME-TIFF
#' 
#' @return omeImage magick pointer
#' 
#' @importFrom EBImage normalize
#' @importFrom EBImage imageData
#' @importFrom EBImage imageData<-
#' @importFrom magick image_read
#' @importFrom EBImage display
#' 


imageExtraction <- function(ometiff, res = 6, scanMeta = NULL, saveFile = FALSE, 
                            fileType = "tiff", color = TRUE, outdir = NULL){
    attachJar()
    
    if(!file.exists(ometiff)){
        stop("ometiff file does not exist")
    }
    
    if(!fileType %in% c("png", "jpeg", "tiff", "jpg")){
        stop("fileType not valid: options are 'tiff', png', or 'jpeg'")
    }
    
    lowRes <- checkValidRes(ometiff)
    
    if(!res %in% c(seq_len(lowRes))){
        msg <- paste("valid res integers for this image must be between 1 and", 
                     lowRes)
        stop(msg)
    }
    
    if(is.null(scanMeta)){
        scanMeta <- parseScanMetadata(xmlExtraction(ometiff)) 
    }
    
    omeImage <- read.image(file = ometiff, resolution = res,
                           read.metadata = FALSE, normalize = FALSE)
    
    if(color == TRUE){
        omeImage <- imageColoring(omeImage, scanMeta)
    }else{
        if(saveFile == TRUE){
            warning("file can only be saved if color == TRUE, will not save file", 
                    immediate. = TRUE)
            saveFile <- FALSE
        }
    }
    
    if(saveFile == TRUE){
        width <- coreMetadata(omeImage)$sizeX
        height <- coreMetadata(omeImage)$sizeY
        
        if(is.null(outdir)){
            imageName <- gsub(pattern = ".ome", 
                              replacement = "", 
                              x = basename(ometiff))
            
            imageName <- paste0(dirname(ometiff), "/", imageName)
        }else{
            imageName <- paste0(outdir, "/", imageName)
        }
        
        if(fileType == "png"){
            imageName <- gsub(pattern = "tiff", replacement = "png", 
                              x = imageName)
            png(imageName, width = width, height = height, units = "px")
        }else if(fileType == "jpeg" | fileType == "jpg"){
            imageName <- gsub(pattern = "tiff", replacement = "jpeg", 
                              x = imageName)
            jpeg(imageName, width = width, height = height, units = "px")
        }else{
            tiff(imageName, width = width, height = height, units = "px")
        }
        
        display(omeImage, method = "raster")
        dev.off()
    }
    
    if(color == TRUE){
        omeImage <- image_read(omeImage)
    }
    
    return(omeImage)
}

#' Determine lowest resolution image in OME-TIFF
#' 
#' @param ometiff path to OME-TIFF
#' 
#' @return value of lowest res image
#' 
#' @examples
#' 
#' image <- downloadMouseBrainImage()
#' checkValidRes(ometiff = image)
#' 
#' @export
#' 
checkValidRes <- function(ometiff){
    meta <- read.metadata(ometiff)
    
    return(length(meta))
}
