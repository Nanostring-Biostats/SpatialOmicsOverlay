#' overlay plots
#' 
#' @param overlay SpatialOverlay object
#' @param colorBy annotation to color by
#' @param hiRes generated figures are either high resolution or print quickly. 
#' @param alpha opacity of overlays 
#' @param legend should legend be plotted
#' @param scaleBar should scale bar be plotted
#' @param image should image be plotted, image must be added to SpatialOverlay object
#' @param ... additional parameters for scale bar line & text, will affect both 
#' @param corner where in the figure should the scale bar be printed. 
#'               Options: "bottomright"  "topright"
#'                        "bottomleft"   "topleft"
#'                        "bottomcenter" "topcenter" 
#' @param scaleBarWidth percent of total figure the scale bar should take up 
#' @param scaleBarColor scale bar & text color
#' @param scaleBarFontSize font size
#' @param scaleBarLineSize width of line
#' @param textDistance text's distance from scale bar. 
#' 
#' @return gp 
#' 
#' @examples
#' 
#' @importFrom geom_scattermore scattermore
#' @import ggplot2
#' @importFrom image_ggplot magick
#' 
#' @export 
#' 

plotSpatialOverlay <- function(overlay, colorBy = "sampleID", hiRes = TRUE, alpha = 1, 
                               legend = TRUE, scaleBar = TRUE, image = TRUE, ... , 
                               corner = "bottomright", scaleBarWidth = 0.2, 
                               scaleBarColor = "red", scaleBarFontSize = 6, 
                               scaleBarLineSize = 1.5, textDistance = 2){
    
    if(class(image(overlay)) == "AnnotatedImage"){
        overlay <- recolor(overlay)
    }
    
    if(colorBy == "sampleID"){
        pts <- as.data.frame(cbind(coords(overlay), 
                                   colorBy=coords(overlay)$sampleID))
        
    }else{
        if(!colorBy %in% colnames(plotFactors(overlay))){
            stop("colorBy not in plotFactors")
        }
        
        pts <- as.data.frame(cbind(coords(overlay), 
                                   colorBy=plotFactors(overlay)[match(coords(overlay)$sampleID, 
                                                                      rownames(plotFactors(overlay))), 
                                                                colorBy]))
    }
    
    if(!is.null(image(overlay)) & image == TRUE){
        gp <- image_ggplot(image(overlay))
        
        scaleImage <- overlay@image
    }else{
        gp <- ggplot()
    }
    
    if(outline(overlay) == TRUE){
        gp <- gp +
            geom_polygon(data = pts, aes(x=xcoor, y=ycoor, fill=colorBy, group=sampleID),
                         alpha = alpha)+
            labs(fill = colorBy)
    }else if(hiRes == TRUE){
        gp <- gp +
            geom_tile(data = pts, aes(x=xcoor, y=ycoor, fill=colorBy),
                      alpha = alpha)+
            labs(fill = colorBy)
    }else{
        gp <- gp +
            geom_scattermore(data = pts, aes(x=xcoor, y=ycoor, color=colorBy),
                             alpha = alpha)+
            labs(color = colorBy)
    }
    
    if(!is.null(image(overlay)) & image == FALSE){
        info <- image_info(SpatialOmicsOverlay::image(overlay))
        gp <- gp + coord_fixed(expand = FALSE, xlim = c(0, info$width), 
                               ylim = c(0, info$height))+
            themeTransparent()
        
        scaleImage <- overlay@image
    }else if(is.null(image(overlay))){
        gp <- gp + coord_fixed(ratio = 1)+
            scale_y_reverse()+
            themeTransparent()
        
        scaleImage <- NULL
    }
 
    
    if(legend == FALSE){
        gp <- gp + theme(legend.position = "none")
    }
    
    if(scaleBar == TRUE){
        scaleBar <- scaleBarMath(scanMetadata = scanMeta(overlay), 
                                 pts = pts, 
                                 scaleBarWidth = scaleBarWidth,
                                 image = scaleImage)
        gp <- scaleBarPrinting(gp = gp, scaleBar = scaleBar, 
                               scaleBarColor = scaleBarColor, 
                               scaleBarFontSize = scaleBarFontSize, 
                               scaleBarLineSize = scaleBarLineSize, 
                               corner = corner, 
                               textDistance = textDistance, 
                               image = scaleImage)
    }
    
    return(gp)
}

#' transparent theme for plots
#' 
#' @return ggplot theme 
#' 
#' @examples
#' 
#' @import ggplot2
#' 
#' @export 
#' 

themeTransparent <- function(){
    return(theme(panel.background = element_rect(fill = "white", 
                                                 color = "black"), 
                 panel.grid.minor = element_blank(), 
                 panel.grid.major = element_blank(),
                 plot.background = element_rect(fill = "white", 
                                                color = NA),
                 axis.text = element_blank(),
                 axis.title = element_blank(),
                 axis.ticks = element_blank()))
}


