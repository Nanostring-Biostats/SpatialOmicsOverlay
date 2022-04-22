---
output:
  pdf_document: default
  html_document: default
---
# Requirements

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

# Specifications

Specifications: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/main/specs.md#specs-for-spatialposition-class
#### Specs for addImageOmeTiff:  
1. The function outputs a list in the image slot containing the expected filePath, imagePointer, and resolution.     
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L11
2. The imagePointer is a magick-image with the correct dimensions.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L26
3. The function scales the coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L42
4. The function produces reproducible results.       
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L36

#### Specs for add4ChannelImage:  
1. The function outputs a list in the image slot containing the expected filePath, imagePointer, and resolution.     
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L77
2. The imagePointer is an AnnotatedImage with the correct dimensions.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L92
3. The function scales the coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L101

#### Specs for addImageFile:  
1. The function outputs a list in the image slot containing the expected filePath, imagePointer, and resolution.     
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L130
2. The imagePointer is a magick-image with the correct dimensions.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L140
3. The function scales the coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L151
4. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L146

#### Specs for addPlottingFactor:  
1. The function only works on one factor at a time regardless of input type.     
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L16
2. The function gives warning for annotation missing for samples in object regardless of input type.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L30
3. The function works with a data.frame input, column name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L18
4. The function works with a data.frame input, row name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L32
5. The function works with a matrix input, column name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L46
6. The function works with a matrix input, row name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L59
7. If vectors aren't named they must be the same length as number of samples in object.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L71
8. The function only matches vectors if they are named, otherwise assumed in correct order.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L77
9. The function works with character vectors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L79
10. The function works with factor vectors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L97
11. The function works with numeric vectors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L116
12. The function works with a NanostringGeomxSet input, column name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L139
13. The function works with a NanostringGeomxSet input, row name plotting factor.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addPlottingFactor.R#L148

#### Specs for decodeB64:  
1. The function produces same values as python truth.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L19

#### Specs for createMask:

When outline == FALSE, 

1. The function creates mask in correct dimension.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L31
2. The function produces same values as python truth.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L33
3. The function produces mask of only 0 & 1.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L35
4. The function creates matrix.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L37

When outline == TRUE,

1. The function creates mask in correct dimension.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L59
2. The function has fewer matches with the python truth.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L61
3. The function produces mask of only 0 & 1.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L64
4. The function creates matrix.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L66
5. The function create mask with < 0.1% of points with 7 or more neighbors.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L69

#### Specs for coordsFromMask:


When outline == FALSE, 

1. The function creates coordinates for mask = 1 points. Coordinates are put into full image range and changed from base1 to base0.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L42

When outline == TRUE, 

1. The function creates coordinates for mask = 1 points. Coordinates are put into full image range and changed from base1 to base0.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L74

#### Specs for pencilSortingCoords:
1. The function sorts outline coordinates by proximity. >99% of differences between adjacent coordinates is 1.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L101
2. The function sorts outline coordinates by proximity. The max difference is <100.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L104

#### Specs for createCoordFile:
1. The function places coordinates in correct location.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L118
2. The function produces same values as python truth.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L125
3. The function only returns outline coordinates on Geometric data.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L136

#### Specs for Boundary:
1. The function returns expected number of neighbors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_coordinateGeneration.R#L145

#### Specs for scaleCoords: 
1. The function scales the coordinates based on the size of the image.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L46
2. The coordinates are all smaller than the image size.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L54
3. There are no duplicated coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L61
4. Coordinates can't be rescaled.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L67
5. An image must be in object to scale coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_addImage.R#L69

#### Specs for xmlExtraction:
1. The function only works with valid ometiff file.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_extraction.R#L4
2. The function returns a valid list with the expected names.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_extraction.R#L12
3. The function saves xml file in expected location, if desired.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_extraction.R#L19
4. The function doesn't save file when not asked.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_extraction.R#L28

#### Specs for imageExtraction:
1. The function only extracts valid res layers.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_extraction.R#L38
2. The function extracts expected res layer.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_extraction.R#L40
3. The function saves file in expected location and in correct & valid fileType.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_extraction.R#L50

#### Specs for checkValidRes:
1. The function returns expected value.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_extraction.R#L85

#### Specs for cropTissue:
1. The function returns smaller image.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L10
2. The function returns all original coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L16
3. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L19

#### Specs for cropSamples:

When sampsOnly = TRUE,

1. The function returns smaller image.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L28
2. The function returns all coordinates of only the given samples.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L34
3. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L19

When sampsOnly = FALSE

1. The function returns smaller image.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L44
2. The function returns all coordinates of the given samples.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L50
3. The function returns coordinates within dimensions of cropped image.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L55
4. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L66
5. The function only works with valid sampleIDs.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L69

#### Specs for flipX:
1. The function returns expected coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L80
2. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L85

#### Specs for flipY:
1. The function returns expected coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L90
2. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L95

#### Specs for changeColoringIntensity:
1. The function only works on 4-channel images.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L100
2. The function changes min/max intensity values of only correct fluor.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L110

