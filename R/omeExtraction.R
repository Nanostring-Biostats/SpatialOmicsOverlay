#' Extract xml from OME-TIFF
#' 
#' @param ometiff path to OME-TIFF 
#' @param saveFile should xml be saved, file is saved in working directory with 
#'                 same name as OME-TIFF 
#' 
#' @return list of xml data
#' 
#' @examples
#' 
#' @importFrom read.omexml RBioFormats
#' 
#' @export 
#' 

# Need to update error checking & saving for URIs

xmlExtraction <- function(ometiff, saveFile = FALSE){
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
        xmlName <- gsub(pattern = "tiff", 
                        replacement = "xml", 
                        x = basename(ometiff))
        
        saveXML(doc = omexml, file = paste0(dirname(ometiff), "/", xmlName))
    }
    
    omexml <- xmlToList(omexml, simplify = TRUE)
    
    return(omexml)
}

#' Extract image from OME-TIFF
#' 
#' @param ometiff path to OME-TIFF
#' @param res resolution layer, 1 = largest & higher values = smaller. The images increase 
#'              in resolution and memory. The largest image your environment 
#'              can hold is recommended.  
#' @param scanMeta scan metadata from parseScanMetadata(). If NULL, that function 
#'                   is automatically called.
#' @param saveFile should xml be saved, file is saved in working directory with 
#'                 same name as OME-TIFF
#' @param fileType type of image file. Options: tiff, png, jpeg
#' 
#' @return omeImage magick pointer
#' 
#' @examples
#' 
#' @importFrom read.omexml RBioFormats
#' @importFrom read.image RBioFormats
#' @importFrom normalize EBImage
#' @importFrom imageData EBImage
#' @importFrom imageData<- EBImage
#' @importFrom image_read magick
#' 
#' @export

imageExtraction <- function(ometiff, res = 6, scanMeta = NULL, saveFile = FALSE, 
                            fileType = "tiff"){
    if(!file.exists(ometiff)){
        stop("ometiff file does not exist")
    }
    
    if(!fileType %in% c("png", "jpeg", "tiff", "jpg")){
        stop("fileType not valid: options are 'tiff', png', or 'jpeg'")
    }
    
    lowRes <- checkValidRes(ometiff)
    
    if(!res %in% c(1:lowRes)){
        stop(paste("valid res integers for this image must be between 1 and", lowRes))
    }
    
    if(is.null(scanMeta)){
        scanMeta <- parseScanMetatdata(xmlExtraction(ometiff)) 
    }
    
    omeImage <- read.image(ometiff, resolution = res,
                       read.metadata = F, normalize = F)
    
    omeImage <- imageColoring(omeImage, scanMeta)
    
    if(saveFile == TRUE){
        width <- omeImage@metadata$coreMetadata$sizeX
        height <- omeImage@metadata$coreMetadata$sizeY
        
        imageName <- gsub(pattern = ".ome", 
                        replacement = "", 
                        x = basename(ometiff))
        
        imageName <- paste0(dirname(ometiff), "/", imageName)
        
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
    
    return(image_read(omeImage))
}

#' Determine lowest resolution image in OME-TIFF
#' 
#' @param ometiff path to OME-TIFF
#' 
#' @return value of lowest res image
#' 
#' @examples
#' 
#' @importFrom read.metadata RBioFormats::
#' 
#' @export
#' 
checkValidRes <- function(ometiff){
    meta <- RBioFormats::read.metadata(tifFile)
    
    return(length(meta))
}