#' ggplot layer with optimized formatting
#' 
#' @description 
#' corrected aspect ratio, y coordinates, and plotting
#' 
#' @param scanMetadata scan metadata including PhysicalSizeX/Y from xml
#' @param pts AOI coordinates
#' @param scaleBarWidth percent of total figure the scale bar should take up 
#' 
#' @return values needed to print scale bar
#' 
scaleBarMath <- function(scanMetadata, pts, scaleBarWidth = 0.20, image = NULL){
    axis = "X"
    
    axis <- toupper(axis)
    
    if(!axis %in% c("X", "Y")){
        stop("Axis can only be X or Y") 
    }
    
    if(scaleBarWidth <= 0 | scaleBarWidth >= 1){
        stop("scaleBarWidth must be a decimal number between 0 and 1")
    }
    
    validSizes <- sort(c(seq(5,25,5), seq(30, 50, 10), 
                         seq(75,5000,25), seq(5100, 25000, 100)))
    
    ratio <- scanMetadata$PhysicalSizes[[axis]]
    
    if(is.null(image)){
        minPtX <- min(pts$xcoor)
        maxPtX <- max(pts$xcoor)
        
        minPtY <- min(pts$ycoor)
        maxPtY <- max(pts$ycoor) 
    }else{
        imageInfo <- image_info(image$imagePointer)
        minPtX <- 0
        maxPtX <- imageInfo$width
        
        minPtY <- 0
        maxPtY <- imageInfo$height
    }
   
    
    if(axis == "X"){
        givenPixels <- (maxPtX - minPtX) * scaleBarWidth
    }else{
        givenPixels <- (maxPtY - minPtY) * scaleBarWidth
    }
    
    if(!is.null(image)){
        minPtX <- imageInfo$width * 0.02
        maxPtX <- imageInfo$width * 0.98
        
        minPtY <- imageInfo$height * 0.02
        maxPtY <- imageInfo$height * 0.98
        
        ratio <- ratio * 2^(image$resolution-1)
    }
    
    um <- givenPixels * ratio
    
    um <- validSizes[which.min(abs(validSizes - um))]
    
    pixels <- um / ratio
    names(pixels) <- NULL
    
    scaleBar <- list(um=um, pixels=pixels, axis=axis, minX=minPtX, 
                     maxX=maxPtX, minY=minPtY, maxY=maxPtY)
    
    return(scaleBar)
}

#' Calculate scale bar points on plot
#' 
#' @param corner where in the figure should the scale bar be printed. 
#'               Options: "bottomright"  "topright"
#'                        "bottomleft"   "topleft"
#'                        "bottomcenter" "topcenter"
#' @param scaleBar output from scaleBarMath
#' @param textDistance text's distance from scale bar. 
#' 
#' @return coordinates needed to print scale bar
#' 
scaleBarCalculation <- function(corner = "bottomright", scaleBar, 
                                textDistance = 2){
    validCorners <- c("bottomright", "bottomleft", "bottomcenter", 
                      "topright", "topleft", "topcenter")
    if(!corner %in% validCorners){
        stop("Provided corner is not valid. Options: ", paste(validCorners, collapse = ", "))
    }
    
    #preparation for other printing vertical scale bar
    #validAxes <- c("X", "Y")
    
    axis <- "X" #scaleBar$axis
    otherAxis <- "Y" #validAxes[validAxes != axis]
    
    if(grepl(pattern = "right", corner)){
        end <- scaleBar[[paste0("max",axis)]] 
        start <- end - scaleBar$pixels
    }else if(grepl(pattern = "left", corner)){
        start <- scaleBar[[paste0("min",axis)]] 
        end <- start + scaleBar$pixels
    }else if(grepl(pattern = "center", corner)){
        mid <- mean(c(scaleBar[[paste0("min",axis)]], 
                      scaleBar[[paste0("max",axis)]]))
        
        start <- mid - (scaleBar$pixels/2)
        end <- mid + (scaleBar$pixels/2)
    }
    
    mid <- mean(c(end,start))
    
    if(grepl("bottom", corner)){
        lineY <- scaleBar[[paste0("max",otherAxis)]]
        textY = lineY - (lineY*(0.01 * textDistance)) 
    }else{
        lineY <- scaleBar[[paste0("min",otherAxis)]]
        textY = lineY + (lineY*(0.01 * textDistance)) 
    }
    
    return(list(start=start, end=end, lineY=lineY, textY=textY))
}

#' Add scale bar to ggplot object
#' 
#' must run scaleBarMath() first
#' 
#' @param gp ggplot object
#' @param scaleBar output from scaleBarMath
#' @param corner where in the figure should the scale bar be printed. 
#'               Options: "bottomright"  "topright"
#'                        "bottomleft"   "topleft"
#'                        "bottomcenter" "topcenter" 
#' @param scaleBarFontSize scale bar font size
#' @param scaleBarLineSize scale bar width of line
#' @param scaleBarColor scale bar color
#' @param textDistance text's distance from scale bar.
#' @param ... additional parameters for geom_line & geom_text, will apply to both
#' 
#' @return gp with scale bar 
#' 
#' @examples
#'
#' @import ggplot2
#' 
#' @export 
#' 
scaleBarPrinting <- function(gp, scaleBar, corner = "bottomright", 
                             scaleBarFontSize = 6, scaleBarLineSize = 1.5, 
                             scaleBarColor = "red", textDistance = 2, image = NULL, ...){
    scaleBarPts <- scaleBarCalculation(scaleBar = scaleBar, corner = corner, textDistance)
    
    if(!is.null(image)){
        scaleBarPts$lineY <- image_info(image$imagePointer)$height - (scaleBarPts$lineY)
        scaleBarPts$textY <- image_info(image$imagePointer)$height - (scaleBarPts$textY)
    }
    
    df <- as.data.frame(rbind(c(scaleBarPts$start, scaleBarPts$lineY), 
                              c(scaleBarPts$end, scaleBarPts$lineY)))
    names(df) <- c("X", "Y")
    
    gp <- gp + geom_line(data = df, mapping = aes(x=X, y=Y, fill = NULL), 
                         color = scaleBarColor, size = scaleBarLineSize, ...)+
        annotate(geom = "text", 
                 x = mean(c(scaleBarPts$start,scaleBarPts$end)),
                 y = scaleBarPts$textY,
                 label = paste(scaleBar$um, "um"),
                 size = scaleBarFontSize,
                 color = scaleBarColor,
                 ...)
    
    return(gp)
}


