#### Specs for addImageOmeTiff:  
1. The function outputs a list in the image slot containing the expected filePath, imagePointer, and resolution.     
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L9
2. The imagePointer is a magick-image with the correct dimensions.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L24
3. The function scales the coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L40
4. The function produces reproducible results.       
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L34

#### Specs for add4ChannelImage:  
1. The function outputs a list in the image slot containing the expected filePath, imagePointer, and resolution.     
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L75
2. The imagePointer is an AnnotatedImage with the correct dimensions.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L90
3. The function scales the coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L99

#### Specs for addImageFile:  
1. The function outputs a list in the image slot containing the expected filePath, imagePointer, and resolution.     
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L128
2. The imagePointer is a magick-image with the correct dimensions.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L138
3. The function scales the coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L149
4. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L144

#### Specs for addPlottingFactor:  
1. The function only works on one factor at a time regardless of input type.     
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L14
2. The function gives warning for annotation missing for samples in object regardless of input type.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L28
3. The function works with a data.frame input, column name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L16
4. The function works with a data.frame input, row name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L30
5. The function works with a matrix input, column name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L44
6. The function works with a matrix input, row name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L57
7. If vectors aren't named they must be the same length as number of samples in object.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L69
8. The function only matches vectors if they are named, otherwise assumed in correct order.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L75
9. The function works with character vectors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L77
10. The function works with factor vectors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L95
11. The function works with numeric vectors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L114
12. The function works with a NanostringGeomxSet input, column name plotting factor.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L137
13. The function works with a NanostringGeomxSet input, row name plotting factor.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addPlottingFactor.R#L146

#### Specs for decodeB64:  
1. The function produces same values as python truth.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L19

#### Specs for createMask:

When outline == FALSE, 

1. The function creates mask in correct dimension.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L31
2. The function produces same values as python truth.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L33
3. The function produces mask of only 0 & 1.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L35
4. The function creates matrix.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L37

When outline == TRUE,

1. The function creates mask in correct dimension.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L59
2. The function has fewer matches with the python truth.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L61
3. The function produces mask of only 0 & 1.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L64
4. The function creates matrix.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L66
5. The function create mask with < 0.1% of points with 7 or more neighbors.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L69

#### Specs for coordsFromMask:


When outline == FALSE, 

1. The function creates coordinates for mask = 1 points. Coordinates are put into full image range and changed from base1 to base0.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L42

When outline == TRUE, 

1. The function creates coordinates for mask = 1 points. Coordinates are put into full image range and changed from base1 to base0.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L74

#### Specs for pencilSortingCoords:
1. The function sorts outline coordinates by proximity. >99% of differences between adjacent coordinates is 1.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L101
2. The function sorts outline coordinates by proximity. The max difference is <100.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L104

#### Specs for createCoordFile:
1. The function places coordinates in correct location.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L118
2. The function produces same values as python truth.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L125
3. The function only returns outline coordinates on Geometric data.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L136

#### Specs for Boundary:
1. The function returns expected number of neighbors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_coordinateGeneration.R#L145

#### Specs for scaleCoords: 
1. The function scales the coordinates based on the size of the image.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L44
2. The coordinates are all smaller than the image size.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L52
3. There are no duplicated coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L59
4. Coordinates can't be rescaled.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L65
5. An image must be in object to scale coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_addImage.R#L67

#### Specs for xmlExtraction:
1. The function only works with valid ometiff file.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_extraction.R#L4
2. The function returns a valid list with the expected names.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_extraction.R#L12
3. The function saves xml file in expected location, if desired.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_extraction.R#L19
4. The function doesn't save file when not asked.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_extraction.R#L28

#### Specs for imageExtraction:
1. The function only extracts valid res layers.    
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_extraction.R#L38
2. The function extracts expected res layer.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_extraction.R#L40
3. The function saves file in expected location and in correct & valid fileType.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_extraction.R#L50

#### Specs for checkValidRes:
1. The function returns expected value.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_extraction.R#L85

#### Specs for cropTissue:
1. The function returns smaller image.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L8
2. The function returns all original coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L14
3. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L17

#### Specs for cropSamples:

When sampsOnly = TRUE,

1. The function returns smaller image.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L26
2. The function returns all coordinates of only the given samples.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L32
3. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L17

When sampsOnly = FALSE

1. The function returns smaller image.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L42
2. The function returns all coordinates of the given samples.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L48
3. The function returns coordinates within dimensions of cropped image.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L53
4. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L64
5. The function only works with valid sampleIDs.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L67

#### Specs for flipX:
1. The function returns expected coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L78
2. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L83

#### Specs for flipY:
1. The function returns expected coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L88
2. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L93

#### Specs for changeColoringIntensity:
1. The function only works on 4-channel images.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L98
2. The function changes min/max intensity values of only correct fluor.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L108

#### Specs for changeImageColoring:
1. The function only works on 4-channel images.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L101
2. The function changes ColorCode values of only correct fluor.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L130

