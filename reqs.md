#### Reqs for addImageOmeTiff:
- The user input overlay, a SpatialOverlay object
- The user input ometiff file path (default NULL)
- The user input the res(olution) image layer to extract from the OMETIFF (default NULL)
- The user can input extra variables for imageExtraction function
- The function outputs a SpatialOverlay object 
    - The function outputs extracted RGB image in object
    - The function outputs calculates and scales coordinates if initial image or at a different resolution

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-addimageometiff

#### Reqs for addImageFile:
- The user input overlay, a SpatialOverlay object
- The user input imageFile path for non-OMETIFF image (default NULL)
- The user input the res(olution) image layer extracted from the OMETIFF (default NULL)
- The function outputs a SpatialOverlay object 
    - The function outputs image in object
    - The function outputs calculates and scales coordinates if initial image or at a different resolution
    
Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-addimagefile

#### Reqs for add4ChannelImage:
- The user input overlay, a SpatialOverlay object
- The user input ometiff file path (default NULL)
- The user input the res(olution) image layer to extract from the OMETIFF (default NULL)
- The user can input extra variables for imageExtraction function
- The function outputs a SpatialOverlay object 
    - The function outputs extracted 4-channel image in object
    - The function outputs calculates and scales coordinates if initial image or at a different resolution

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-add4channelimage

#### Reqs for addPlottingFactor:
- The user input overlay, a SpatialOverlay object
- The user input annots, a NanoStringGeoMxSet, matrix, data.frame, or vector
- The user input the plottingFactor: column or row name from annots
- If using NanoStringGeoMxSet, the user input countMatrix in object to pull counts from (default "exprs")
- The function outputs a SpatialOverlay object 
    - The function outputs plottingFactor in plotFactors
    - The function matches on SampleID or if unnamed vector assumes correct order

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-addplottingfactor

#### Reqs for createCoordFile:
- The user input overlay, a SpatialOverlay object
- The user input outline, only outline or all coordinates boolean (default = TRUE)
- The function outputs a SpatialOverlay object 
    - The function outputs coordinates in coords
    - The function specifies workflow@scaled and workflow@outline
    - The function only returns outline coords on Geometric datasets
    - The function wraps all coordinate generating functions together to add to SpatialOverlay object

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-createcoordfile

#### Reqs for createMask:
- The user input b64string, a base64 encoded string containing AOI position
- The user input metadata, metadata of AOI including height and width
- The user input outline, only outline or all coordinates boolean (default = TRUE)
- The function outputs a binary mask matrix 
    - The function outputs binary matrix containing AOI position
    - The function outputs matrix in metadata specified height and width
    - The function outputs only outline coordinates if specified, else all coordinates are output

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-createmask

#### Reqs for coordsFromMask:
- The user input mask, binary mask matrix
- The user input metadata, metadata of AOI including X,Y in full image
- The user input outline, only outline or all coordinates boolean (default = TRUE)
- The function outputs a data.frame of coordinate values 
    - The function outputs data.frame containing X,Y coordinates of all AOIs in slide
    - The function changes coordinates from 1 base to 0 base
    - The function sorts coordinates if returning outline coords

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-coordsfrommask

#### Reqs for pencilCoordSorting:
- The user input coords for an AOI
- The user input rangeWidth, distance to look for closest coord (default = 100)
- The function outputs an ordered data.frame of coordinate values 
    - The function outputs data.frame containing X,Y coordinates of all AOIs in slide ordered by proximity to the previous coordinate
    - The function does not repeat coordinates

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-pencilsortingcoords

#### Reqs for boundary:
- The user input mat, binary mask matrix
- The function outputs an vector  
    - The function outputs vector of number of neighbors each point has 

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-boundary

#### Reqs for moveCoords:
- The user input overlay, SpatialOverlay object
- The user input direction, direction to move coordinates
- The function outputs a SpatialOverlay object

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-moveCoords

#### Reqs for scaleCoords:
- The user input overlay, a SpatialOverlay object
- The function outputs a SpatialOverlay object  
    - The function outputs SpatialOverlay object with coordinates scaled to image size
    - The function does not scale coordinates again if already scaled
    - The function does not scale coordinates if no image in object
    - The function only returns unique coordinates

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-scalecoords

