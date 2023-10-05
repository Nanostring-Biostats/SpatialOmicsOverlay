COLORS <- c(Blue  = "#0000feff",
            Red   = "#fe0000ff",
            Green = "#00fe00ff",
            Purple = "#7f00feff",
            Yellow = "#fefe00ff",
            GreenYellow = "#7ffe00ff",
            Cyan = "#00fefeff",
            Magenta = "#fe00feff",
            Grey = "#7f7f7fff")

#' Parse the xml file for the scan metadata of GeoMx images 
#' 
#' @param omexml xml file from OME-TIFF, can provide path to OME-TIFF and 
#'                   xml will automatically be extracted 
#' 
#' @return metadata for entire scan
#' 
#' @importFrom XML xmlToList
#' 
#' @examples 
#' 
#' image <- downloadMouseBrainImage()
#' 
#' xml <- xmlExtraction(ometiff = image)
#' 
#' scan_metadata <- parseScanMetadata(omexml = xml)
#' 
#' @export
#' 

parseScanMetadata <- function(omexml){
    if(any(is(omexml,"XMLInternalDocument"))){
        omexml <- xmlToList(omexml)
    }
    
    if(is(omexml,"character")){
        if(endsWith(omexml, suffix = ".ome.tiff")){
            omexml <- xmlExtraction(ometiff = omexml)
        }
    }
    
    panels <- omexml$Screen$Reagent[["ReagentIdentifier"]]
    
    scanMetadata <- list(Panels=panels,
                         PhysicalSizes=physicalSizes(omexml),
                         Fluorescence=fluorData(omexml))
    
    return(scanMetadata)
}

#' Parse the xml file for AOI attributes in GeoMx images 
#' 
#' @param omexml xml file from OME-TIFF, can provide path to OME-TIFF and xml 
#'                   will automatically be extracted 
#' @param annots df of annotations
#' @param labworksheet annots are from lab worksheet file
#' 
#' @return SpatialPosition of AOIs containing metadata and base64encoded positions
#' 
#' @importFrom XML xmlToList
#' 
#' @examples 
#' 
#' image <- downloadMouseBrainImage()
#' 
#' xml <- xmlExtraction(ometiff = image)
#' 
#' muBrainLW <- system.file("extdata", "muBrain_LabWorksheet.txt", 
#'                          package = "SpatialOmicsOverlay")
#' 
#' muBrainLW <- readLabWorksheet(muBrainLW, slideName = "D5761 (3)")
#' 
#' overlay <- parseOverlayAttrs(omexml = xml, 
#'                              annots = muBrainLW, 
#'                              labworksheet = TRUE)
#' 
#' @export
#' 

parseOverlayAttrs <- function(omexml, annots, labworksheet){
    if(!is(annots,"data.frame")){
        stop("File must be read into R and passed as a dataframe")
    }
    
    if(any(is(omexml,"XMLInternalDocument"))){
        omexml <- xmlToList(omexml)
    }
    
    if(is(omexml,"character")){
        if(endsWith(omexml, suffix = ".ome.tiff")){
            omexml <- xmlExtraction(ometiff = omexml)
        }
    }
    
    ROIs <- omexml[which(names(omexml) == "ROI")]
    names(ROIs) <- paste0(names(ROIs), 0:(length(ROIs)-1))
    
    AOIattrs <- NULL
    
    # Time trial with lapply showed minimal time difference 
    for(ROI in names(ROIs)){
        ROInum <- ROIs[[ROI]]$AnnotationRef
        ROInum <- as.numeric(gsub("Annotation:", "", ROInum))
        
        ROInum <- omexml$StructuredAnnotations[ROInum]$XMLAnnotation$Value$ChannelThresholds$RoiName
        
        ROI <- ROIs[[ROI]]$Union
        
        masks <- which(names(ROI) == "Mask")
        
        for(mask in masks){
            
            maskNum <- which(masks == mask)
            
            segmentation <- ifelse(length(masks) == 1, "Geometric", "Segmented")
            
            mask.attrs <- ROI[[mask]]$.attrs
            
            if(labworksheet == TRUE & !"Text" %in% names(mask.attrs)){
                stop("Scan was not exported on version 2.4+, please use DA annotation instead of Lab Worksheet")
            }else if(labworksheet == TRUE){
                maskText <- mask.attrs[["Text"]]
            }else{
                maskText <- NULL
            }
            
            ROIannot <- annotMatching(annots, ROInum, maskNum, maskText)
            
            if(is.null(ROIannot) ){
                next
            }else if(nrow(ROIannot) == 0){
                next
            }
            
            AOIattr <- as.data.frame(c(ROILabel=ROInum,
                                       ROIannot, 
                                       mask.attrs[c("Height", "Width", "X", "Y")], 
                                       Segmentation=segmentation))
            
            AOIattr$Height <- as.numeric(AOIattr$Height)
            AOIattr$Width <- as.numeric(AOIattr$Width)
            AOIattr$X <- as.numeric(AOIattr$X)
            AOIattr$Y <- as.numeric(AOIattr$Y)
            
            AOIattrs <- rbind(AOIattrs, 
                              cbind(AOIattr,
                                    Position=ROI[[mask]]$BinData$text))
        }
    }
    
    if(nrow(AOIattrs) < nrow(annots)){
        names(annots)[names(annots) == "SegmentDisplayName"] <- "Sample_ID"
        warning(paste("Some AOIs do not match annotation file. \nNot Matched:",
                      paste(annots$Sample_ID[!annots$Sample_ID %in% AOIattrs$Sample_ID], 
                            collapse = ", ")))
    }
    
    return(SpatialPosition(position = AOIattrs))
}