#### Specs for imageColoring:
1. The function creates RGB image arrays.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L155
2. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L160

#### Specs for recolor:
1. The function scales coordinates.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L168
2. The function creates RGB image arrays.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L176
3. The function produces reproducible results.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_imageManipulation.R#L182

#### Specs for parseScanMetadata:
1. The function works on ometiff variable instead of expected xml.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_parsing.R#L12
2. The function returns a list with all of the expected names.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_parsing.R#L18

#### Specs for fluorData:
1. The function works on xmls where fluor data takes up 1 or 2 lines.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_parsing.R#L44
2. The function returns a data.frame with all of the expected values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_parsing.R#L72

#### Specs for physicalSizes:
1. The function works returns list with expected names & values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_parsing.R#L91

#### Specs for parseOverlayAttrs:
1. The function requires correct labworksheet boolean.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_parsing.R#L105
2. The function only works with valid sample names.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_parsing.R#L112
3. The function returns SpatialPosition with correct column names.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_parsing.R#L122

#### Specs for annotMatching:
1. The function matches sampleIDs correctly between xml and annots.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_parsing.R#L138

#### Specs for plotSpatialOverlay:
1. The function requires valid colorBy variable.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L22
2. The function returns a ggplot object for high resolution, low resolution and outline graphing.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L30
3. The function returns a ggplot object without legend if desired.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L51
4. The function returns a ggplot object with fluorescence legend if desired.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L58
5. The function works on with both 4-channel and RGB images.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L248
6. The function produces reproducible figures. 
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L37

#### Specs for scaleBarMath:
1. The function expects size to be between 0-1.  
test:https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L113

Without image

2. The function returns a list with the expected names and values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L117
3. The function returns a um value in valid sizes.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L135
4. The function calculates the number of pixels for scale bar correctly.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L141

With image

2. The function returns a list with the expected names and values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L286
3. The function returns a um value in valid sizes.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L304
4. The function calculates the number of pixels for scale bar correctly.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L310

#### Specs for scaleBarCalculation:
1. The function only works with valid corner value.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L147

Without image

2. The function returns a list of numeric values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L150
3. The function calculates the scale bar points the same across the different corner options.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L154

With image

2. The function returns a list of numeric values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L319
3. The function calculates the scale bar points the same across the different corner options.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L323

#### Specs for scaleBarPrinting:


Without image,

1. The function only works with valid corner value.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L224
2. The function produces a ggplot object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L228
3. The function produces reproducible figures. 
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L232

With image

2. The function produces a ggplot object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L393
3. The function produces reproducible figures. 
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L397

#### Specs for fluorLegend:
1. The function only works on valid nrow values.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L403
2. The function produces reproducible legends. 
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_plotting.R#L406

#### Specs for readSpatialOverlay:
1. The function works with either a labworksheet or a geomxset object as annotation.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L13
2. The function only returns samples in both xml and annotation.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L25

With all points

1. The function returns a SpatialOverlay object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L32
2. The function returns a SpatialOverlay object with the expected values in the correct locations.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L35

With image

1. The function returns a SpatialOverlay object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L62
2. The function returns a SpatialOverlay object with the expected values in the correct locations.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L65
3. The function returns a SpatialOverlay object with image in expected location.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L82
4. The function returns a SpatialOverlay object with scaled coordinates to image.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L88

With boundary points

1. The function returns a SpatialOverlay object.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L97
2. The function returns a SpatialOverlay object with the expected values in the correct locations.  
test:  https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_readSpatialOverlay.R#L100

#### Specs for removeSamples:
1. The function only works on valid sample names.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_removeSamples.R#L25
2. The function works before adding coordinates and plotting factors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_removeSamples.R#L31
3. The function works after adding coordinates and before plotting factors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_removeSamples.R#L49
4. The function works after adding coordinates and plotting factors.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_removeSamples.R#L67

#### Specs for SpatialOverlay-class:
1. The class is formatted correctly.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_SpatialOverlay.R#L15
2. The class accessors work as expected.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_SpatialOverlay.R#L43
3. The class replacers work as expected.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_SpatialOverlay.R#L87

#### Specs for SpatialPosition-class:
1. The class is formatted correctly.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_SpatialPosition.R#L9
2. The class accessors work as expected.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_SpatialPosition.R#L30

#### Specs for bookendStr:
1. The function returns a string in the expected format.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_utils.R#L3

#### Specs for readLabWorksheet:
1. The function only works on correct file paths.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_utils.R#L24
2. The function only works on correct slide names.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_utils.R#L26
3. The function only returns annotations from the specified slide.  
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_utils.R#L29

#### Specs for downloadMouseBrainImage:
1. The function downloads the mouse brain tiff and returns a valid file path.   
test: https://github.com/Nanostring-Biostats/SpatialOmicsOverlay/blob/2a68865ebee908a149de508b5f0ccc92220e8fca/tests/testthat/test_utils.R#L49
