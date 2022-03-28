#' Read in \code{\linkS4class{SpatialOverlay}} from tiff file and annotations
#' 
#' @description Create an instance of class \code{\linkS4class{SpatialOverlay}} 
#' by reading data from OME-TIFF and annotation sheet.
#' 
#' @param ometiff path to OME-TIFF 
#' @param annots path to annotation file: can be labWorksheet, DA excel file, or delimted file
#' @param slideName name of slide
#' @param image should image be extracted from OME-TIFF
#' @param saveFile should xml & image be saved, file is saved in working directory 
#'                     with same name as OME-TIFF 
#' @param outline returned coordinates only contain outlinearies, 
#'                   will not work for segmented ROIs
#' 
#' @return \code{\linkS4class{SpatialOverlay}} of slide
#' 
#' @examples
#' 
#' @importFrom read_xlsx readxl
#' @importFrom fread data.table
#' @importFrom pData GeomxTools
#' 
#' @seealso \code{\link{SpatialOverlay-class}}
#' 
#' @export 
#' 

readSpatialOverlay <- function(ometiff, annots, slideName, image = FALSE, res = NULL,
                               saveFile = FALSE, outline = TRUE){
    labWorksheet <- FALSE
    if(class(annots) == "NanoStringGeoMxSet"){
       annots <- pData(annots)
       labWorksheet <- TRUE
       colnames(annots)[colnames(annots) == "roi"] <- "ROILabel"
    }else if(endsWith(annots, "_LabWorksheet.txt")){
        annots <- readLabWorksheet(lw = annots, slideName = slideName)
        labWorksheet <- TRUE
    }else if(endsWith(annots, ".xlsx")){
        annots <- readxl::read_xlsx(annots, sheet = "SegmentProperties")
    }else{
        annots <- as.data.frame(data.table::fread(file = annots))
    }
    
    if(image == TRUE & is.null(res)){
        warning("No res was given so default res of 6 will be used")
        res <- 6
    }
    
    print("Extracting XML")
    xml <- xmlExtraction(ometiff = ometiff, saveFile = saveFile)
    
    print("Parsing XML - scan metadata")
    scan_metadata <- parseScanMetatdata(omexml = xml)
    
    print("Parsing XML - overlay data")
    AOIattrs <- parseOverlayAttrs(omexml = xml, annots = annots, 
                                  labworksheet = labWorksheet)
    
    if(any(meta(AOIattrs)$Segmentation == "Segmented")){
        scan_metadata[["Segmentation"]] <- "Segmented"
    }else{
        scan_metadata[["Segmentation"]] <- "Geometric"
    }
    
    so <- SpatialOverlay(slideName = slideName, 
                         scanMetadata = scan_metadata, 
                         overlayData = AOIattrs, 
                         workflow = list(labWorksheet=labWorksheet,
                                         outline=NULL,
                                         scaled=FALSE))
    
    if(image == TRUE){
        print("Adding Image")
        so <- addImageOmeTiff(overlay = so, ometiff = ometiff, res = res, 
                       scanMeta = scan_metadata, saveFile = saveFile)
    }
    
    print("Generating Coordinates")
    so <- createCoordFile(overlay = so, outline = outline)
    
    if(image == TRUE){
        print("Scaling Coordinates")
        so <- scaleCoords(overlay = so)
        so <- cropTissue(overlay = so)
    }
     
    
    return(so)
}