#### Specs for changeImageColoring:
1. The function only works on 4-channel images.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L103
2. The function changes ColorCode values of only correct fluor.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L132

#### Specs for imageColoring:
1. The function creates RGB image arrays.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L157
2. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L162

#### Specs for recolor:
1. The function scales coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L170
2. The function creates RGB image arrays.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L178
3. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_imageManipulation.R#L184

#### Specs for parseScanMetadata:
1. The function works on ometiff variable instead of expected xml.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_parsing.R#L12
2. The function returns a list with all of the expected names.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_parsing.R#L18

#### Specs for fluorData:
1. The function works on xmls where fluor data takes up 1 or 2 lines.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_parsing.R#L44
2. The function returns a data.frame with all of the expected values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_parsing.R#L72

#### Specs for physicalSizes:
1. The function works returns list with expected names & values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_parsing.R#L91

#### Specs for parseOverlayAttrs:
1. The function requires correct labworksheet boolean.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_parsing.R#L105
2. The function only works with valid sample names.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_parsing.R#L112
3. The function returns SpatialPosition with correct column names.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_parsing.R#L122

#### Specs for annotMatching:
1. The function matches sampleIDs correctly between xml and annots.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_parsing.R#L138

#### Specs for plotSpatialOverlay:
1. The function requires valid colorBy variable.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L22
2. The function returns a ggplot object for high resolution, low resolution and outline graphing.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L30
3. The function returns a ggplot object without legend if desired.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L51
4. The function returns a ggplot object with fluorescence legend if desired.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L58
5. The function works on with both 4-channel and RGB images.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L250
6. The function produces reproducible figures. 
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L37

#### Specs for scaleBarMath:
1. The function expects size to be between 0-1.  
test:https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L113

Without image

2. The function returns a list with the expected names and values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L117
3. The function returns a um value in valid sizes.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L135
4. The function calculates the number of pixels for scale bar correctly.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L141

With image

2. The function returns a list with the expected names and values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L288
3. The function returns a um value in valid sizes.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L306
4. The function calculates the number of pixels for scale bar correctly.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L312

#### Specs for scaleBarCalculation:
1. The function only works with valid corner value.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L147

Without image

2. The function returns a list of numeric values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L150
3. The function calculates the scale bar points the same across the different corner options.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L154

With image

2. The function returns a list of numeric values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L321
3. The function calculates the scale bar points the same across the different corner options.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L325

#### Specs for scaleBarPrinting:


Without image,

1. The function only works with valid corner value.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L224
2. The function produces a ggplot object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L228
3. The function produces reproducible figures. 
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L232

With image

2. The function produces a ggplot object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L395
3. The function produces reproducible figures. 
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L399

#### Specs for fluorLegend:
1. The function only works on valid nrow values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L405
2. The function produces reproducible legends. 
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_plotting.R#L408

#### Specs for readSpatialOverlay:
1. The function works with either a labworksheet or a geomxset object as annotation.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L13
2. The function only returns samples in both xml and annotation.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L25

With all points

1. The function returns a SpatialOverlay object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L32
2. The function returns a SpatialOverlay object with the expected values in the correct locations.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L35

With image

1. The function returns a SpatialOverlay object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L62
2. The function returns a SpatialOverlay object with the expected values in the correct locations.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L65
3. The function returns a SpatialOverlay object with image in expected location.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L82
4. The function returns a SpatialOverlay object with scaled coordinates to image.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L88

With boundary points

1. The function returns a SpatialOverlay object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L97
2. The function returns a SpatialOverlay object with the expected values in the correct locations.  
test:  https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_readSpatialOverlay.R#L100

#### Specs for removeSamples:
1. The function only works on valid sample names.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_removeSamples.R#L25
2. The function works before adding coordinates and plotting factors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_removeSamples.R#L31
3. The function works after adding coordinates and before plotting factors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_removeSamples.R#L49
4. The function works after adding coordinates and plotting factors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_removeSamples.R#L67

#### Specs for SpatialOverlay-class:
1. The class is formatted correctly.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_SpatialOverlay.R#L17
2. The class accessors work as expected.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_SpatialOverlay.R#L45
3. The class replacers work as expected.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_SpatialOverlay.R#L89

#### Specs for SpatialPosition-class:
1. The class is formatted correctly.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_SpatialPosition.R#L11
2. The class accessors work as expected.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_SpatialPosition.R#L32

#### Specs for bookendStr:
1. The function returns a string in the expected format.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_utils.R#L3

#### Specs for readLabWorksheet:
1. The function only works on correct file paths.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_utils.R#L24
2. The function only works on correct slide names.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_utils.R#L26
3. The function only returns annotations from the specified slide.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_utils.R#L29

#### Specs for downloadMouseBrainImage:
1. The function downloads the mouse brain tiff and returns a valid file path.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/c427265120cc9835f1443541d68a22901195e308/longtests/testthat/test_utils.R#L49
