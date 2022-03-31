#' Print long string in more managable fashion
#' 
#' @description 
#' Print first and last n characters of string in this format: 
#' "### ... ### (x total char)" 
#'
#' @param x long string
#' @param bookend number of characters on either side to print
#' 
#' @return reformatted string
#' 
#' @examples 
#' 
#' start_string <- stringi::stri_rand_strings(n = 1, length = 250)
#' bookendStr(start_string, bookend = 6)
#' 
#' @export
bookendStr <- function(x, bookend = 8){
    if(class(x) != "character"){
        x <- as.character(x)
    }
    if(nchar(x) > bookend*2){
        x <- paste(substr(x = x, start = 1, stop = bookend), "...",
                   substr(x = x, start = nchar(x)-(bookend-1), stop = nchar(x)),
                   paste0("(", nchar(x), " total char)"))
    }
    
    return(x)
}

#' Read lab worksheet into dataframe of annotations 
#' 
#' @param lw lab worksheet file path
#' @param slideName name of slide 
#' 
#' @return df of ROI annotations
#' 
#' @examples 
#' muBrainLW <- system.file("extdata", "muBrain_LabWorksheet.txt", 
#'                          package = "SpatialOmicsOverlay")
#' 
#' muBrainLW <- readLabWorksheet(muBrainLW, slideName = "4")
#' 
#' @export
readLabWorksheet <- function(lw, slideName){
    if(!file.exists(lw)){
        stop("Lab worksheet path is invalid")
    }
    
    startLine <- grep(readLines(lw), pattern = "^Annotations")
    
    lw <- read.table(lw, header = TRUE, sep = "\t", skip = startLine, fill = TRUE)
    lw$ROILabel <- as.numeric(gsub("\"", "", gsub("=", "", lw$roi)))
    
    lw <- lw[lw$slide.name == slideName,]
    
    if(nrow(lw) == 0){
        stop("No ROIs match given slideName")
    }
    
    return(lw)
}


#' Download Mouse Brain OME-TIFF from NanoString's Spatial Organ Atlas
#' 
#' @details https://nanostring.com/products/geomx-digital-spatial-profiler/spatial-organ-atlas/mouse-brain/
#' 
#' @return mouse brain OME-TIFF
#'
#' @importFrom bfcquery BiocFileCache
#' @importFrom bfcrpath BiocFileCache
#' @importFrom bfcadd BiocFileCache
#' 
#' @examples 
#' 
#' image <- downloadMouseBrainImage()
#'
#' @export
downloadMouseBrainImage <- function(){
    url <- "https://external-soa-downloads-p-1.s3.us-west-2.amazonaws.com"
    images <- "mu_brain_image_files.tar.gz"
    imageFile <- "image_files/mu_brain_004.ome.tiff"

    fileURL <- paste(url, images, sep = "/")

    bfc <- .get_cache()
    rid <- bfcquery(bfc, imageFile)$rid
    
    if (!length(rid)) {
        rid <- bfcquery(bfc, images)$rid
        if (!length(rid)) {
            message("Downloading file")
            rid <- names(bfcadd(bfc, images, fileURL))
        }
        
        imageFile <- "image_files/mu_brain_004.ome.tiff"
        
        message( "Untaring file" )
        untar(bfcrpath(bfc, rids = rid),
              files = imageFile,
              exdir = bfc@cache)
        
        rid <- names(bfcadd(bfc, rname = "mu_brain_004.ome.tiff", fpath = paste(bfc@cache, imageFile, sep = "/")))
    }
    
    bfcrpath(bfc, rids=rid)
}

.get_cache <- function(){
    cache <- tools::R_user_dir("SpatialOmicsOverlay", which="cache")
    BiocFileCache::BiocFileCache(cache)
}