#' Parse physicalSize data from xml 
#' 
#' @param omexml xml file from OME-TIFF
#' 
#' @return physicalSizes info from xml
#' 
#' @noRd
physicalSizes <- function(omexml){
    physicalSizeX <- as.numeric(omexml$Image$Pixels$.attrs[["PhysicalSizeX"]])
    names(physicalSizeX) <- paste0(omexml$Image$Pixels$.attrs[["PhysicalSizeXUnit"]], 
                                   "/pixel")
    
    physicalSizeY <- as.numeric(omexml$Image$Pixels$.attrs[["PhysicalSizeY"]])
    names(physicalSizeY) <- paste0(omexml$Image$Pixels$.attrs[["PhysicalSizeYUnit"]], 
                                   "/pixel")
    
    return(list(X=physicalSizeX, 
                Y=physicalSizeY))
}

#' Parse fluorescence data from xml 
#' 
#' @param omexml xml file from OME-TIFF
#' 
#' @return fluorescence info from xml
#' 
#' @noRd 
#' 
fluorData <- function(omexml){
    fluorescence <- NULL
    planeLine <- min(which(names(omexml$Image$Pixels) == "Plane"))-1
    addition <- 0
    
    for(chan in seq_len(length(which(names(omexml$Image$Pixels) == "Channel")))){
        fluor <- omexml$Image$Pixels[chan]$Channel$.attrs
        exposure <- omexml$Image$Pixels[planeLine + chan]$Plane
        
        hex <- paste(as.hexmode(as.integer(fluor[["Color"]])))
        
        if(nchar(hex) != 8){
            hex <- paste0(paste(rep(0, 8-nchar(hex)), collapse = ""), hex)
        }
        
        colorCode <- paste0("#", hex)
        col <- names(which(COLORS == colorCode))
        
        if(identical(col, character(0))){
            col <- fluorAnnots[["Name"]]
        }
        
        chan <- chan + addition
        
        # Some xml files have 2 lines per Fluor. The addition catches this and keeps 
        # grabbing correct line needed info is only in ChannelInfo
        if(names(omexml$StructuredAnnotations[chan]$XMLAnnotation$Value) != "ChannelInfo"){
            addition <- addition + 1
            
            chan <- chan + 1
        }
        
        fluorAnnots <- omexml$StructuredAnnotations[chan]$XMLAnnotation$Value$ChannelInfo
        
        if(fluor[["Fluor"]] != fluorAnnots[["Dye"]]){
            stop("Fluor and Dye doesn't match")
        }
        
        if(names(omexml$StructuredAnnotations[chan+1]$XMLAnnotation$Value) == "ChannelInfo"){
            fluorescence <- as.data.frame(rbind(fluorescence, 
                                                c(Dye = fluor[["Fluor"]],
                                                  DisplayName = fluorAnnots[["DyeDisplayName"]],
                                                  Color = col,
                                                  WaveLength = fluorAnnots[["DyeWavelength"]],
                                                  Target = fluorAnnots[["BiologicalTarget"]],
                                                  ExposureTime = paste(exposure[["ExposureTime"]],
                                                                       exposure[["ExposureTimeUnit"]]),
                                                  ColorCode = colorCode)))
        }else{
            intensities <- omexml$StructuredAnnotations[chan+1]$XMLAnnotation$Value$ChannelIntensity
            
            if(is.null(intensities)){
                fluorescence <- as.data.frame(rbind(fluorescence, 
                                                    c(Dye = fluor[["Fluor"]],
                                                      DisplayName = fluorAnnots[["DyeDisplayName"]],
                                                      Color = col,
                                                      WaveLength = fluorAnnots[["DyeWavelength"]],
                                                      Target = fluorAnnots[["BiologicalTarget"]],
                                                      ExposureTime = paste(exposure[["ExposureTime"]],
                                                                           exposure[["ExposureTimeUnit"]]),
                                                      ColorCode = colorCode)))
            }else{
                fluorescence <- as.data.frame(rbind(fluorescence, 
                                                    c(Dye = fluor[["Fluor"]],
                                                      DisplayName = fluorAnnots[["DyeDisplayName"]],
                                                      Color = col,
                                                      WaveLength = fluorAnnots[["DyeWavelength"]],
                                                      Target = fluorAnnots[["BiologicalTarget"]],
                                                      ExposureTime = paste(exposure[["ExposureTime"]],
                                                                           exposure[["ExposureTimeUnit"]]),
                                                      MinIntensity = intensities[["Minintensity"]],
                                                      MaxIntensity = intensities[["Maxintensity"]],
                                                      ColorCode = colorCode)))
            }
        }
        
        
        rm(fluor, exposure, fluorAnnots)
        
        if(addition != 0){
            addition <- addition + 1
        }
    }
    
    return(fluorescence)
}