#### Reqs for imageColoring:
- The user input omeImage, a 4-channel AnnotatedImage object
- The user input scanMeta, scan metadata including fluorescence info
- The function outputs a AnnotatedImage object 
    - The function outputs an RGB AnnotatedImage object 
    - The function scales to min and max intensity if given in scanMeta
    - The function adds 4-channel RGB together for final RGB matrix
    - The function normalizes RGB matrix

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-imagecoloring

#### Reqs for changeImageColoring:
- The user input overlay, a SpatialOverlay object with 4-channel image
- The user input color, new color hex or R color name
- The user input dye, Dye or DisplayName to change color of
- The function outputs a SpatialOverlay object 
    - The function outputs SpatialOverlay object with fluorescence ColorCode updated
    - The function only works on objects with 4-channel images
    - The function only changes valid dye colors

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-changeimagecoloring

#### Reqs for changeColoringIntensity:
- The user input overlay, a SpatialOverlay object with 4-channel image
- The user input minInten, new minimum intensity value (default = NULL)
- The user input maxInten, new maximum intensity value (default = NULL)
- The user input dye, Dye or DisplayName to change color of
- The function outputs a SpatialOverlay object  
    - The function outputs SpatialOverlay object with fluorescence MinIntensity and/or MaxIntensity updated
    - The function only works on objects with 4-channel images
    - The function only changes valid dye colors

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-changecoloringintensity

#### Reqs for recolor:
- The user input overlay, a SpatialOverlay object with 4-channel image
- The function outputs a SpatialOverlay object 
    - The function outputs SpatialOverlay object with RGB image
    - The function only works on objects with 4-channel images
    - The function only scales coordinates if needed
    - The function crops to tissue

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-recolor

#### Reqs for flipY:
- The user input overlay, a SpatialOverlay object
- The function outputs a SpatialOverlay object 
    - The function outputs SpatialOverlay object with Y axis flipped
    - The function flips image and coordinates

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-flipy

#### Reqs for flipX:
- The user input overlay, a SpatialOverlay object
- The function outputs a SpatialOverlay object 
    - The function outputs SpatialOverlay object with X axis flipped
    - The function flips image and coordinates

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-flipx

#### Reqs for cropSamples:
- The user input overlay, a SpatialOverlay object
- The user input sampleIDs, sampleIDs of AOIs to include
- The user input buffer, percent of image to add on each edge (default = 0.1)
- The user input sampsOnly, only show given samples (default = TRUE)
- The function outputs a SpatialOverlay object 
    - The function outputs SpatialOverlay object with cropped image and coordinates only showing given samples
    - The function only works on valid sampleIDs
    - The function only works on RGB images
    - The function requires coordinates to be generated
    - The function requires image in overlay
    - The function generates min/max coords to crop on given sampleIDs 
    - The function filters coordinates to only given sampleIDs if desired

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-cropsamples

#### Reqs for cropTissue:
- The user input overlay, a SpatialOverlay object
- The user input buffer, percent of image to add on each edge (default = 0.05)
- The function outputs a SpatialOverlay object 
    - The function outputs SpatialOverlay object with cropped image and coordinates minimizing black background around tissue
    - The function can work on 4-channel or RGB image
    - The function requires coordinates to be generated with RGB image
    - The function requires image in overlay
    - The function generates min/max coords to crop on tissue 

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-croptissue

#### Reqs for xmlExtraction:
- The user input ometiff, file path
- The user input saveFile, boolean (default = FALSE)
- The function outputs a list 
    - The function outputs list containing all xml info 
    - The function only works on valid paths
    - The function saves file to same folder as ometiff if desired

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-xmlextraction

#### Reqs for imageExtraction:
- The user input ometiff, file path
- The user input res(olution), image layer to extract from the OMETIFF (default = 6)
- The user input scanMeta, scan metadata from XML (default = NULL)
- The user input saveFile, boolean (default = FALSE)
- The user input fileType, image type to save as (default = "tiff")
- The user input color, turn into RGB image boolean (default = TRUE)
- The function outputs an image 
    - If color == TRUE
        - The function outputs magick-image pointer 
        - The function colors image 
        - The function saves image to same folder as ometiff if desired
        - The function only saves to valid fileTypes
    - If color == FALSE
        - The function outputs AnnotatedImage
    - The function only works on valid paths
    - The function only extracts valid res layers
    - The function extracts scanMeta if NULL

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-imageextraction

