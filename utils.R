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
bookendStr <- function(x, bookend = 8){
    if(class(x) != "character"){
        x <- as.character(x)
    }
    if(nchar(x) > bookend*2){
        x <- paste(substr(x = x, start = 1, stop = bookend), "...",
                   substr(x = x, start = nchar(x)-bookend, stop = nchar(x)),
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