#' Decode a base 64 string into 8 bit binary image mask
#' 
#' @param b64string base 64 string 
#' @param width width of image
#' @param height height of image
#' 
#' @return binary vector mask 
#' 
#' @importFrom base64enc base64decode
#' 
#' @noRd
decodeB64 <- function(b64string, width, height){
    # rawToBits returns the reverse of the actual binary sequence, needs to be 
    #   reversed for real image
    # example from https://kb.iu.edu/d/afdl
    # Dec    Hex    Bin
    # 192    c0     11000000
    # rawToBits(as.raw(192)) 
    # returns 00 00 00 00 00 00 01 01
    
    base8 <- vapply(X = base64decode(b64string), 
                    FUN = function(x){rev(rawToBits(x))}, 
                    FUN.VALUE = raw(8))
    
    base8 <- base8[seq_len((width*height))]
    
    return(base8)
}

#' Match ROIs in annotation file to xml 
#' 
#' @param annots df of annotations
#' @param ROInum ROI number from xml file
#' @param maskNum number of masks for ROI, used for AOI matching in software 
#'                  <= v2.4
#' @param maskText segment name, used for AOI matching in software v2.4+
#' 
#' @return df with ROI unique identifiers
#' 
#' @noRd

annotMatching <- function(annots, ROInum, maskNum, maskText){
    if(!"ROILabel" %in% colnames(annots)){
        stop("The column ROILabel is not in annots. ")
    }
  
    if(suppressWarnings(!is.na(as.numeric(ROInum)))){
      ROInum <- as.numeric(ROInum)
      annots$ROILabel <- as.numeric(annots$ROILabel)
    }
    
    w2kp <- which(annots$ROILabel == ROInum)
    
    if(length(w2kp) == 0){
        return(NULL)
    }
    
    annots <- annots[w2kp,]
    
    if(!is.null(maskText)){
        annots <- annots[which(annots$segment == maskText),]
        annots <- as.data.frame(annots[,c("Sample_ID")])
        colnames(annots) <- "Sample_ID"
    }else{
        if(nrow(annots) < maskNum){
            stop("incorrect number of masks in annotation, was this file filtered?")
        }
        
        if(!"SegmentID" %in% colnames(annots)){
            stop("Please change labWorksheet to TRUE")
        }
        
        #sort by SegmentID
        #software versions #### missing the segment ID value in xml
        #software versions #### will match on segment ID
        annots <- annots[order(annots$SegmentID), ]
        
        annots <- annots[maskNum,]
        annots <- annots[,c("SegmentDisplayName", "SegmentID")]
        colnames(annots) <- c("Sample_ID", "SegmentID")
    }
    
    return(annots)
}