#### Reqs for checkValidRes:
- The user input ometiff, file path
- The function outputs an numeric 
    - The function returns highest valid res(olution) value for ometiff

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-checkvalidres
 
#### Reqs for plotSpatialOverlay:
- The user input overlay, file path
- The user input colorBy, coloring factor (default = "sampleID")
- The user input hiRes(olution) plotting boolean (default = TRUE)
- The user input alpha, opacity value (default = 1)
- The user input legend, show legend boolean (default = TRUE)
- The user input scaleBar, show scale bar boolean (default = TRUE)
- The user input image, show image boolean (default = TRUE)
- The user input fluorLegend, show fluorescence legend (default = FALSE)
- The user input ..., extra values for scale bar plotting
- The user input corner, scale bar corner (default = "bottomright")
- The user input scaleBarWidth, scale bar width of image percentage (default = 0.2)
- The user input scaleBarColor, scale bar color (default = "black")
- The user input scaleBarFontSize, scale bar font size value (default = 6)
- The user input scaleBarLineSize, scale bar line size value (default = 1.5)
- The user input textDistance, distance of text from line value (default = 2)
- The function outputs a ggplot object 
    - The function recolors image if 4-channel is given
    - The function only works on valid plotFactors unless sampleID is given
    - The function only adds fluorLegend if image = TRUE and desired regardless of plotting call
    - The function adds image to background if image = TRUE
    - The function uses image coordinates if image is attached even with image = FALSE
    - The function removes legend if desired
    - The function adds scalebar if desired
    - The function customizes scale bar 

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-plotspatialoverlay

#### Reqs for scaleBarMath:
- The user input scanMetadata, scan metadata from XML specifically PhysicalX/Y
- The user input pts, coordinate data.frame
- The user input scaleBarWidth, percent of image value (default = 0.2)
- The user input image, image from SpatialOverlay (default = NULL)
- The function outputs a list
    - The function returns list of values to print scale bar
    - The function works with or without image
    - The function calculates scale bar width based on um/pixel ratio
    - The function works on all resolutions
    - The function only creates scale bars with round values

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-scalebarmath

#### Reqs for scaleBarCalculation:
- The user input corner, location for scale bar (default = "bottomright")
- The user input scaleBar, list from scaleBarMath 
- The user input textDistance, distance of text from line value (default = 2)
- The function outputs a data.frame
    - The function returns data.frame of coordinates for scale bar
    - The function only works with valid corner 
    - The function calculates scale bar coordinates

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-scalebarcalculation

