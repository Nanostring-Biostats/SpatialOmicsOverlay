# SpatialOmicsOverlay

## Overview

The SpatialOmicsOverlay package contains tools for analyzing data on the image from
NanoString GeoMx Digital Spatial Profiler (DSP). It provides functions
to extract image and XML from OME-TIFFs, overlay Regions of Interest (ROIs) onto
the image, and manipulate the image (coloring, orientation, cropping). Output 
figures are ggplot based allowing for easy customization of images to include
spatial images into data visualization. 

## Installation

### Install the release version from GitHub
``` r
if (!requireNamespace("devtools", quietly=TRUE))
    install.packages("devtools")

devtools::install_github("Nanostring-Biostats/SpatialOmicsOverlay", 
                         build_vignettes = TRUE, ref = "main")
```

### Install the development version from GitHub
``` r
if (!requireNamespace("devtools", quietly=TRUE))
    install.packages("devtools")
    
devtools::install_github("Nanostring-Biostats/SpatialOmicsOverlay", 
                         build_vignettes = TRUE, ref = "dev")
```

## Documentation

To learn how to start using SpatialOmicsOverlay, view documentation for the
version of this package installed in your system, start R and enter:

``` r
browseVignettes("SpatialOmicsOverlay")
```

or download vignette from NanoString website
<>

## Branches
The release version on GitHub is the stable version.
<https://github.com/Nanostring-Biostats/SpatialOmicsOverlay>

The dev branch on GitHub is under active development and no guarantee 
is made on usability at any given time.

## Citation
Griswold, M.
SpatialOmicsOverlay: Spatial Overlay for Omic Data From Nanostring GeoMx data. 
R Package Version 0.99.10. 
NanoString Technologies Inc.; Seattle, WA 98109, USA. 2021. 

## License
This project is licensed under the [MIT license](LICENSE).