#### Reqs for scaleBarPrinting:
- The user input gp, ggplot object 
- The user input scaleBar, list from scaleBarMath 
- The user input corner, distance of text from line value (default = 2)
- The user input scaleBarFontSize, scale bar font size value (default = 6)
- The user input scaleBarLineSize, scale bar line size value (default = 1.5)
- The user input scaleBarColor, scale bar color (default = "red)
- The user input textDistance, distance of text from line value (default = 2)
- The user input image, image from SpatialOverlay (default = NULL)
- The user input ..., extra values for scale bar plotting
- The function outputs a ggplot object
    - The function returns ggplot with added scale bar
    - The function works with or without image
    - The function customizes scale bar

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-scalebarprinting

#### Reqs for fluorLegend:
- The user input overlay, SpatialOverlay object 
- The user input nrow, number of rows value (default = 4)
- The user input textSize, font size value (default = 10)
- The user input boxColor, color of background (default = "grey")
- The user input alpha, opacity value (default = 0.25)
- The function outputs a ggplot object
    - The function returns ggplot of visualization marker legend
    - The function only works with valid nrows
    - The function colors Target based on ColorCode
    - The function adds background based on user input

Specifications:

#### Reqs for readSpatialOverlay:
- The user input ometiff, file path
- The user input annots, file path or GeomxSet object
- The user input slideName, name of slide 
- The user input image, add image boolean (default = FALSE)
- The user input res, image layer to extract from the OMETIFF (default = NULL)
- The user input saveFile, save file boolean (default = FALSE)
- The user input outline, outline coords only boolean (default = TRUE)
- The function outputs a SpatialOverlay object
    - The function returns starting point SpatialOverlay 
    - The function annotations can be NanostringGeomxSet, labWorksheet, or DSPDA output
    - The function is a wrapper for extracting XML, add scan metadata, add overlay attrs, determine dataset segmentation, add image, generate coordinates

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-readspatialoverlay

#### Reqs for removeSample:
- The user input overlay, SpatialOverlay object
- The user input remove, sampleIDs to remove
- The function outputs a SpatialOverlay object
    - The function returns a SpatialOverlay without sampleIDs to remove 
    - The function only works on valid sampleIDs
    - The function removes samples across all parts of the SpatialOverlay object
    - The function determines if dataset segmentation type

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-removesamples

#### Reqs for bookendStr:
- The user input x, string
- The user input bookend, length of bookend value (default = 8)
- The function outputs a string
    - The function returns a string small enough to be legible
    - The function returns first bookend ... last bookend (# total char)

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-bookendstr
 
#### Reqs for readLabWorksheet:
- The user input lw, labworksheet file path
- The user input slideName, slide name
- The function outputs a data.frame
    - The function returns a data.frame with AOI annotations
    - The function only works on valid lw
    - The function only works with valid slide name

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-readlabworksheet

#### Reqs for downloadMouseBrainImage:
- The function outputs a tiff file path
    - The function returns a cached tiff file path for Spatial Organ Atlas Mouse Brain OMETIFF
    - The function downloads and untars file if not already cached

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-downloadmousebrainimage

#### Reqs for parseScanMetadata:
- The user input omexml, xml list
- The function outputs a list
    - The function returns a list of scan metadata including panel, physical size and fluorescence data
    - The function can handle omexml being the file path to ometiff

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-downloadmousebrainimage

#### Reqs for parseOverlayAttrs:
- The user input omexml, xml list
- The user input annots, data.frame of annotations
- The user input labworksheet, is annot labworksheet boolean
- The function outputs a SpatialPosition
    - The function returns a list of AOI metadata including AOI height, width, and location
    - The function can handle xml files from multiple software versions
    - The function only returns AOIs in both XML and annots

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-parseoverlayattrs

#### Reqs for physicalSizes:
- The user input omexml, xml list
- The function outputs a list
    - The function returns a list of PhysicalSizes from xml

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-physicalsizes

#### Reqs for fluorData:
- The user input omexml, xml list
- The function outputs a data.frame
    - The function returns a data.frame of fluorescence data from xml including: dye, displayname, color, wavelength, target, exposuretime, colorcode, and min/max intensities if avaliable. 
    - The function can work if fluorescence data takes 1 or 2 slots in XML

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-fluordata

#### Reqs for decodeB64:
- The user input b64string, base 64 location string
- The user input width, width of AOI
- The user input height, height of AOI
- The function outputs a vector
    - The function returns a binary vector of AOI position

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-decodeb64

#### Reqs for annotMatching:
- The user input annots, data.frame of annotations
- The user input ROInum, ROI number from xml
- The user input maskNum, number of masks in ROI
- The user input maskText, segment name
- The function outputs a data.frame
    - The function returns a data.frame of the matching sampleID
    - The function only works on valid ROInums
    - The function can work on multiple versions of the software

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-annotmatching

#### Reqs for SpatialOverlay-class:
- The class contains all info pertaining to image
    - The class contains slideName
    - The class contains scanMetadata
        - List of panel, physicalsize, and fluorescence
    - The class contains overlayData
        - SpatialPosition
    - The class contains coords
    - The class contains plottingFactors 
        - Added individually
    - The class contains workflow
        - Workflow booleans that affect downstream analysis: outline, labworksheet, scaled
    - The class contains image
        - list of image related info: filePath, imagePointer, resolution
- The class contains accessors and replacers where neccesary 

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-spatialoverlay-class


#### Reqs for SpatialPosition-class:
- The class contains all info pertaining to position in space
    - The class contains ROILabel
    - The class contains Sample_ID
    - The class contains Height
    - The class contains Width
    - The class contains X 
    - The class contains Y
    - The class contains Segmentation
    - The class contains Position
        - Base64 encoded string
- The class contains accessors and replacers where neccesary 

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-spatialposition-class
